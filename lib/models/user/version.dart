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

import 'package:equatable/equatable.dart';

class VersionsConstants {
  static const String data = "data";
  static const String email = "email";
  static const String metadata = "metadata";
  static const String preferredLanguage = "preferredLanguage";
  static const String sessions = "sessions";
  static const String passwordHistories = "password_histories";
  static const String avatar = "avatar";
}

class Versions extends Equatable {
  final int data;
  final int email;
  final int metadata;
  final int preferredLanguage;
  final int sessions;
  final int passwordHistories;
  final int avatar;

  const Versions({
    required this.data,
    required this.email,
    required this.metadata,
    required this.preferredLanguage,
    required this.sessions,
    required this.passwordHistories,
    required this.avatar,
  });

  factory Versions.fromMap(Map<String, dynamic> map) {
    return Versions(
      data: map[VersionsConstants.data],
      email: map[VersionsConstants.email],
      metadata: map[VersionsConstants.metadata],
      preferredLanguage: map[VersionsConstants.preferredLanguage],
      sessions: map[VersionsConstants.sessions],
      passwordHistories: map[VersionsConstants.passwordHistories],
      avatar: map[VersionsConstants.avatar],
    );
  }

  Versions copyWith({
    int? data,
    int? email,
    int? metadata,
    int? preferredLanguage,
    int? sessions,
    int? passwordHistories,
    int? avatar,
  }) {
    return Versions(
      data: data ?? this.data,
      email: email ?? this.email,
      metadata: metadata ?? this.metadata,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sessions: sessions ?? this.sessions,
      passwordHistories: passwordHistories ?? this.passwordHistories,
      avatar: avatar ?? this.avatar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      VersionsConstants.data: data,
      VersionsConstants.email: email,
      VersionsConstants.metadata: metadata,
      VersionsConstants.preferredLanguage: preferredLanguage,
      VersionsConstants.sessions: sessions,
      VersionsConstants.passwordHistories: passwordHistories,
      VersionsConstants.avatar: avatar,
    };
  }

  @override
  List<Object?> get props => [data, email, metadata, preferredLanguage, sessions, passwordHistories, avatar];
}
