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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../../helpers/database.dart';
import '../../../../models/user/user.dart';
import '../auth/auth_service.dart';

@internal
abstract class RemoteVersionService {
  /// Latest known version of the user record.
  ///
  /// This value reflects the `version` field stored remotely for the
  /// currently authenticated user. It may be `null` if the user is
  /// not authenticated or if the version has not yet been resolved.
  int? get version;

  /// Reactive stream of the user record version.
  ///
  /// Emits whenever the remote user version changes, allowing
  /// consumers to react to schema migrations, forced refreshes,
  /// or compatibility updates.
  Stream<int?> get versionStream;
}

@Singleton(as: RemoteVersionService)
class RemoteVersionServiceImpl implements RemoteVersionService {
  final RemoteAuthService _auth;

  RemoteVersionServiceImpl(this._auth);

  final _versionSubject = BehaviorSubject<int?>.seeded(null);

  @override
  int? get version => _versionSubject.value;

  @override
  Stream<int?> get versionStream => _versionSubject.stream;

  @PostConstruct()
  init() async {
    listenToRemoteVersion();
  }

  StreamSubscription<int?>? versionSub;
}

extension on RemoteVersionServiceImpl {
  void listenToRemoteVersion() {
    _auth.userIdStream.distinct().listen((userId) {
      if (userId != null) {
        final stream = DatabaseNodes.users(userId).child(UserConstants.version).onValue.map((event) {
          final raw = event.snapshot.value;
          if (raw is! int) return null;

          return raw;
        });

        versionSub = stream.distinct().listen((version) => _versionSubject.value = version);
      } else {
        versionSub?.cancel();
        versionSub = null;
      }
    });
  }
}
