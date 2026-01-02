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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../helpers/database.dart';
import '../../../models/observe.dart';

@internal
abstract class AuthUserService {
  Observe<bool> get isUserConnected;
  Observe<String?> get userId;
  Observe<bool> get isEmailVerified;
  Future<String?> getUserId(String email);
  Future<void> signOut();
}

@Singleton(as: AuthUserService)
class AuthUserServiceImpl implements AuthUserService {
  final _isUserConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _userIdSubject = BehaviorSubject<String?>.seeded(null);
  final _isEmailVerifiedSubject = BehaviorSubject<bool>.seeded(false);

  @override
  Observe<bool> get isUserConnected =>
      Observe<bool>(value: _isUserConnectedSubject.value, stream: _isUserConnectedSubject.stream);

  @override
  Observe<String?> get userId => Observe<String?>(value: _userIdSubject.value, stream: _userIdSubject.stream);

  @override
  Observe<bool> get isEmailVerified =>
      Observe<bool>(value: _isEmailVerifiedSubject.value, stream: _isEmailVerifiedSubject.stream);

  @override
  Future<String?> getUserId(String email) async {
    final snapshot = await DatabaseNodes.emails(email).get();
    final raw = snapshot.value;
    if (raw is! String) return null;

    return raw;
  }

  @override
  Future<void> signOut() => _instance.signOut();

  @PostConstruct()
  init() async {
    listenToUserChanges();
  }

  FirebaseAuth get _instance => FirebaseAuth.instance;
}

extension on AuthUserServiceImpl {
  void listenToUserChanges() {
    _instance.userChanges().distinct().listen((user) {
      final userId = user?.uid;
      final isUserConnected = userId != null;
      final emailVerified = user?.emailVerified ?? false;

      _isUserConnectedSubject.value = isUserConnected;
      _isEmailVerifiedSubject.value = emailVerified;
      _userIdSubject.value = userId;
    });
  }
}
