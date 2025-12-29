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

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:string_validator/string_validator.dart';

import '../../helpers/local.dart';
import '../../models/auth/otp.dart';
import '../../models/auth/rate_limite.dart';
import '../../models/user/device.dart';
import '../../results/auth.dart';
import '../../results/sign_in.dart';
import '../device/device_info_service.dart';
import '../device/network_service.dart';
import '../firebase/auth/auth_service.dart';
import '../firebase/database/device_service.dart';
import '../firebase/database/otp_service.dart';
import '../firebase/database/rate_limite.dart';
import '../firebase/database/user_id_service.dart';
import '../local_storage/services/device_service.dart';

abstract class SignInService {
  /// Authenticates a user using an email address and password.
  ///
  /// This method validates the provided credentials, checks network
  /// availability, and determines whether the sign-in attempt originates
  /// from a known or a new device.
  ///
  /// If the device is already associated with a user, the method proceeds
  /// with a standard authentication flow.
  ///
  /// If the device is detected as new, the sign-in process is paused and
  /// an OTP-based verification flow is initiated to confirm the device.
  ///
  /// The returned [SignInResult] describes the outcome of the operation,
  /// including validation errors, authentication failures, or the need
  /// for additional verification.
  Future<SignInResult> signInWithEmailAndPassword(String email, String password);

  /// Verifies a one-time password (OTP) for a newly detected device.
  ///
  /// This method completes the sign-in flow that was previously interrupted
  /// due to a new device detection.
  ///
  /// The provided [otp] is validated against the remotely stored value,
  /// subject to rate-limiting constraints.
  ///
  /// On successful verification:
  /// - the user is authenticated,
  /// - the new device is registered for the user,
  /// - local and remote device state is updated accordingly.
  ///
  /// The returned [SignInOtpResult] reflects whether the verification
  /// succeeded or failed (e.g. invalid, expired, or rate-limited).
  Future<SignInOtpResult> verifyOtp(String otp);

  /// Requests a new one-time password (OTP) for a pending new-device
  /// authentication flow.
  ///
  /// This method is intended to be called when the user did not receive
  /// or has lost the previous OTP.
  ///
  /// The request is subject to rate limiting to prevent abuse. On success,
  /// a new OTP is generated and stored remotely.
  ///
  /// The returned [SignInNewOtpResult] indicates whether the request
  /// was accepted, rate-limited, or failed due to connectivity issues.
  Future<SignInNewOtpResult> askNewOtp();
}

@Singleton(as: SignInService)
class SignInServiceImpl implements SignInService {
  final DeviceInfoService _deviceInfo;
  final NetworkService _network;
  final AuthService _auth;
  final DeviceService _device;
  final LocalDeviceService _localDevice;
  final OtpService _otp;
  final RateLimiteService _rateLimite;
  final UserIdService _userId;

  SignInServiceImpl(
    this._deviceInfo,
    this._network,
    this._auth,
    this._device,
    this._localDevice,
    this._otp,
    this._rateLimite,
    this._userId,
  );

  String? _newDeviceDetectedEmail;
  String? _newDeviceDetectedPassword;

  @override
  Future<SignInResult> signInWithEmailAndPassword(String email, String password) async {
    email = email.trim().toLowerCase();
    password = password.trim();

    if (email.isEmpty) return SignInResult.emptyEmail;
    if (password.isEmpty) return SignInResult.emptyPassword;
    if (!email.isEmail) return SignInResult.invalidEmailFormat;
    if (!_network.isReachable) return SignInResult.noInternet;

    final deviceId = _deviceInfo.identifier;
    final userId = await _userId.getByDeviceId(deviceId);
    if (userId == null) {
      final otp = Otp(email: email, createdAt: DateTime.now().millisecondsSinceEpoch, deviceId: deviceId);

      _newDeviceDetectedEmail = email;
      _newDeviceDetectedPassword = password;

      await _otp.insert(otp);
      return SignInResult.newDeviceDetected;
    }

    final testCredientialResult = await _auth.testCredentials(email, password);

    if (testCredientialResult == TestCredientialResult.invalid) return SignInResult.invalidCredentials;
    if (testCredientialResult == TestCredientialResult.userDisabled) return SignInResult.userDisabled;
    if (testCredientialResult == TestCredientialResult.tooManyRequests) return SignInResult.tooManyRequests;

    final signInWithEmailAndPasswordResult = await _auth.signInWithEmailAndPassword(email, password);

    await _device.update(userId, isSignedIn: true, lastSignInTime: DateTime.now().millisecondsSinceEpoch);
    await _localDevice.update(userId, isSignedIn: true, lastSignInTime: DateTime.now().millisecondsSinceEpoch);

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

    if (await _rateLimite.isExists(RateLimiteFeature.newDeviceDetected)) {
      return SignInOtpResult.tooManyRequests;
    }
    await _rateLimite.recordHit(RateLimiteFeature.newDeviceDetected);

    otp = sha256.convert(utf8.encode(otp)).toString();
    final remoteOtp = await _otp.get(email);

    if (otp != remoteOtp) return SignInOtpResult.invalidOrExpired;

    final signInWithEmailAndPasswordResult = await _auth.signInWithEmailAndPassword(email, password);
    if (signInWithEmailAndPasswordResult.isError) {
      return switch (signInWithEmailAndPasswordResult) {
        SignInWithEmailAndPasswordResult.invalidCredentials ||
        SignInWithEmailAndPasswordResult.invalidEmailFormat ||
        SignInWithEmailAndPasswordResult.userDisabled ||
        SignInWithEmailAndPasswordResult.unknown => SignInOtpResult.unknown,
        SignInWithEmailAndPasswordResult.noInternet => SignInOtpResult.noInternet,
        SignInWithEmailAndPasswordResult.tooManyRequests => SignInOtpResult.tooManyRequests,
        SignInWithEmailAndPasswordResult.success => SignInOtpResult.success,
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

    _device.add(device);
    _localDevice.add(device);

    return SignInOtpResult.success;
  }

  @override
  Future<SignInNewOtpResult> askNewOtp() async {
    final email = _newDeviceDetectedEmail;
    final password = _newDeviceDetectedPassword;
    if (email == null || password == null) return SignInNewOtpResult.unknown;

    if (!_network.isReachable) return SignInNewOtpResult.noInternet;

    if (await _rateLimite.isExists(RateLimiteFeature.newDeviceOtpRequest)) {
      return SignInNewOtpResult.tooManyRequests;
    }
    await _rateLimite.recordHit(RateLimiteFeature.newDeviceOtpRequest);

    final otp = Otp(email: email, createdAt: DateTime.now().millisecondsSinceEpoch, deviceId: _deviceInfo.identifier);
    await _otp.insert(otp);

    return SignInNewOtpResult.success;
  }
}
