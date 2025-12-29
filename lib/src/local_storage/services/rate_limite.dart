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

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../models/auth/rate_limite.dart';
import '../../device/device_info_service.dart';
import '../local_storage.dart';

abstract class LocalRateLimiteService {
  /// Checks whether a rate limit entry currently exists for the given feature
  /// and the current device.
  ///
  /// This method evaluates the local rate-limit state within the configured
  /// time window (e.g. last few minutes) and returns `true` if the rate limit
  /// has already been reached or exceeded.
  ///
  /// It is typically used as a fast, synchronous-like guard before performing
  /// sensitive or costly operations, without modifying the stored counters.
  Future<bool> isExists(RateLimiteFeature feature);

  /// Records a new hit for the given feature and returns the updated rate-limit state.
  ///
  /// This method atomically:
  /// - reads the current rate-limit entry for the feature and device,
  /// - resets the counter if the time window has expired,
  /// - or increments the counter if the window is still active,
  /// - persists the updated state locally.
  ///
  /// The returned [RateLimiteState] reflects the **current hit count** and
  /// the timestamp at which the rate-limit window started.
  ///
  /// This method is intended to be called when an action is actually
  /// performed and must be accounted for in rate limiting.
  Future<RateLimiteState> recordHitAndGet(RateLimiteFeature feature);

  /// Replaces or inserts the rate-limit entry for the given feature.
  ///
  /// This operation overwrites any existing entry for the current device
  /// and feature combination with the provided values.
  ///
  /// It is used internally to ensure idempotent updates of rate-limit data
  /// and should generally not be called directly by higher-level consumers.
  Future<void> replace({required RateLimiteFeature feature, required int count, required int createdAt});
}

@Singleton(as: LocalRateLimiteService)
class LocalRateLimiteServiceImpl implements LocalRateLimiteService {
  final DeviceInfoService _deviceInfo;

  LocalRateLimiteServiceImpl(this._deviceInfo);

  @override
  Future<bool> isExists(RateLimiteFeature feature) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final window = const Duration(minutes: 3).inMilliseconds;
    final limit = now - window;

    final row =
        await (_instance.select(_table)
              ..where((tbl) => tbl.deviceId.equals(_deviceInfo.identifier) & tbl.feature.equals(feature.name)))
            .getSingleOrNull();

    if (row == null) return false;

    final isBlocked = row.count >= 5 && row.createdAt >= limit;
    if (isBlocked) return true;

    await (_instance.delete(
      _table,
    )..where((tbl) => tbl.deviceId.equals(_deviceInfo.identifier) & tbl.feature.equals(feature.name))).go();

    return false;
  }

  @override
  Future<RateLimiteState> recordHitAndGet(RateLimiteFeature feature) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final limit = now - const Duration(minutes: 3).inMilliseconds;

    return await _instance.transaction(() async {
      final row = await get(feature);

      if (row == null || row.createdAt < limit) {
        await replace(feature: feature, count: 1, createdAt: now);
        return RateLimiteState(1, now);
      }

      final newCount = row.count + 1;
      await replace(feature: feature, count: newCount, createdAt: row.createdAt);
      return RateLimiteState(newCount, row.createdAt);
    });
  }

  @override
  Future<void> replace({required RateLimiteFeature feature, required int count, required int createdAt}) => _instance
      .into(_table)
      .insertOnConflictUpdate(
        RateLimiteTableCompanion(
          deviceId: Value(_deviceInfo.identifier),
          feature: Value(feature.name),
          count: Value(count),
          createdAt: Value(createdAt),
        ),
      );

  LocalAuthStorage get _instance => LocalAuthStorage.instance;
  $RateLimiteTableTable get _table => _instance.rateLimiteTable;
}

extension on LocalRateLimiteServiceImpl {
  Future<RateLimiteState?> get(RateLimiteFeature feature) async {
    final row =
        await (_instance.select(_table)
              ..where((tbl) => tbl.deviceId.equals(_deviceInfo.identifier) & tbl.feature.equals(feature.name)))
            .getSingleOrNull();

    if (row == null) return null;

    return RateLimiteState(row.count, row.createdAt);
  }
}
