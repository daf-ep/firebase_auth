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
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordHistoriesMeta = const VerificationMeta(
    'passwordHistories',
  );
  @override
  late final GeneratedColumn<String> passwordHistories =
      GeneratedColumn<String>(
        'password_histories',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _preferredLanguageMeta = const VerificationMeta(
    'preferredLanguage',
  );
  @override
  late final GeneratedColumn<String> preferredLanguage =
      GeneratedColumn<String>(
        'preferred_language',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sessionsMeta = const VerificationMeta(
    'sessions',
  );
  @override
  late final GeneratedColumn<String> sessions = GeneratedColumn<String>(
    'sessions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    email,
    data,
    passwordHistories,
    metadata,
    preferredLanguage,
    sessions,
    avatar,
  ];
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
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('password_histories')) {
      context.handle(
        _passwordHistoriesMeta,
        passwordHistories.isAcceptableOrUnknown(
          data['password_histories']!,
          _passwordHistoriesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHistoriesMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    } else if (isInserting) {
      context.missing(_metadataMeta);
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
        _preferredLanguageMeta,
        preferredLanguage.isAcceptableOrUnknown(
          data['preferred_language']!,
          _preferredLanguageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_preferredLanguageMeta);
    }
    if (data.containsKey('sessions')) {
      context.handle(
        _sessionsMeta,
        sessions.isAcceptableOrUnknown(data['sessions']!, _sessionsMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionsMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
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
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      ),
      passwordHistories: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_histories'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      )!,
      preferredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_language'],
      )!,
      sessions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sessions'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
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
  final String? data;
  final String passwordHistories;
  final String metadata;
  final String preferredLanguage;
  final String sessions;
  final String? avatar;
  const UserTableData({
    required this.userId,
    required this.email,
    this.data,
    required this.passwordHistories,
    required this.metadata,
    required this.preferredLanguage,
    required this.sessions,
    this.avatar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || data != null) {
      map['data'] = Variable<String>(data);
    }
    map['password_histories'] = Variable<String>(passwordHistories);
    map['metadata'] = Variable<String>(metadata);
    map['preferred_language'] = Variable<String>(preferredLanguage);
    map['sessions'] = Variable<String>(sessions);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      userId: Value(userId),
      email: Value(email),
      data: data == null && nullToAbsent ? const Value.absent() : Value(data),
      passwordHistories: Value(passwordHistories),
      metadata: Value(metadata),
      preferredLanguage: Value(preferredLanguage),
      sessions: Value(sessions),
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
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
      data: serializer.fromJson<String?>(json['data']),
      passwordHistories: serializer.fromJson<String>(json['passwordHistories']),
      metadata: serializer.fromJson<String>(json['metadata']),
      preferredLanguage: serializer.fromJson<String>(json['preferredLanguage']),
      sessions: serializer.fromJson<String>(json['sessions']),
      avatar: serializer.fromJson<String?>(json['avatar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'email': serializer.toJson<String>(email),
      'data': serializer.toJson<String?>(data),
      'passwordHistories': serializer.toJson<String>(passwordHistories),
      'metadata': serializer.toJson<String>(metadata),
      'preferredLanguage': serializer.toJson<String>(preferredLanguage),
      'sessions': serializer.toJson<String>(sessions),
      'avatar': serializer.toJson<String?>(avatar),
    };
  }

  UserTableData copyWith({
    String? userId,
    String? email,
    Value<String?> data = const Value.absent(),
    String? passwordHistories,
    String? metadata,
    String? preferredLanguage,
    String? sessions,
    Value<String?> avatar = const Value.absent(),
  }) => UserTableData(
    userId: userId ?? this.userId,
    email: email ?? this.email,
    data: data.present ? data.value : this.data,
    passwordHistories: passwordHistories ?? this.passwordHistories,
    metadata: metadata ?? this.metadata,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    sessions: sessions ?? this.sessions,
    avatar: avatar.present ? avatar.value : this.avatar,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      email: data.email.present ? data.email.value : this.email,
      data: data.data.present ? data.data.value : this.data,
      passwordHistories: data.passwordHistories.present
          ? data.passwordHistories.value
          : this.passwordHistories,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      sessions: data.sessions.present ? data.sessions.value : this.sessions,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('data: $data, ')
          ..write('passwordHistories: $passwordHistories, ')
          ..write('metadata: $metadata, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('sessions: $sessions, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    email,
    data,
    passwordHistories,
    metadata,
    preferredLanguage,
    sessions,
    avatar,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.userId == this.userId &&
          other.email == this.email &&
          other.data == this.data &&
          other.passwordHistories == this.passwordHistories &&
          other.metadata == this.metadata &&
          other.preferredLanguage == this.preferredLanguage &&
          other.sessions == this.sessions &&
          other.avatar == this.avatar);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> userId;
  final Value<String> email;
  final Value<String?> data;
  final Value<String> passwordHistories;
  final Value<String> metadata;
  final Value<String> preferredLanguage;
  final Value<String> sessions;
  final Value<String?> avatar;
  final Value<int> rowid;
  const UserTableCompanion({
    this.userId = const Value.absent(),
    this.email = const Value.absent(),
    this.data = const Value.absent(),
    this.passwordHistories = const Value.absent(),
    this.metadata = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.sessions = const Value.absent(),
    this.avatar = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String userId,
    required String email,
    this.data = const Value.absent(),
    required String passwordHistories,
    required String metadata,
    required String preferredLanguage,
    required String sessions,
    this.avatar = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       email = Value(email),
       passwordHistories = Value(passwordHistories),
       metadata = Value(metadata),
       preferredLanguage = Value(preferredLanguage),
       sessions = Value(sessions);
  static Insertable<UserTableData> custom({
    Expression<String>? userId,
    Expression<String>? email,
    Expression<String>? data,
    Expression<String>? passwordHistories,
    Expression<String>? metadata,
    Expression<String>? preferredLanguage,
    Expression<String>? sessions,
    Expression<String>? avatar,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (data != null) 'data': data,
      if (passwordHistories != null) 'password_histories': passwordHistories,
      if (metadata != null) 'metadata': metadata,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (sessions != null) 'sessions': sessions,
      if (avatar != null) 'avatar': avatar,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? email,
    Value<String?>? data,
    Value<String>? passwordHistories,
    Value<String>? metadata,
    Value<String>? preferredLanguage,
    Value<String>? sessions,
    Value<String?>? avatar,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      data: data ?? this.data,
      passwordHistories: passwordHistories ?? this.passwordHistories,
      metadata: metadata ?? this.metadata,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sessions: sessions ?? this.sessions,
      avatar: avatar ?? this.avatar,
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
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (passwordHistories.present) {
      map['password_histories'] = Variable<String>(passwordHistories.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<String>(preferredLanguage.value);
    }
    if (sessions.present) {
      map['sessions'] = Variable<String>(sessions.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
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
          ..write('data: $data, ')
          ..write('passwordHistories: $passwordHistories, ')
          ..write('metadata: $metadata, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('sessions: $sessions, ')
          ..write('avatar: $avatar, ')
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
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
  static const VerificationMeta _resetAtMeta = const VerificationMeta(
    'resetAt',
  );
  @override
  late final GeneratedColumn<int> resetAt = GeneratedColumn<int>(
    'reset_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lockUntilMeta = const VerificationMeta(
    'lockUntil',
  );
  @override
  late final GeneratedColumn<int> lockUntil = GeneratedColumn<int>(
    'lock_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    feature,
    count,
    resetAt,
    lockUntil,
  ];
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
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
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
    if (data.containsKey('reset_at')) {
      context.handle(
        _resetAtMeta,
        resetAt.isAcceptableOrUnknown(data['reset_at']!, _resetAtMeta),
      );
    } else if (isInserting) {
      context.missing(_resetAtMeta);
    }
    if (data.containsKey('lock_until')) {
      context.handle(
        _lockUntilMeta,
        lockUntil.isAcceptableOrUnknown(data['lock_until']!, _lockUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key, feature};
  @override
  RateLimiteTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RateLimiteTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      resetAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reset_at'],
      )!,
      lockUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lock_until'],
      ),
    );
  }

  @override
  $RateLimiteTableTable createAlias(String alias) {
    return $RateLimiteTableTable(attachedDatabase, alias);
  }
}

class RateLimiteTableData extends DataClass
    implements Insertable<RateLimiteTableData> {
  final String key;
  final String feature;
  final int count;
  final int resetAt;
  final int? lockUntil;
  const RateLimiteTableData({
    required this.key,
    required this.feature,
    required this.count,
    required this.resetAt,
    this.lockUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['feature'] = Variable<String>(feature);
    map['count'] = Variable<int>(count);
    map['reset_at'] = Variable<int>(resetAt);
    if (!nullToAbsent || lockUntil != null) {
      map['lock_until'] = Variable<int>(lockUntil);
    }
    return map;
  }

  RateLimiteTableCompanion toCompanion(bool nullToAbsent) {
    return RateLimiteTableCompanion(
      key: Value(key),
      feature: Value(feature),
      count: Value(count),
      resetAt: Value(resetAt),
      lockUntil: lockUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockUntil),
    );
  }

  factory RateLimiteTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RateLimiteTableData(
      key: serializer.fromJson<String>(json['key']),
      feature: serializer.fromJson<String>(json['feature']),
      count: serializer.fromJson<int>(json['count']),
      resetAt: serializer.fromJson<int>(json['resetAt']),
      lockUntil: serializer.fromJson<int?>(json['lockUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'feature': serializer.toJson<String>(feature),
      'count': serializer.toJson<int>(count),
      'resetAt': serializer.toJson<int>(resetAt),
      'lockUntil': serializer.toJson<int?>(lockUntil),
    };
  }

  RateLimiteTableData copyWith({
    String? key,
    String? feature,
    int? count,
    int? resetAt,
    Value<int?> lockUntil = const Value.absent(),
  }) => RateLimiteTableData(
    key: key ?? this.key,
    feature: feature ?? this.feature,
    count: count ?? this.count,
    resetAt: resetAt ?? this.resetAt,
    lockUntil: lockUntil.present ? lockUntil.value : this.lockUntil,
  );
  RateLimiteTableData copyWithCompanion(RateLimiteTableCompanion data) {
    return RateLimiteTableData(
      key: data.key.present ? data.key.value : this.key,
      feature: data.feature.present ? data.feature.value : this.feature,
      count: data.count.present ? data.count.value : this.count,
      resetAt: data.resetAt.present ? data.resetAt.value : this.resetAt,
      lockUntil: data.lockUntil.present ? data.lockUntil.value : this.lockUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RateLimiteTableData(')
          ..write('key: $key, ')
          ..write('feature: $feature, ')
          ..write('count: $count, ')
          ..write('resetAt: $resetAt, ')
          ..write('lockUntil: $lockUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, feature, count, resetAt, lockUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RateLimiteTableData &&
          other.key == this.key &&
          other.feature == this.feature &&
          other.count == this.count &&
          other.resetAt == this.resetAt &&
          other.lockUntil == this.lockUntil);
}

class RateLimiteTableCompanion extends UpdateCompanion<RateLimiteTableData> {
  final Value<String> key;
  final Value<String> feature;
  final Value<int> count;
  final Value<int> resetAt;
  final Value<int?> lockUntil;
  final Value<int> rowid;
  const RateLimiteTableCompanion({
    this.key = const Value.absent(),
    this.feature = const Value.absent(),
    this.count = const Value.absent(),
    this.resetAt = const Value.absent(),
    this.lockUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RateLimiteTableCompanion.insert({
    required String key,
    required String feature,
    required int count,
    required int resetAt,
    this.lockUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       feature = Value(feature),
       count = Value(count),
       resetAt = Value(resetAt);
  static Insertable<RateLimiteTableData> custom({
    Expression<String>? key,
    Expression<String>? feature,
    Expression<int>? count,
    Expression<int>? resetAt,
    Expression<int>? lockUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (feature != null) 'feature': feature,
      if (count != null) 'count': count,
      if (resetAt != null) 'reset_at': resetAt,
      if (lockUntil != null) 'lock_until': lockUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RateLimiteTableCompanion copyWith({
    Value<String>? key,
    Value<String>? feature,
    Value<int>? count,
    Value<int>? resetAt,
    Value<int?>? lockUntil,
    Value<int>? rowid,
  }) {
    return RateLimiteTableCompanion(
      key: key ?? this.key,
      feature: feature ?? this.feature,
      count: count ?? this.count,
      resetAt: resetAt ?? this.resetAt,
      lockUntil: lockUntil ?? this.lockUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (resetAt.present) {
      map['reset_at'] = Variable<int>(resetAt.value);
    }
    if (lockUntil.present) {
      map['lock_until'] = Variable<int>(lockUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RateLimiteTableCompanion(')
          ..write('key: $key, ')
          ..write('feature: $feature, ')
          ..write('count: $count, ')
          ..write('resetAt: $resetAt, ')
          ..write('lockUntil: $lockUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VersionsTableTable extends VersionsTable
    with TableInfo<$VersionsTableTable, VersionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<int> data = GeneratedColumn<int>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<int> email = GeneratedColumn<int>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _passwordHistoriesMeta = const VerificationMeta(
    'passwordHistories',
  );
  @override
  late final GeneratedColumn<int> passwordHistories = GeneratedColumn<int>(
    'password_histories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<int> metadata = GeneratedColumn<int>(
    'metadata',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _preferredLanguageMeta = const VerificationMeta(
    'preferredLanguage',
  );
  @override
  late final GeneratedColumn<int> preferredLanguage = GeneratedColumn<int>(
    'preferred_language',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sessionsMeta = const VerificationMeta(
    'sessions',
  );
  @override
  late final GeneratedColumn<int> sessions = GeneratedColumn<int>(
    'sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<int> avatar = GeneratedColumn<int>(
    'avatar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    data,
    email,
    passwordHistories,
    metadata,
    preferredLanguage,
    sessions,
    avatar,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'versions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<VersionsTableData> instance, {
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
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('password_histories')) {
      context.handle(
        _passwordHistoriesMeta,
        passwordHistories.isAcceptableOrUnknown(
          data['password_histories']!,
          _passwordHistoriesMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('preferred_language')) {
      context.handle(
        _preferredLanguageMeta,
        preferredLanguage.isAcceptableOrUnknown(
          data['preferred_language']!,
          _preferredLanguageMeta,
        ),
      );
    }
    if (data.containsKey('sessions')) {
      context.handle(
        _sessionsMeta,
        sessions.isAcceptableOrUnknown(data['sessions']!, _sessionsMeta),
      );
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  VersionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VersionsTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}data'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}email'],
      )!,
      passwordHistories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}password_histories'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}metadata'],
      )!,
      preferredLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_language'],
      )!,
      sessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sessions'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avatar'],
      )!,
    );
  }

  @override
  $VersionsTableTable createAlias(String alias) {
    return $VersionsTableTable(attachedDatabase, alias);
  }
}

class VersionsTableData extends DataClass
    implements Insertable<VersionsTableData> {
  final String userId;
  final int data;
  final int email;
  final int passwordHistories;
  final int metadata;
  final int preferredLanguage;
  final int sessions;
  final int avatar;
  const VersionsTableData({
    required this.userId,
    required this.data,
    required this.email,
    required this.passwordHistories,
    required this.metadata,
    required this.preferredLanguage,
    required this.sessions,
    required this.avatar,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['data'] = Variable<int>(data);
    map['email'] = Variable<int>(email);
    map['password_histories'] = Variable<int>(passwordHistories);
    map['metadata'] = Variable<int>(metadata);
    map['preferred_language'] = Variable<int>(preferredLanguage);
    map['sessions'] = Variable<int>(sessions);
    map['avatar'] = Variable<int>(avatar);
    return map;
  }

  VersionsTableCompanion toCompanion(bool nullToAbsent) {
    return VersionsTableCompanion(
      userId: Value(userId),
      data: Value(data),
      email: Value(email),
      passwordHistories: Value(passwordHistories),
      metadata: Value(metadata),
      preferredLanguage: Value(preferredLanguage),
      sessions: Value(sessions),
      avatar: Value(avatar),
    );
  }

  factory VersionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VersionsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      data: serializer.fromJson<int>(json['data']),
      email: serializer.fromJson<int>(json['email']),
      passwordHistories: serializer.fromJson<int>(json['passwordHistories']),
      metadata: serializer.fromJson<int>(json['metadata']),
      preferredLanguage: serializer.fromJson<int>(json['preferredLanguage']),
      sessions: serializer.fromJson<int>(json['sessions']),
      avatar: serializer.fromJson<int>(json['avatar']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'data': serializer.toJson<int>(data),
      'email': serializer.toJson<int>(email),
      'passwordHistories': serializer.toJson<int>(passwordHistories),
      'metadata': serializer.toJson<int>(metadata),
      'preferredLanguage': serializer.toJson<int>(preferredLanguage),
      'sessions': serializer.toJson<int>(sessions),
      'avatar': serializer.toJson<int>(avatar),
    };
  }

  VersionsTableData copyWith({
    String? userId,
    int? data,
    int? email,
    int? passwordHistories,
    int? metadata,
    int? preferredLanguage,
    int? sessions,
    int? avatar,
  }) => VersionsTableData(
    userId: userId ?? this.userId,
    data: data ?? this.data,
    email: email ?? this.email,
    passwordHistories: passwordHistories ?? this.passwordHistories,
    metadata: metadata ?? this.metadata,
    preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    sessions: sessions ?? this.sessions,
    avatar: avatar ?? this.avatar,
  );
  VersionsTableData copyWithCompanion(VersionsTableCompanion data) {
    return VersionsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      data: data.data.present ? data.data.value : this.data,
      email: data.email.present ? data.email.value : this.email,
      passwordHistories: data.passwordHistories.present
          ? data.passwordHistories.value
          : this.passwordHistories,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      preferredLanguage: data.preferredLanguage.present
          ? data.preferredLanguage.value
          : this.preferredLanguage,
      sessions: data.sessions.present ? data.sessions.value : this.sessions,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VersionsTableData(')
          ..write('userId: $userId, ')
          ..write('data: $data, ')
          ..write('email: $email, ')
          ..write('passwordHistories: $passwordHistories, ')
          ..write('metadata: $metadata, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('sessions: $sessions, ')
          ..write('avatar: $avatar')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    data,
    email,
    passwordHistories,
    metadata,
    preferredLanguage,
    sessions,
    avatar,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VersionsTableData &&
          other.userId == this.userId &&
          other.data == this.data &&
          other.email == this.email &&
          other.passwordHistories == this.passwordHistories &&
          other.metadata == this.metadata &&
          other.preferredLanguage == this.preferredLanguage &&
          other.sessions == this.sessions &&
          other.avatar == this.avatar);
}

class VersionsTableCompanion extends UpdateCompanion<VersionsTableData> {
  final Value<String> userId;
  final Value<int> data;
  final Value<int> email;
  final Value<int> passwordHistories;
  final Value<int> metadata;
  final Value<int> preferredLanguage;
  final Value<int> sessions;
  final Value<int> avatar;
  final Value<int> rowid;
  const VersionsTableCompanion({
    this.userId = const Value.absent(),
    this.data = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHistories = const Value.absent(),
    this.metadata = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.sessions = const Value.absent(),
    this.avatar = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VersionsTableCompanion.insert({
    required String userId,
    this.data = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHistories = const Value.absent(),
    this.metadata = const Value.absent(),
    this.preferredLanguage = const Value.absent(),
    this.sessions = const Value.absent(),
    this.avatar = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<VersionsTableData> custom({
    Expression<String>? userId,
    Expression<int>? data,
    Expression<int>? email,
    Expression<int>? passwordHistories,
    Expression<int>? metadata,
    Expression<int>? preferredLanguage,
    Expression<int>? sessions,
    Expression<int>? avatar,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (data != null) 'data': data,
      if (email != null) 'email': email,
      if (passwordHistories != null) 'password_histories': passwordHistories,
      if (metadata != null) 'metadata': metadata,
      if (preferredLanguage != null) 'preferred_language': preferredLanguage,
      if (sessions != null) 'sessions': sessions,
      if (avatar != null) 'avatar': avatar,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VersionsTableCompanion copyWith({
    Value<String>? userId,
    Value<int>? data,
    Value<int>? email,
    Value<int>? passwordHistories,
    Value<int>? metadata,
    Value<int>? preferredLanguage,
    Value<int>? sessions,
    Value<int>? avatar,
    Value<int>? rowid,
  }) {
    return VersionsTableCompanion(
      userId: userId ?? this.userId,
      data: data ?? this.data,
      email: email ?? this.email,
      passwordHistories: passwordHistories ?? this.passwordHistories,
      metadata: metadata ?? this.metadata,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      sessions: sessions ?? this.sessions,
      avatar: avatar ?? this.avatar,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (data.present) {
      map['data'] = Variable<int>(data.value);
    }
    if (email.present) {
      map['email'] = Variable<int>(email.value);
    }
    if (passwordHistories.present) {
      map['password_histories'] = Variable<int>(passwordHistories.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<int>(metadata.value);
    }
    if (preferredLanguage.present) {
      map['preferred_language'] = Variable<int>(preferredLanguage.value);
    }
    if (sessions.present) {
      map['sessions'] = Variable<int>(sessions.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<int>(avatar.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersionsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('data: $data, ')
          ..write('email: $email, ')
          ..write('passwordHistories: $passwordHistories, ')
          ..write('metadata: $metadata, ')
          ..write('preferredLanguage: $preferredLanguage, ')
          ..write('sessions: $sessions, ')
          ..write('avatar: $avatar, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalStorage extends GeneratedDatabase {
  _$LocalStorage(QueryExecutor e) : super(e);
  $LocalStorageManager get managers => $LocalStorageManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $RateLimiteTableTable rateLimiteTable = $RateLimiteTableTable(
    this,
  );
  late final $VersionsTableTable versionsTable = $VersionsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    rateLimiteTable,
    versionsTable,
  ];
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      required String userId,
      required String email,
      Value<String?> data,
      required String passwordHistories,
      required String metadata,
      required String preferredLanguage,
      required String sessions,
      Value<String?> avatar,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> userId,
      Value<String> email,
      Value<String?> data,
      Value<String> passwordHistories,
      Value<String> metadata,
      Value<String> preferredLanguage,
      Value<String> sessions,
      Value<String?> avatar,
      Value<int> rowid,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$LocalStorage, $UserTableTable> {
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

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessions => $composableBuilder(
    column: $table.sessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$LocalStorage, $UserTableTable> {
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

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessions => $composableBuilder(
    column: $table.sessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$LocalStorage, $UserTableTable> {
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

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<String> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<String> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sessions =>
      $composableBuilder(column: $table.sessions, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$LocalStorage,
          $UserTableTable,
          UserTableData,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            UserTableData,
            BaseReferences<_$LocalStorage, $UserTableTable, UserTableData>,
          ),
          UserTableData,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$LocalStorage db, $UserTableTable table)
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
                Value<String?> data = const Value.absent(),
                Value<String> passwordHistories = const Value.absent(),
                Value<String> metadata = const Value.absent(),
                Value<String> preferredLanguage = const Value.absent(),
                Value<String> sessions = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                userId: userId,
                email: email,
                data: data,
                passwordHistories: passwordHistories,
                metadata: metadata,
                preferredLanguage: preferredLanguage,
                sessions: sessions,
                avatar: avatar,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String email,
                Value<String?> data = const Value.absent(),
                required String passwordHistories,
                required String metadata,
                required String preferredLanguage,
                required String sessions,
                Value<String?> avatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                userId: userId,
                email: email,
                data: data,
                passwordHistories: passwordHistories,
                metadata: metadata,
                preferredLanguage: preferredLanguage,
                sessions: sessions,
                avatar: avatar,
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
      _$LocalStorage,
      $UserTableTable,
      UserTableData,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        UserTableData,
        BaseReferences<_$LocalStorage, $UserTableTable, UserTableData>,
      ),
      UserTableData,
      PrefetchHooks Function()
    >;
typedef $$RateLimiteTableTableCreateCompanionBuilder =
    RateLimiteTableCompanion Function({
      required String key,
      required String feature,
      required int count,
      required int resetAt,
      Value<int?> lockUntil,
      Value<int> rowid,
    });
typedef $$RateLimiteTableTableUpdateCompanionBuilder =
    RateLimiteTableCompanion Function({
      Value<String> key,
      Value<String> feature,
      Value<int> count,
      Value<int> resetAt,
      Value<int?> lockUntil,
      Value<int> rowid,
    });

class $$RateLimiteTableTableFilterComposer
    extends Composer<_$LocalStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
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

  ColumnFilters<int> get resetAt => $composableBuilder(
    column: $table.resetAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lockUntil => $composableBuilder(
    column: $table.lockUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RateLimiteTableTableOrderingComposer
    extends Composer<_$LocalStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
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

  ColumnOrderings<int> get resetAt => $composableBuilder(
    column: $table.resetAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lockUntil => $composableBuilder(
    column: $table.lockUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RateLimiteTableTableAnnotationComposer
    extends Composer<_$LocalStorage, $RateLimiteTableTable> {
  $$RateLimiteTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get resetAt =>
      $composableBuilder(column: $table.resetAt, builder: (column) => column);

  GeneratedColumn<int> get lockUntil =>
      $composableBuilder(column: $table.lockUntil, builder: (column) => column);
}

class $$RateLimiteTableTableTableManager
    extends
        RootTableManager<
          _$LocalStorage,
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
              _$LocalStorage,
              $RateLimiteTableTable,
              RateLimiteTableData
            >,
          ),
          RateLimiteTableData,
          PrefetchHooks Function()
        > {
  $$RateLimiteTableTableTableManager(
    _$LocalStorage db,
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
                Value<String> key = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> resetAt = const Value.absent(),
                Value<int?> lockUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RateLimiteTableCompanion(
                key: key,
                feature: feature,
                count: count,
                resetAt: resetAt,
                lockUntil: lockUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String feature,
                required int count,
                required int resetAt,
                Value<int?> lockUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RateLimiteTableCompanion.insert(
                key: key,
                feature: feature,
                count: count,
                resetAt: resetAt,
                lockUntil: lockUntil,
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
      _$LocalStorage,
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
          _$LocalStorage,
          $RateLimiteTableTable,
          RateLimiteTableData
        >,
      ),
      RateLimiteTableData,
      PrefetchHooks Function()
    >;
typedef $$VersionsTableTableCreateCompanionBuilder =
    VersionsTableCompanion Function({
      required String userId,
      Value<int> data,
      Value<int> email,
      Value<int> passwordHistories,
      Value<int> metadata,
      Value<int> preferredLanguage,
      Value<int> sessions,
      Value<int> avatar,
      Value<int> rowid,
    });
typedef $$VersionsTableTableUpdateCompanionBuilder =
    VersionsTableCompanion Function({
      Value<String> userId,
      Value<int> data,
      Value<int> email,
      Value<int> passwordHistories,
      Value<int> metadata,
      Value<int> preferredLanguage,
      Value<int> sessions,
      Value<int> avatar,
      Value<int> rowid,
    });

class $$VersionsTableTableFilterComposer
    extends Composer<_$LocalStorage, $VersionsTableTable> {
  $$VersionsTableTableFilterComposer({
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

  ColumnFilters<int> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sessions => $composableBuilder(
    column: $table.sessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VersionsTableTableOrderingComposer
    extends Composer<_$LocalStorage, $VersionsTableTable> {
  $$VersionsTableTableOrderingComposer({
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

  ColumnOrderings<int> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sessions => $composableBuilder(
    column: $table.sessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VersionsTableTableAnnotationComposer
    extends Composer<_$LocalStorage, $VersionsTableTable> {
  $$VersionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<int> get passwordHistories => $composableBuilder(
    column: $table.passwordHistories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<int> get preferredLanguage => $composableBuilder(
    column: $table.preferredLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sessions =>
      $composableBuilder(column: $table.sessions, builder: (column) => column);

  GeneratedColumn<int> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);
}

class $$VersionsTableTableTableManager
    extends
        RootTableManager<
          _$LocalStorage,
          $VersionsTableTable,
          VersionsTableData,
          $$VersionsTableTableFilterComposer,
          $$VersionsTableTableOrderingComposer,
          $$VersionsTableTableAnnotationComposer,
          $$VersionsTableTableCreateCompanionBuilder,
          $$VersionsTableTableUpdateCompanionBuilder,
          (
            VersionsTableData,
            BaseReferences<
              _$LocalStorage,
              $VersionsTableTable,
              VersionsTableData
            >,
          ),
          VersionsTableData,
          PrefetchHooks Function()
        > {
  $$VersionsTableTableTableManager(_$LocalStorage db, $VersionsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<int> data = const Value.absent(),
                Value<int> email = const Value.absent(),
                Value<int> passwordHistories = const Value.absent(),
                Value<int> metadata = const Value.absent(),
                Value<int> preferredLanguage = const Value.absent(),
                Value<int> sessions = const Value.absent(),
                Value<int> avatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersionsTableCompanion(
                userId: userId,
                data: data,
                email: email,
                passwordHistories: passwordHistories,
                metadata: metadata,
                preferredLanguage: preferredLanguage,
                sessions: sessions,
                avatar: avatar,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<int> data = const Value.absent(),
                Value<int> email = const Value.absent(),
                Value<int> passwordHistories = const Value.absent(),
                Value<int> metadata = const Value.absent(),
                Value<int> preferredLanguage = const Value.absent(),
                Value<int> sessions = const Value.absent(),
                Value<int> avatar = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersionsTableCompanion.insert(
                userId: userId,
                data: data,
                email: email,
                passwordHistories: passwordHistories,
                metadata: metadata,
                preferredLanguage: preferredLanguage,
                sessions: sessions,
                avatar: avatar,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VersionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalStorage,
      $VersionsTableTable,
      VersionsTableData,
      $$VersionsTableTableFilterComposer,
      $$VersionsTableTableOrderingComposer,
      $$VersionsTableTableAnnotationComposer,
      $$VersionsTableTableCreateCompanionBuilder,
      $$VersionsTableTableUpdateCompanionBuilder,
      (
        VersionsTableData,
        BaseReferences<_$LocalStorage, $VersionsTableTable, VersionsTableData>,
      ),
      VersionsTableData,
      PrefetchHooks Function()
    >;

class $LocalStorageManager {
  final _$LocalStorage _db;
  $LocalStorageManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$RateLimiteTableTableTableManager get rateLimiteTable =>
      $$RateLimiteTableTableTableManager(_db, _db.rateLimiteTable);
  $$VersionsTableTableTableManager get versionsTable =>
      $$VersionsTableTableTableManager(_db, _db.versionsTable);
}
