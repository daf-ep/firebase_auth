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

import 'language.dart';

class PreferredLanguageConstants {
  static const String current = "current";
  static const String histories = "histories";
}

class PreferredLanguageHistoryConstants {
  static const String language = "language";
  static const String changedAt = "changed_at";
  static const String deviceId = "device_id";
}

class PreferredLanguage extends Equatable {
  final Language current;
  final List<PreferredLanguageHistory> histories;

  const PreferredLanguage({required this.current, required this.histories});

  factory PreferredLanguage.fromMap(Map<String, dynamic> map) {
    return PreferredLanguage(
      current: Language.values.byName(map[PreferredLanguageConstants.current]),
      histories: ((map[PreferredLanguageConstants.histories] ?? []) as List<dynamic>)
          .map((h) => PreferredLanguageHistory.fromMap(h))
          .toList(),
    );
  }

  PreferredLanguage copyWith({Language? current, List<PreferredLanguageHistory>? histories}) {
    return PreferredLanguage(current: current ?? this.current, histories: histories ?? this.histories);
  }

  Map<String, dynamic> toMap() {
    return {
      PreferredLanguageConstants.current: current.name,
      PreferredLanguageConstants.histories: histories.map((h) => h.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [current, histories];
}

class PreferredLanguageHistory extends Equatable {
  final Language language;
  final int changedAt;
  final String deviceId;

  const PreferredLanguageHistory({required this.language, required this.changedAt, required this.deviceId});

  factory PreferredLanguageHistory.fromMap(Map<String, dynamic> map) {
    return PreferredLanguageHistory(
      language: Language.values.byName(map[PreferredLanguageHistoryConstants.language]),
      changedAt: map[PreferredLanguageHistoryConstants.changedAt],
      deviceId: map[PreferredLanguageHistoryConstants.deviceId],
    );
  }

  PreferredLanguageHistory copyWith({Language? language, int? changedAt, String? deviceId}) {
    return PreferredLanguageHistory(
      language: language ?? this.language,
      changedAt: changedAt ?? this.changedAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      PreferredLanguageHistoryConstants.language: language.name,
      PreferredLanguageHistoryConstants.changedAt: changedAt,
      PreferredLanguageHistoryConstants.deviceId: deviceId,
    };
  }

  @override
  List<Object?> get props => [language, changedAt, deviceId];
}
