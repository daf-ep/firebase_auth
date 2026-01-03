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
import 'package:flutter/material.dart';

import '../../../common/provider/state_provider.dart';
import '../../forgot_password/views/forgot_password_view.dart';
import '../../sign_up/views/sign_up_view.dart';
import '../views/otp_view.dart';

class SignInState {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  SignInState();
}

class SignInProvider extends StateProvider<SignInState> {
  final _signIn = FiberAuth.signIn;

  SignInProvider() : super(SignInState()) {
    state.emailController.addListener(_reload);
    state.passwordController.addListener(_reload);
  }

  @override
  void dispose() {
    state.emailController.removeListener(_reload);
    state.passwordController.removeListener(_reload);
    super.dispose();
  }

  void _reload() => notifyListeners();

  Future<void> logIn(BuildContext context) async {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    final result = await _signIn.signInWithEmailAndPassword(email, password);
    if (!context.mounted) return;

    if (result.isError) {
      context.error(result.message);
    } else if (result.isWaitingAction) {
      context.info(result.message);
      state.emailController.clear();
      state.passwordController.clear();

      Navigator.push(context, MaterialPageRoute(builder: (_) => OtpView()));
    } else {
      state.emailController.clear();
      state.passwordController.clear();
    }
  }

  void goToForgotPasswordView(BuildContext context) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordView()));

  void goToSignUpView(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpView()));
}

extension SignInStateExtension on SignInState {
  bool get isSignInButtonEnabled => emailController.text.trim().isNotEmpty && passwordController.text.trim().isNotEmpty;
}

extension on SignInResult {
  String get message => switch (this) {
    SignInResult.emptyEmail => "Please enter your email address.",
    SignInResult.emptyPassword => "Please enter your password.",
    SignInResult.invalidEmailFormat => "The email address format is invalid.",
    SignInResult.invalidCredentials => "The email or password is incorrect.",
    SignInResult.newDeviceDetected => "A new device was detected. Please verify this sign-in.",
    SignInResult.userDisabled => "This account has been disabled.",
    SignInResult.noInternet => "No internet connection. Please try again.",
    SignInResult.tooManyRequests => "Too many attempts. Please try again later.",
    SignInResult.unknown => "An unexpected error occurred. Please try again.",
    SignInResult.success => "Sign in successful.",
  };
}
