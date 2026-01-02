// Copyright (C) 2026 Fiber
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../results/auth.dart';

@internal
abstract class AuthSignUpService {
  Future<CreateUserWithEmailAndPassword> createUserWithEmailAndPassword(String email, String password);
}

@Singleton(as: AuthSignUpService)
class AuthSignUpServiceImpl implements AuthSignUpService {
  @override
  Future<CreateUserWithEmailAndPassword> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final userId = newUser.user?.uid;

      if (userId == null) {
        return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
      }

      return CreateUserWithEmailAndPassword(userId: userId, result: CreateUserWithEmailAndPasswordResult.success);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.userAlreadyExists,
          );
        case 'invalid-email':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.invalidEmailFormat,
          );
        case 'operation-not-allowed':
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
        case 'weak-password':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.weakPassword,
          );
        case 'too-many-requests':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.tooManyRequests,
          );
        case 'network-request-failed':
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.noInternet);
        default:
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
      }
    }
  }
}
