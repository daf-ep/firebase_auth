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

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../results/auth.dart';
import '../device/device_info_service.dart';

@internal
abstract class AuthSignInService {
  Future<SignInWithEmailAndPasswordResult> signInWithEmailAndPassword(String email, String password);

  Future<void> askOtp(String email);

  Future<bool> verify(String email, String otp);
}

@Singleton(as: AuthSignInService)
class AuthSignInServiceImpl implements AuthSignInService {
  final DeviceInfoService _deviceInfo;

  AuthSignInServiceImpl(this._deviceInfo);

  @override
  Future<SignInWithEmailAndPasswordResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return SignInWithEmailAndPasswordResult.success;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          return SignInWithEmailAndPasswordResult.invalidEmailFormat;
        case 'user-disabled':
          return SignInWithEmailAndPasswordResult.userDisabled;

        case 'too-many-requests':
          return SignInWithEmailAndPasswordResult.tooManyRequests;

        case 'network-request-failed':
          return SignInWithEmailAndPasswordResult.noInternet;

        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          return SignInWithEmailAndPasswordResult.invalidCredentials;

        default:
          return SignInWithEmailAndPasswordResult.unknown;
      }
    }
  }

  @override
  Future<void> askOtp(String email) async {
    final callable = _instance.httpsCallable("askNewDeviceDectectedOtp");
    await callable.call({'email': email, 'deviceId': _deviceInfo.identifier});
  }

  @override
  Future<bool> verify(String email, String otp) async {
    final callable = _instance.httpsCallable('verifyNewDeviceDetectedOtp');

    try {
      final result = await callable.call({'email': email, 'deviceId': _deviceInfo.identifier, 'otp': otp});

      return result.data?['success'] == true;
    } catch (_) {
      return false;
    }
  }

  final FirebaseFunctions _instance = FirebaseFunctions.instance;
}
