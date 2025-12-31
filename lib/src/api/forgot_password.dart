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

import 'package:injectable/injectable.dart';
import 'package:string_validator/string_validator.dart';

import '../../models/auth/password_policy.dart';
import '../../results/forgot_password.dart';
import '../internal/device/device_info_service.dart';
import '../internal/device/network_service.dart';
import '../internal/remote/cloud_functions/otp_service.dart';
import '../internal/remote/database/user_id_service.dart';

abstract class ForgotPasswordService {
  Future<ForgotPasswordResult> reset(String email);

  Future<ForgotPasswordOtpResult> verifyOtp(String otp);

  Future<ForgotPasswordNewOtpResult> askNewOtp();

  Future<ForgotPasswordUpdatePasswordResult> updatePassword(
    String email,
    String newPassword,
    String confirmPassword, {
    PasswordPolicy? passwordPolicy,
  });
}

@Singleton(as: ForgotPasswordService)
class ForgotPasswordServiceImpl implements ForgotPasswordService {
  final DeviceInfoService _deviceInfo;
  final NetworkService _network;
  final RemoteUserIdService _userId;
  final RemoteOtpService _otp;

  ForgotPasswordServiceImpl(this._deviceInfo, this._network, this._userId, this._otp);

  String? _resetPasswordEmail;

  @override
  Future<ForgotPasswordResult> reset(String email) async {
    email = email.trim();

    if (email.isEmpty) return ForgotPasswordResult.emptyEmail;
    if (!email.isEmail) return ForgotPasswordResult.invalidEmailFormat;
    if (!_network.isReachable) return ForgotPasswordResult.noInternet;

    final userId = await _userId.getByEmail(email);
    if (userId == null) return ForgotPasswordResult.userNotFound;

    _resetPasswordEmail = email;

    await _otp.insert(email);

    return ForgotPasswordResult.success;
  }

  @override
  Future<ForgotPasswordOtpResult> verifyOtp(String otp) async {
    otp = otp.trim();

    return ForgotPasswordOtpResult.success;
  }

  @override
  Future<ForgotPasswordNewOtpResult> askNewOtp() async {
    return ForgotPasswordNewOtpResult.success;
  }

  @override
  Future<ForgotPasswordUpdatePasswordResult> updatePassword(
    String email,
    String newPassword,
    String confirmPassword, {
    PasswordPolicy? passwordPolicy,
  }) async {
    return ForgotPasswordUpdatePasswordResult.success;
  }
}
