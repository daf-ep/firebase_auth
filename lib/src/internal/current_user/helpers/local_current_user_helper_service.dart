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
import 'package:rxdart/subjects.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/user.dart';
import '../../auth/user_service.dart';
import '../../local/local_storage.dart';
import '../../users/users_service.dart';

@internal
abstract class LocalCurrentUserHelperService {
  Observe<User?> get data;

  Future<void> add(User user);

  Future<void> update(User? Function(User?) copyWith);

  Future<void> delete();
}

@Singleton(as: LocalCurrentUserHelperService)
class LocalCurrentUserHelperServiceImpl implements LocalCurrentUserHelperService {
  final AuthUserService _authUser;
  final UsersService _users;

  LocalCurrentUserHelperServiceImpl(this._authUser, this._users);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  Observe<User?> get data => Observe<User?>(value: _userSubject.value, stream: _userSubject.stream);

  @override
  Future<void> add(User user) => _db.transaction(() async {
    final existing = await (_db.select(_table)..where((tbl) => tbl.userId.equals(user.userId))).getSingleOrNull();

    if (existing != null && existing.version >= user.version) return;

    await _db
        .into(_table)
        .insert(
          UserTableData(
            userId: user.userId,
            email: user.email.value,
            version: user.version,
            data: json.encode(user.toMap()),
          ),
          mode: InsertMode.insertOrReplace,
        );
  });

  @override
  Future<void> update(User? Function(User?) copyWith) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final updated = copyWith(data.value);
    if (updated == null) return;

    final version = updated.version + 1;

    await (_db.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(
        version: Value(version),
        data: Value(json.encode(updated.copyWith(version: version).toMap())),
      ),
    );
  }

  @override
  Future<void> delete() async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    _userSub?.cancel();
    _userSub = null;

    await (_db.delete(_table)..where((tbl) => tbl.userId.equals(userId))).go();

    _userSubject.value = null;
  }

  @PostConstruct()
  init() async {
    listenToUser();
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _table => _db.userTable;

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
    final row = await (_db.select(_table)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();

    if (row == null) {
      final data = await _users.getUser(userId);
      if (data == null) return;

      await add(data);
    }

    final stream = (_db.select(_table)..where((tbl) => tbl.userId.equals(userId))).watchSingleOrNull().map((row) {
      if (row == null) return null;

      final map = json.decode(row.data) as Map<String, dynamic>;
      return User.fromMap(userId, map);
    });

    _userSub = stream
        .distinct((prev, next) {
          if (prev?.metadata.updatedAt == next?.metadata.updatedAt) return true;
          return false;
        })
        .listen((user) => _userSubject.value = user);
  }
}
