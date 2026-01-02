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

import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../models/observe.dart';
import '../../internal/user/user/current_user_service.dart';

abstract class UserMetadataService {
  Observe<int?> get createdAt;
  Observe<int?> get updatedAt;
  Observe<int?> get lastSignInTime;
}

@Singleton(as: UserMetadataService)
class UserMetadataServiceImpl implements UserMetadataService {
  final CurrentUserService _currentUser;

  UserMetadataServiceImpl(this._currentUser);

  final _createdAtSubject = BehaviorSubject<int?>.seeded(null);
  final _updatedAtSubject = BehaviorSubject<int?>.seeded(null);
  final _lastSignInTimeSubject = BehaviorSubject<int?>.seeded(null);

  @override
  Observe<int?> get createdAt => Observe<int?>(value: _createdAtSubject.value, stream: _createdAtSubject.stream);

  @override
  Observe<int?> get updatedAt => Observe<int?>(value: _updatedAtSubject.value, stream: _updatedAtSubject.stream);

  @override
  Observe<int?> get lastSignInTime =>
      Observe<int?>(value: _lastSignInTimeSubject.value, stream: _lastSignInTimeSubject.stream);

  @PostConstruct()
  init() {
    listenToMetadata();
  }
}

extension on UserMetadataServiceImpl {
  void listenToMetadata() {
    _currentUser.data.stream
        .map((user) => user?.metadata)
        .distinct((prev, next) {
          if (prev?.updatedAt == next?.updatedAt) return true;
          return false;
        })
        .listen((metadata) {
          _createdAtSubject.value = metadata?.createdAt;
          _updatedAtSubject.value = metadata?.updatedAt;
          _lastSignInTimeSubject.value = metadata?.lastSignInTime;
        });
  }
}
