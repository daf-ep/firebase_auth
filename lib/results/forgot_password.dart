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

/// {@template forgot_password_result}
/// Enumerates all possible outcomes of a password reset request.
///
/// Each value in [ForgotPasswordResult] corresponds to a distinct state
/// or error condition encountered during the password reset workflow.
/// It allows higher-level logic (such as UI or analytics) to react precisely
/// to user input errors, network failures, or backend validation results.
///
/// This enum is typically returned inside a [Result] wrapper by
/// [ForgotPasswordInterface.reset].
///
/// Example:
/// ```dart
/// final result = await forgotPasswordRepository.reset("user@example.com");
/// switch (result.value) {
///   case ForgotPasswordResult.success:
///     showMessage("Check your email for the reset link.");
///     break;
///   case ForgotPasswordResult.userNotFound:
///     showError("No account found for this email.");
///     break;
///   default:
///     showError("An unexpected error occurred.");
/// }
/// ```
/// {@endtemplate}
enum ForgotPasswordResult {
  /// The provided email is empty.
  ///
  /// Triggered when the user submits the reset form without entering
  /// any email address. The UI should prompt the user to fill in the field.
  emptyEmail,

  /// The email format is invalid.
  ///
  /// Occurs when the input string does not match a valid email pattern,
  /// such as missing an "@" or domain part.
  /// Example of invalid input: `username` or `user@`.
  invalidEmailFormat,

  /// The device is offline or unable to reach the internet.
  ///
  /// Indicates that the request could not be completed due to connectivity issues.
  /// The user should check their connection and retry.
  noInternet,

  /// The provided email does not correspond to any existing user.
  ///
  /// Typically returned when the email is not registered in Firebase Authentication
  /// or was entered incorrectly. The user may need to register or correct it.
  userNotFound,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// The password reset request succeeded.
  ///
  /// A password reset email or OTP was successfully dispatched to the user.
  /// The UI should prompt the user to check their inbox.
  success,
}

/// {@template forgot_password_otp_result}
/// Enumerates all possible outcomes of an OTP verification
/// during the password reset process.
///
/// Each value in [ForgotPasswordOtpResult] represents a distinct state
/// that can occur while validating a one-time password (OTP) sent to the user.
/// This helps differentiate between user input issues, connectivity failures,
/// expired tokens, or successful verification.
///
/// Typically returned by [ForgotPasswordInterface.verifyOtp].
///
/// Example:
/// ```dart
/// final result = await forgotPasswordRepository.verifyOtp("927461");
/// switch (result.value) {
///   case ForgotPasswordOtpResult.success:
///     showMessage("OTP verified successfully.");
///     break;
///   case ForgotPasswordOtpResult.invalidOrExpired:
///     showError("The code is invalid or has expired.");
///     break;
///   default:
///     showError("An unexpected error occurred.");
/// }
/// ```
/// {@endtemplate}
enum ForgotPasswordOtpResult {
  /// The provided OTP is empty.
  ///
  /// Triggered when the user submits the form without entering a code.
  /// The interface should prompt the user to input the OTP.
  emptyOtp,

  /// The device has no active internet connection.
  ///
  /// The OTP verification cannot be completed while offline.
  /// The user should restore connectivity before retrying.
  noInternet,

  /// The provided email does not correspond to any existing user.
  ///
  /// Typically returned when the email is not registered in Firebase Authentication
  /// or was entered incorrectly. The user may need to register or correct it.
  userNotFound,

  /// The user account exists but has been disabled.
  ///
  /// May result from administrative action, security enforcement, or policy violation.
  /// The user should contact support to restore access.
  userDisabled,

  /// The provided OTP is invalid or has expired.
  ///
  /// Returned when the entered code does not match the stored one
  /// or when its lifetime has exceeded the allowed duration.
  /// The user should request a new OTP.
  invalidOrExpired,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// An unexpected error occurred during verification.
  ///
  /// Used as a fallback when an unknown or unhandled exception occurs,
  /// such as a server issue or data inconsistency.
  unknown,

  /// The OTP was successfully verified.
  ///
  /// Indicates that the code entered by the user matched the stored hash
  /// and that the password reset process can continue.
  success,
}

/// {@template forgot_password_new_otp_result}
/// Represents the possible outcomes when requesting a new OTP (One-Time Password)
/// during the password reset process.
///
/// This enum is typically returned by the authentication service after
/// attempting to generate and send a new OTP to the user's registered email.
/// Each value corresponds to a specific result that can guide the UI response.
/// {@endtemplate}
enum ForgotPasswordNewOtpResult {
  /// {@template forgot_password_new_otp_result_no_internet_connection}
  /// No active internet connection is available.
  ///
  /// The new OTP request cannot be completed because the device is offline
  /// or unable to reach the authentication server.
  ///
  /// The UI should inform the user that an internet connection is required
  /// and prompt them to reconnect before retrying.
  /// {@endtemplate}
  noInternet,

  /// {@template forgot_password_new_otp_result_unknown}
  /// An unexpected or unhandled error occurred.
  ///
  /// Serves as a fallback for rare or unidentified issues such as:
  /// - Temporary backend failure
  /// - Invalid configuration
  /// - Unexpected exceptions during OTP generation or dispatch
  ///
  /// The UI should display a generic error message and invite the user
  /// to retry later.
  /// {@endtemplate}
  unknown,

  /// The client has made too many sign-up attempts.
  ///
  /// The backend may temporarily lock the user from retrying.
  tooManyRequests,

  /// {@template forgot_password_new_otp_result_success}
  /// The new OTP was successfully generated and sent.
  ///
  /// Indicates that the backend successfully processed the request and
  /// delivered a new verification code to the user’s registered email.
  ///
  /// The interface should inform the user that a new OTP has been sent
  /// and prompt them to check their inbox (and possibly their spam folder).
  /// {@endtemplate}
  success,
}

/// {@template forgot_password_update_password_result}
/// Enumerates all possible outcomes of a **password update attempt**
/// during the password reset process.
///
/// Each value in [ForgotPasswordUpdatePasswordResult] represents a distinct
/// validation or system state that may occur while setting a new password.
/// This allows clear differentiation between user input errors,
/// connectivity issues, backend validation failures, or successful updates.
///
/// Typically returned by [ForgotPasswordInterface.updatePassword].
///
/// Example:
/// ```dart
/// final result = await forgotPasswordRepository.updatePassword(
///   "john@example.com",
///   "StrongPass1",
///   "StrongPass1",
/// );
///
/// switch (result.value) {
///   case ForgotPasswordUpdatePasswordResult.success:
///     showMessage("Password updated successfully.");
///     break;
///   case ForgotPasswordUpdatePasswordResult.notIdenticalConfirmPassword:
///     showError("Passwords do not match.");
///     break;
///   case ForgotPasswordUpdatePasswordResult.weakNewPassword:
///     showError("Password does not meet security requirements.");
///     break;
///   default:
///     showError("An unexpected error occurred.");
/// }
/// ```
///
/// ### Notes
/// - Each case is a distinct logical outcome, not an exception.
/// - Should always be wrapped in a [Result] to provide structured feedback.
/// - Used by password recovery workflows to standardize validation and result handling.
///
/// See also:
/// * [ForgotPasswordOtpResult], which handles OTP validation outcomes.
/// * [ForgotPasswordNewOtpResult], which covers new OTP generation.
/// {@endtemplate}
enum ForgotPasswordUpdatePasswordResult {
  /// The new password field is empty.
  ///
  /// Triggered when the user submits the form without entering a new password.
  /// The interface should prompt the user to input a valid password.
  emptyNewPassword,

  /// The confirmation password field is empty.
  ///
  /// Occurs when the user does not re-enter the password for confirmation.
  /// The UI should request confirmation before proceeding.
  emptyConfirmNewPassword,

  /// The new password and its confirmation do not match.
  ///
  /// Indicates a mismatch between the entered passwords.
  /// The user should retype the values to ensure consistency.
  notIdenticalConfirmPassword,

  /// The new password does not meet the required security policy.
  ///
  /// Typically returned when it fails to satisfy the regex pattern:
  /// - at least 7 characters long,
  /// - includes one lowercase letter,
  /// - includes one uppercase letter,
  /// - includes one digit.
  weakNewPassword,

  /// No active internet connection.
  ///
  /// The password update cannot be completed while offline.
  /// The user should restore connectivity before retrying.
  noInternet,

  /// The provided email does not correspond to any existing user.
  ///
  /// Triggered when the email is not found in the authentication system.
  /// The user may need to verify the email or register a new account.
  userNotFound,

  /// The user account exists but has been disabled.
  ///
  /// May result from administrative action, policy violation,
  /// or a security enforcement decision.
  /// The user should contact support for resolution.
  userDisabled,

  /// An unexpected or unhandled error occurred.
  ///
  /// Serves as a fallback for rare issues such as:
  /// - backend inconsistencies,
  /// - transient service failures,
  /// - or unknown exceptions.
  unknown,

  /// The password was successfully updated.
  ///
  /// Indicates that the user’s password has been securely changed
  /// and the reset process can now be completed.
  success,
}
