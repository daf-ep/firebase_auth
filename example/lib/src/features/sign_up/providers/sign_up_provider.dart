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
import '../../../models/user_profil.dart';

class SignUpState {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController randomTextController = TextEditingController();

  SignUpState();
}

class SignUpProvider extends StateProvider<SignUpState> {
  final _signUp = FiberAuth.signUp;

  SignUpProvider() : super(SignUpState()) {
    state.emailController.addListener(_reload);
    state.passwordController.addListener(_reload);
    state.pseudoController.addListener(_reload);
    state.randomTextController.addListener(_reload);
  }

  @override
  void dispose() {
    state.emailController.removeListener(_reload);
    state.passwordController.removeListener(_reload);
    state.pseudoController.removeListener(_reload);
    state.randomTextController.removeListener(_reload);
    super.dispose();
  }

  void _reload() => notifyListeners();

  Future<void> signUp(BuildContext context) async {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();
    final pseudo = state.pseudoController.text.trim();
    final randomText = state.randomTextController.text.trim();

    if (email.isEmpty || password.isEmpty || pseudo.isEmpty || randomText.isEmpty) return;

    final credentials = Credentials(
      email: email,
      password: password,
      passwordPolicy: PasswordPolicy(min: 7, withLowerCase: true, withUpperCase: true),
    );

    final userProfil = UserProfil(pseudo: pseudo, randomText: randomText);

    final result = await _signUp.signUpWithEmailAndPassword(credentials: credentials, data: userProfil.toJson());
    if (!context.mounted) return;

    if (result.isError) {
      context.error(result.message);
    } else {
      state.emailController.clear();
      state.passwordController.clear();

      Navigator.pop(context);
    }
  }
}

extension SignUpStateExtension on SignUpState {
  bool get isSignUpButtonEnabled =>
      emailController.text.trim().isNotEmpty &&
      passwordController.text.trim().isNotEmpty &&
      pseudoController.text.trim().isNotEmpty &&
      randomTextController.text.trim().isNotEmpty;
}

extension on SignUpResult {
  String get message => switch (this) {
    SignUpResult.emptyEmail => "Please enter your email address.",
    SignUpResult.emptyPassword => "Please enter a password.",
    SignUpResult.invalidEmailFormat => "The email address format is invalid.",
    SignUpResult.noInternet => "No internet connection. Please try again.",
    SignUpResult.tooManyRequests => "Too many attempts. Please try again later.",
    SignUpResult.userAlreadyExists => "An account with this email already exists.",
    SignUpResult.weakPassword => "The password is too weak. Please choose a stronger one.",
    SignUpResult.unknown => "An unexpected error occurred. Please try again.",
    SignUpResult.success => "Account created successfully.",
  };
}
