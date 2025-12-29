// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber SAS. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber SAS.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber SAS.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER SAS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'password_policy.dart';

/// {@template credentials}
/// Holds the authentication credentials required to sign in or create an account.
///
/// This model bundles:
/// - The user's email address
/// - The plaintext password (typically validated or hashed elsewhere)
/// - An optional [PasswordPolicy] defining constraints such as minimum length,
///   required characters, or security rules
///
/// It is intentionally lightweight and is often used as a parameter for:
/// - authentication services
/// - form validation
/// - account creation flows
///
/// Sensitive fields such as [password] should be handled securely and never
/// logged or exposed.
/// {@endtemplate}
class Credentials {
  /// The user’s email address.
  ///
  /// Must be a valid email format. Usually validated before use.
  final String email;

  /// The user’s plaintext password.
  ///
  /// This value should typically be validated by a [PasswordPolicy] or
  /// encrypted/hashed before transmission or storage.
  final String password;

  /// Optional password policy used to validate the strength or format of [password].
  ///
  /// If `null`, no validation policy is applied by this model.
  final PasswordPolicy? passwordPolicy;

  /// {@macro credentials}
  Credentials({required this.email, required this.password, this.passwordPolicy});
}
