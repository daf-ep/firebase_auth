// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage.dart';

// ignore_for_file: type=lint
class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, email, version, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final String userId;
  final String email;
  final int version;
  final String data;
  const UserTableData({
    required this.userId,
    required this.email,
    required this.version,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['email'] = Variable<String>(email);
    map['version'] = Variable<int>(version);
    map['data'] = Variable<String>(data);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      userId: Value(userId),
      email: Value(email),
      version: Value(version),
      data: Value(data),
    );
  }

  factory UserTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      userId: serializer.fromJson<String>(json['userId']),
      email: serializer.fromJson<String>(json['email']),
      version: serializer.fromJson<int>(json['version']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'email': serializer.toJson<String>(email),
      'version': serializer.toJson<int>(version),
      'data': serializer.toJson<String>(data),
    };
  }

  UserTableData copyWith({
    String? userId,
    String? email,
    int? version,
    String? data,
  }) => UserTableData(
    userId: userId ?? this.userId,
    email: email ?? this.email,
    version: version ?? this.version,
    data: data ?? this.data,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      email: data.email.present ? data.email.value : this.email,
      version: data.version.present ? data.version.value : this.version,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('version: $version, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, email, version, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.userId == this.userId &&
          other.email == this.email &&
          other.version == this.version &&
          other.data == this.data);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> userId;
  final Value<String> email;
  final Value<int> version;
  final Value<String> data;
  final Value<int> rowid;
  const UserTableCompanion({
    this.userId = const Value.absent(),
    this.email = const Value.absent(),
    this.version = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String userId,
    required String email,
    required int version,
    required String data,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       email = Value(email),
       version = Value(version),
       data = Value(data);
  static Insertable<UserTableData> custom({
    Expression<String>? userId,
    Expression<String>? email,
    Expression<int>? version,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (version != null) 'version': version,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? email,
    Value<int>? version,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      version: version ?? this.version,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTableCompanion(')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('version: $version, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RateLimiteTableTable extends RateLimiteTable
    with TableInfo<$RateLimiteTableTable, RateLimiteTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RateLimiteTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deviceId, feature, count, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rate_limite_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RateLimiteTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId, feature};
  @override
  RateLimiteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateLimiteTableData(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RateLimiteTableTable createAlias(String alias) {
    return $RateLimiteTableTable(attachedDatabase, alias);
  }
}

class RateLimiteTableData extends DataClass
    implements Insertable<RateLimiteTableData> {
  final String deviceId;
  final String feature;
  final int count;
  final int createdAt;
  const RateLimiteTableData({
    required this.deviceId,
    required this.feature,
    required this.count,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['feature'] = Variable<String>(feature);
    map['count'] = Variable<int>(count);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  RateLimiteTableCompanion toCompanion(bool nullToAbsent) {
    return RateLimiteTableCompanion(
      deviceId: Value(deviceId),
      feature: Value(feature),
      count: Value(count),
      createdAt: Value(createdAt),
    );
  }

  factory RateLimiteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateLimiteTableData(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      feature: serializer.fromJson<String>(json['feature']),
      count: serializer.fromJson<int>(json['count']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'feature': serializer.toJson<String>(feature),
      'count': serializer.toJson<int>(count),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  RateLimiteTableData copyWith({
    String? deviceId,
    String? feature,
    int? count,
    int? createdAt,
  }) => RateLimiteTableData(
    deviceId: deviceId ?? this.deviceId,
    feature: feature ?? this.feature,
    count: count ?? this.count,
    createdAt: createdAt ?? this.createdAt,
  );
  RateLimiteTableData copyWithCompanion(RateLimiteTableCompanion data) {
    return RateLimiteTableData(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      feature: data.feature.present ? data.feature.value : this.feature,
      count: data.count.present ? data.count.value : this.count,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateLimiteTableData(')
          ..write('deviceId: $deviceId, ')
          ..write('feature: $feature, ')
          ..write('count: $count, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deviceId, feature, count, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateLimiteTableData &&
          other.deviceId == this.deviceId &&
          other.feature == this.feature &&
          other.count == this.count &&
          other.createdAt == this.createdAt);
}

class RateLimiteTableCompanion extends UpdateCompanion<RateLimiteTableData> {
  final Value<String> deviceId;
  final Value<String> feature;
  final Value<int> count;
  final Value<int> createdAt;
  final Value<int> rowid;
  const RateLimiteTableCompanion({
    this.deviceId = const Value.absent(),
    this.feature = const Value.absent(),
    this.count = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RateLimiteTableCompanion.insert({
    required String deviceId,
    required String feature,
    required int count,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       feature = Value(feature),
       count = Value(count),
       createdAt = Value(createdAt);
  static Insertable<RateLimiteTableData> custom({
    Expression<String>? deviceId,
    Expression<String>? feature,
    Expression<int>? count,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (feature != null) 'feature': feature,
      if (count != null) 'count': count,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RateLimiteTableCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? feature,
    Value<int>? count,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return RateLimiteTableCompanion(
      deviceId: deviceId ?? this.deviceId,
      feature: feature ?? this.feature,
      count: count ?? this.count,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RateLimiteTableCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('feature: $feature, ')
          ..write('count: $count, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalAuthStorage extends GeneratedDatabase {
  _$LocalAuthStorage(QueryExecutor e) : super(e);
  $LocalAuthStorageManager get managers => $LocalAuthStorageManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $RateLimiteTableTable rateLimiteTable = $RateLimiteTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    rateLimiteTable,
  ];
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      required String userId,
      required String email,
      required int version,
      required String data,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> userId,
      Value<String> email,
      Value<int> version,
      Value<String> data,
      Value<int> rowid,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$LocalAuthStorage, $UserTableTable> {
  $$UserTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$LocalAuthStorage, $UserTableTable> {
  $$UserTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$LocalAuthStorage, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$LocalAuthStorage,
          $UserTableTable,
          UserTableData,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            UserTableData,
            BaseReferences<_$LocalAuthStorage, $UserTableTable, UserTableData>,
          ),
          UserTableData,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$LocalAuthStorage db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                userId: userId,
                email: email,
                version: version,
                data: data,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String email,
                required int version,
                required String data,
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                userId: userId,
                email: email,
                version: version,
                data: data,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalAuthStorage,
      $UserTableTable,
      UserTableData,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        UserTableData,
        BaseReferences<_$LocalAuthStorage, $UserTableTable, UserTableData>,
      ),
      UserTableData,
      PrefetchHooks Function()
    >;
typedef $$RateLimiteTableTableCreateCompanionBuilder =
    RateLimiteTableCompanion Function({
      required String deviceId,
      required String feature,
      required int count,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$RateLimiteTableTableUpdateCompanionBuilder =
    RateLimiteTableCompanion Function({
      Value<String> deviceId,
      Value<String> feature,
      Value<int> count,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$RateLimiteTableTableFilterComposer
    extends Composer<_$LocalAuthStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RateLimiteTableTableOrderingComposer
    extends Composer<_$LocalAuthStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RateLimiteTableTableAnnotationComposer
    extends Composer<_$LocalAuthStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RateLimiteTableTableTableManager
    extends
        RootTableManager<
          _$LocalAuthStorage,
          $RateLimiteTableTable,
          RateLimiteTableData,
          $$RateLimiteTableTableFilterComposer,
          $$RateLimiteTableTableOrderingComposer,
          $$RateLimiteTableTableAnnotationComposer,
          $$RateLimiteTableTableCreateCompanionBuilder,
          $$RateLimiteTableTableUpdateCompanionBuilder,
          (
            RateLimiteTableData,
            BaseReferences<
              _$LocalAuthStorage,
              $RateLimiteTableTable,
              RateLimiteTableData
            >,
          ),
          RateLimiteTableData,
          PrefetchHooks Function()
        > {
  $$RateLimiteTableTableTableManager(
    _$LocalAuthStorage db,
    $RateLimiteTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RateLimiteTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RateLimiteTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RateLimiteTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RateLimiteTableCompanion(
                deviceId: deviceId,
                feature: feature,
                count: count,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String feature,
                required int count,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RateLimiteTableCompanion.insert(
                deviceId: deviceId,
                feature: feature,
                count: count,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RateLimiteTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalAuthStorage,
      $RateLimiteTableTable,
      RateLimiteTableData,
      $$RateLimiteTableTableFilterComposer,
      $$RateLimiteTableTableOrderingComposer,
      $$RateLimiteTableTableAnnotationComposer,
      $$RateLimiteTableTableCreateCompanionBuilder,
      $$RateLimiteTableTableUpdateCompanionBuilder,
      (
        RateLimiteTableData,
        BaseReferences<
          _$LocalAuthStorage,
          $RateLimiteTableTable,
          RateLimiteTableData
        >,
      ),
      RateLimiteTableData,
      PrefetchHooks Function()
    >;

class $LocalAuthStorageManager {
  final _$LocalAuthStorage _db;
  $LocalAuthStorageManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$RateLimiteTableTableTableManager get rateLimiteTable =>
      $$RateLimiteTableTableTableManager(_db, _db.rateLimiteTable);
}
