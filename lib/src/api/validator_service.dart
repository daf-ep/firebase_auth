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

import '../../models/auth/password_policy.dart';
import '../../results/password_validator.dart';

abstract class ValidatorService {
  /// Validates a password against the provided policy.
  ///
  /// The validation is performed deterministically and returns a
  /// [PasswordValidatorResult] describing the outcome.
  ///
  /// The result may indicate:
  /// - that the password fully satisfies the policy,
  /// - or the first detected rule violation (e.g. missing uppercase,
  ///   insufficient length, missing digit).
  ///
  /// This method does **not** throw on validation failure and is safe
  /// to call repeatedly (e.g. on every keystroke).
  PasswordValidatorResult isPasswordValid({required PasswordPolicy passwordPolicy, required String password});
}

@Singleton(as: ValidatorService)
class ValidatorServiceImpl implements ValidatorService {
  @override
  PasswordValidatorResult isPasswordValid({required PasswordPolicy passwordPolicy, required String password}) {
    if (password.length < passwordPolicy.min) return PasswordValidatorResult.weak;

    if (passwordPolicy.withUpperCase && !password.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidatorResult.missingUpperCase;
    }
    if (passwordPolicy.withLowerCase && !password.contains(RegExp(r'[a-z]'))) {
      return PasswordValidatorResult.missingLowerCase;
    }
    if (passwordPolicy.withDigit && !password.contains(RegExp(r'[0-9]'))) {
      return PasswordValidatorResult.missingDigit;
    }
    if (passwordPolicy.withSpecialChar && !password.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return PasswordValidatorResult.missingSpecialChar;
    }
    return PasswordValidatorResult.valid;
  }
}
