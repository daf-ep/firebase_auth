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

import '../../../../models/user/language.dart';
import '../../../../models/user/session.dart';
import '../../auth/auth.dart';
import '../user.dart';
import 'local_service.dart';
import 'remote_service.dart';

@internal
abstract class SessionsService {
  Future<bool> isExists(String deviceId);
  Future<void> add(Session session);
  Future<void> delete(String deviceId);
  Future<void> update({int? lastSignInTime, bool? isSignedIn, ThemeMode? themeMode, Language? language});
}

@Singleton(as: SessionsService)
class SessionsServiceImpl implements SessionsService {
  final LocalSessionsService _local;
  final RemoteSessionsService _remote;

  SessionsServiceImpl(this._local, this._remote);

  @override
  Future<bool> isExists(String deviceId) => _remote.isExists(deviceId);

  @override
  Future<void> add(Session session) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await _local.add(session);
    await _remote.add(session);

    await UserServices.version.upgrade();

    return;
  }

  @override
  Future<void> delete(String deviceId) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await _local.delete(deviceId);
    await _remote.delete(deviceId);

    await UserServices.version.upgrade();

    return;
  }

  @override
  Future<void> update({int? lastSignInTime, bool? isSignedIn, ThemeMode? themeMode, Language? language}) async {
    final userId = AuthServices.user.userId.value;
    if (userId == null) return;

    await _local.update(
      lastSignInTime: lastSignInTime,
      isSignedIn: isSignedIn,
      themeMode: themeMode,
      language: language,
    );

    await _remote.update(
      lastSignInTime: lastSignInTime,
      isSignedIn: isSignedIn,
      themeMode: themeMode,
      language: language,
    );

    await UserServices.version.upgrade();

    return;
  }
}
