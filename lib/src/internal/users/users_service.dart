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

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../helpers/database.dart';
import '../../../models/user/avatar.dart';
import '../../../models/user/email.dart';
import '../../../models/user/metadata.dart';
import '../../../models/user/password.dart';
import '../../../models/user/preferred_language.dart';
import '../../../models/user/session.dart';
import '../../../models/user/user.dart';
import '../../../models/users/presence.dart';
import '../auth/user_service.dart';
import '../device/network_service.dart';

abstract class RemoteUsersService {
  Future<String?> getUserId(String email);

  Future<User?> user(String userId);

  Stream<User?> userStream(String userId);

  Future<Map<String, dynamic>?> getData(String userId);

  Future<Email?> getEmail(String userId);

  Future<Avatar?> getAvatar(String userId);

  Future<UserMetadata?> getMetadata(String userId);

  Future<PreferredLanguage?> getPreferredLanguage(String userId);

  Future<List<Session>> getSessions(String userId);

  Future<List<PasswordHistories>> getPasswordHistories(String userId);

  Stream<Presence> presence(String userId);

  Stream<List<Presence>> presences(List<String> userIds);
}

@Singleton(as: RemoteUsersService)
class RemoteUsersServiceImpl implements RemoteUsersService {
  final NetworkService _network;
  final AuthUserService _authUser;

  RemoteUsersServiceImpl(this._network, this._authUser);

  @override
  Future<String?> getUserId(String email) async {
    final snapshot = await DatabaseNodes.emails(email).get();
    final raw = snapshot.value;
    if (raw is! String) return null;

    return raw;
  }

  @override
  Future<User?> user(String userId) async {
    final snapshot = await DatabaseNodes.users(userId).get();
    final raw = snapshot.value;
    if (raw is! Map) return null;

    final map = raw.entries.fold<Map<String, dynamic>>({}, (map, entry) {
      final key = entry.key.toString();
      final value = _cast(entry.value);
      map[key] = value;
      return map;
    });
    return User.fromMap(userId, map);
  }

  @override
  Stream<User?> userStream(String userId) {
    return DatabaseNodes.users(userId).onValue
        .map((event) {
          final raw = event.snapshot.value;
          if (raw is! Map) return null;

          final map = raw.entries.fold<Map<String, dynamic>>({}, (map, entry) {
            final key = entry.key.toString();
            final value = _cast(entry.value);
            map[key] = value;
            return map;
          });

          return User.fromMap(userId, map);
        })
        .distinct((prev, next) {
          if (prev == null && next == null) return true;
          if (prev == null || next == null) return false;

          return mapEquals(prev.toMap(), next.toMap());
        });
  }

  @override
  Future<Avatar?> getAvatar(String userId) async {
    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.avatar).get();

    final raw = snapshot.value;
    if (raw is! Map) return null;

    final map = _cast(raw);

    return switch (AvatarType.values.byName(map[AvatarFields.objectType])) {
      AvatarType.photoAvatar => PhotoAvatar.fromMap(map),
      AvatarType.textAvatar => TextAvatar.fromMap(map),
      AvatarType.placeholderAvatar => PlaceholderAvatar.fromMap(map),
    };
  }

  @override
  Future<Map<String, dynamic>?> getData(String userId) => _getNode(userId, UserConstants.data);

  @override
  Future<Email?> getEmail(String userId) async {
    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.email).get();

    final raw = snapshot.value;
    if (raw is! Map) return null;

    return Email.fromMap(_cast(raw));
  }

  @override
  Future<UserMetadata?> getMetadata(String userId) async {
    final map = await _getNode(userId, UserConstants.metadata);
    if (map == null) return null;

    return UserMetadata.fromMap(map);
  }

  @override
  Future<PreferredLanguage?> getPreferredLanguage(String userId) async {
    final map = await _getNode(userId, UserConstants.preferredLanguage);
    if (map == null) return null;

    return PreferredLanguage.fromMap(map);
  }

  @override
  Future<List<Session>> getSessions(String userId) async {
    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.sessions).get();

    final raw = snapshot.value;
    if (raw is! Map) return const [];

    final map = _cast(raw) as Map<String, dynamic>;

    return map.entries.map((e) => Session.fromMap(e.key, e.value)).toList();
  }

  @override
  Future<List<PasswordHistories>> getPasswordHistories(String userId) async {
    final snapshot = await DatabaseNodes.users(userId).child(UserConstants.passwordHistories).get();

    final raw = snapshot.value;
    if (raw is! List) return const [];

    return raw.map((e) => PasswordHistories.fromMap(_cast(e))).toList();
  }

  @override
  Stream<Presence> presence(String userId) {
    return _canReadPresence(userId)
        .switchMap((canRead) {
          if (!canRead) {
            return Stream.value(Presence(userId: userId, isOnline: false, lastSeenAt: null));
          }

          final presenceStream = DatabaseNodes.presences(userId).onValue.map((event) {
            final raw = event.snapshot.value;
            if (raw is! Map) return false;
            return raw.isNotEmpty;
          });

          final lastSeenStream = DatabaseNodes.users(userId)
              .child(UserConstants.metadata)
              .child(UserMetadataConstants.lastSeenAt)
              .onValue
              .map((event) {
                final value = event.snapshot.value;
                if (value is int) return value;
                return null;
              });

          return CombineLatestStream.combine2<bool, int?, Presence>(presenceStream, lastSeenStream, (
            isOnline,
            lastSeenAt,
          ) {
            return Presence(userId: userId, isOnline: isOnline, lastSeenAt: lastSeenAt);
          });
        })
        .distinct((prev, next) {
          return prev.isOnline == next.isOnline && prev.lastSeenAt == next.lastSeenAt;
        });
  }

  @override
  Stream<List<Presence>> presences(List<String> userIds) {
    if (userIds.isEmpty) return Stream.value(const <Presence>[]);

    final streams = userIds.map(presence).toList();

    return CombineLatestStream.list<Presence>(streams).distinct((prev, next) {
      if (prev.length != next.length) return false;

      for (var i = 0; i < prev.length; i++) {
        final a = prev[i];
        final b = next[i];
        if (a.isOnline != b.isOnline || a.lastSeenAt != b.lastSeenAt) {
          return false;
        }
      }
      return true;
    });
  }
}

extension on RemoteUsersServiceImpl {
  dynamic _cast(dynamic value) {
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), _cast(val)));
    } else if (value is List) {
      return value.map(_cast).toList();
    }
    return value;
  }

  Future<Map<String, dynamic>?> _getNode(String userId, String key) async {
    final snapshot = await DatabaseNodes.users(userId).child(key).get();
    final raw = snapshot.value;
    if (raw == null) return null;

    return _cast(raw) as Map<String, dynamic>?;
  }

  Stream<bool> _canReadPresence(String userId) {
    return CombineLatestStream.combine2<bool, bool, bool>(
      _network.isReachable.stream,
      _authUser.isUserConnected.stream,
      (isReachable, isUserConnected) => isReachable && isUserConnected,
    ).distinct();
  }
}
