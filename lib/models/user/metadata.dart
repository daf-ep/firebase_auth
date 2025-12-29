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

class UserMetadataConstants {
  static const String createdAt = "created_at";
  static const String updatedAt = "updated_at";
  static const String lastSignInTime = "last_sign_in_time";
}

class UserMetadata {
  final int createdAt;
  final int updatedAt;
  final int lastSignInTime;

  UserMetadata({required this.createdAt, required this.updatedAt, required this.lastSignInTime});

  factory UserMetadata.fromMap(Map<String, dynamic> map) {
    return UserMetadata(
      createdAt: map[UserMetadataConstants.createdAt],
      updatedAt: map[UserMetadataConstants.updatedAt],
      lastSignInTime: map[UserMetadataConstants.lastSignInTime],
    );
  }

  UserMetadata copyWith({int? createdAt, int? updatedAt, int? lastSignInTime}) {
    return UserMetadata(
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserMetadataConstants.createdAt: createdAt,
      UserMetadataConstants.updatedAt: updatedAt,
      UserMetadataConstants.lastSignInTime: lastSignInTime,
    };
  }
}
