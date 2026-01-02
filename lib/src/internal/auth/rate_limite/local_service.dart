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

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../models/auth/rate_limite.dart';
import '../../local/local_storage.dart';

class RateLimiteState {
  final int count;
  final int resetAt;

  const RateLimiteState(this.count, this.resetAt);
}

class RateLimiteConfig {
  final int limit;
  final Duration window;

  const RateLimiteConfig({required this.limit, required this.window});
}

const _rateLimiteConfigs = {
  RateLimite.signIn: RateLimiteConfig(limit: 5, window: Duration(minutes: 2)),
  RateLimite.signUp: RateLimiteConfig(limit: 5, window: Duration(hours: 1)),
  RateLimite.newDeviceDetectedVerify: RateLimiteConfig(limit: 4, window: Duration(minutes: 5)),
  RateLimite.newDeviceOtpRequest: RateLimiteConfig(limit: 3, window: Duration(minutes: 5)),
  RateLimite.resetPassword: RateLimiteConfig(limit: 5, window: Duration(minutes: 30)),
};

@internal
abstract class LocalRateLimiteService {
  Future<bool> isRateLimited(RateLimite feature, String key);

  Future<void> saveBlocked(RateLimite feature, String key, int resetAt);
}

@Singleton(as: LocalRateLimiteService)
class LocalRateLimiteServiceImpl implements LocalRateLimiteService {
  @override
  Future<bool> isRateLimited(RateLimite feature, String key) async {
    final config = _rateLimiteConfigs[feature];
    if (config == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;

    final existing = await _get(feature, key);
    if (existing != null && existing.count >= config.limit && existing.resetAt > now) {
      return true;
    }

    return _db.transaction(() async {
      final state = await _get(feature, key);

      if (state == null || state.resetAt <= now) {
        await _save(feature: feature, key: key, count: 1, resetAt: now + config.window.inMilliseconds);
        return false;
      }

      if (state.count >= config.limit) return true;

      await _save(feature: feature, key: key, count: state.count + 1, resetAt: state.resetAt);

      return false;
    });
  }

  @override
  Future<void> saveBlocked(RateLimite feature, String key, int resetAt) async {
    final config = _rateLimiteConfigs[feature];
    if (config == null) return;

    await _save(feature: feature, key: key, count: config.limit, resetAt: resetAt);
  }

  LocalStorage get _db => LocalStorage.instance;
  $RateLimiteTableTable get _table => _db.rateLimiteTable;
}

extension on LocalRateLimiteServiceImpl {
  Future<RateLimiteState?> _get(RateLimite feature, String key) async {
    final row = await (_db.select(
      _table,
    )..where((t) => t.key.equals(key) & t.feature.equals(feature.name))).getSingleOrNull();

    if (row == null) return null;
    return RateLimiteState(row.count, row.resetAt);
  }

  Future<void> _save({required RateLimite feature, required String key, required int count, required int resetAt}) {
    return _db
        .into(_table)
        .insertOnConflictUpdate(
          RateLimiteTableCompanion(
            key: Value(key),
            feature: Value(feature.name),
            count: Value(count),
            resetAt: Value(resetAt),
          ),
        );
  }
}
