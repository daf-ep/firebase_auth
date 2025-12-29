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
import 'package:injectable/injectable.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../models/user/user.dart';
import '../../firebase/auth/auth_service.dart';
import '../../firebase/database/remote_version_service.dart';
import '../../firebase/database/user_service.dart';
import '../local_storage.dart';

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
  Future<void> delete(String userId);

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
  final AuthService _auth;
  final UserService _user;
  final RemoteVersionService _remoteVersion;

  LocalUserServiceImpl(this._auth, this._user, this._remoteVersion);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  User? get user => _userSubject.value;

  @override
  Stream<User?> get userStream => _userSubject.stream;

  @override
  Future<void> add(User user) => _instance
      .into(_table)
      .insert(
        UserTableData(userId: user.userId, version: user.version, data: json.encode(user.data.toMap())),
        mode: InsertMode.insertOrReplace,
      );

  @override
  Future<void> delete(String userId) async {
    final userId = _auth.userId;
    if (userId == null) return;

    _localUserSub?.cancel();
    _localUserSub = null;

    _userSubject.value = null;

    await (_instance.delete(_table)..where((tbl) => tbl.userId.equals(userId))).go();
  }

  @PostConstruct()
  init() async {
    listenToUser();
    listenToVersionData();
  }

  LocalAuthStorage get _instance => LocalAuthStorage.instance;
  $UserTableTable get _table => _instance.userTable;

  StreamSubscription<User?>? _localUserSub;
  bool _isNewDataWaiting = false;
}

extension on LocalUserServiceImpl {
  void listenToUser() {
    _auth.userIdStream.distinct().listen((userId) {
      if (userId == null) {
        _userSubject.value = null;
      } else {
        final user = (_instance.select(_table)..where((tbl) => tbl.userId.equals(userId))).watchSingleOrNull().asyncMap(
          (row) async {
            if (row == null) return null;

            final map = json.decode(row.toCompanion(true).data.value) as Map<String, dynamic>;
            return User.fromMap(userId, map);
          },
        );

        _localUserSub?.cancel();
        _localUserSub = null;

        _localUserSub = user.distinct().listen((user) => _userSubject.value = user);
      }
    });
  }

  void listenToVersionData() {
    CombineLatestStream.combine2(_remoteVersion.versionStream, _userSubject.stream.map((user) => user?.version), (
      remoteVersion,
      localVersion,
    ) {
      if (remoteVersion == null || localVersion == null) return null;
      return remoteVersion > localVersion;
    }).distinct().listen((isNewVersionAvailable) {
      if (isNewVersionAvailable == null) return;

      if (isNewVersionAvailable && !_isNewDataWaiting) {
        getNewData();
      }
    });
  }

  Future<void> getNewData() async {
    _isNewDataWaiting = true;

    final userId = _auth.userId;
    if (userId == null) {
      _isNewDataWaiting = false;
      return;
    }
    final data = await _user.getUser(userId);
    if (data == null) {
      _isNewDataWaiting = false;
      return;
    }

    await add(data);
    _isNewDataWaiting = false;
  }
}
