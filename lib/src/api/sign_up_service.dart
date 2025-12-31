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

import '../../extensions/local.dart';
import '../../models/auth/credentials.dart';
import '../../models/auth/password_policy.dart';
import '../../models/user/device.dart';
import '../../models/user/metadata.dart';
import '../../models/user/preferred_language.dart';
import '../../models/user/user.dart';
import '../../results/auth.dart';
import '../../results/password_validator.dart';
import '../../results/sign_up.dart';
import '../internal/device/device_info_service.dart';
import '../internal/device/network_service.dart';
import '../internal/local/user_service.dart';
import '../internal/remote/auth/auth_service.dart';
import '../internal/remote/database/user_service.dart';
import 'validator_service.dart';

abstract class SignUpService {
  /// Creates a new user account using an email address and password.
  ///
  /// This method performs all required validation and initialization steps
  /// and returns a [SignUpResult] describing the outcome of the operation.
  ///
  /// The result may indicate:
  /// - a successful account creation,
  /// - a validation failure (e.g. invalid email, weak password),
  /// - a network-related error,
  /// - or an authentication-layer failure (e.g. account already exists).
  ///
  /// This method is asynchronous and safe to call from UI or domain layers.
  Future<SignUpResult> signUpWithEmailAndPassword({
    required Credentials credentials,
    required Map<String, dynamic> data,
  });
}

@Singleton(as: SignUpService)
class SignUpServiceImpl implements SignUpService {
  final DeviceInfoService _deviceInfo;
  final NetworkService _network;
  final RemoteAuthService _auth;
  final RemoteUserService _user;
  final LocalUserService _localUser;
  final ValidatorService _validator;

  SignUpServiceImpl(this._deviceInfo, this._network, this._auth, this._user, this._localUser, this._validator);

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
        _validator.isPasswordValid(passwordPolicy: policy, password: password) != PasswordValidatorResult.valid) {
      return SignUpResult.weakPassword;
    }
    if (!_network.isReachable) return SignUpResult.noInternet;

    final createAccountResult = await _auth.createUserWithEmailAndPassword(email, password);
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

    final device = UserDevice(
      deviceId: _deviceInfo.identifier,
      deviceInfo: UserDeviceInfo(
        deviceId: _deviceInfo.identifier,
        operatingSystem: _deviceInfo.operatingSystem,
        deviceCategory: _deviceInfo.device,
        isPhysicalDevice: _deviceInfo.isPhysical,
        model: _deviceInfo.model,
      ),
      metadata: UserDeviceMetadata(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        isSignedIn: true,
        lastSignInTime: DateTime.now().millisecondsSinceEpoch,
      ),
      lastKnownPosition: UserLastKnownPosition(
        city: _deviceInfo.ipInfo?.city,
        country: _deviceInfo.ipInfo?.country,
        ip: _deviceInfo.ipInfo?.ip,
      ),
      preferences: UserDevicePreferences(
        language: PlatformDispatcher.instance.locale.convert(),
        themeMode: (WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark)
            ? ThemeMode.dark
            : ThemeMode.light,
      ),
    );

    final user = User(
      userId: userId,
      version: 1,
      email: email,
      devices: [device],
      metadata: UserMetadata(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        lastSignInTime: DateTime.now().millisecondsSinceEpoch,
      ),
      preferredLanguage: PreferredLanguage(current: PlatformDispatcher.instance.locale.convert(), histories: []),
      data: data,
    );

    await _localUser.add(user);
    await _user.add(user);

    return SignUpResult.success;
  }
}
