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

import 'user_service.dart';

abstract class LocalVersionService {
  /// Latest locally cached version of the user data.
  ///
  /// This value reflects the `version` field stored in local persistence
  /// for the currently authenticated user.
  ///
  /// It may be `null` when:
  /// - no user is authenticated,
  /// - no user data is available locally,
  /// - or the local cache has not yet been initialized.
  ///
  /// This getter provides synchronous access to the current version snapshot
  /// and should be treated as read-only by consumers.
  int? get version;

  /// Reactive stream of the locally cached user version.
  ///
  /// Emits whenever the local user version changes, including:
  /// - initial load from local storage,
  /// - local updates triggered by device or preference changes,
  /// - synchronization with newer remote data.
  ///
  /// Consumers can rely on this stream to detect version changes and
  /// react accordingly (e.g. trigger remote comparisons or refresh logic).
  Stream<int?> get versionStream;
}

@Singleton(as: LocalVersionService)
class LocalVersionServiceImpl implements LocalVersionService {
  final LocalUserService _localUser;

  LocalVersionServiceImpl(this._localUser);

  final _versionSubject = BehaviorSubject<int?>.seeded(null);

  @override
  int? get version => _versionSubject.value;

  @override
  Stream<int?> get versionStream => _versionSubject.stream;

  @PostConstruct()
  init() async {
    listenToLocalVersion();
  }
}

extension on LocalVersionServiceImpl {
  void listenToLocalVersion() {
    _localUser.userStream.distinct().map((user) => user?.version).listen((version) => _versionSubject.value = version);
  }
}
