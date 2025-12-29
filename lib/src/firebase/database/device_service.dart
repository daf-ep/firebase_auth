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

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../helpers/database_nodes.dart';
import '../../../models/user/device.dart';
import '../../../models/user/user.dart';
import '../../device/device_info_service.dart';
import '../auth/auth_service.dart';

abstract class DeviceService {
  /// Registers a device for a user.
  ///
  /// This operation persists the provided [UserDevice] information
  /// in the remote data store, establishing the association between
  /// the device and its owning user.
  ///
  /// Implementations are responsible for initializing all required
  /// metadata and ensuring the device is correctly indexed for
  /// future lookups.
  Future<void> add(UserDevice device);

  /// Removes a device registration.
  ///
  /// This operation deletes all stored information related to the
  /// specified [deviceId], effectively revoking the device’s
  /// association with any user.
  ///
  /// Typical use cases include sign-out from a specific device,
  /// device revocation, or security-related cleanup.
  Future<void> delete(String deviceId);

  /// Updates metadata and preferences for a registered device.
  ///
  /// Only the provided optional fields are updated; omitted values
  /// are left unchanged.
  ///
  /// This method is commonly invoked to:
  /// - update sign-in and session-related timestamps,
  /// - reflect changes in authentication state,
  /// - persist user preference updates (e.g. theme or language),
  /// - refresh contextual information such as last known position.
  Future<void> update(
    String userId, {
    int? lastSignInTime,
    bool? isSignedIn,
    ThemeMode? themeMode,
    UserLanguage? language,
  });
}

@Singleton(as: DeviceService)
class DeviceServiceImpl implements DeviceService {
  final AuthService _auth;
  final DeviceInfoService _deviceInfo;

  DeviceServiceImpl(this._auth, this._deviceInfo);

  @override
  Future<void> add(UserDevice device) async {
    final userId = _auth.userId;
    if (userId == null) return;

    await DatabaseNodes.users(userId).child(UserConstants.version).set(ServerValue.increment(1));
    await DatabaseNodes.devices(device.deviceId).set(userId);
    await DatabaseNodes.users(userId).child(UserConstants.devices).child(device.deviceId).set(device.toMap());
  }

  @override
  Future<void> delete(String deviceId) async {
    final userId = _auth.userId;
    if (userId == null) return;

    await DatabaseNodes.users(userId).child(UserConstants.version).set(ServerValue.increment(1));
    await DatabaseNodes.devices(deviceId).remove();
    await DatabaseNodes.users(userId).child(UserConstants.devices).child(deviceId).remove();
  }

  @override
  Future<void> update(
    String userId, {
    int? lastSignInTime,
    bool? isSignedIn,
    ThemeMode? themeMode,
    UserLanguage? language,
  }) async {
    final userId = _auth.userId;
    if (userId == null) return;

    await DatabaseNodes.users(userId).child(UserConstants.version).set(ServerValue.increment(1));

    final target = DatabaseNodes.users(userId).child(UserConstants.devices).child(_deviceInfo.identifier);
    target
        .child(UserDeviceConstants.metadata)
        .child(UserDeviceMetadataConstants.updatedAt)
        .set(DateTime.now().millisecondsSinceEpoch);

    if (lastSignInTime != null) {
      await target
          .child(UserDeviceConstants.metadata)
          .child(UserDeviceMetadataConstants.lastSignInTime)
          .set(lastSignInTime);
    }
    if (isSignedIn != null) {
      await target.child(UserDeviceConstants.metadata).child(UserDeviceMetadataConstants.isSignedIn).set(isSignedIn);
    }

    final ipInfo = _deviceInfo.ipInfo;

    if (ipInfo != null) {
      final ip = ipInfo.ip;
      final city = ipInfo.city;
      final country = ipInfo.country;

      if (ip != null) {
        await target.child(UserDeviceConstants.lastKnownPosition).child(UserLastKnownPositionConstants.ip).set(ip);
      }
      if (city != null) {
        await target.child(UserDeviceConstants.lastKnownPosition).child(UserLastKnownPositionConstants.city).set(city);
      }
      if (country != null) {
        await target
            .child(UserDeviceConstants.lastKnownPosition)
            .child(UserLastKnownPositionConstants.country)
            .set(country);
      }
    }

    if (themeMode != null) {
      await target
          .child(UserDeviceConstants.metadata)
          .child(UserDevicePreferencesConstants.themeMode)
          .set(themeMode.name);
    }
    if (language != null) {
      await target
          .child(UserDeviceConstants.metadata)
          .child(UserDevicePreferencesConstants.language)
          .set(language.name);
    }
  }
}
