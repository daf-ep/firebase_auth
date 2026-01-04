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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../models/observe.dart';
import '../../../models/user/user.dart';
import '../auth/user_service.dart';
import 'helpers/current_user_helper_service.dart';

@internal
abstract class CurrentUserService {
  Observe<User?> get data;
  Future<void> add(User user);
  Future<void> delete();
}

@Singleton(as: CurrentUserService)
class CurrentUserServiceImpl implements CurrentUserService {
  final CurrentUserHelperService _helper;
  final AuthUserService _authUser;

  CurrentUserServiceImpl(this._helper, this._authUser);

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  @override
  Observe<User?> get data => _helper.data;

  @override
  Future<void> add(User user) => _helper.add(user);

  @override
  Future<void> delete() async {
    final userId = _authUser.userId.value;
    if (userId == null) return;

    _userSubject.value = null;

    return _helper.delete();
  }
}
