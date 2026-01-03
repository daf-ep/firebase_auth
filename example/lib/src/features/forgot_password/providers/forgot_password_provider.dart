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

class ForgotPasswordState {
  TextEditingController emailController = TextEditingController();

  ForgotPasswordState();
}

class ForgotPasswordProvider extends StateProvider<ForgotPasswordState> {
  final _forgotPassword = FiberAuth.forgotPassword;

  ForgotPasswordProvider() : super(ForgotPasswordState()) {
    state.emailController.addListener(_reload);
  }

  @override
  void dispose() {
    state.emailController.removeListener(_reload);
    super.dispose();
  }

  Future<void> validate(BuildContext context) async {
    final email = state.emailController.text.trim();
    if (email.isEmpty) return;

    final result = await _forgotPassword.reset(email);
    if (!context.mounted) return;

    if (result.isError) {
      context.error(result.message);
    } else {
      context.success(result.message);
    }
  }

  void _reload() => notifyListeners();
}

extension ForgotPasswordStateExtension on ForgotPasswordState {
  bool get isValidateButtonEnabled => emailController.text.trim().isNotEmpty;
}

extension on ForgotPasswordResult {
  String get message => switch (this) {
    ForgotPasswordResult.emptyEmail => 'Please enter your email address to continue.',
    ForgotPasswordResult.invalidEmailFormat => 'This email address does not appear to be valid.',
    ForgotPasswordResult.noInternet => 'Unable to connect to the internet. Please check your connection and try again.',
    ForgotPasswordResult.userNotFound => 'No account is associated with this email address.',
    ForgotPasswordResult.tooManyRequests => 'You have made too many requests. Please try again later.',
    ForgotPasswordResult.success => 'A password reset message has been sent. Please check your inbox.',
  };
}
