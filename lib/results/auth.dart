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

class CreateUserWithEmailAndPassword {
  final String? userId;
  final CreateUserWithEmailAndPasswordResult result;

  CreateUserWithEmailAndPassword({required this.userId, required this.result});
}

enum CreateUserWithEmailAndPasswordResult {
  /// The provided email does not match a valid format.
  ///
  /// Occurs when the input is malformed, missing the '@' symbol,
  /// or lacks a valid domain part (e.g. `example.com`).
  invalidEmailFormat,

  /// An account already exists with the provided email address.
  ///
  /// Returned when the backend detects an existing registration
  /// for the same email.
  userAlreadyExists,

  /// The provided password is too weak.
  ///
  /// Typically triggered when the backend enforces password policies
  /// (e.g., minimum length, special characters).
  weakPassword,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// No active internet connection.
  ///
  /// The operation cannot proceed without a valid network connection.
  noInternet,

  /// An unexpected or unhandled error occurred.
  ///
  /// Used as a fallback when no specific mapping applies.
  unknown,

  /// The registration completed successfully.
  ///
  /// The user account has been created and is now valid.
  success;

  bool get isError => switch (this) {
    CreateUserWithEmailAndPasswordResult.invalidEmailFormat ||
    CreateUserWithEmailAndPasswordResult.noInternet ||
    CreateUserWithEmailAndPasswordResult.weakPassword ||
    CreateUserWithEmailAndPasswordResult.tooManyRequests ||
    CreateUserWithEmailAndPasswordResult.userAlreadyExists ||
    CreateUserWithEmailAndPasswordResult.unknown => true,
    CreateUserWithEmailAndPasswordResult.success => false,
  };

  bool get isSuccess => !isError;
}

enum SignInWithEmailAndPasswordResult {
  invalidEmailFormat,
  userDisabled,
  tooManyRequests,
  noInternet,
  invalidCredentials,
  unknown,
  success;

  bool get isError => switch (this) {
    SignInWithEmailAndPasswordResult.invalidEmailFormat ||
    SignInWithEmailAndPasswordResult.noInternet ||
    SignInWithEmailAndPasswordResult.tooManyRequests ||
    SignInWithEmailAndPasswordResult.unknown ||
    SignInWithEmailAndPasswordResult.userDisabled ||
    SignInWithEmailAndPasswordResult.invalidCredentials => true,
    SignInWithEmailAndPasswordResult.success => false,
  };

  bool get isSuccess => !isError;
}

enum TestCredientialResult { invalidEmail, userDisabled, tooManyRequests, networkRequestFailed, invalid, valid }
