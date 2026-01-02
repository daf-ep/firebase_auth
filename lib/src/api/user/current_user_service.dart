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
import 'package:rxdart/subjects.dart';

import '../../../models/observe.dart';
import '../../internal/auth/user_service.dart';

abstract class CurrentUserService {
  Observe<bool> get isUserConnected;
  Observe<String?> get userId;
  Future<void> signOut();
}

@Singleton(as: CurrentUserService)
class CurrentUserServiceImpl implements CurrentUserService {
  final AuthUserService _authUser;

  CurrentUserServiceImpl(this._authUser);

  final _isUserConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _userIdSubject = BehaviorSubject<String?>.seeded(null);

  @override
  Observe<bool> get isUserConnected =>
      Observe<bool>(value: _isUserConnectedSubject.value, stream: _isUserConnectedSubject.stream);

  @override
  Observe<String?> get userId => Observe<String?>(value: _userIdSubject.value, stream: _userIdSubject.stream);

  @override
  Future<void> signOut() => _authUser.signOut();

  @PostConstruct()
  init() {
    listenToUserConnected();
    listenToUserId();
  }
}

extension on CurrentUserServiceImpl {
  void listenToUserConnected() {
    _authUser.isUserConnected.stream.distinct().listen(
      (isUserConnected) => _isUserConnectedSubject.value = isUserConnected,
    );
  }

  void listenToUserId() {
    _authUser.userId.stream.distinct().listen((userId) => _userIdSubject.value = userId);
  }
}
