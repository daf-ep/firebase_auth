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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../models/user/language.dart';
import '../../../../models/user/session.dart';
import '../../auth/user_service.dart';
import '../../device/device_info_service.dart';
import '../../local/local_storage.dart';
import '../user.dart';

@internal
abstract class LocalSessionsService {
  Future<void> add(Session session);
  Future<void> delete(String deviceId);
  Future<void> update({int? lastSignInTime, ThemeMode? themeMode, Language? language});
}

@Singleton(as: LocalSessionsService)
class LocalSessionsServiceImpl implements LocalSessionsService {
  final DeviceInfoService _deviceInfo;
  final AuthUserService _authUser;

  LocalSessionsServiceImpl(this._deviceInfo, this._authUser);

  @override
  Future<void> add(Session session) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final currentUser = UserServices.current.data.value;
    if (currentUser == null) return;

    final sessions = [...currentUser.sessions];
    final index = sessions.indexWhere((d) => d.deviceId == session.deviceId);

    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }

    final newUser = currentUser.copyWith(
      sessions: sessions,
      metadata: currentUser.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
    );

    await _db
        .update(_table)
        .replace(
          UserTableData(
            userId: newUser.userId,
            email: newUser.email.value,
            version: newUser.version,
            data: json.encode(newUser.toMap()),
          ),
        );
  }

  @override
  Future<void> delete(String deviceId) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final currentUser = UserServices.current.data.value;
    if (currentUser == null) return;

    final newSessions = currentUser.sessions.where((d) => d.deviceId != deviceId).toList();

    if (newSessions.length == currentUser.sessions.length) return;

    final updatedUser = currentUser.copyWith(
      sessions: newSessions,
      metadata: currentUser.metadata.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch),
    );

    await (_db.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(data: Value(json.encode(updatedUser.toMap()))),
    );
  }

  @override
  Future<void> update({int? lastSignInTime, ThemeMode? themeMode, Language? language}) async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    final user = UserServices.current.data.value;
    if (user == null) return;

    final deviceId = _deviceInfo.identifier;
    final ipInfo = _deviceInfo.ipInfo;
    if (ipInfo == null) return;

    final sessions = user.sessions.map((device) {
      if (device.deviceId != deviceId) return device;

      return device.copyWith(
        metadata: device.metadata.copyWith(
          updatedAt: DateTime.now().millisecondsSinceEpoch,
          lastSignInTime: lastSignInTime ?? device.metadata.lastSignInTime,
        ),
        preferences: device.preferences.copyWith(
          themeMode: themeMode ?? device.preferences.themeMode,
          language: language ?? device.preferences.language,
        ),
        networkLocation: NetworkLocation(ip: ipInfo.ip, city: ipInfo.city, country: ipInfo.country),
      );
    }).toList();

    final updatedUser = user.copyWith(sessions: sessions);

    await (_db.update(_table)..where((tbl) => tbl.userId.equals(userId))).write(
      UserTableCompanion(data: Value(json.encode(updatedUser.toMap()))),
    );
  }

  LocalStorage get _db => LocalStorage.instance;
  $UserTableTable get _table => _db.userTable;
}
