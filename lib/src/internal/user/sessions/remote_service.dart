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

import '../../../../helpers/database.dart';
import '../../../../models/user/language.dart';
import '../../../../models/user/session.dart';
import '../../../../models/user/user.dart';
import '../../auth/auth.dart';
import '../../device/device_info_service.dart';

@internal
abstract class RemoteSessionsService {
  Future<bool> isExists(String deviceId);
  Future<void> add(Session session);
  Future<void> delete(String deviceId);
  Future<void> update({int? lastSignInTime, bool? isSignedIn, ThemeMode? themeMode, Language? language});
}

@Singleton(as: RemoteSessionsService)
class RemoteSessionsServiceImpl implements RemoteSessionsService {
  final DeviceInfoService _deviceInfo;

  RemoteSessionsServiceImpl(this._deviceInfo);

  @override
  Future<bool> isExists(String deviceId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return false;

    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.sessions).child(deviceId).get();
    return snapshot.exists;
  }

  @override
  Future<void> add(Session session) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await DatabaseNodes.users(userId).child(UserConstants.sessions).child(session.deviceId).set(session.toMap());
  }

  @override
  Future<void> delete(String deviceId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await DatabaseNodes.users(userId).child(UserConstants.sessions).child(deviceId).remove();
  }

  @override
  Future<void> update({int? lastSignInTime, bool? isSignedIn, ThemeMode? themeMode, Language? language}) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    final target = DatabaseNodes.users(userId).child(UserConstants.sessions).child(_deviceInfo.identifier);

    if (lastSignInTime != null) {
      await target.child(SessionConstants.metadata).child(SessionMetadataConstants.lastSignInTime).set(lastSignInTime);
    }
    if (isSignedIn != null) {
      await target.child(SessionConstants.metadata).child(SessionMetadataConstants.isSignedIn).set(isSignedIn);
    }

    final ipInfo = _deviceInfo.ipInfo;

    if (ipInfo != null) {
      final ip = ipInfo.ip;
      final city = ipInfo.city;
      final country = ipInfo.country;

      if (ip != null) {
        await target.child(SessionConstants.networkLocation).child(NetworkLocationConstants.ip).set(ip);
      }
      if (city != null) {
        await target.child(SessionConstants.networkLocation).child(NetworkLocationConstants.city).set(city);
      }
      if (country != null) {
        await target.child(SessionConstants.networkLocation).child(NetworkLocationConstants.country).set(country);
      }
    }

    if (themeMode != null) {
      await target.child(SessionConstants.preferences).child(SessionPreferencesConstants.themeMode).set(themeMode.name);
    }
    if (language != null) {
      await target.child(SessionConstants.preferences).child(SessionPreferencesConstants.language).set(language.name);
    }
  }
}
