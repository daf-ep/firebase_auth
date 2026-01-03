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
import '../../auth/auth.dart';
import '../../auth/user_service.dart';
import '../../local/local_storage.dart';

@internal
abstract class LocalVersionService {
  Observe<int?> get version;

  Future<void> upgrade();
}

@Singleton(as: LocalVersionService)
class LocalVersionServiceImpl implements LocalVersionService {
  final AuthUserService _authUser;

  LocalVersionServiceImpl(this._authUser);

  final _versionSubject = BehaviorSubject<int?>.seeded(null);

  @override
  Observe<int?> get version => Observe<int?>(value: _versionSubject.value, stream: _versionSubject.stream);

  @override
  Future<void> upgrade() async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    final row = await (_db.select(_table)..where((tbl) => tbl.userId.equals(userId))).getSingleOrNull();
    if (row == null) return;

    final map = json.decode(row.toCompanion(true).data.value) as Map<String, dynamic>;
    final user = User.fromMap(userId, map);
    final version = row.version + 1;

    await (_db.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(
        version: Value(version),
        data: Value(json.encode(user.copyWith(version: version).toMap())),
      ),
    );
  }

  @PostConstruct()
  init() async {
    listenToCurrentLocalVersion();
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _table => _db.userTable;

  StreamSubscription<int?>? _versionSub;
}

extension on LocalVersionServiceImpl {
  void listenToCurrentLocalVersion() {
    _authUser.userId.stream
        .distinct((prev, next) {
          if (prev == next) return true;
          return false;
        })
        .listen((userId) {
          _versionSub?.cancel();
          _versionSub = null;

          if (userId != null) {
            final versionStream = (_db.select(_table)..where((tbl) => tbl.userId.equals(userId)))
                .watchSingleOrNull()
                .asyncMap((row) async {
                  if (row == null) return null;

                  return row.version;
                });

            _versionSub = versionStream
                .distinct((prev, next) {
                  if (prev == next) return true;
                  return false;
                })
                .listen((version) => _versionSubject.value = version);
          }
        });
  }
}
