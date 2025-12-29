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

import '../../models/user/user.dart';
import '../firebase/auth/auth_service.dart';
import '../local_storage/services/user_service.dart';

abstract class UserService {
  /// Latest resolved user data for the current session.
  ///
  /// This getter exposes the most recent user model available in memory,
  /// typically sourced from local persistence and kept in sync with
  /// authentication state.
  ///
  /// It returns `null` when:
  /// - no user is authenticated,
  /// - user data has not yet been loaded,
  /// - or the local cache has been cleared.
  ///
  /// This value is read-only and represents a snapshot of the current
  /// user state.
  User? get data;

  /// Reactive stream of the current user data.
  ///
  /// Emits whenever the user model changes due to authentication events,
  /// local persistence updates, or synchronization logic.
  ///
  /// Consumers should rely on this stream to keep UI and domain logic
  /// synchronized with the active user.
  Stream<User?> get dataStream;

  /// Indicates whether a user is currently authenticated.
  ///
  /// This value reflects the latest known authentication state and
  /// is derived from the underlying authentication service.
  ///
  /// A value of `true` means a user session is active, while `false`
  /// indicates that no user is currently signed in.
  bool get isUserConnected;

  /// Reactive stream of the authentication state.
  ///
  /// Emits whenever the authentication status changes, allowing
  /// consumers to react to sign-in and sign-out events.
  Stream<bool> get isUserConnectedStream;

  /// Identifier of the currently authenticated user.
  ///
  /// Returns the unique user ID if a user is signed in, or `null`
  /// if no authenticated session is active.
  ///
  /// This value represents the authoritative identity for the
  /// current session.
  String? get userId;

  /// Reactive stream of the authenticated user identifier.
  ///
  /// Emits whenever the current user changes or the session ends.
  ///
  /// This stream is commonly used to trigger user-scoped data loading,
  /// cleanup, or navigation logic.
  Stream<String?> get userIdStream;
}

@Singleton(as: UserService)
class UserServiceImpl implements UserService {
  final LocalUserService _localUser;
  final AuthService _auth;

  UserServiceImpl(this._localUser, this._auth);

  final _userSubject = BehaviorSubject<User?>.seeded(null);
  final _isUserConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _userIdSubject = BehaviorSubject<String?>.seeded(null);

  @override
  User? get data => _userSubject.value;

  @override
  Stream<User?> get dataStream => _userSubject.stream;

  @override
  bool get isUserConnected => _isUserConnectedSubject.value;

  @override
  Stream<bool> get isUserConnectedStream => _isUserConnectedSubject.stream;

  @override
  String? get userId => _userIdSubject.value;

  @override
  Stream<String?> get userIdStream => _userIdSubject.stream;

  @PostConstruct()
  init() async {
    listenToUser();
    listenToUserConnected();
    listenToUserId();
  }
}

extension on UserServiceImpl {
  void listenToUser() {
    _localUser.userStream.distinct().listen((user) => _userSubject.value = user);
  }

  void listenToUserConnected() {
    _auth.isUserConnectedStream.distinct().listen((isUserConnected) => _isUserConnectedSubject.value = isUserConnected);
  }

  void listenToUserId() {
    _auth.userIdStream.distinct().listen((userId) => _userIdSubject.value = userId);
  }
}
