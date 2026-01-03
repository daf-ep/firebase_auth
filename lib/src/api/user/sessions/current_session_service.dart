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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../../extensions/language.dart';
import '../../../../models/observe.dart';
import '../../../../models/user/language.dart';
import '../../../../models/user/session.dart';
import '../../../internal/device/device_info_service.dart';
import '../../../internal/settings/preferences_service.dart';
import '../../../internal/user/sessions/sessions_service.dart';
import '../../../internal/user/user/current_user_service.dart';

abstract class CurrentSessionService {
  Observe<Session?> get session;

  Future<void> language(Language language);

  Future<void> themeMode(ThemeMode themeMode);
}

@Singleton(as: CurrentSessionService)
class CurrentSessionServiceImpl implements CurrentSessionService {
  final DeviceInfoService _deviceInfo;
  final CurrentUserService _currentUser;
  final SessionsService _sessions;
  final PreferencesService _preferences;

  CurrentSessionServiceImpl(this._deviceInfo, this._currentUser, this._sessions, this._preferences);

  final _sessionSubject = BehaviorSubject<Session?>.seeded(null);

  @override
  Observe<Session?> get session => Observe<Session?>(value: _sessionSubject.value, stream: _sessionSubject.stream);

  @override
  Future<void> language(Language language) async {
    final userId = _currentUser.data.value?.userId;
    if (userId == null) return;

    await _preferences.locale.set(language.convert().languageCode);
    await _sessions.update(language: language);
  }

  @override
  Future<void> themeMode(ThemeMode themeMode) async {
    final userId = _currentUser.data.value?.userId;
    if (userId == null) return;

    await _preferences.themeMode.set(themeMode);
    await _sessions.update(themeMode: themeMode);
  }

  @PostConstruct()
  init() {
    listenToCurrentSession();
  }
}

extension on CurrentSessionServiceImpl {
  void listenToCurrentSession() {
    _currentUser.data.stream
        .distinct((prev, next) {
          if (mapEquals(
            prev?.sessions.where((session) => session.deviceId == _deviceInfo.identifier).firstOrNull?.toMap() ?? {},
            next?.sessions.where((session) => session.deviceId == _deviceInfo.identifier).firstOrNull?.toMap() ?? {},
          )) {
            return true;
          }
          return false;
        })
        .listen((user) {
          final deviceId = _deviceInfo.identifier;
          final sessions = user?.sessions;

          _sessionSubject.value = sessions?.where((session) => session.deviceId == deviceId).firstOrNull;
        });
  }
}
