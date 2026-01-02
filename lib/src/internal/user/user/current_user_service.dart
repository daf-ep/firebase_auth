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
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/user.dart';
import '../../auth/auth.dart';
import '../../local/local_storage.dart';
import '../version/version_service.dart';
import 'local_current_user_service.dart';
import 'remote_current_user_service.dart';

@internal
abstract class CurrentUserService {
  Observe<User?> get data;
  Future<void> add(User user);
  Future<void> delete(String userId);
}

@Singleton(as: CurrentUserService)
class CurrentUserServiceImpl implements CurrentUserService {
  final LocalCurrentUserService _local;
  final RemoteCurrentUserService _remote;
  final VersionService _version;

  CurrentUserServiceImpl(this._local, this._remote, this._version);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  Observe<User?> get data => Observe<User?>(value: _userSubject.value, stream: _userSubject.stream);

  @override
  Future<void> add(User user) async {
    await _local.add(user);
    await _remote.add(user);
  }

  @override
  Future<void> delete(String userId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    _localUserSub?.cancel();
    _localUserSub = null;
    _userSubject.value = null;

    await _local.delete(userId);
    await _remote.delete(userId);
  }

  @PostConstruct()
  init() async {
    listenToUser();
    listenToVersions();
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _table => _db.userTable;

  StreamSubscription<User?>? _localUserSub;
  StreamSubscription<bool?>? _versionsSub;
  bool _isSyncing = false;
}

extension on CurrentUserServiceImpl {
  void listenToUser() {
    AuthServices.user.userId.stream
        .distinct((prev, next) {
          if (prev == next) return true;
          return false;
        })
        .listen((userId) {
          if (userId == null) {
            _handleSignOut();
          } else {
            _handleSignIn(userId);
          }
        });
  }

  Future<void> _handleSignIn(String userId) async {
    final row = await (_db.select(_table)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

    if (row == null) {
      await getRemoteData();
    }

    final userStream = (_db.select(_table)..where((tbl) => tbl.userId.equals(userId))).watchSingleOrNull().asyncMap((
      row,
    ) async {
      if (row == null) return null;

      final map = json.decode(row.toCompanion(true).data.value) as Map<String, dynamic>;
      return User.fromMap(userId, map);
    });

    _localUserSub?.cancel();
    _localUserSub = null;

    _localUserSub = userStream
        .distinct((prev, next) {
          if (prev?.version == next?.version) return true;
          return false;
        })
        .listen((user) {
          final current = _userSubject.value;

          if (user == null) return;

          if (current != null && user.version < current.version) return;
          _userSubject.value = user;
        });
  }

  void _handleSignOut() {
    _localUserSub?.cancel();
    _localUserSub = null;
    _userSubject.value = null;
  }

  void listenToVersions() {
    _versionsSub?.cancel();
    _versionsSub = null;

    _versionsSub =
        CombineLatestStream.combine2(_version.remote.stream, _version.local.stream, (remote, local) {
              if (remote == null || local == null) return null;
              return remote > local;
            })
            .distinct((prev, next) {
              if (prev == next) return true;
              return false;
            })
            .listen((isNewVersionAvailable) {
              if (isNewVersionAvailable == true && !_isSyncing) {
                getRemoteData();
              }
            });
  }

  Future<void> getRemoteData() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      final userId = AuthServices.user.userId.value;
      if (userId == null) return;

      final data = await _remote.getUser(userId);
      if (data == null) return;

      await add(data);
    } finally {
      _isSyncing = false;
    }
  }
}
