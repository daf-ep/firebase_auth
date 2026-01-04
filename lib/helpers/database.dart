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

import 'package:firebase_database/firebase_database.dart';

class DatabaseNodes {
  static DatabaseReference connected() => _database.ref(".info/connected");

  static DatabaseReference events(String userId) => _database.ref("events/$userId");

  static DatabaseReference presences(String userId, {String? deviceId}) {
    if (deviceId != null) {
      return _database.ref("presences/$userId/$deviceId");
    } else {
      return _database.ref("presences/$userId");
    }
  }

  static DatabaseReference users(String userId) => _database.ref("users/${_DatabaseEncoder.encode(userId)}");

  static DatabaseReference emails(String email) => _database.ref("emails/${_DatabaseEncoder.encode(email)}");

  static FirebaseDatabase get _database => FirebaseDatabase.instance;
}

class _DatabaseEncoder {
  static const Map<String, String> _replacements = {
    '.': '_dot_',
    '#': '_hash_',
    r'$': '_dollar_',
    '[': '_lb_',
    ']': '_rb_',
  };

  static String encode(String input) {
    var value = input.trim();

    for (final entry in _replacements.entries) {
      value = value.replaceAll(entry.key, entry.value);
    }

    if (value.isEmpty) {
      throw ArgumentError("RTDB key cannot be empty");
    }
    return value;
  }
}
