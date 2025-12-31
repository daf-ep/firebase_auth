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

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../helpers/database.dart';
import '../../../../models/user/user.dart';
import '../../device/device_info_service.dart';
import '../auth/auth_service.dart';

@internal
abstract class RemoteUserService {
  /// Persists a new user in the remote data store and initializes
  /// all required associations for the current device.
  ///
  /// This operation is typically invoked after a successful
  /// authentication or sign-up flow. Implementations are responsible
  /// for ensuring that the user record is created atomically and that
  /// the current device is correctly linked to the user.
  Future<void> add(User user);

  /// Deletes a user and all associated device references.
  ///
  /// This operation removes the user record from the remote data store
  /// and cleans up any device-to-user mappings.
  ///
  /// Implementations may silently ignore the call if no authenticated
  /// user is present or if the local user state is unavailable.
  Future<void> delete(String userId);

  /// Retrieves a user by its unique identifier.
  ///
  /// Returns the fully hydrated [User] if the user exists, or `null`
  /// if no user record is found or the stored data is invalid.
  ///
  /// This method performs a remote lookup and is safe to use for
  /// session restoration or user refresh flows.
  Future<User?> getUser(String userId);
}

@Singleton(as: RemoteUserService)
class RemoteUserServiceImpl implements RemoteUserService {
  final RemoteAuthService _auth;
  final DeviceInfoService deviceInfo;

  RemoteUserServiceImpl(this._auth, this.deviceInfo);

  @override
  Future<void> add(User user) async {
    await DatabaseNodes.users(user.userId).set(user.toMap());
  }

  @override
  Future<void> delete(String userId) async {
    if (!_auth.isUserConnected) return;

    final user = await getUser(userId);
    if (user == null) return;

    await DatabaseNodes.users(user.userId).remove();
  }

  @override
  Future<User?> getUser(String userId) async {
    final userId = _auth.userId;
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

extension on RemoteUserServiceImpl {
  dynamic _cast(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _cast(val)));
    } else if (value is List) {
      return value.map(_cast).toList();
    }
    return value;
  }
}
