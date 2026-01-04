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

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/language.dart';
import '../../../../models/user/session.dart';
import '../../../internal/current_user/sessions_service.dart';
import '../../../internal/device/device_info_service.dart';
import 'all_sessions_service.dart';

abstract class UserSessionService {
  Observe<Session?> get session;

  Future<void> language(Language language);

  Future<void> themeMode(ThemeMode themeMode);
}

@Singleton(as: UserSessionService)
class UserSessionServiceImpl implements UserSessionService {
  final UserAllSessionsService _allSessions;
  final DeviceInfoService _deviceInfo;
  final CurrentSessionsService _currentSessions;

  UserSessionServiceImpl(this._allSessions, this._deviceInfo, this._currentSessions);

  @override
  Observe<Session?> get session => Observe<Session?>(
    value: _allSessions.sessions.value?.where((s) => s.deviceId == _deviceInfo.identifier).firstOrNull,
    stream: _allSessions.sessions.stream.map(
      (sessions) => sessions?.where((s) => s.deviceId == _deviceInfo.identifier).firstOrNull,
    ),
  );

  @override
  Future<void> language(Language language) => _currentSessions.update(language: language);

  @override
  Future<void> themeMode(ThemeMode themeMode) => _currentSessions.update(themeMode: themeMode);
}
