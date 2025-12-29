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

/// {@template sign_in_result}
/// Enumerates all **possible outcomes** of a user authentication attempt.
///
/// The [SignInResult] enum provides a structured and type-safe representation
/// of the different states that can result from a sign-in process.
/// Each value corresponds to a distinct logical outcome — from user input
/// validation failures to backend-specific responses such as invalid credentials
/// or disabled accounts.
///
/// Using [SignInResult] avoids reliance on raw exception strings and ensures
/// that authentication results are predictable, testable, and easy to handle
/// in both UI and service layers.
///
/// Example:
/// ```dart
/// final result = await auth.signInWithEmailAndPassword(email, password);
///
/// switch (result.value) {
///   case SignInResult.success:
///     print("User successfully signed in.");
///     break;
///   case SignInResult.invalidCredentials:
///     print("Invalid email or password.");
///     break;
///   case SignInResult.noInternet:
///     print("No internet connection.");
///     break;
///   default:
///     print("Sign-in failed: ${result.value}");
/// }
/// ```
///
/// ### Notes
/// - Each value is a defined **logical outcome**, not an exception.
/// - It is typically wrapped in a [Result] object to preserve both
///   the result and its contextual data (e.g., logs, metadata).
/// - Commonly used in Firebase, Appwrite, or any custom authentication service.
///
/// See also:
///  * [SignInInterface], which defines the authentication contract.
/// {@endtemplate}
enum SignInResult {
  /// The provided email field was left empty.
  ///
  /// Occurs when the user submits the sign-in form without an email.
  /// The UI should prompt the user to enter their email address.
  emptyEmail,

  /// The provided password field was left empty.
  ///
  /// Indicates that the password field was not filled out.
  /// The user should be prompted to provide their password.
  emptyPassword,

  /// The provided email does not match a valid format.
  ///
  /// Typically occurs when the string lacks an "@" symbol or domain part.
  /// Example of invalid input: `username` or `user@`.
  invalidEmailFormat,

  /// The provided credentials are invalid.
  ///
  /// Returned when the email exists but the password is incorrect,
  /// or when no user corresponds to the provided credentials.
  invalidCredentials,

  /// No active internet connection is detected.
  ///
  /// The sign-in request cannot proceed while the device is offline.
  /// The user should reconnect and retry.
  noInternet,

  /// The user made too many authentication attempts in a short time.
  ///
  /// This usually triggers a temporary lockout to prevent brute-force attacks.
  /// The user should wait before trying again.
  tooManyRequests,

  /// The user account has been disabled.
  ///
  /// May occur due to administrative action, policy enforcement,
  /// or security violations. The user should contact support.
  userDisabled,

  /// An unexpected or unclassified error occurred.
  ///
  /// Acts as a fallback for all unhandled exceptions or unknown conditions.
  unknown,

  /// The sign-in attempt originated from a new or unrecognized device.
  ///
  /// This event may trigger extra verification, such as OTP confirmation
  /// or device-based security checks.
  newDeviceDetected,

  /// The sign-in process completed successfully.
  ///
  /// The user has been authenticated, and the session is now active.
  success;

  bool get isWaitingAction => this == newDeviceDetected;

  bool get isSuccess => this == success;

  bool get isError => !isWaitingAction && !isSuccess;
}

/// {@template sign_in_otp_result}
/// Enumerates the **possible outcomes** of an OTP (One-Time Password) verification
/// during the sign-in process.
///
/// A [SignInOtpResult] value provides a clear, type-safe indication of whether
/// the OTP verification succeeded, failed, or encountered an unexpected issue.
/// This enum is typically used in conjunction with [Result] to report both
/// the outcome and any contextual information.
///
/// Example:
/// ```dart
/// final result = await auth.verifyOtp("123456");
///
/// switch (result.value) {
///   case SignInOtpResult.success:
///     print("OTP verified successfully.");
///     break;
///   case SignInOtpResult.invalidOrExpired:
///     print("OTP is invalid or expired.");
///     break;
///   case SignInOtpResult.noInternet:
///     print("Network unavailable. Please try again later.");
///     break;
///   default:
///     print("Verification failed: ${result.value}");
/// }
/// ```
///
/// ### Notes
/// - Each case corresponds to a distinct logical outcome.
/// - Used in security flows like **new device detection** or **multi-factor authentication**.
/// - The `invalidOrExpired` state covers both incorrect OTP input and expired codes.
///
/// See also:
///  * [SignInResult], which represents general sign-in outcomes.
/// {@endtemplate}
enum SignInOtpResult {
  /// The provided OTP field was empty.
  ///
  /// The user submitted an empty input during verification.
  emptyOtp,

  /// No active internet connection is available.
  ///
  /// The OTP verification request cannot proceed without network access.
  noInternet,

  /// The OTP is invalid or has expired.
  ///
  /// This may occur when the user enters an incorrect code or when
  /// the OTP’s validity period has elapsed.
  invalidOrExpired,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// An unexpected or unhandled error occurred.
  ///
  /// Used as a fallback for unknown failures during verification.
  unknown,

  /// The OTP verification completed successfully.
  ///
  /// The provided OTP was valid, and authentication can proceed.
  success;

  bool get isSuccess => this == success;

  bool get isError => !isSuccess;
}

/// {@template sign_in_new_otp_result}
/// Enumerates the **possible outcomes** of a *new OTP (One-Time Password)* request
/// triggered when a new device or session is detected.
///
/// A [SignInNewOtpResult] value provides a type-safe indication of whether
/// the OTP generation and dispatch process succeeded, failed, or encountered
/// a network or internal issue.
///
/// Example:
/// ```dart
/// final result = await auth.newOtp("user@example.com");
///
/// switch (result.value) {
///   case SignInNewOtpResult.success:
///     print("New OTP sent successfully.");
///     break;
///   case SignInNewOtpResult.userNotFound:
///     print("No user associated with this email.");
///     break;
///   case SignInNewOtpResult.noInternet:
///     print("Network unavailable. Please try again later.");
///     break;
///   default:
///     print("OTP generation failed: ${result.value}");
/// }
/// ```
///
/// ### Notes
/// - Each case corresponds to a distinct logical outcome of the OTP *generation* process.
/// - Commonly used in flows like **new device detection** or **passwordless authentication**.
/// - Unlike [SignInOtpResult], this enum describes the *sending* of an OTP, not its verification.
///
/// See also:
///  * [SignInOtpResult], which represents OTP **verification** outcomes.
/// {@endtemplate}
enum SignInNewOtpResult {
  /// No active internet connection is available.
  ///
  /// The new OTP request cannot proceed without network access.
  noInternet,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// An unexpected or unhandled error occurred.
  ///
  /// Used as a fallback for unknown failures during OTP generation.
  unknown,

  /// The new OTP was successfully generated and sent.
  ///
  /// The backend accepted the request and dispatched the OTP to the user.
  success;

  bool get isSuccess => this == success;

  bool get isError => !isSuccess;
}
