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

library;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';

import 'di/di.dart';
import 'src/api/auth/forgot_password.dart';
import 'src/api/auth/sign_in_service.dart';
import 'src/api/auth/sign_up_service.dart';
import 'src/api/user/user.dart';
import 'src/internal/local/local_storage.dart';

export './models/auth/credentials.dart';
export './models/auth/password_policy.dart';
export './models/user/metadata.dart';
export './models/user/user.dart';
export './results/auth.dart';
export './results/forgot_password.dart';
export './results/password_validator.dart';
export './results/sign_in.dart';
export './results/sign_up.dart';
export 'models/user/session.dart';

class FiberAuth {
  static Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    await configureAuthDependencies();
    await LocalStorage.initialize();
  }

  static SignUpService get signUp => GetIt.I.get();
  static SignInService get signIn => GetIt.I.get();
  static ForgotPasswordService get forgotPassword => GetIt.I.get();
  static User get user => User();
}
