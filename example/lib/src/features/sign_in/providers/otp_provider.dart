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
// Fiber BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'package:example/src/common/widgets/top_snack_bar.dart';
import 'package:fiber_firebase_auth/fiber_firebase_auth.dart';
import 'package:flutter/widgets.dart';

import '../../../common/provider/state_provider.dart';

class OtpState {
  Duration resendOtpDelay;
  TextEditingController otpController = TextEditingController();

  OtpState({required this.resendOtpDelay});
}

class OtpProvider extends StateProvider<OtpState> {
  final _signIn = FiberAuth.signIn;

  OtpProvider() : super(OtpState(resendOtpDelay: FiberAuth.signIn.resendOtpDelay.value)) {
    state.otpController.addListener(_reload);

    _signIn.resendOtpDelay.stream
        .listen((duration) {
          state.resendOtpDelay = duration;
          notifyListeners();
        })
        .store(this);
  }

  @override
  void dispose() {
    state.otpController.removeListener(_reload);
    super.dispose();
  }

  void _reload() => notifyListeners();

  Future<void> validate(BuildContext context) async {
    final otp = state.otpController.text.trim();

    if (otp.length == 6) {
      final result = await _signIn.verifyOtp(otp);
      if (!context.mounted) return;

      if (result.isError) {
        context.error(result.message);
      } else {
        context.success(result.message);
      }
    }
  }

  Future<void> askNewOtp(BuildContext context) => _signIn.askNewOtp();
}

extension OtpStateExtension on OtpState {
  bool get isValidateButtonEnabled => otpController.text.trim().isNotEmpty;

  bool get canResendOtp => resendOtpDelay.inSeconds == 0;
}

extension SignInOtpResultMessage on SignInOtpResult {
  String get message => switch (this) {
    SignInOtpResult.emptyOtp => 'Please enter the verification code.',
    SignInOtpResult.noInternet => 'No internet connection. Please try again.',
    SignInOtpResult.invalidOrExpired => 'The code is invalid or has expired.',
    SignInOtpResult.tooManyRequests => 'Too many attempts. Please try again later.',
    SignInOtpResult.invalidCredentials => 'The login information is incorrect.',
    SignInOtpResult.userDisabled => 'This account has been disabled.',
    SignInOtpResult.unknown => 'An unexpected error occurred. Please try again.',
    SignInOtpResult.success => 'Code verified successfully.',
  };
}
