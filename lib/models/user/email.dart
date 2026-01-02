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

class EmailConstants {
  static const value = 'value';
  static const histories = 'histories';
}

class EmailHistoriesConstants {
  static const value = 'value';
  static const changedAt = 'changed_at';
  static const deviceId = 'device_id';
}

class Email extends Equatable {
  final String value;
  final List<EmailHistories> histories;

  const Email({required this.value, required this.histories});

  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      value: map[EmailConstants.value] as String,
      histories: ((map[EmailConstants.histories] ?? []) as List)
          .map((e) => EmailHistories.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Email copyWith({String? value, List<EmailHistories>? histories}) {
    return Email(value: value ?? this.value, histories: histories ?? this.histories);
  }

  Map<String, dynamic> toMap() {
    return {EmailConstants.value: value, EmailConstants.histories: histories.map((e) => e.toMap()).toList()};
  }

  @override
  List<Object?> get props => [value, histories];
}

class EmailHistories extends Equatable {
  final String value;
  final int changedAt;
  final String deviceId;

  const EmailHistories({required this.value, required this.changedAt, required this.deviceId});

  factory EmailHistories.fromMap(Map<String, dynamic> map) {
    return EmailHistories(
      value: map[EmailHistoriesConstants.value] as String,
      changedAt: map[EmailHistoriesConstants.changedAt] as int,
      deviceId: map[EmailHistoriesConstants.deviceId] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      EmailHistoriesConstants.value: value,
      EmailHistoriesConstants.changedAt: changedAt,
      EmailHistoriesConstants.deviceId: deviceId,
    };
  }

  @override
  List<Object?> get props => [value, changedAt, deviceId];
}
