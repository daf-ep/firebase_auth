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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import '../../../../results/auth.dart';

@internal
abstract class RemoteAuthService {
  /// Indicates whether a user is currently authenticated.
  ///
  /// This getter reflects the latest known authentication state as reported
  /// by the underlying authentication provider.
  ///
  /// A value of `true` means a user session is active, while `false`
  /// indicates that no user is currently signed in.
  ///
  /// This getter provides synchronous access to the current state and
  /// should be treated as read-only by consumers.
  bool get isUserConnected;

  /// Reactive stream of the authentication state.
  ///
  /// Emits a new value whenever the authentication status changes
  /// (e.g. sign-in, sign-out, session expiration).
  ///
  /// Consumers should rely on this stream to react to authentication
  /// state transitions and keep application logic in sync.
  Stream<bool> get isUserConnectedStream;

  /// Identifier of the currently authenticated user.
  ///
  /// Returns the unique user ID if a user is signed in, or `null`
  /// if no authenticated session is active.
  ///
  /// This value is derived from the authentication provider and
  /// represents the authoritative user identity for the session.
  String? get userId;

  /// Reactive stream of the authenticated user identifier.
  ///
  /// Emits whenever the current user changes or the session ends.
  ///
  /// This stream is useful for triggering user-scoped data loading,
  /// cleanup, or synchronization logic.
  Stream<String?> get userIdStream;

  bool get isEmailVerified;

  Stream<bool> get isEmailVerifiedStream;

  /// Creates a new user account using an email address and password.
  ///
  /// This method delegates account creation to the authentication
  /// provider and returns a structured result describing the outcome.
  ///
  /// The returned object contains:
  /// - the newly created user ID on success,
  /// - or an error result describing why the operation failed.
  ///
  /// Implementations must handle provider-specific errors and map
  /// them to domain-level results.
  Future<CreateUserWithEmailAndPassword> createUserWithEmailAndPassword(String email, String password);

  /// Signs in an existing user using an email address and password.
  ///
  /// This method attempts to authenticate the user and returns a
  /// [SignInWithEmailAndPasswordResult] describing the outcome.
  ///
  /// Possible outcomes include successful authentication, invalid
  /// credentials, network errors, rate limiting, or account restrictions.
  Future<SignInWithEmailAndPasswordResult> signInWithEmailAndPassword(String email, String password);

  Future<void> signOut();
}

@Singleton(as: RemoteAuthService)
class RemoteAuthServiceImpl implements RemoteAuthService {
  final _isUserConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _isEmailVerifiedSubject = BehaviorSubject<bool>.seeded(false);
  final _userIdSubject = BehaviorSubject<String?>.seeded(null);

  @override
  bool get isUserConnected => _isUserConnectedSubject.value;

  @override
  Stream<bool> get isUserConnectedStream => _isUserConnectedSubject.stream;

  @override
  bool get isEmailVerified => _isEmailVerifiedSubject.value;

  @override
  Stream<bool> get isEmailVerifiedStream => _isEmailVerifiedSubject.stream;

  @override
  String? get userId => _userIdSubject.value;

  @override
  Stream<String?> get userIdStream => _userIdSubject.stream;

  @override
  Future<CreateUserWithEmailAndPassword> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final userId = newUser.user?.uid;

      if (userId == null) {
        return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
      }

      return CreateUserWithEmailAndPassword(userId: userId, result: CreateUserWithEmailAndPasswordResult.success);
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.userAlreadyExists,
          );
        case 'invalid-email':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.invalidEmailFormat,
          );
        case 'operation-not-allowed':
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
        case 'weak-password':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.weakPassword,
          );
        case 'too-many-requests':
          return CreateUserWithEmailAndPassword(
            userId: null,
            result: CreateUserWithEmailAndPasswordResult.tooManyRequests,
          );
        case 'network-request-failed':
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.noInternet);
        default:
          return CreateUserWithEmailAndPassword(userId: null, result: CreateUserWithEmailAndPasswordResult.unknown);
      }
    }
  }

  @override
  Future<SignInWithEmailAndPasswordResult> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      return SignInWithEmailAndPasswordResult.success;
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'invalid-email':
          return SignInWithEmailAndPasswordResult.invalidEmailFormat;
        case 'user-disabled':
          return SignInWithEmailAndPasswordResult.userDisabled;

        case 'too-many-requests':
          return SignInWithEmailAndPasswordResult.tooManyRequests;

        case 'network-request-failed':
          return SignInWithEmailAndPasswordResult.noInternet;

        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
        case 'INVALID_LOGIN_CREDENTIALS':
          return SignInWithEmailAndPasswordResult.invalidCredentials;

        default:
          return SignInWithEmailAndPasswordResult.unknown;
      }
    }
  }

  @override
  Future<void> signOut() => _instance.signOut();

  @PostConstruct()
  init() async {
    listenToUserChanges();
  }

  FirebaseAuth get _instance => FirebaseAuth.instance;
}

extension on RemoteAuthServiceImpl {
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
