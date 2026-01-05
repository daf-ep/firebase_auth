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
import '../../../../models/user/version.dart';
import '../../auth/user_service.dart';
import '../../device/device_info_service.dart';
import 'local_current_user_helper_service.dart';

@internal
abstract class RemoteCurrentUserHelperService {
  Future<void> add(User user);

  Future<void> update(Future<User?> Function(User?) copyWith);

  Future<void> delete();

  Observe<List<String>?> get connectedDevices;

  Observe<Versions?> get versions;
}

@Singleton(as: RemoteCurrentUserHelperService)
class RemoteCurrentUserHelperServiceImpl implements RemoteCurrentUserHelperService {
  final AuthUserService _authUser;
  final DeviceInfoService _deviceInfo;
  final LocalCurrentUserHelperService _local;

  RemoteCurrentUserHelperServiceImpl(this._authUser, this._deviceInfo, this._local);

  final _versionsSubject = BehaviorSubject<Versions?>.seeded(null);
  final _connectedDevicesSubject = BehaviorSubject<List<String>?>.seeded(null);

  @override
  Observe<Versions?> get versions => Observe<Versions?>(value: _versionsSubject.value, stream: _versionsSubject.stream);

  @override
  Observe<List<String>?> get connectedDevices =>
      Observe<List<String>?>(value: _connectedDevicesSubject.value, stream: _connectedDevicesSubject.stream);

  @override
  Future<void> add(User user) => DatabaseNodes.users(user.userId).set(user.toMap());

  @override
  Future<void> update(Future<User?> Function(User?) copyWith) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final current = _local.data.value;
    if (current == null) return;

    final updated = await copyWith(current);
    if (updated == null) return;

    final patch = JsonPatch.diff(current.toMap(), updated.toMap());
    if (patch.isEmpty) return;

    final basePath = DatabaseNodes.users(userId).path;
    final finalUpdates = <String, Object?>{};

    final touchedNodes = <String>{};

    for (final op in patch) {
      final operation = op['op'] as String;
      final rawPath = (op['path'] as String).replaceFirst('/', '').replaceAll('~1', '/').replaceAll('~0', '~');

      final segments = rawPath.split('/');
      if (segments.isEmpty) continue;

      final rootKey = segments.first;
      touchedNodes.add(rootKey);

      final rtdbPath = '$basePath/$rawPath';

      switch (operation) {
        case 'add':
        case 'replace':
          finalUpdates[rtdbPath] = op['value'];
        case 'remove':
          finalUpdates[rtdbPath] = null;
      }
    }

    for (final key in touchedNodes) {
      finalUpdates['$basePath/${UserConstants.versions}/$key'] = ServerValue.increment(1);
    }

    print("====> $finalUpdates");

    // // Écriture atomique
    // await DatabaseNodes.root().update(finalUpdates);
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
  StreamSubscription<Versions?>? _versionsSub;

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
          _versionsSub?.cancel();
          _versionsSub = null;

          if (userId == null) {
            _versionsSubject.value = null;
            return;
          }

          final stream = DatabaseNodes.users(userId).child(UserConstants.versions).onValue.map((event) {
            final raw = event.snapshot.value;
            if (raw is! Map) return null;

            final map = raw.entries.fold<Map<String, dynamic>>({}, (map, entry) {
              final key = entry.key.toString();
              final value = _cast(entry.value);
              map[key] = value;
              return map;
            });

            return Versions.fromMap(map);
          });

          _versionsSub = stream.distinct(_versionsEquals).listen((versions) => _versionsSubject.value = versions);
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

  bool _versionsEquals(Versions? a, Versions? b) {
    final aMap = a?.toMap();
    final bMap = a?.toMap();

    if (mapEquals(aMap, bMap)) return true;
    if (aMap == null || bMap == null) return false;

    for (final key in aMap.keys) {
      if (aMap[key] != bMap[key]) return false;
    }
    return true;
  }

  dynamic _cast(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _cast(val)));
    } else if (value is List) {
      return value.map(_cast).toList();
    }
    return value;
  }
}
