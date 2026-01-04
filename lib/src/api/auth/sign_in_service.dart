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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:string_validator/string_validator.dart';

import '../../../extensions/local.dart';
import '../../../models/auth/rate_limite.dart';
import '../../../models/observe.dart';
import '../../../models/user/session.dart';
import '../../../results/auth.dart';
import '../../../results/sign_in.dart';
import '../../internal/auth/rate_limite/rate_limite_service.dart';
import '../../internal/auth/sign_in_service.dart';
import '../../internal/current_user/metadata_service.dart';
import '../../internal/current_user/sessions_service.dart';
import '../../internal/device/device_info_service.dart';
import '../../internal/device/network_service.dart';
import '../../internal/users/sessions_service.dart';
import '../../internal/users/users_service.dart';

abstract class SignInService {
  Future<SignInResult> signInWithEmailAndPassword(String email, String password);
  Future<SignInOtpResult> verifyOtp(String otp);
  Future<SignInNewOtpResult> askNewOtp();
  Observe<Duration> get resendOtpDelay;
}

@Singleton(as: SignInService)
class SignInServiceImpl implements SignInService {
  final DeviceInfoService _deviceInfo;
  final NetworkService _network;
  final RateLimiteService _rateLimite;
  final CurrentSessionsService _userSessions;
  final AuthSignInService _authSignIn;
  final CurrentUserMetadataService _userMetadata;
  final UsersSessionsService _usersSessions;
  final UsersService _users;

  SignInServiceImpl(
    this._deviceInfo,
    this._network,
    this._rateLimite,
    this._userSessions,
    this._authSignIn,
    this._userMetadata,
    this._usersSessions,
    this._users,
  );

  String? _newDeviceDetectedEmail;
  String? _newDeviceDetectedPassword;

  final _durationSubject = BehaviorSubject<Duration>.seeded(Duration(minutes: 1, seconds: 30));

  @override
  Observe<Duration> get resendOtpDelay =>
      Observe<Duration>(value: _durationSubject.value, stream: _durationSubject.stream);

  @override
  Future<SignInResult> signInWithEmailAndPassword(String email, String password) async {
    email = email.trim().toLowerCase();
    password = password.trim();

    if (email.isEmpty) return SignInResult.emptyEmail;
    if (password.isEmpty) return SignInResult.emptyPassword;
    if (!email.isEmail) return SignInResult.invalidEmailFormat;
    if (!_network.isReachable) return SignInResult.noInternet;

    final deviceId = _deviceInfo.identifier;
    final userId = await _users.getUserId(email);
    if (userId == null) return SignInResult.invalidCredentials;

    if (await _rateLimite.isRateLimited(RateLimite.signIn, deviceId)) return SignInResult.tooManyRequests;

    final isDeviceExists = await _usersSessions.isExists(userId, deviceId);
    if (!isDeviceExists) {
      _newDeviceDetectedEmail = email;
      _newDeviceDetectedPassword = password;

      final askOtpResponse = await _authSignIn.askOtp(email);
      if (askOtpResponse.isLimited) return SignInResult.tooManyRequests;

      _updateOtpRetryAfter();

      return SignInResult.newDeviceDetected;
    }

    final signInWithEmailAndPasswordResult = await _authSignIn.signInWithEmailAndPassword(email, password);
    await _userSessions.update(lastSignInTime: DateTime.now().millisecondsSinceEpoch);
    await _userMetadata.update(lastSignInTime: DateTime.now().millisecondsSinceEpoch);

    return switch (signInWithEmailAndPasswordResult) {
      SignInWithEmailAndPasswordResult.invalidCredentials => SignInResult.invalidCredentials,
      SignInWithEmailAndPasswordResult.invalidEmailFormat => SignInResult.invalidEmailFormat,
      SignInWithEmailAndPasswordResult.noInternet => SignInResult.noInternet,
      SignInWithEmailAndPasswordResult.tooManyRequests => SignInResult.tooManyRequests,
      SignInWithEmailAndPasswordResult.userDisabled => SignInResult.userDisabled,
      SignInWithEmailAndPasswordResult.unknown => SignInResult.unknown,
      SignInWithEmailAndPasswordResult.success => SignInResult.success,
    };
  }

  @override
  Future<SignInOtpResult> verifyOtp(String otp) async {
    final email = _newDeviceDetectedEmail;
    final password = _newDeviceDetectedPassword;
    if (email == null || password == null) return SignInOtpResult.invalidOrExpired;

    otp = otp.trim();

    if (otp.isEmpty) return SignInOtpResult.emptyOtp;
    if (!_network.isReachable) return SignInOtpResult.noInternet;

    final deviceId = _deviceInfo.identifier;

    if (await _rateLimite.isRateLimited(RateLimite.newDeviceDetectedVerify, deviceId)) {
      return SignInOtpResult.tooManyRequests;
    }

    if (!await _authSignIn.verify(email, otp)) return SignInOtpResult.invalidOrExpired;

    final signInWithEmailAndPasswordResult = await _authSignIn.signInWithEmailAndPassword(email, password);
    if (signInWithEmailAndPasswordResult.isError) {
      return switch (signInWithEmailAndPasswordResult) {
        SignInWithEmailAndPasswordResult.invalidCredentials => SignInOtpResult.invalidCredentials,
        SignInWithEmailAndPasswordResult.userDisabled => SignInOtpResult.userDisabled,
        SignInWithEmailAndPasswordResult.unknown ||
        SignInWithEmailAndPasswordResult.invalidEmailFormat => SignInOtpResult.unknown,
        SignInWithEmailAndPasswordResult.noInternet => SignInOtpResult.noInternet,
        SignInWithEmailAndPasswordResult.tooManyRequests => SignInOtpResult.tooManyRequests,
        SignInWithEmailAndPasswordResult.success => SignInOtpResult.success,
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

    await _userSessions.add(device);
    await _userMetadata.update(lastSignInTime: DateTime.now().millisecondsSinceEpoch);

    return SignInOtpResult.success;
  }

  @override
  Future<SignInNewOtpResult> askNewOtp() async {
    final email = _newDeviceDetectedEmail;
    final password = _newDeviceDetectedPassword;
    if (email == null || password == null) return SignInNewOtpResult.unknown;

    if (!_network.isReachable) return SignInNewOtpResult.noInternet;

    final deviceId = _deviceInfo.identifier;

    if (await _rateLimite.isRateLimited(RateLimite.newDeviceOtpRequest, deviceId)) {
      return SignInNewOtpResult.tooManyRequests;
    }

    final userId = await _users.getUserId(email);
    if (userId == null) return SignInNewOtpResult.userNotFound;

    final askOtpResponse = await _authSignIn.askOtp(email);
    if (askOtpResponse.isLimited) return SignInNewOtpResult.tooManyRequests;

    _updateOtpRetryAfter();

    return SignInNewOtpResult.success;
  }

  Timer? _otpCooldownTimer;
  final Duration _otpCooldownDuration = Duration(minutes: 1, seconds: 30);
}

extension on SignInServiceImpl {
  void _updateOtpRetryAfter() {
    _otpCooldownTimer?.cancel();

    var remaining = _otpCooldownDuration;

    _durationSubject.add(remaining);

    _otpCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= const Duration(seconds: 1);

      if (remaining <= Duration.zero) {
        timer.cancel();
        _durationSubject.add(Duration.zero);
        return;
      }

      _durationSubject.add(remaining);
    });
  }
}
