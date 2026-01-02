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

import '../../../../helpers/database.dart';
import '../../../../models/user/user.dart';
import '../../auth/auth.dart';

@internal
abstract class RemoteCurrentUserService {
  Future<void> add(User user);
  Future<void> delete(String userId);
  Future<User?> getUser(String userId);
}

@Singleton(as: RemoteCurrentUserService)
class RemoteCurrentUserServiceImpl implements RemoteCurrentUserService {
  @override
  Future<void> add(User user) => DatabaseNodes.users(user.userId).set(user.toMap());

  @override
  Future<void> delete(String userId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await DatabaseNodes.users(userId).remove();
  }

  @override
  Future<User?> getUser(String userId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return null;

    final snapshot = await DatabaseNodes.users(userId).get();
    final raw = snapshot.value;
    if (raw is! Map) return null;

    final map = raw.entries.fold<Map<String, dynamic>>({}, (map, entry) {
      final key = entry.key.toString();
      final value = _cast(entry.value);
      map[key] = value;
      return map;
    });
    return User.fromMap(userId, map);
  }
}

extension on RemoteCurrentUserServiceImpl {
  dynamic _cast(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _cast(val)));
    } else if (value is List) {
      return value.map(_cast).toList();
    }
    return value;
  }
}
