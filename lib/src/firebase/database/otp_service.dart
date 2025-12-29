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
import '../../../models/auth/otp.dart';

abstract class OtpService {
  /// Persists a one-time password (OTP) for the given identity.
  ///
  /// This method stores the provided [Otp] data in the remote data store,
  /// typically indexed by the associated email address.
  ///
  /// It is commonly invoked during authentication or verification flows
  /// such as sign-up confirmation, password reset, or sensitive action
  /// validation.
  ///
  /// Implementations are responsible for overwriting any existing OTP
  /// associated with the same identity and ensuring the data is stored
  /// atomically.
  Future<void> insert(Otp otp);

  /// Retrieves the currently stored one-time password for an email address.
  ///
  /// Returns the OTP value as a `String` if one exists and is still available,
  /// or `null` if no OTP is found or the stored value is invalid.
  ///
  /// This method is typically used during OTP verification to compare
  /// user-provided input with the stored value.
  Future<String?> get(String email);
}

@Singleton(as: OtpService)
class OtpServiceImpl implements OtpService {
  @override
  Future<void> insert(Otp otp) => DatabaseNodes.otps(otp.email).set(otp.toMap());

  @override
  Future<String?> get(String email) async {
    final snapshot = await DatabaseNodes.otps(email).child(OtpConstants.otp).get();
    final raw = snapshot.value;
    if (raw is! String) return null;
    return raw;
  }
}
