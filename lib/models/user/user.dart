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
import 'package:flutter/foundation.dart';

import 'avatar.dart';
import 'email.dart';
import 'metadata.dart';
import 'password.dart';
import 'preferred_language.dart';
import 'session.dart';
import 'version.dart';

class UserConstants {
  static const String email = "email";
  static const String sessions = "sessions";
  static const String metadata = "metadata";
  static const String avatar = "avatar";
  static const String preferredLanguage = "preferred_language";
  static const String passwordHistories = "password_histories";
  static const String data = "data";
  static const String versions = "_versions";
}

class User extends Equatable {
  final String userId;
  final Email email;
  final Avatar? avatar;
  final List<Session> sessions;
  final UserMetadata metadata;
  final PreferredLanguage preferredLanguage;
  final List<PasswordHistories> passwordHistories;
  final Map<String, dynamic>? data;
  final Versions versions;

  const User({
    required this.userId,
    required this.email,
    required this.sessions,
    required this.metadata,
    required this.avatar,
    required this.preferredLanguage,
    required this.passwordHistories,
    required this.data,
    required this.versions,
  });

  factory User.fromMap(String userId, Map<String, dynamic> map) {
    return User(
      userId: userId,
      email: Email.fromMap(map[UserConstants.email]),
      metadata: UserMetadata.fromMap(map[UserConstants.metadata]),
      avatar: switch (AvatarType.values.byName(map[AvatarFields.objectType])) {
        AvatarType.photoAvatar => PhotoAvatar.fromMap(map),
        AvatarType.textAvatar => TextAvatar.fromMap(map),
        AvatarType.placeholderAvatar => PlaceholderAvatar.fromMap(map),
      },
      sessions: ((map[UserConstants.sessions] ?? {}) as Map<dynamic, dynamic>).entries
          .map((e) => Session.fromMap(e.key, e.value))
          .toList(),
      preferredLanguage: PreferredLanguage.fromMap(map[UserConstants.preferredLanguage]),
      passwordHistories: ((map[UserConstants.passwordHistories] ?? []) as List)
          .map((e) => PasswordHistories.fromMap(e as Map<String, dynamic>))
          .toList(),
      data: map[UserConstants.data],
      versions: Versions.fromMap(map[UserConstants.versions]),
    );
  }

  User copyWith({
    String? userId,
    Email? email,
    List<Session>? sessions,
    UserMetadata? metadata,
    ValueGetter<Avatar?>? avatar,
    PreferredLanguage? preferredLanguage,
    List<PasswordHistories>? passwordHistories,
    Map<String, dynamic>? data,
    Versions? versions,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      sessions: sessions ?? this.sessions,
      metadata: metadata ?? this.metadata,
      avatar: avatar != null ? avatar() : this.avatar,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      passwordHistories: passwordHistories ?? this.passwordHistories,
      data: data ?? this.data,
      versions: versions ?? this.versions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserConstants.email: email.toMap(),
      UserConstants.sessions: Map.fromEntries(sessions.map((device) => MapEntry(device.deviceId, device.toMap()))),
      UserConstants.metadata: metadata.toMap(),
      UserConstants.avatar: avatar,
      UserConstants.preferredLanguage: preferredLanguage.toMap(),
      UserConstants.passwordHistories: passwordHistories.map((history) => history.toMap()).toList(),
      UserConstants.data: data,
      UserConstants.versions: versions,
    };
  }

  @override
  List<Object?> get props => [userId, versions, sessions, metadata, avatar, preferredLanguage, passwordHistories, data];
}
