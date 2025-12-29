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

/// {@template password_policy}
/// Defines the validation rules required for a password to be considered secure.
///
/// A [PasswordPolicy] specifies:
/// - The minimum length of the password
/// - Whether it must contain uppercase letters
/// - Whether it must contain lowercase letters
/// - Whether it must contain digits
/// - Whether it must contain special characters
///
/// This class does not validate passwords itself; instead, it provides a
/// configurable rule set that can be applied by an authentication or form
/// validation layer.
///
/// The default policy requires:
/// - A minimum length of 6
/// - No other mandatory character constraints
///
/// Use stricter settings to align with security or compliance requirements.
/// {@endtemplate}
class PasswordPolicy {
  /// Minimum allowed password length.
  ///
  /// Must be **at least 6**, enforced through an assertion.
  final int min;

  /// Whether the password must contain **at least one uppercase letter**.
  final bool withUpperCase;

  /// Whether the password must contain **at least one lowercase letter**.
  final bool withLowerCase;

  /// Whether the password must contain **at least one numeric digit**.
  final bool withDigit;

  /// Whether the password must contain **at least one special character**
  /// (e.g., `! @ # $ % ^ & *`).
  final bool withSpecialChar;

  /// {@macro password_policy}
  PasswordPolicy({
    this.min = 6,
    this.withUpperCase = false,
    this.withLowerCase = false,
    this.withDigit = false,
    this.withSpecialChar = false,
  }) : assert(min >= 6, 'min must be at least 6');
}
