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
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../models/auth/rate_limite.dart';

class RateLimiteInfo {
  final bool isRateLimited;
  final int? resetAt;

  RateLimiteInfo({required this.isRateLimited, required this.resetAt});
}

@internal
abstract class RemoteRateLimiteService {
  Future<RateLimiteInfo> isRateLimited(RateLimite rateLimite, String key);
}

@Singleton(as: RemoteRateLimiteService)
class RemoteRateLimiteServiceImpl implements RemoteRateLimiteService {
  @override
  Future<RateLimiteInfo> isRateLimited(RateLimite rateLimite, String key) async {
    final callable = _instance.httpsCallable('isRateLimited');
    final result = await callable.call({'rateLimiter': rateLimite.value, 'key': key});

    final data = result.data as Map<String, dynamic>?;
    return RateLimiteInfo(isRateLimited: data?['limited'] == true, resetAt: data?['resetAt'] as int?);
  }

  final FirebaseFunctions _instance = FirebaseFunctions.instance;
}

extension on RateLimite {
  String get value => switch (this) {
    RateLimite.signIn => 'sign_in',
    RateLimite.signUp => 'sign_up',
    RateLimite.newDeviceDetectedVerify => 'new_device_detected_verify',
    RateLimite.newDeviceOtpRequest => 'new_device_otp_request',
    RateLimite.resetPassword => 'reset_password',
  };
}
