// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber SAS. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber SAS.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber SAS.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER SAS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'package:equatable/equatable.dart';

import 'email.dart';
import 'metadata.dart';
import 'password.dart';
import 'preferred_language.dart';
import 'session.dart';

class UserConstants {
  static const String version = "version";
  static const String email = "email";
  static const String sessions = "sessions";
  static const String metadata = "metadata";
  static const String preferredLanguage = "preferred_language";
  static const String passwordHistories = "password_histories";
  static const String data = "data";
}

class User extends Equatable {
  final String userId;
  final int version;
  final Email email;
  final List<Session> sessions;
  final UserMetadata metadata;
  final PreferredLanguage preferredLanguage;
  final List<PasswordHistories> passwordHistories;
  final Map<String, dynamic> data;

  const User({
    required this.userId,
    required this.version,
    required this.email,
    required this.sessions,
    required this.metadata,
    required this.preferredLanguage,
    required this.passwordHistories,
    required this.data,
  });

  factory User.fromMap(String userId, Map<String, dynamic> map) {
    return User(
      userId: userId,
      version: map[UserConstants.version],
      email: Email.fromMap(map[UserConstants.email]),
      metadata: UserMetadata.fromMap(map[UserConstants.metadata]),
      sessions: ((map[UserConstants.sessions] ?? {}) as Map<dynamic, dynamic>).entries
          .map((e) => Session.fromMap(e.key, e.value))
          .toList(),
      preferredLanguage: PreferredLanguage.fromMap(map[UserConstants.preferredLanguage]),
      passwordHistories: ((map[UserConstants.passwordHistories] ?? []) as List)
          .map((e) => PasswordHistories.fromMap(e as Map<String, dynamic>))
          .toList(),
      data: map[UserConstants.data],
    );
  }

  User copyWith({
    String? userId,
    int? version,
    Email? email,
    List<Session>? sessions,
    UserMetadata? metadata,
    PreferredLanguage? preferredLanguage,
    List<PasswordHistories>? passwordHistories,
    Map<String, dynamic>? data,
  }) {
    return User(
      userId: userId ?? this.userId,
      version: version ?? this.version,
      email: email ?? this.email,
      sessions: sessions ?? this.sessions,
      metadata: metadata ?? this.metadata,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      passwordHistories: passwordHistories ?? this.passwordHistories,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserConstants.version: version,
      UserConstants.email: email.toMap(),
      UserConstants.sessions: Map.fromEntries(sessions.map((device) => MapEntry(device.deviceId, device.toMap()))),
      UserConstants.metadata: metadata.toMap(),
      UserConstants.preferredLanguage: preferredLanguage.toMap(),
      UserConstants.passwordHistories: passwordHistories.map((history) => history.toMap()).toList(),
      UserConstants.data: data,
    };
  }

  @override
  List<Object?> get props => [userId, version, sessions, metadata, preferredLanguage, passwordHistories, data];
}
