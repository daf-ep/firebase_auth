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

import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

import '../app/app.dart';
import 'tables/rate_limite.dart';
import 'tables/user.dart';
import 'tables/versions.dart';

part 'local_storage.g.dart';

@internal
@DriftDatabase(tables: [UserTable, RateLimiteTable, VersionsTable])
class LocalStorage extends _$LocalStorage {
  static LocalStorage? _instance;

  factory LocalStorage() {
    if (_instance == null) {
      throw StateError('LocalStorage.initialize() must be called before accessing LocalStorage.');
    }
    return _instance!;
  }

  LocalStorage._internal() : super(_openConnection());

  static LocalStorage get instance {
    final instance = _instance;
    if (instance == null) {
      throw StateError('LocalStorage.initialize() must be called before accessing instance.');
    }
    return instance;
  }

  static final isInitializedSubject = BehaviorSubject<bool>.seeded(false);

  static bool get isInitialized => isInitializedSubject.value;

  static Stream<bool> get isInitializedStream => isInitializedSubject.stream;

  @override
  int get schemaVersion => 2;

  static Future<void> initialize() async {
    if (_instance != null) return;

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
      open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
    }
    _instance ??= LocalStorage._internal();
    isInitializedSubject.value = true;
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from == 1) {
        await m.createTable(userTable);
        await m.createTable(versionsTable);
        await m.createTable(rateLimiteTable);
      }
    },
    beforeOpen: (details) async {
      final migrator = Migrator(this);

      await _ensureTableExists(userTable.actualTableName, () => migrator.createTable(userTable));
      await _ensureTableExists(versionsTable.actualTableName, () => migrator.createTable(versionsTable));
      await _ensureTableExists(rateLimiteTable.actualTableName, () => migrator.createTable(rateLimiteTable));
    },
  );

  Future<void> _ensureTableExists(String tableName, Future<void> Function() createCallback) async {
    final tables = await customSelect("SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName';").get();

    if (tables.isEmpty) {
      await createCallback();
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final appName = App.info.name.toLowerCase().replaceAll(" ", "_");
    final file = File(p.join(dbFolder.path, '${appName}_auth_storage.sqlite'));
    final rawDb = sqlite3.open(file.path);

    final encryptionKey = await _loadEncryptionKey();
    rawDb.execute("PRAGMA key = \"x'$encryptionKey'\";");

    rawDb.config.doubleQuotedStringLiterals = false;

    return NativeDatabase.opened(rawDb);
  });
}

Future<String> _loadEncryptionKey() async {
  const storage = FlutterSecureStorage();
  final appName = App.info.name.toLowerCase().replaceAll(" ", "_");
  final storageKey = "__fbs__${appName}_auth_storage_password";

  var key = await storage.read(key: storageKey);

  if (key == null) {
    key = _generateSecureHexKey(32);
    await storage.write(key: storageKey, value: key);
  }
  return key;
}

String _generateSecureHexKey(int length) {
  final random = Random.secure();
  final bytes = List<int>.generate(length, (_) => random.nextInt(256));
  final StringBuffer sb = StringBuffer();
  for (final b in bytes) {
    sb.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return sb.toString();
}
