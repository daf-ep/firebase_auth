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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/button.dart';
import '../../../common/widgets/input.dart';
import '../../../common/widgets/link.dart';
import '../../../common/widgets/scaffold.dart';
import '../../../common/widgets/spacing.dart';
import '../../../common/widgets/text.dart';
import '../providers/sign_in_provider.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInProvider(),
      child: Consumer<SignInProvider>(
        builder: (_, provider, __) {
          final state = provider.state;

          return AppScaffold(
            children: [
              AppText.title("Sign In"),
              AppSpacing.size4(),
              AppText.subtitle("Welcome back"),
              AppSpacing.size24(),
              AppInput(controller: state.emailController, placeholder: "E-mail"),
              AppSpacing.size12(),
              AppInput(controller: state.passwordController, placeholder: "Password"),
              AppSpacing.size12(),
              AppLink(text: "Forgot Password", onPressed: () => provider.goToForgotPasswordView(context)),
              AppSpacing.size12(),
              AppButton(
                isEnabled: state.isSignInButtonEnabled,
                onPressed: () => provider.logIn(context),
                label: "Log In",
              ),
              AppSpacing.size12(),
              AppLink(text: "Sign Up", onPressed: () => provider.goToSignUpView(context)),
            ],
          );
        },
      ),
    );
  }
}
