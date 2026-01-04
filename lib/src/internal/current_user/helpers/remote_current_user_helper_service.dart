// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:json_patch/json_patch.dart';
import 'package:rxdart/subjects.dart';

import '../../../../helpers/database.dart';
import '../../../../models/observe.dart';
import '../../../../models/user/user.dart';
import '../../auth/user_service.dart';
import '../../device/device_info_service.dart';
import '../../users/users_service.dart';
import 'local_current_user_helper_service.dart';

@internal
abstract class RemoteCurrentUserHelperService {
  Future<void> add(User user);

  Future<User?> get();

  Future<void> update(User? Function(User?) copyWith);

  Future<void> delete();

  Observe<List<String>?> get connectedDevices;

  Observe<int?> get version;
}

@Singleton(as: RemoteCurrentUserHelperService)
class RemoteCurrentUserHelperServiceImpl implements RemoteCurrentUserHelperService {
  final AuthUserService _authUser;
  final DeviceInfoService _deviceInfo;
  final UsersService _users;
  final LocalCurrentUserHelperService _local;

  RemoteCurrentUserHelperServiceImpl(this._authUser, this._deviceInfo, this._users, this._local);

  final _versionSubject = BehaviorSubject<int?>.seeded(null);
  final _connectedDevicesSubject = BehaviorSubject<List<String>?>.seeded(null);

  @override
  Observe<int?> get version => Observe<int?>(value: _versionSubject.value, stream: _versionSubject.stream);

  @override
  Observe<List<String>?> get connectedDevices =>
      Observe<List<String>?>(value: _connectedDevicesSubject.value, stream: _connectedDevicesSubject.stream);

  @override
  Future<void> add(User user) => DatabaseNodes.users(user.userId).set(user.toMap());

  @override
  Future<User?> get() async {
    final userId = _authUser.userId.value;
    if (userId == null) return null;

    return _users.getUser(userId);
  }

  @override
  Future<void> update(User? Function(User?) copyWith) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final data = _local.data.value;
    if (data == null) return;

    final updated = copyWith(data);
    if (updated == null) return;

    final patch = JsonPatch.diff(data.toMap(), updated.toMap());
    if (patch.isEmpty) return;

    final updates = jsonPatchToRtdbUpdate(patch);
    updates[UserConstants.version] = ServerValue.increment(1);

    final basePath = DatabaseNodes.users(userId).path;

    final finalUpdates = <String, Object?>{};
    updates.forEach((key, value) => finalUpdates['$basePath/$key'] = value);

    print("=====> $finalUpdates");
  }

  @override
  Future<void> delete() async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    await DatabaseNodes.users(userId).remove();
  }

  @PostConstruct()
  init() async {
    listenToConnectedDevices();
    listenToBackground();
    listenToVersion();
  }

  StreamSubscription<DatabaseEvent>? _connectedSub;
  StreamSubscription<DatabaseEvent>? _presenceIds;
  StreamSubscription<int?>? _versionSub;

  bool _presenceActive = false;
  String? _lastUserId;
}

extension on RemoteCurrentUserHelperServiceImpl {
  void listenToVersion() {
    _authUser.userId.stream
        .distinct((prev, next) {
          if (prev == next) return true;
          return false;
        })
        .listen((userId) {
          _versionSub?.cancel();
          _versionSub = null;

          if (userId == null) {
            _versionSubject.value = null;
            return;
          }

          final stream = DatabaseNodes.users(userId).child(UserConstants.version).onValue.map((event) {
            final raw = event.snapshot.value;
            if (raw is! int) return null;

            return raw;
          });

          _versionSub = stream
              .distinct((prev, next) {
                if (prev == next) return true;
                return false;
              })
              .listen((version) => _versionSubject.value = version);
        });
  }

  void listenToConnectedDevices() {
    _authUser.userId.stream
        .distinct((prev, next) {
          if (prev == next) return true;
          return false;
        })
        .listen((userId) {
          _connectedSub?.cancel();
          _connectedSub = null;

          _presenceIds?.cancel();
          _presenceIds = null;

          if (userId == null) {
            if (_lastUserId == null) return;

            _setUserPresence(_lastUserId, false);
            _lastUserId = null;
            _connectedDevicesSubject.value = null;
            return;
          }

          _lastUserId = userId;

          _connectedSub = DatabaseNodes.connected().onValue.listen((event) {
            final isConnected = event.snapshot.value == true;

            final ref = DatabaseNodes.presences(userId, deviceId: _deviceInfo.identifier);

            if (isConnected && !_presenceActive) {
              _presenceActive = true;
              ref.onDisconnect().remove();
              ref.set(true);
            }

            if (!isConnected) {
              _presenceActive = false;
            }
          });

          _presenceIds = DatabaseNodes.presences(userId).onValue.listen((values) {
            final raw = values.snapshot.value;
            if (raw is! Map) {
              _connectedDevicesSubject.value = const [];
              return;
            }

            final connectedDevices = raw.entries
                .where((entry) => entry.value == true)
                .map((entry) => entry.key.toString())
                .toList();

            _connectedDevicesSubject.value = connectedDevices;
          });
        });
  }

  void listenToBackground() {
    AppLifecycleListener(
      onResume: () => _setUserPresence(_authUser.userId.value, true),
      onInactive: () => _setUserPresence(_authUser.userId.value, false),
    );
  }

  Future<void> _setUserPresence(String? userId, bool isOnline) async {
    if (userId == null) return;

    if (isOnline) {
      await DatabaseNodes.presences(userId, deviceId: _deviceInfo.identifier).set(true);
    } else {
      await DatabaseNodes.presences(userId, deviceId: _deviceInfo.identifier).remove();
    }
  }

  Map<String, Object?> jsonPatchToRtdbUpdate(List<dynamic> patch) {
    final updates = <String, Object?>{};

    for (final op in patch) {
      final operation = op['op'] as String;
      final path = (op['path'] as String).replaceFirst('/', '').replaceAll('~1', '/').replaceAll('~0', '~');

      switch (operation) {
        case 'add':
        case 'replace':
          updates[path] = op['value'];
        case 'remove':
          updates[path] = null;
        default:
          break;
      }
    }

    return updates;
  }
}
