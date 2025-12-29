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

/// {@template sign_up_result}
/// Enumerates the **possible outcomes** of a user registration (sign-up) attempt.
///
/// A [SignUpResult] value provides a clear, type-safe representation of why a
/// registration succeeded or failed. It helps distinguish between validation
/// errors, backend rejections, and unexpected failures without relying on
/// raw exception messages.
///
/// Example:
/// ```dart
/// final result = await auth.signUpWithEmailAndPassword(signUp);
///
/// switch (result.value) {
///   case SignUpResult.success:
///     print('Account created successfully.');
///     break;
///   case SignUpResult.userAlreadyExists:
///     print('Email already registered.');
///     break;
///   case SignUpResult.weakPassword:
///     print('Password too weak.');
///     break;
///   default:
///     print('Sign-up failed: ${result.value}');
/// }
/// ```
///
/// ### Notes
/// - Each value represents a distinct logical outcome, not an exception.
/// - Should always be wrapped in a [Result] object to convey both status and context.
/// - Typically used by [SignUpInterface] implementations for Firebase or Appwrite.
///
/// See also:
///  * [SignUpInterface], which defines the abstract registration contract.
/// {@endtemplate}
enum SignUpResult {
  /// The email field is empty.
  ///
  /// The user attempted to sign up without entering an email address.
  emptyEmail,

  /// The password field is empty.
  ///
  /// The user attempted to sign up without entering a password.
  emptyPassword,

  /// The provided email does not match a valid format.
  ///
  /// Occurs when the input is malformed, missing the '@' symbol,
  /// or lacks a valid domain part (e.g. `example.com`).
  invalidEmailFormat,

  /// No active internet connection.
  ///
  /// The operation cannot proceed without a valid network connection.
  noInternet,

  /// The provided password is too weak.
  ///
  /// Typically triggered when the backend enforces password policies
  /// (e.g., minimum length, special characters).
  weakPassword,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// An account already exists with the provided email address.
  ///
  /// Returned when the backend detects an existing registration
  /// for the same email.
  userAlreadyExists,

  /// An unexpected or unhandled error occurred.
  ///
  /// Used as a fallback when no specific mapping applies.
  unknown,

  /// The registration completed successfully.
  ///
  /// The user account has been created and is now valid.
  success;

  bool get isError => switch (this) {
    SignUpResult.emptyEmail ||
    SignUpResult.emptyPassword ||
    SignUpResult.invalidEmailFormat ||
    SignUpResult.noInternet ||
    SignUpResult.weakPassword ||
    SignUpResult.tooManyRequests ||
    SignUpResult.userAlreadyExists ||
    SignUpResult.unknown => true,
    SignUpResult.success => false,
  };

  bool get isSuccess => !isError;
}
