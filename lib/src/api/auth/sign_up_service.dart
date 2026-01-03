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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:string_validator/string_validator.dart';

import '../../../extensions/local.dart';
import '../../../models/auth/credentials.dart';
import '../../../models/auth/password_policy.dart';
import '../../../models/auth/rate_limite.dart';
import '../../../models/user/email.dart';
import '../../../models/user/metadata.dart';
import '../../../models/user/preferred_language.dart';
import '../../../models/user/session.dart';
import '../../../models/user/user.dart';
import '../../../results/auth.dart';
import '../../../results/password_validator.dart';
import '../../../results/sign_up.dart';
import '../../internal/auth/rate_limite/rate_limite_service.dart';
import '../../internal/auth/sign_up_service.dart';
import '../../internal/device/device_info_service.dart';
import '../../internal/device/network_service.dart';
import '../../internal/user/user/current_user_service.dart';

abstract class SignUpService {
  Future<SignUpResult> signUpWithEmailAndPassword({
    required Credentials credentials,
    required Map<String, dynamic> data,
  });

  PasswordValidatorResult isPasswordValid({required PasswordPolicy passwordPolicy, required String password});
}

@Singleton(as: SignUpService)
class SignUpServiceImpl implements SignUpService {
  final DeviceInfoService _deviceInfo;
  final NetworkService _network;
  final RateLimiteService _rateLimite;
  final AuthSignUpService _signUp;
  final CurrentUserService _currentUser;

  SignUpServiceImpl(this._deviceInfo, this._network, this._rateLimite, this._signUp, this._currentUser);

  @override
  Future<SignUpResult> signUpWithEmailAndPassword({
    required Credentials credentials,
    required Map<String, dynamic> data,
  }) async {
    final policy = credentials.passwordPolicy ?? PasswordPolicy(min: 6);

    final email = credentials.email;
    final password = credentials.password;

    if (email.isEmpty) return SignUpResult.emptyEmail;
    if (!email.isEmail) return SignUpResult.invalidEmailFormat;
    if (password.isEmpty ||
        isPasswordValid(passwordPolicy: policy, password: password) != PasswordValidatorResult.valid) {
      return SignUpResult.weakPassword;
    }
    if (!_network.isReachable) return SignUpResult.noInternet;

    final deviceId = _deviceInfo.identifier;
    if (await _rateLimite.isRateLimited(RateLimite.signUp, deviceId)) return SignUpResult.tooManyRequests;

    final createAccountResult = await _signUp.createUserWithEmailAndPassword(email, password);
    final userId = createAccountResult.userId;

    if (userId == null || createAccountResult.result.isError) {
      return switch (createAccountResult.result) {
        CreateUserWithEmailAndPasswordResult.invalidEmailFormat => SignUpResult.invalidEmailFormat,
        CreateUserWithEmailAndPasswordResult.noInternet => SignUpResult.noInternet,
        CreateUserWithEmailAndPasswordResult.tooManyRequests => SignUpResult.tooManyRequests,
        CreateUserWithEmailAndPasswordResult.unknown => SignUpResult.unknown,
        CreateUserWithEmailAndPasswordResult.userAlreadyExists => SignUpResult.userAlreadyExists,
        CreateUserWithEmailAndPasswordResult.weakPassword => SignUpResult.weakPassword,
        CreateUserWithEmailAndPasswordResult.success => SignUpResult.success,
      };
    }

    final device = Session(
      deviceId: _deviceInfo.identifier,
      deviceInfo: DeviceInfo(
        deviceId: _deviceInfo.identifier,
        operatingSystem: _deviceInfo.operatingSystem,
        deviceCategory: _deviceInfo.device,
        isPhysicalDevice: _deviceInfo.isPhysical,
        model: _deviceInfo.model,
      ),
      metadata: SessionMetadata(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        isSignedIn: true,
        lastSignInTime: DateTime.now().millisecondsSinceEpoch,
      ),
      networkLocation: NetworkLocation(
        city: _deviceInfo.ipInfo?.city,
        country: _deviceInfo.ipInfo?.country,
        ip: _deviceInfo.ipInfo?.ip,
      ),
      preferences: SessionPreferences(
        language: PlatformDispatcher.instance.locale.convert(),
        themeMode: (WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark)
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );

    final user = User(
      userId: userId,
      version: 1,
      email: Email(value: email, histories: []),
      sessions: [device],
      metadata: UserMetadata(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        lastSignInTime: DateTime.now().millisecondsSinceEpoch,
      ),
      preferredLanguage: PreferredLanguage(current: PlatformDispatcher.instance.locale.convert(), histories: []),
      data: data,
    );

    await _currentUser.add(user);

    return SignUpResult.success;
  }

  @override
  PasswordValidatorResult isPasswordValid({required PasswordPolicy passwordPolicy, required String password}) {
    if (password.length < passwordPolicy.min) return PasswordValidatorResult.weak;

    if (passwordPolicy.withUpperCase && !password.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidatorResult.missingUpperCase;
    }
    if (passwordPolicy.withLowerCase && !password.contains(RegExp(r'[a-z]'))) {
      return PasswordValidatorResult.missingLowerCase;
    }
    if (passwordPolicy.withDigit && !password.contains(RegExp(r'[0-9]'))) {
      return PasswordValidatorResult.missingDigit;
    }
    if (passwordPolicy.withSpecialChar && !password.contains(RegExp(r'[^A-Za-z0-9]'))) {
      return PasswordValidatorResult.missingSpecialChar;
    }
    return PasswordValidatorResult.valid;
  }
}
