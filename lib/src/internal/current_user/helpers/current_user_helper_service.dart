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

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/user.dart';
import '../../auth/user_service.dart';
import '../../device/device_info_service.dart';
import 'local_current_user_helper_service.dart';
import 'remote_current_user_helper_service.dart';

class Version {
  final int? local;
  final int? remote;

  Version({required this.local, required this.remote});
}

@internal
abstract class CurrentUserHelperService {
  Observe<User?> get data;

  Future<void> add(User user);

  Future<User?> get();

  Future<void> update(User? Function(User?) copyWith);

  Future<void> delete();

  Observe<List<String>?> get connectedDevices;

  Observe<Version> get version;
}

@Singleton(as: CurrentUserHelperService)
class CurrentUserHelperServiceImpl implements CurrentUserHelperService {
  final LocalCurrentUserHelperService _local;
  final RemoteCurrentUserHelperService _remote;
  final DeviceInfoService _deviceInfo;
  final AuthUserService _authUser;

  CurrentUserHelperServiceImpl(this._local, this._remote, this._deviceInfo, this._authUser);

  final _userSubject = BehaviorSubject<User?>.seeded(null);
  final _versionSubject = BehaviorSubject<Version>.seeded(Version(local: null, remote: null));

  @override
  Observe<Version> get version => Observe<Version>(value: _versionSubject.value, stream: _versionSubject.stream);

  @override
  Observe<User?> get data => Observe<User?>(value: _userSubject.value, stream: _userSubject.stream);

  @override
  Future<void> add(User user) async {
    await _local.add(user);
    await _remote.add(user);
  }

  @override
  Future<User?> get() => _remote.get();

  @override
  Future<void> update(User? Function(User?) copyWith) async {
    await _local.update(copyWith);
    await _remote.update(copyWith);
  }

  @override
  Future<void> delete() async {
    await _local.delete();
    await _remote.delete();
  }

  @override
  Observe<List<String>?> get connectedDevices => _remote.connectedDevices;

  @PostConstruct()
  init() async {
    listenToUser();
    listenToVersion();
    listenToSync();
    listenToCurrentDevice();
    listenToConnectedDevices();
  }

  bool _isSyncing = false;
}

extension on CurrentUserHelperServiceImpl {
  void listenToUser() {
    _local.data.stream
        .distinct((prev, next) {
          if (prev?.metadata.updatedAt == next?.metadata.updatedAt) return true;
          return false;
        })
        .listen((user) => _userSubject.value = user);
  }

  void listenToConnectedDevices() {
    CombineLatestStream.combine2(data.stream, connectedDevices.stream, (data, connectedDevices) {
      if (data == null) return null;

      return connectedDevices;
    }).listen((connectedDevices) {
      if (connectedDevices == null) return;

      final current = data.value;
      if (current == null) return;

      bool changed = false;

      final updatedSessions = current.sessions.map((session) {
        final isOnline = connectedDevices.contains(session.deviceId);

        if (session.metadata.isSignedIn == isOnline) return session;

        changed = true;
        return session.copyWith(metadata: session.metadata.copyWith(isSignedIn: isOnline));
      }).toList();

      if (!changed) return;

      _userSubject.value = current.copyWith(sessions: updatedSessions);
    });
  }

  void listenToCurrentDevice() {
    data.stream
        .map((data) => data?.sessions)
        .distinct((prev, next) {
          if (listEquals(
            prev?.map((session) => session.toMap()).toList() ?? [],
            next?.map((session) => session.toMap()).toList() ?? [],
          )) {
            return true;
          }
          return false;
        })
        .listen((sessions) {
          final deviceIds = sessions?.map((session) => session.deviceId).toList();
          if (deviceIds == null) return;

          final deviceId = _deviceInfo.identifier;
          if (!deviceIds.contains(deviceId)) {
            _authUser.signOut();
          }
        });
  }

  void listenToVersion() {
    CombineLatestStream.combine2(
          _local.data.stream.map((data) => data?.version),
          _remote.version.stream,
          (local, remote) => Version(local: local, remote: remote),
        )
        .distinct((prev, next) {
          if (prev.local == next.local && prev.remote == next.remote) return true;
          return false;
        })
        .listen((version) => _versionSubject.value = version);
  }

  void listenToSync() {
    version.stream
        .distinct((prev, next) {
          if (prev.local == next.local && prev.remote == next.remote) return true;
          return false;
        })
        .listen((version) {
          final local = version.local;
          final remote = version.remote;

          if (local == null || remote == null) return;

          final isNewVersionAvailable = remote > local;
          if (isNewVersionAvailable == true && !_isSyncing) {
            _sync();
          }
        });
  }

  Future<void> _sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final data = await get();
      if (data == null) return;

      await _local.update((_) => data);
    } finally {
      _isSyncing = false;
    }
  }
}
