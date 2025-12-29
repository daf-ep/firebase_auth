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

import 'package:injectable/injectable.dart';

import '../../../helpers/database_nodes.dart';

abstract class UserIdService {
  /// Resolves the user identifier associated with a specific device.
  ///
  /// This method performs a lookup using the provided [deviceId] and returns
  /// the corresponding user ID if the device is known and linked to a user.
  ///
  /// A `null` value indicates that:
  /// - the device is not registered,
  /// - no user is associated with the device,
  /// - or the stored data is missing or invalid.
  ///
  /// This method is commonly used during sign-in flows to determine whether
  /// the current device has already been authorized for a user.
  Future<String?> getByDeviceId(String deviceId);

  /// Resolves the user identifier associated with an email address.
  ///
  /// This method performs a lookup using the provided [email] and returns
  /// the corresponding user ID if the email is known and linked to a user.
  ///
  /// A `null` value indicates that:
  /// - the email address is not registered,
  /// - no user is associated with the email,
  /// - or the stored data is missing or invalid.
  ///
  /// This method is typically used during authentication and account
  /// recovery flows to resolve user identity from user-provided input.
  Future<String?> getByEmail(String email);
}

@Singleton(as: UserIdService)
class UserIdServiceImpl implements UserIdService {
  @override
  Future<String?> getByDeviceId(String deviceId) async {
    final snapshot = await DatabaseNodes.devices(deviceId).get();
    final raw = snapshot.value;
    if (raw is! String) return null;

    return raw;
  }

  @override
  Future<String?> getByEmail(String email) async {
    final snapshot = await DatabaseNodes.emails(email).get();
    final raw = snapshot.value;
    if (raw is! String) return null;

    return raw;
  }
}
