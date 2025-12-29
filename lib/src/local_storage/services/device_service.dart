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

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../models/user/device.dart';
import '../../device/device_info_service.dart';
import '../../firebase/auth/auth_service.dart';
import '../local_storage.dart';
import 'user_service.dart';

abstract class LocalDeviceService {
  /// Adds or updates a device in the locally cached user.
  ///
  /// This operation persists the provided [UserDevice] into local storage,
  /// either by inserting it as a new device or replacing the existing entry
  /// with the same device identifier.
  ///
  /// The user record is rewritten atomically, and its version and metadata
  /// are updated to reflect the change.
  ///
  /// This method is typically invoked:
  /// - after a successful sign-in on a new device,
  /// - when device information is refreshed,
  /// - or during local synchronization with remote state.
  Future<void> add(UserDevice device);

  /// Removes a device from the locally cached user.
  ///
  /// This operation deletes the device identified by [deviceId] from the
  /// local user record. If the device does not exist, the operation is
  /// treated as a no-op.
  ///
  /// The user record is rewritten with an updated version and metadata,
  /// ensuring local consistency and proper change propagation.
  ///
  /// Common use cases include device revocation, sign-out from a specific
  /// device, or local cleanup during account removal.
  Future<void> delete(String deviceId);

  /// Updates metadata and preferences for a specific device in local storage.
  ///
  /// The update is scoped to the device associated with the provided [userId]
  /// and the current runtime device context.
  ///
  /// Only the optional fields provided are modified; all other device data
  /// remains unchanged.
  ///
  /// This method is typically used to:
  /// - update sign-in state and timestamps,
  /// - persist preference changes (theme, language),
  /// - refresh device-related metadata during active sessions.
  Future<void> update(
    String userId, {
    int? lastSignInTime,
    bool? isSignedIn,
    ThemeMode? themeMode,
    UserLanguage? language,
  });
}

@Singleton(as: LocalDeviceService)
class LocalDeviceServiceImpl implements LocalDeviceService {
  final AuthService _auth;
  final LocalUserService _localUser;
  final DeviceInfoService _deviceInfo;

  LocalDeviceServiceImpl(this._auth, this._localUser, this._deviceInfo);

  @override
  Future<void> add(UserDevice device) async {
    final userId = _auth.userId;
    if (userId == null) return;

    final currentUser = _localUser.user;
    if (currentUser == null) return;

    final devices = [...currentUser.devices];
    final index = devices.indexWhere((d) => d.deviceId == device.deviceId);

    if (index >= 0) {
      devices[index] = device;
    } else {
      devices.add(device);
    }

    final updatedUser = currentUser.copyWith(
      version: currentUser.version + 1,
      devices: devices,
      metadata: currentUser.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
    );

    await _instance
        .update(_table)
        .replace(
          UserTableData(
            userId: updatedUser.userId,
            version: updatedUser.version,
            data: json.encode(updatedUser.data.toMap()),
          ),
        );
  }

  @override
  Future<void> delete(String deviceId) async {
    final userId = _auth.userId;
    if (userId == null) return;

    final currentUser = _localUser.user;
    if (currentUser == null) return;

    final updatedDevices = currentUser.devices.where((d) => d.deviceId != deviceId).toList();

    if (updatedDevices.length == currentUser.devices.length) return;

    final updatedUser = currentUser.copyWith(
      version: currentUser.version + 1,
      devices: updatedDevices,
      metadata: currentUser.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
    );

    await (_instance.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(data: Value(json.encode(updatedUser.data.toMap()))),
    );
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

    final user = _localUser.user;
    if (user == null) return;

    final deviceId = _deviceInfo.identifier;
    final ipInfo = _deviceInfo.ipInfo;
    if (ipInfo == null) return;

    final devices = user.devices.map((device) {
      if (device.deviceId != deviceId) return device;

      return device.copyWith(
        metadata: device.metadata.copyWith(
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          lastSignInTime: lastSignInTime ?? device.metadata.lastSignInTime,
          isSignedIn: isSignedIn ?? device.metadata.isSignedIn,
        ),
        preferences: device.preferences.copyWith(
          themeMode: themeMode ?? device.preferences.themeMode,
          language: language ?? device.preferences.language,
        ),
        lastKnownPosition: UserLastKnownPosition(ip: ipInfo.ip, city: ipInfo.city, country: ipInfo.country),
      );
    }).toList();

    final updatedUser = user.copyWith(
      version: user.version + 1,
      devices: devices,
      metadata: user.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
    );

    await (_instance.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(data: Value(json.encode(updatedUser.data.toMap()))),
    );
  }

  LocalAuthStorage get _instance => LocalAuthStorage.instance;
  $UserTableTable get _table => _instance.userTable;
}
