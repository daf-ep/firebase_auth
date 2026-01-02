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
import 'package:injectable/injectable.dart';

import '../../../../models/auth/rate_limite.dart';
import 'local_service.dart';
import 'remote_service.dart';

@internal
abstract class RateLimiteService {
  Future<bool> isRateLimited(RateLimite rateLimite, String key);
}

@Singleton(as: RateLimiteService)
class RateLimiteServiceImpl implements RateLimiteService {
  final LocalRateLimiteService _local;
  final RemoteRateLimiteService _remote;

  RateLimiteServiceImpl(this._local, this._remote);

  @override
  Future<bool> isRateLimited(RateLimite rateLimite, String key) async {
    if (await _local.isRateLimited(rateLimite, key)) return true;

    final isRateLimite = await _remote.isRateLimited(rateLimite, key);

    if (isRateLimite.isRateLimited) {
      final resetAt = isRateLimite.resetAt;
      if (resetAt != null) {
        await _local.saveBlocked(rateLimite, key, resetAt);
      }
    }
    return isRateLimite.isRateLimited;
  }
}
