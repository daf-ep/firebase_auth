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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../auth/auth.dart';
import '../../local/local_storage.dart';
import '../user.dart';

abstract class LocalUserMetadataService {
  Future<void> update({int? lastSignInTime});
}

@Singleton(as: LocalUserMetadataService)
class LocalUserMetadataServiceImpl implements LocalUserMetadataService {
  @override
  Future<void> update({int? lastSignInTime}) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    final user = UserServices.current.data.value;
    if (user == null) return;

    if (lastSignInTime == null) return;

    final updatedUser = user.copyWith(
      metadata: user.metadata.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        lastSignInTime: lastSignInTime,
      ),
    );

    await (_db.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(data: Value(json.encode(updatedUser.toMap()))),
    );
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _table => _db.userTable;
}
