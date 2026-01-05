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

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/avatar.dart';
import '../../../../models/user/email.dart';
import '../../../../models/user/metadata.dart';
import '../../../../models/user/password.dart';
import '../../../../models/user/preferred_language.dart';
import '../../../../models/user/session.dart';
import '../../../../models/user/user.dart';
import '../../../../models/user/version.dart';
import '../../auth/user_service.dart';
import '../../local/local_storage.dart';
import '../../users/users_service.dart';

@internal
abstract class LocalCurrentUserHelperService {
  Observe<User?> get data;

  Future<void> add(User user);

  Future<void> update(Future<User?> Function(User?) copyWith);

  Future<void> delete();
}

@Singleton(as: LocalCurrentUserHelperService)
class LocalCurrentUserHelperServiceImpl implements LocalCurrentUserHelperService {
  final AuthUserService _authUser;
  final RemoteUsersService _users;

  LocalCurrentUserHelperServiceImpl(this._authUser, this._users);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  Observe<User?> get data => Observe<User?>(value: _userSubject.value, stream: _userSubject.stream);

  @override
  Future<void> add(User user) => _db.transaction(() async {
    final localVersions = await (_db.select(
      _versionsTable,
    )..where((t) => t.userId.equals(user.userId))).getSingleOrNull();

    final remote = user.versions;

    if (localVersions == null) {
      await _insertAll(user);
      await _insertVersions(user.userId, remote);
      return;
    }

    if (remote.email != localVersions.email) await _updateEmail(user);
    if (remote.data != localVersions.data) await _updateData(user);
    if (remote.avatar != localVersions.avatar) await _updateAvatar(user);
    if (remote.passwordHistories != localVersions.passwordHistories) await _updatePasswordHistories(user);
    if (remote.metadata != localVersions.metadata) await _updateMetadata(user);
    if (remote.preferredLanguage != localVersions.preferredLanguage) await _updatePreferredLanguage(user);
    if (remote.sessions != localVersions.sessions) await _updateSessions(user);

    await _insertVersions(user.userId, remote);
  });

  @override
  Future<void> update(Future<User?> Function(User?) copyWith) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final current = data.value;
    if (current == null) return;

    final updated = await copyWith(current);
    if (updated == null) return;

    await _db.transaction(() async {
      final localVersions = await (_db.select(_versionsTable)..where((t) => t.userId.equals(userId))).getSingleOrNull();

      if (localVersions == null) return;

      final updates = <Future<void>>[];
      var newVersions = updated.versions;

      if (!mapEquals(updated.email.toMap(), current.email.toMap())) {
        updates.add(_updateEmail(updated));
        newVersions = newVersions.copyWith(email: localVersions.email + 1);
      }

      if (!mapEquals(updated.data, current.data)) {
        updates.add(_updateData(updated));
        newVersions = newVersions.copyWith(data: localVersions.data + 1);
      }

      if (!mapEquals(updated.avatar?.toMap() ?? {}, current.avatar?.toMap() ?? {})) {
        updates.add(_updateAvatar(updated));
        newVersions = newVersions.copyWith(avatar: localVersions.avatar + 1);
      }

      if (!listEquals(
        updated.passwordHistories.map((h) => h.toMap()).toList(),
        current.passwordHistories.map((h) => h.toMap()).toList(),
      )) {
        updates.add(_updatePasswordHistories(updated));
        newVersions = newVersions.copyWith(passwordHistories: localVersions.passwordHistories + 1);
      }

      if (!mapEquals(updated.metadata.toMap(), current.metadata.toMap())) {
        updates.add(_updateMetadata(updated));
        newVersions = newVersions.copyWith(metadata: localVersions.metadata + 1);
      }

      if (!mapEquals(updated.preferredLanguage.toMap(), current.preferredLanguage.toMap())) {
        updates.add(_updatePreferredLanguage(updated));
        newVersions = newVersions.copyWith(preferredLanguage: localVersions.preferredLanguage + 1);
      }

      if (!listEquals(
        updated.sessions.map((s) => s.toMap()).toList(),
        current.sessions.map((s) => s.toMap()).toList(),
      )) {
        updates.add(_updateSessions(updated));
        newVersions = newVersions.copyWith(sessions: localVersions.sessions + 1);
      }

      for (final u in updates) {
        await u;
      }

      await _insertVersions(userId, newVersions);

      _userSubject.value = updated.copyWith(versions: newVersions);
    });
  }

  @override
  Future<void> delete() async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    _userSub?.cancel();
    _userSub = null;

    await _db.transaction(() async {
      await (_db.delete(_usersTable)..where((t) => t.userId.equals(userId))).go();
      await (_db.delete(_versionsTable)..where((t) => t.userId.equals(userId))).go();
    });

    _userSubject.value = null;
  }

  @PostConstruct()
  init() async {
    listenToUser();
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _usersTable => _db.userTable;
  $VersionsTableTable get _versionsTable => _db.versionsTable;

  StreamSubscription<User?>? _userSub;
}

extension on LocalCurrentUserHelperServiceImpl {
  void listenToUser() {
    _authUser.userId.stream
        .distinct((prev, next) {
          if (prev == next) return true;
          return false;
        })
        .listen((userId) {
          _userSub?.cancel();
          _userSub = null;

          if (userId == null) {
            _userSubject.value = null;
            return;
          }

          _handleSignIn(userId);
        });
  }

  Future<void> _handleSignIn(String userId) async {
    final row = await (_db.select(_usersTable)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

    if (row == null) {
      final remote = await _users.user(userId);
      if (remote == null) return;

      await add(remote);
    }

    final userStream = (_db.select(_usersTable)..where((t) => t.userId.equals(userId))).watchSingleOrNull();
    final versionsStream = (_db.select(_versionsTable)..where((t) => t.userId.equals(userId))).watchSingleOrNull();

    final stream = CombineLatestStream.combine2(userStream, versionsStream, (user, versions) {
      if (user == null || versions == null) return null;

      return User(
        userId: userId,
        email: Email.fromMap(json.decode(user.email)),
        metadata: UserMetadata.fromMap(json.decode(user.metadata)),
        sessions: (json.decode(user.sessions) as Map<String, dynamic>).entries
            .map((e) => Session.fromMap(e.key, e.value as Map<String, dynamic>))
            .toList(),
        preferredLanguage: PreferredLanguage.fromMap(json.decode(user.preferredLanguage)),
        passwordHistories: (json.decode(user.passwordHistories) as List<dynamic>)
            .map((e) => PasswordHistories.fromMap(e as Map<String, dynamic>))
            .toList(),
        data: user.data == null ? null : json.decode(user.data!),
        avatar: user.avatar == null ? null : Avatar.fromMap(json.decode(user.avatar!)),
        versions: Versions(
          data: versions.data,
          email: versions.email,
          avatar: versions.avatar,
          metadata: versions.metadata,
          preferredLanguage: versions.preferredLanguage,
          sessions: versions.sessions,
          passwordHistories: versions.passwordHistories,
        ),
      );
    });

    _userSub = stream
        .distinct((prev, next) {
          if (mapEquals(prev?.toMap(), next?.toMap())) return true;
          if (prev == null || next == null) return false;

          return prev.versions == next.versions && prev.metadata.updatedAt == next.metadata.updatedAt;
        })
        .listen((user) => _userSubject.value = user);
  }

  Future<void> _insertAll(User user) => _db
      .into(_usersTable)
      .insert(
        UserTableData(
          userId: user.userId,
          email: user.email.value,
          data: json.encode(user.data),
          avatar: json.encode(user.avatar),
          metadata: json.encode(user.metadata.toMap()),
          preferredLanguage: json.encode(user.preferredLanguage.toMap()),
          sessions: json.encode(Map.fromEntries(user.sessions.map((s) => MapEntry(s.deviceId, s.toMap())))),
          passwordHistories: json.encode(user.passwordHistories.map((p) => p.toMap()).toList()),
        ),
        mode: InsertMode.insertOrReplace,
      );

  Future<void> _updateEmail(User user) => (_db.update(_usersTable)..where((t) => t.userId.equals(user.userId))).write(
    UserTableCompanion(email: Value(json.encode(user.email.toMap()))),
  );

  Future<void> _updateData(User user) => (_db.update(
    _usersTable,
  )..where((t) => t.userId.equals(user.userId))).write(UserTableCompanion(data: Value(json.encode(user.data))));

  Future<void> _updateAvatar(User user) => (_db.update(
    _usersTable,
  )..where((t) => t.userId.equals(user.userId))).write(UserTableCompanion(avatar: Value(json.encode(user.avatar))));

  Future<void> _updatePasswordHistories(User user) =>
      (_db.update(_usersTable)..where((t) => t.userId.equals(user.userId))).write(
        UserTableCompanion(
          passwordHistories: Value(json.encode(user.passwordHistories.map((h) => h.toMap()).toList())),
        ),
      );

  Future<void> _updateMetadata(User user) => (_db.update(_usersTable)..where((t) => t.userId.equals(user.userId)))
      .write(UserTableCompanion(metadata: Value(json.encode(user.metadata.toMap()))));

  Future<void> _updatePreferredLanguage(User user) =>
      (_db.update(_usersTable)..where((t) => t.userId.equals(user.userId))).write(
        UserTableCompanion(preferredLanguage: Value(json.encode(user.preferredLanguage.toMap()))),
      );

  Future<void> _updateSessions(User user) =>
      (_db.update(_usersTable)..where((t) => t.userId.equals(user.userId))).write(
        UserTableCompanion(
          sessions: Value(json.encode(Map.fromEntries(user.sessions.map((s) => MapEntry(s.deviceId, s.toMap()))))),
        ),
      );

  Future<void> _insertVersions(String userId, Versions versions) => _db
      .into(_versionsTable)
      .insert(
        VersionsTableCompanion(
          userId: Value(userId),
          data: Value(versions.data),
          email: Value(versions.email),
          metadata: Value(versions.metadata),
          preferredLanguage: Value(versions.preferredLanguage),
          sessions: Value(versions.sessions),
        ),
        mode: InsertMode.insertOrReplace,
      );
}
