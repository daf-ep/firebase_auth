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

import '../../../extensions/language.dart';
import '../../../helpers/database.dart';
import '../../../models/observe.dart';
import '../../../models/user/language.dart';
import '../../../models/user/preferred_language.dart';
import '../../../models/user/session.dart';
import '../../../models/user/user.dart';
import '../auth/user_service.dart';
import '../device/device_info_service.dart';
import '../settings/preferences_service.dart';
import 'helpers/current_user_helper_service.dart';

@internal
abstract class CurrentSessionsService {
  Observe<List<Session>?> get sessions;
  Future<bool> isExists(String deviceId);
  Future<void> add(Session session);
  Future<void> delete(String deviceId);
  Future<void> update({int? lastSignInTime, ThemeMode? themeMode, Language? language});
}

@Singleton(as: CurrentSessionsService)
class CurrentSessionsServiceImpl implements CurrentSessionsService {
  final AuthUserService _authUser;
  final CurrentUserHelperService _helper;
  final DeviceInfoService _deviceInfo;
  final PreferencesService _preferences;

  CurrentSessionsServiceImpl(this._authUser, this._helper, this._deviceInfo, this._preferences);

  @override
  Observe<List<Session>?> get sessions => Observe<List<Session>?>(
    value: _helper.data.value?.sessions,
    stream: _helper.data.stream.map((user) => user?.sessions),
  );

  @override
  Future<bool> isExists(String deviceId) async {
    final userId = _authUser.userId.value;
    if (userId == null) return false;

    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.sessions).child(deviceId).get();
    return snapshot.exists;
  }

  @override
  Future<void> add(Session session) async {
    if (_helper.data.value?.sessions == null) return;
    final sessions = List<Session>.from(_helper.data.value?.sessions ?? []);

    sessions.add(session);

    return _helper.update((user) => user?.copyWith(sessions: sessions));
  }

  @override
  Future<void> delete(String deviceId) async {
    if (_helper.data.value?.sessions == null) return;
    final sessions = List<Session>.from(_helper.data.value?.sessions ?? []);

    sessions.removeWhere((session) => session.deviceId == deviceId);

    return _helper.update((user) => user?.copyWith(sessions: sessions));
  }

  @override
  Future<void> update({int? lastSignInTime, ThemeMode? themeMode, Language? language}) async {
    if (lastSignInTime == null && themeMode == null && language == null) return;

    if (_helper.data.value?.sessions == null) return;
    final sessions = List<Session>.from(_helper.data.value?.sessions ?? []);

    final deviceId = _deviceInfo.identifier;
    final current = sessions.where((session) => session.deviceId == deviceId).firstOrNull;
    if (current == null) return;

    final updated = current.copyWith(
      metadata: current.metadata.copyWith(
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        lastSignInTime: lastSignInTime,
      ),
      preferences: current.preferences.copyWith(themeMode: themeMode, language: language),
    );

    sessions.removeWhere((session) => session.deviceId == deviceId);
    sessions.add(updated);

    PreferredLanguage? preferredLanguage;
    if (language != null) {
      final currentPreferredLanguage = _helper.data.value?.preferredLanguage.current;
      if (currentPreferredLanguage == null) return;

      preferredLanguage = PreferredLanguage(
        current: language,
        histories: [
          ...(_helper.data.value?.preferredLanguage.histories ?? []),
          PreferredLanguageHistory(
            language: currentPreferredLanguage,
            changedAt: DateTime.now().millisecondsSinceEpoch,
            deviceId: deviceId,
          ),
        ],
      );
    }

    if (language != null) {
      _preferences.locale.set(language.languageCode);
    }
    if (themeMode != null) {
      _preferences.themeMode.set(themeMode);
    }

    return _helper.update(
      (user) => user?.copyWith(
        metadata: user.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
        preferredLanguage: preferredLanguage,
        sessions: sessions,
      ),
    );
  }
}
