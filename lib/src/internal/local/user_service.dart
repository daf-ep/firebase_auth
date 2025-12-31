// Copyright (C) 2025 Fiber
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

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/user/user.dart';
import '../remote/auth/auth_service.dart';
import '../remote/database/remote_version_service.dart';
import '../remote/database/user_service.dart';
import 'local_storage.dart';

@internal
abstract class LocalUserService {
  /// Persists the given user in local storage.
  ///
  /// This method stores a serialized representation of the provided [User]
  /// in the local database, replacing any existing entry for the same user.
  ///
  /// It is typically invoked:
  /// - after a successful sign-in or sign-up,
  /// - when fresh user data is fetched from the remote source,
  /// - or during synchronization after a version update.
  ///
  /// This operation does not emit directly to consumers; updates are
  /// propagated through the [userStream].
  Future<void> add(User user);

  /// Removes a user from local storage.
  ///
  /// This operation clears the locally persisted user data and resets
  /// the in-memory user state.
  ///
  /// It is commonly used during sign-out, account deletion, or when
  /// local data must be invalidated for consistency or security reasons.
  Future<void> deleteById(String userId);

  Future<void> deleteByEmail(String email);

  /// Latest locally cached user.
  ///
  /// Returns the most recent user snapshot stored in local storage, or
  /// `null` if no user is currently authenticated or cached.
  ///
  /// This getter provides synchronous access to the in-memory state and
  /// should be treated as read-only by consumers.
  User? get user;

  /// Reactive stream of the locally cached user.
  ///
  /// Emits whenever the local user changes due to authentication events,
  /// local persistence updates, or remote synchronization.
  ///
  /// Consumers should rely on this stream to keep UI and domain logic
  /// synchronized with the current user state.
  Stream<User?> get userStream;
}

@Singleton(as: LocalUserService)
class LocalUserServiceImpl implements LocalUserService {
  final RemoteAuthService _auth;
  final RemoteUserService _user;
  final RemoteVersionService _remoteVersion;

  LocalUserServiceImpl(this._auth, this._user, this._remoteVersion);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  User? get user => _userSubject.value;

  @override
  Stream<User?> get userStream => _userSubject.stream;

  @override
  Future<void> add(User user) async {
    await _instance.transaction(() async {
      final existing = await (_instance.select(
        _table,
      )..where((tbl) => tbl.userId.equals(user.userId))).getSingleOrNull();

      if (existing != null && existing.version >= user.version) return;

      await _instance
          .into(_table)
          .insert(
            UserTableData(
              userId: user.userId,
              email: user.email,
              version: user.version,
              data: json.encode(user.toMap()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    });
  }

  @override
  Future<void> deleteById(String userId) async {
    final authUserId = _auth.userId;
    if (authUserId == null) return;

    _localUserSub?.cancel();
    _localUserSub = null;

    _userSubject.value = null;

    await (_instance.delete(_table)..where((tbl) => tbl.userId.equals(authUserId))).go();
  }

  @override
  Future<void> deleteByEmail(String email) async {
    _localUserSub?.cancel();
    _localUserSub = null;
    _userSubject.value = null;

    await (_instance.delete(_table)..where((tbl) => tbl.email.equals(email))).go();
  }

  @PostConstruct()
  init() async {
    listenToUser();
    listenToVersions();
  }

  LocalAuthStorage get _instance => LocalAuthStorage.instance;
  $UserTableTable get _table => _instance.userTable;

  StreamSubscription<User?>? _localUserSub;
  StreamSubscription<bool?>? _versionsSub;
  bool _isSyncing = false;
}

extension on LocalUserServiceImpl {
  void listenToUser() {
    _auth.userIdStream
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
    final row = await (_instance.select(_table)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

    if (row == null) {
      await getRemoteData();
    }

    final userStream = (_instance.select(_table)..where((tbl) => tbl.userId.equals(userId)))
        .watchSingleOrNull()
        .asyncMap((row) async {
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
        CombineLatestStream.combine2(_remoteVersion.versionStream, _userSubject.stream.map((user) => user?.version), (
              remoteVersion,
              localVersion,
            ) {
              _log('VERSION compare → remote=$remoteVersion local=$localVersion');

              if (remoteVersion == null || localVersion == null) return null;
              return remoteVersion > localVersion;
            })
            .distinct((prev, next) {
              if (prev == next) return true;
              return false;
            })
            .listen((isNewVersionAvailable) {
              _log('VERSION newAvailable=$isNewVersionAvailable');

              if (isNewVersionAvailable == true && !_isSyncing) {
                _log('VERSION trigger getRemoteData()');
                getRemoteData();
              }
            });
  }

  Future<void> getRemoteData() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      final userId = _auth.userId;
      if (userId == null) return;
      print("===============> getData");

      final data = await _user.getUser(userId);
      if (data == null) return;

      await add(data);
    } finally {
      _isSyncing = false;
    }
  }

  void _log(String message) {
    // ignore: avoid_print
    print('[LocalUserService] $message');
  }
}
