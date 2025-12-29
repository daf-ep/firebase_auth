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

import 'package:injectable/injectable.dart';

import '../../../helpers/database_nodes.dart';
import '../../../models/auth/rate_limite.dart';
import '../../device/device_info_service.dart';
import '../../local_storage/services/rate_limite.dart';

abstract class RateLimiteService {
  /// Determines whether the specified feature is currently rate-limited
  /// for the current device.
  ///
  /// This method checks both:
  /// - the locally cached rate-limit state for fast, offline-aware decisions,
  /// - and the remote rate-limit data to ensure cross-session consistency.
  ///
  /// It returns `true` when the rate limit has been reached or exceeded
  /// within the active time window, and `false` otherwise.
  ///
  /// This method does not mutate state unless a remote block is detected,
  /// in which case the local cache may be synchronized.
  Future<bool> isExists(RateLimiteFeature feature);

  /// Records a rate-limit hit for the specified feature.
  ///
  /// This method updates the local rate-limit state immediately and then
  /// propagates the new state to the remote data store.
  ///
  /// It should be invoked only when the associated action has actually
  /// been performed and must be counted toward the rate limit.
  ///
  /// This operation is asynchronous and ensures eventual consistency
  /// between local and remote rate-limit data.
  Future<void> recordHit(RateLimiteFeature feature);
}

@Singleton(as: RateLimiteService)
class RateLimiteServiceImpl implements RateLimiteService {
  final DeviceInfoService _deviceInfo;
  final LocalRateLimiteService _localRateLimite;

  RateLimiteServiceImpl(this._deviceInfo, this._localRateLimite);

  @override
  Future<bool> isExists(RateLimiteFeature feature) async {
    final localBlocked = await _localRateLimite.isExists(feature);
    if (localBlocked) return true;

    final ref = DatabaseNodes.rateLimite(_deviceInfo.identifier).child(feature.name);

    final snapshot = await ref.get();
    if (!snapshot.exists) return false;

    final data = snapshot.value as Map;
    final count = data['count'] as int? ?? 0;
    final createdAt = data['created_at'] as int? ?? 0;

    final now = DateTime.now().millisecondsSinceEpoch;
    final window = const Duration(minutes: 3).inMilliseconds;

    final isBlocked = count >= 5 && now - createdAt < window;

    if (isBlocked) {
      await _localRateLimite.replace(feature: feature, count: count, createdAt: createdAt);
      return true;
    }

    await ref.remove();
    return false;
  }

  @override
  Future<void> recordHit(RateLimiteFeature feature) async {
    final localState = await _localRateLimite.recordHitAndGet(feature);

    await DatabaseNodes.rateLimite(
      _deviceInfo.identifier,
    ).child(feature.name).set({'count': localState.count, 'created_at': localState.createdAt});
  }
}
