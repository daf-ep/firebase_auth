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
import 'package:rxdart/subjects.dart';

import '../../../../models/observe.dart';
import '../../../../models/user/session.dart';
import '../../../internal/user/user/current_user_service.dart';

abstract class AllSessionsService {
  Observe<List<Session>?> get sessions;
}

@Singleton(as: AllSessionsService)
class AllSessionsServiceImpl implements AllSessionsService {
  final CurrentUserService _currentUser;

  AllSessionsServiceImpl(this._currentUser);

  final _sessionsSubject = BehaviorSubject<List<Session>?>.seeded(null);

  @override
  Observe<List<Session>?> get sessions =>
      Observe<List<Session>?>(value: _sessionsSubject.value, stream: _sessionsSubject.stream);

  @PostConstruct()
  init() {
    listenToSessions();
  }
}

extension on AllSessionsServiceImpl {
  void listenToSessions() {
    _currentUser.data.stream
        .distinct((prev, next) {
          if (listEquals(
            prev?.sessions.map((session) => session.toMap()).toList() ?? [],
            next?.sessions.map((session) => session.toMap()).toList() ?? [],
          )) {
            return true;
          }
          return false;
        })
        .listen((user) => _sessionsSubject.value = user?.sessions);
  }
}
