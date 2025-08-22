// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserEntriesTable extends UserEntries
    with TableInfo<$UserEntriesTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 10,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hashedPasswordMeta = const VerificationMeta(
    'hashedPassword',
  );
  @override
  late final GeneratedColumn<String> hashedPassword = GeneratedColumn<String>(
    'hashed_password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    externalId,
    lastName,
    firstName,
    middleName,
    phoneNumber,
    hashedPassword,
    role,
    createdAt,
    updatedAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('hashed_password')) {
      context.handle(
        _hashedPasswordMeta,
        hashedPassword.isAcceptableOrUnknown(
          data['hashed_password']!,
          _hashedPasswordMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hashedPasswordMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {externalId},
    {phoneNumber},
  ];
  @override
  UserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      ),
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      hashedPassword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hashed_password'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $UserEntriesTable createAlias(String alias) {
    return $UserEntriesTable(attachedDatabase, alias);
  }
}

class UserEntry extends DataClass implements Insertable<UserEntry> {
  final int id;
  final String externalId;
  final String lastName;
  final String firstName;
  final String? middleName;
  final String phoneNumber;
  final String hashedPassword;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncAt;
  const UserEntry({
    required this.id,
    required this.externalId,
    required this.lastName,
    required this.firstName,
    this.middleName,
    required this.phoneNumber,
    required this.hashedPassword,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['external_id'] = Variable<String>(externalId);
    map['last_name'] = Variable<String>(lastName);
    map['first_name'] = Variable<String>(firstName);
    if (!nullToAbsent || middleName != null) {
      map['middle_name'] = Variable<String>(middleName);
    }
    map['phone_number'] = Variable<String>(phoneNumber);
    map['hashed_password'] = Variable<String>(hashedPassword);
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  UserEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserEntriesCompanion(
      id: Value(id),
      externalId: Value(externalId),
      lastName: Value(lastName),
      firstName: Value(firstName),
      middleName: middleName == null && nullToAbsent
          ? const Value.absent()
          : Value(middleName),
      phoneNumber: Value(phoneNumber),
      hashedPassword: Value(hashedPassword),
      role: Value(role),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory UserEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<int>(json['id']),
      externalId: serializer.fromJson<String>(json['externalId']),
      lastName: serializer.fromJson<String>(json['lastName']),
      firstName: serializer.fromJson<String>(json['firstName']),
      middleName: serializer.fromJson<String?>(json['middleName']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      hashedPassword: serializer.fromJson<String>(json['hashedPassword']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'externalId': serializer.toJson<String>(externalId),
      'lastName': serializer.toJson<String>(lastName),
      'firstName': serializer.toJson<String>(firstName),
      'middleName': serializer.toJson<String?>(middleName),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'hashedPassword': serializer.toJson<String>(hashedPassword),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  UserEntry copyWith({
    int? id,
    String? externalId,
    String? lastName,
    String? firstName,
    Value<String?> middleName = const Value.absent(),
    String? phoneNumber,
    String? hashedPassword,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => UserEntry(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    lastName: lastName ?? this.lastName,
    firstName: firstName ?? this.firstName,
    middleName: middleName.present ? middleName.value : this.middleName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    hashedPassword: hashedPassword ?? this.hashedPassword,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  UserEntry copyWithCompanion(UserEntriesCompanion data) {
    return UserEntry(
      id: data.id.present ? data.id.value : this.id,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      hashedPassword: data.hashedPassword.present
          ? data.hashedPassword.value
          : this.hashedPassword,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('lastName: $lastName, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    externalId,
    lastName,
    firstName,
    middleName,
    phoneNumber,
    hashedPassword,
    role,
    createdAt,
    updatedAt,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.lastName == this.lastName &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.phoneNumber == this.phoneNumber &&
          other.hashedPassword == this.hashedPassword &&
          other.role == this.role &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class UserEntriesCompanion extends UpdateCompanion<UserEntry> {
  final Value<int> id;
  final Value<String> externalId;
  final Value<String> lastName;
  final Value<String> firstName;
  final Value<String?> middleName;
  final Value<String> phoneNumber;
  final Value<String> hashedPassword;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncAt;
  const UserEntriesCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.lastName = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.hashedPassword = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  UserEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String externalId,
    required String lastName,
    required String firstName,
    this.middleName = const Value.absent(),
    required String phoneNumber,
    required String hashedPassword,
    required String role,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  }) : externalId = Value(externalId),
       lastName = Value(lastName),
       firstName = Value(firstName),
       phoneNumber = Value(phoneNumber),
       hashedPassword = Value(hashedPassword),
       role = Value(role);
  static Insertable<UserEntry> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<String>? lastName,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? phoneNumber,
    Expression<String>? hashedPassword,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (externalId != null) 'external_id': externalId,
      if (lastName != null) 'last_name': lastName,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (hashedPassword != null) 'hashed_password': hashedPassword,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  UserEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? externalId,
    Value<String>? lastName,
    Value<String>? firstName,
    Value<String?>? middleName,
    Value<String>? phoneNumber,
    Value<String>? hashedPassword,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? lastSyncAt,
  }) {
    return UserEntriesCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (hashedPassword.present) {
      map['hashed_password'] = Variable<String>(hashedPassword.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserEntriesCompanion(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('lastName: $lastName, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('hashedPassword: $hashedPassword, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $UserTracksTable extends UserTracks
    with TableInfo<$UserTracksTable, UserTrackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTracksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _routeIdMeta = const VerificationMeta(
    'routeId',
  );
  @override
  late final GeneratedColumn<int> routeId = GeneratedColumn<int>(
    'route_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalDistanceMetersMeta =
      const VerificationMeta('totalDistanceMeters');
  @override
  late final GeneratedColumn<double> totalDistanceMeters =
      GeneratedColumn<double>(
        'total_distance_meters',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _movingTimeSecondsMeta = const VerificationMeta(
    'movingTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> movingTimeSeconds = GeneratedColumn<int>(
    'moving_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalTimeSecondsMeta = const VerificationMeta(
    'totalTimeSeconds',
  );
  @override
  late final GeneratedColumn<int> totalTimeSeconds = GeneratedColumn<int>(
    'total_time_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _averageSpeedKmhMeta = const VerificationMeta(
    'averageSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> averageSpeedKmh = GeneratedColumn<double>(
    'average_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _maxSpeedKmhMeta = const VerificationMeta(
    'maxSpeedKmh',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKmh = GeneratedColumn<double>(
    'max_speed_kmh',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    routeId,
    startTime,
    endTime,
    totalDistanceMeters,
    movingTimeSeconds,
    totalTimeSeconds,
    averageSpeedKmh,
    maxSpeedKmh,
    status,
    metadata,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_tracks';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserTrackData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('route_id')) {
      context.handle(
        _routeIdMeta,
        routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('total_distance_meters')) {
      context.handle(
        _totalDistanceMetersMeta,
        totalDistanceMeters.isAcceptableOrUnknown(
          data['total_distance_meters']!,
          _totalDistanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('moving_time_seconds')) {
      context.handle(
        _movingTimeSecondsMeta,
        movingTimeSeconds.isAcceptableOrUnknown(
          data['moving_time_seconds']!,
          _movingTimeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('total_time_seconds')) {
      context.handle(
        _totalTimeSecondsMeta,
        totalTimeSeconds.isAcceptableOrUnknown(
          data['total_time_seconds']!,
          _totalTimeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('average_speed_kmh')) {
      context.handle(
        _averageSpeedKmhMeta,
        averageSpeedKmh.isAcceptableOrUnknown(
          data['average_speed_kmh']!,
          _averageSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('max_speed_kmh')) {
      context.handle(
        _maxSpeedKmhMeta,
        maxSpeedKmh.isAcceptableOrUnknown(
          data['max_speed_kmh']!,
          _maxSpeedKmhMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserTrackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTrackData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      routeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}route_id'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      totalDistanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_distance_meters'],
      )!,
      movingTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}moving_time_seconds'],
      )!,
      totalTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_time_seconds'],
      )!,
      averageSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}average_speed_kmh'],
      )!,
      maxSpeedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kmh'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserTracksTable createAlias(String alias) {
    return $UserTracksTable(attachedDatabase, alias);
  }
}

class UserTrackData extends DataClass implements Insertable<UserTrackData> {
  /// Уникальный ID трека
  final int id;

  /// ID пользователя, которому принадлежит трек
  final int userId;

  /// ID маршрута, в рамках которого записан трек (может быть null)
  final int? routeId;

  /// Дата и время начала трека
  final DateTime startTime;

  /// Дата и время окончания трека (null если трек активен)
  final DateTime? endTime;

  /// Общая дистанция в метрах
  final double totalDistanceMeters;

  /// Время в движении в секундах
  final int movingTimeSeconds;

  /// Общее время трека в секундах
  final int totalTimeSeconds;

  /// Средняя скорость в км/ч
  final double averageSpeedKmh;

  /// Максимальная скорость в км/ч
  final double maxSpeedKmh;

  /// Статус трека: active, paused, completed, cancelled
  final String status;

  /// Дополнительные метаданные в формате JSON
  final String? metadata;

  /// Дата создания записи
  final DateTime createdAt;

  /// Дата последнего обновления
  final DateTime updatedAt;
  const UserTrackData({
    required this.id,
    required this.userId,
    this.routeId,
    required this.startTime,
    this.endTime,
    required this.totalDistanceMeters,
    required this.movingTimeSeconds,
    required this.totalTimeSeconds,
    required this.averageSpeedKmh,
    required this.maxSpeedKmh,
    required this.status,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || routeId != null) {
      map['route_id'] = Variable<int>(routeId);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['total_distance_meters'] = Variable<double>(totalDistanceMeters);
    map['moving_time_seconds'] = Variable<int>(movingTimeSeconds);
    map['total_time_seconds'] = Variable<int>(totalTimeSeconds);
    map['average_speed_kmh'] = Variable<double>(averageSpeedKmh);
    map['max_speed_kmh'] = Variable<double>(maxSpeedKmh);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserTracksCompanion toCompanion(bool nullToAbsent) {
    return UserTracksCompanion(
      id: Value(id),
      userId: Value(userId),
      routeId: routeId == null && nullToAbsent
          ? const Value.absent()
          : Value(routeId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      totalDistanceMeters: Value(totalDistanceMeters),
      movingTimeSeconds: Value(movingTimeSeconds),
      totalTimeSeconds: Value(totalTimeSeconds),
      averageSpeedKmh: Value(averageSpeedKmh),
      maxSpeedKmh: Value(maxSpeedKmh),
      status: Value(status),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserTrackData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTrackData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      routeId: serializer.fromJson<int?>(json['routeId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      totalDistanceMeters: serializer.fromJson<double>(
        json['totalDistanceMeters'],
      ),
      movingTimeSeconds: serializer.fromJson<int>(json['movingTimeSeconds']),
      totalTimeSeconds: serializer.fromJson<int>(json['totalTimeSeconds']),
      averageSpeedKmh: serializer.fromJson<double>(json['averageSpeedKmh']),
      maxSpeedKmh: serializer.fromJson<double>(json['maxSpeedKmh']),
      status: serializer.fromJson<String>(json['status']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'routeId': serializer.toJson<int?>(routeId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'totalDistanceMeters': serializer.toJson<double>(totalDistanceMeters),
      'movingTimeSeconds': serializer.toJson<int>(movingTimeSeconds),
      'totalTimeSeconds': serializer.toJson<int>(totalTimeSeconds),
      'averageSpeedKmh': serializer.toJson<double>(averageSpeedKmh),
      'maxSpeedKmh': serializer.toJson<double>(maxSpeedKmh),
      'status': serializer.toJson<String>(status),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserTrackData copyWith({
    int? id,
    int? userId,
    Value<int?> routeId = const Value.absent(),
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    double? totalDistanceMeters,
    int? movingTimeSeconds,
    int? totalTimeSeconds,
    double? averageSpeedKmh,
    double? maxSpeedKmh,
    String? status,
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserTrackData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    routeId: routeId.present ? routeId.value : this.routeId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
    movingTimeSeconds: movingTimeSeconds ?? this.movingTimeSeconds,
    totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
    averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
    maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
    status: status ?? this.status,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserTrackData copyWithCompanion(UserTracksCompanion data) {
    return UserTrackData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      totalDistanceMeters: data.totalDistanceMeters.present
          ? data.totalDistanceMeters.value
          : this.totalDistanceMeters,
      movingTimeSeconds: data.movingTimeSeconds.present
          ? data.movingTimeSeconds.value
          : this.movingTimeSeconds,
      totalTimeSeconds: data.totalTimeSeconds.present
          ? data.totalTimeSeconds.value
          : this.totalTimeSeconds,
      averageSpeedKmh: data.averageSpeedKmh.present
          ? data.averageSpeedKmh.value
          : this.averageSpeedKmh,
      maxSpeedKmh: data.maxSpeedKmh.present
          ? data.maxSpeedKmh.value
          : this.maxSpeedKmh,
      status: data.status.present ? data.status.value : this.status,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTrackData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('routeId: $routeId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('movingTimeSeconds: $movingTimeSeconds, ')
          ..write('totalTimeSeconds: $totalTimeSeconds, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    routeId,
    startTime,
    endTime,
    totalDistanceMeters,
    movingTimeSeconds,
    totalTimeSeconds,
    averageSpeedKmh,
    maxSpeedKmh,
    status,
    metadata,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTrackData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.routeId == this.routeId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.totalDistanceMeters == this.totalDistanceMeters &&
          other.movingTimeSeconds == this.movingTimeSeconds &&
          other.totalTimeSeconds == this.totalTimeSeconds &&
          other.averageSpeedKmh == this.averageSpeedKmh &&
          other.maxSpeedKmh == this.maxSpeedKmh &&
          other.status == this.status &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserTracksCompanion extends UpdateCompanion<UserTrackData> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int?> routeId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<double> totalDistanceMeters;
  final Value<int> movingTimeSeconds;
  final Value<int> totalTimeSeconds;
  final Value<double> averageSpeedKmh;
  final Value<double> maxSpeedKmh;
  final Value<String> status;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserTracksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.routeId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.movingTimeSeconds = const Value.absent(),
    this.totalTimeSeconds = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    this.status = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserTracksCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.routeId = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.totalDistanceMeters = const Value.absent(),
    this.movingTimeSeconds = const Value.absent(),
    this.totalTimeSeconds = const Value.absent(),
    this.averageSpeedKmh = const Value.absent(),
    this.maxSpeedKmh = const Value.absent(),
    required String status,
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId),
       startTime = Value(startTime),
       status = Value(status);
  static Insertable<UserTrackData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? routeId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<double>? totalDistanceMeters,
    Expression<int>? movingTimeSeconds,
    Expression<int>? totalTimeSeconds,
    Expression<double>? averageSpeedKmh,
    Expression<double>? maxSpeedKmh,
    Expression<String>? status,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (routeId != null) 'route_id': routeId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (totalDistanceMeters != null)
        'total_distance_meters': totalDistanceMeters,
      if (movingTimeSeconds != null) 'moving_time_seconds': movingTimeSeconds,
      if (totalTimeSeconds != null) 'total_time_seconds': totalTimeSeconds,
      if (averageSpeedKmh != null) 'average_speed_kmh': averageSpeedKmh,
      if (maxSpeedKmh != null) 'max_speed_kmh': maxSpeedKmh,
      if (status != null) 'status': status,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserTracksCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int?>? routeId,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<double>? totalDistanceMeters,
    Value<int>? movingTimeSeconds,
    Value<int>? totalTimeSeconds,
    Value<double>? averageSpeedKmh,
    Value<double>? maxSpeedKmh,
    Value<String>? status,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserTracksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      routeId: routeId ?? this.routeId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      movingTimeSeconds: movingTimeSeconds ?? this.movingTimeSeconds,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      averageSpeedKmh: averageSpeedKmh ?? this.averageSpeedKmh,
      maxSpeedKmh: maxSpeedKmh ?? this.maxSpeedKmh,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<int>(routeId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (totalDistanceMeters.present) {
      map['total_distance_meters'] = Variable<double>(
        totalDistanceMeters.value,
      );
    }
    if (movingTimeSeconds.present) {
      map['moving_time_seconds'] = Variable<int>(movingTimeSeconds.value);
    }
    if (totalTimeSeconds.present) {
      map['total_time_seconds'] = Variable<int>(totalTimeSeconds.value);
    }
    if (averageSpeedKmh.present) {
      map['average_speed_kmh'] = Variable<double>(averageSpeedKmh.value);
    }
    if (maxSpeedKmh.present) {
      map['max_speed_kmh'] = Variable<double>(maxSpeedKmh.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTracksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('routeId: $routeId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('totalDistanceMeters: $totalDistanceMeters, ')
          ..write('movingTimeSeconds: $movingTimeSeconds, ')
          ..write('totalTimeSeconds: $totalTimeSeconds, ')
          ..write('averageSpeedKmh: $averageSpeedKmh, ')
          ..write('maxSpeedKmh: $maxSpeedKmh, ')
          ..write('status: $status, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TrackPointsTable extends TrackPoints
    with TableInfo<$TrackPointsTable, TrackPointData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _trackIdMeta = const VerificationMeta(
    'trackId',
  );
  @override
  late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
    'track_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_tracks (id)',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeMeta = const VerificationMeta(
    'altitude',
  );
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
    'altitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _altitudeAccuracyMeta = const VerificationMeta(
    'altitudeAccuracy',
  );
  @override
  late final GeneratedColumn<double> altitudeAccuracy = GeneratedColumn<double>(
    'altitude_accuracy',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _speedKmhMeta = const VerificationMeta(
    'speedKmh',
  );
  @override
  late final GeneratedColumn<double> speedKmh = GeneratedColumn<double>(
    'speed_kmh',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bearingMeta = const VerificationMeta(
    'bearing',
  );
  @override
  late final GeneratedColumn<double> bearing = GeneratedColumn<double>(
    'bearing',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceFromPreviousMeta =
      const VerificationMeta('distanceFromPrevious');
  @override
  late final GeneratedColumn<double> distanceFromPrevious =
      GeneratedColumn<double>(
        'distance_from_previous',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timeFromPreviousMeta = const VerificationMeta(
    'timeFromPrevious',
  );
  @override
  late final GeneratedColumn<int> timeFromPrevious = GeneratedColumn<int>(
    'time_from_previous',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackId,
    latitude,
    longitude,
    timestamp,
    accuracy,
    altitude,
    altitudeAccuracy,
    speedKmh,
    bearing,
    distanceFromPrevious,
    timeFromPrevious,
    metadata,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPointData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('track_id')) {
      context.handle(
        _trackIdMeta,
        trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackIdMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    }
    if (data.containsKey('altitude')) {
      context.handle(
        _altitudeMeta,
        altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta),
      );
    }
    if (data.containsKey('altitude_accuracy')) {
      context.handle(
        _altitudeAccuracyMeta,
        altitudeAccuracy.isAcceptableOrUnknown(
          data['altitude_accuracy']!,
          _altitudeAccuracyMeta,
        ),
      );
    }
    if (data.containsKey('speed_kmh')) {
      context.handle(
        _speedKmhMeta,
        speedKmh.isAcceptableOrUnknown(data['speed_kmh']!, _speedKmhMeta),
      );
    }
    if (data.containsKey('bearing')) {
      context.handle(
        _bearingMeta,
        bearing.isAcceptableOrUnknown(data['bearing']!, _bearingMeta),
      );
    }
    if (data.containsKey('distance_from_previous')) {
      context.handle(
        _distanceFromPreviousMeta,
        distanceFromPrevious.isAcceptableOrUnknown(
          data['distance_from_previous']!,
          _distanceFromPreviousMeta,
        ),
      );
    }
    if (data.containsKey('time_from_previous')) {
      context.handle(
        _timeFromPreviousMeta,
        timeFromPrevious.isAcceptableOrUnknown(
          data['time_from_previous']!,
          _timeFromPreviousMeta,
        ),
      );
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPointData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPointData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      trackId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}track_id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      accuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy'],
      ),
      altitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude'],
      ),
      altitudeAccuracy: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_accuracy'],
      ),
      speedKmh: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kmh'],
      ),
      bearing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bearing'],
      ),
      distanceFromPrevious: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_from_previous'],
      ),
      timeFromPrevious: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_from_previous'],
      ),
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TrackPointsTable createAlias(String alias) {
    return $TrackPointsTable(attachedDatabase, alias);
  }
}

class TrackPointData extends DataClass implements Insertable<TrackPointData> {
  /// Уникальный ID точки
  final int id;

  /// ID трека, к которому относится точка
  final int trackId;

  /// Широта
  final double latitude;

  /// Долгота
  final double longitude;

  /// Временная метка GPS точки
  final DateTime timestamp;

  /// Точность GPS в метрах
  final double? accuracy;

  /// Высота над уровнем моря в метрах
  final double? altitude;

  /// Точность высоты в метрах
  final double? altitudeAccuracy;

  /// Скорость в км/ч
  final double? speedKmh;

  /// Направление движения в градусах (0-360)
  final double? bearing;

  /// Расстояние от предыдущей точки в метрах
  final double? distanceFromPrevious;

  /// Время от предыдущей точки в секундах
  final int? timeFromPrevious;

  /// Дополнительные метаданные в формате JSON
  final String? metadata;

  /// Дата создания записи
  final DateTime createdAt;
  const TrackPointData({
    required this.id,
    required this.trackId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.altitude,
    this.altitudeAccuracy,
    this.speedKmh,
    this.bearing,
    this.distanceFromPrevious,
    this.timeFromPrevious,
    this.metadata,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['track_id'] = Variable<int>(trackId);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || accuracy != null) {
      map['accuracy'] = Variable<double>(accuracy);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || altitudeAccuracy != null) {
      map['altitude_accuracy'] = Variable<double>(altitudeAccuracy);
    }
    if (!nullToAbsent || speedKmh != null) {
      map['speed_kmh'] = Variable<double>(speedKmh);
    }
    if (!nullToAbsent || bearing != null) {
      map['bearing'] = Variable<double>(bearing);
    }
    if (!nullToAbsent || distanceFromPrevious != null) {
      map['distance_from_previous'] = Variable<double>(distanceFromPrevious);
    }
    if (!nullToAbsent || timeFromPrevious != null) {
      map['time_from_previous'] = Variable<int>(timeFromPrevious);
    }
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TrackPointsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointsCompanion(
      id: Value(id),
      trackId: Value(trackId),
      latitude: Value(latitude),
      longitude: Value(longitude),
      timestamp: Value(timestamp),
      accuracy: accuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(accuracy),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      altitudeAccuracy: altitudeAccuracy == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeAccuracy),
      speedKmh: speedKmh == null && nullToAbsent
          ? const Value.absent()
          : Value(speedKmh),
      bearing: bearing == null && nullToAbsent
          ? const Value.absent()
          : Value(bearing),
      distanceFromPrevious: distanceFromPrevious == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceFromPrevious),
      timeFromPrevious: timeFromPrevious == null && nullToAbsent
          ? const Value.absent()
          : Value(timeFromPrevious),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
      createdAt: Value(createdAt),
    );
  }

  factory TrackPointData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPointData(
      id: serializer.fromJson<int>(json['id']),
      trackId: serializer.fromJson<int>(json['trackId']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      accuracy: serializer.fromJson<double?>(json['accuracy']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      altitudeAccuracy: serializer.fromJson<double?>(json['altitudeAccuracy']),
      speedKmh: serializer.fromJson<double?>(json['speedKmh']),
      bearing: serializer.fromJson<double?>(json['bearing']),
      distanceFromPrevious: serializer.fromJson<double?>(
        json['distanceFromPrevious'],
      ),
      timeFromPrevious: serializer.fromJson<int?>(json['timeFromPrevious']),
      metadata: serializer.fromJson<String?>(json['metadata']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'trackId': serializer.toJson<int>(trackId),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'accuracy': serializer.toJson<double?>(accuracy),
      'altitude': serializer.toJson<double?>(altitude),
      'altitudeAccuracy': serializer.toJson<double?>(altitudeAccuracy),
      'speedKmh': serializer.toJson<double?>(speedKmh),
      'bearing': serializer.toJson<double?>(bearing),
      'distanceFromPrevious': serializer.toJson<double?>(distanceFromPrevious),
      'timeFromPrevious': serializer.toJson<int?>(timeFromPrevious),
      'metadata': serializer.toJson<String?>(metadata),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TrackPointData copyWith({
    int? id,
    int? trackId,
    double? latitude,
    double? longitude,
    DateTime? timestamp,
    Value<double?> accuracy = const Value.absent(),
    Value<double?> altitude = const Value.absent(),
    Value<double?> altitudeAccuracy = const Value.absent(),
    Value<double?> speedKmh = const Value.absent(),
    Value<double?> bearing = const Value.absent(),
    Value<double?> distanceFromPrevious = const Value.absent(),
    Value<int?> timeFromPrevious = const Value.absent(),
    Value<String?> metadata = const Value.absent(),
    DateTime? createdAt,
  }) => TrackPointData(
    id: id ?? this.id,
    trackId: trackId ?? this.trackId,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    timestamp: timestamp ?? this.timestamp,
    accuracy: accuracy.present ? accuracy.value : this.accuracy,
    altitude: altitude.present ? altitude.value : this.altitude,
    altitudeAccuracy: altitudeAccuracy.present
        ? altitudeAccuracy.value
        : this.altitudeAccuracy,
    speedKmh: speedKmh.present ? speedKmh.value : this.speedKmh,
    bearing: bearing.present ? bearing.value : this.bearing,
    distanceFromPrevious: distanceFromPrevious.present
        ? distanceFromPrevious.value
        : this.distanceFromPrevious,
    timeFromPrevious: timeFromPrevious.present
        ? timeFromPrevious.value
        : this.timeFromPrevious,
    metadata: metadata.present ? metadata.value : this.metadata,
    createdAt: createdAt ?? this.createdAt,
  );
  TrackPointData copyWithCompanion(TrackPointsCompanion data) {
    return TrackPointData(
      id: data.id.present ? data.id.value : this.id,
      trackId: data.trackId.present ? data.trackId.value : this.trackId,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      altitude: data.altitude.present ? data.altitude.value : this.altitude,
      altitudeAccuracy: data.altitudeAccuracy.present
          ? data.altitudeAccuracy.value
          : this.altitudeAccuracy,
      speedKmh: data.speedKmh.present ? data.speedKmh.value : this.speedKmh,
      bearing: data.bearing.present ? data.bearing.value : this.bearing,
      distanceFromPrevious: data.distanceFromPrevious.present
          ? data.distanceFromPrevious.value
          : this.distanceFromPrevious,
      timeFromPrevious: data.timeFromPrevious.present
          ? data.timeFromPrevious.value
          : this.timeFromPrevious,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointData(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('altitudeAccuracy: $altitudeAccuracy, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('bearing: $bearing, ')
          ..write('distanceFromPrevious: $distanceFromPrevious, ')
          ..write('timeFromPrevious: $timeFromPrevious, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    trackId,
    latitude,
    longitude,
    timestamp,
    accuracy,
    altitude,
    altitudeAccuracy,
    speedKmh,
    bearing,
    distanceFromPrevious,
    timeFromPrevious,
    metadata,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPointData &&
          other.id == this.id &&
          other.trackId == this.trackId &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.timestamp == this.timestamp &&
          other.accuracy == this.accuracy &&
          other.altitude == this.altitude &&
          other.altitudeAccuracy == this.altitudeAccuracy &&
          other.speedKmh == this.speedKmh &&
          other.bearing == this.bearing &&
          other.distanceFromPrevious == this.distanceFromPrevious &&
          other.timeFromPrevious == this.timeFromPrevious &&
          other.metadata == this.metadata &&
          other.createdAt == this.createdAt);
}

class TrackPointsCompanion extends UpdateCompanion<TrackPointData> {
  final Value<int> id;
  final Value<int> trackId;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime> timestamp;
  final Value<double?> accuracy;
  final Value<double?> altitude;
  final Value<double?> altitudeAccuracy;
  final Value<double?> speedKmh;
  final Value<double?> bearing;
  final Value<double?> distanceFromPrevious;
  final Value<int?> timeFromPrevious;
  final Value<String?> metadata;
  final Value<DateTime> createdAt;
  const TrackPointsCompanion({
    this.id = const Value.absent(),
    this.trackId = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.altitudeAccuracy = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.bearing = const Value.absent(),
    this.distanceFromPrevious = const Value.absent(),
    this.timeFromPrevious = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TrackPointsCompanion.insert({
    this.id = const Value.absent(),
    required int trackId,
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    this.accuracy = const Value.absent(),
    this.altitude = const Value.absent(),
    this.altitudeAccuracy = const Value.absent(),
    this.speedKmh = const Value.absent(),
    this.bearing = const Value.absent(),
    this.distanceFromPrevious = const Value.absent(),
    this.timeFromPrevious = const Value.absent(),
    this.metadata = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : trackId = Value(trackId),
       latitude = Value(latitude),
       longitude = Value(longitude),
       timestamp = Value(timestamp);
  static Insertable<TrackPointData> custom({
    Expression<int>? id,
    Expression<int>? trackId,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? timestamp,
    Expression<double>? accuracy,
    Expression<double>? altitude,
    Expression<double>? altitudeAccuracy,
    Expression<double>? speedKmh,
    Expression<double>? bearing,
    Expression<double>? distanceFromPrevious,
    Expression<int>? timeFromPrevious,
    Expression<String>? metadata,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackId != null) 'track_id': trackId,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (timestamp != null) 'timestamp': timestamp,
      if (accuracy != null) 'accuracy': accuracy,
      if (altitude != null) 'altitude': altitude,
      if (altitudeAccuracy != null) 'altitude_accuracy': altitudeAccuracy,
      if (speedKmh != null) 'speed_kmh': speedKmh,
      if (bearing != null) 'bearing': bearing,
      if (distanceFromPrevious != null)
        'distance_from_previous': distanceFromPrevious,
      if (timeFromPrevious != null) 'time_from_previous': timeFromPrevious,
      if (metadata != null) 'metadata': metadata,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TrackPointsCompanion copyWith({
    Value<int>? id,
    Value<int>? trackId,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime>? timestamp,
    Value<double?>? accuracy,
    Value<double?>? altitude,
    Value<double?>? altitudeAccuracy,
    Value<double?>? speedKmh,
    Value<double?>? bearing,
    Value<double?>? distanceFromPrevious,
    Value<int?>? timeFromPrevious,
    Value<String?>? metadata,
    Value<DateTime>? createdAt,
  }) {
    return TrackPointsCompanion(
      id: id ?? this.id,
      trackId: trackId ?? this.trackId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      altitudeAccuracy: altitudeAccuracy ?? this.altitudeAccuracy,
      speedKmh: speedKmh ?? this.speedKmh,
      bearing: bearing ?? this.bearing,
      distanceFromPrevious: distanceFromPrevious ?? this.distanceFromPrevious,
      timeFromPrevious: timeFromPrevious ?? this.timeFromPrevious,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (trackId.present) {
      map['track_id'] = Variable<int>(trackId.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (altitudeAccuracy.present) {
      map['altitude_accuracy'] = Variable<double>(altitudeAccuracy.value);
    }
    if (speedKmh.present) {
      map['speed_kmh'] = Variable<double>(speedKmh.value);
    }
    if (bearing.present) {
      map['bearing'] = Variable<double>(bearing.value);
    }
    if (distanceFromPrevious.present) {
      map['distance_from_previous'] = Variable<double>(
        distanceFromPrevious.value,
      );
    }
    if (timeFromPrevious.present) {
      map['time_from_previous'] = Variable<int>(timeFromPrevious.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointsCompanion(')
          ..write('id: $id, ')
          ..write('trackId: $trackId, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('timestamp: $timestamp, ')
          ..write('accuracy: $accuracy, ')
          ..write('altitude: $altitude, ')
          ..write('altitudeAccuracy: $altitudeAccuracy, ')
          ..write('speedKmh: $speedKmh, ')
          ..write('bearing: $bearing, ')
          ..write('distanceFromPrevious: $distanceFromPrevious, ')
          ..write('timeFromPrevious: $timeFromPrevious, ')
          ..write('metadata: $metadata, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RoutesTableTable extends RoutesTable
    with TableInfo<$RoutesTableTable, RoutesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathJsonMeta = const VerificationMeta(
    'pathJson',
  );
  @override
  late final GeneratedColumn<String> pathJson = GeneratedColumn<String>(
    'path_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    startTime,
    endTime,
    status,
    pathJson,
    userId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('path_json')) {
      context.handle(
        _pathJsonMeta,
        pathJson.isAcceptableOrUnknown(data['path_json']!, _pathJsonMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      pathJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path_json'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $RoutesTableTable createAlias(String alias) {
    return $RoutesTableTable(attachedDatabase, alias);
  }
}

class RoutesTableData extends DataClass implements Insertable<RoutesTableData> {
  final int id;
  final String name;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status;
  final String? pathJson;
  final int userId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const RoutesTableData({
    required this.id,
    required this.name,
    this.description,
    this.startTime,
    this.endTime,
    required this.status,
    this.pathJson,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<DateTime>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || pathJson != null) {
      map['path_json'] = Variable<String>(pathJson);
    }
    map['user_id'] = Variable<int>(userId);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  RoutesTableCompanion toCompanion(bool nullToAbsent) {
    return RoutesTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      status: Value(status),
      pathJson: pathJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pathJson),
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory RoutesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutesTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      startTime: serializer.fromJson<DateTime?>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      status: serializer.fromJson<String>(json['status']),
      pathJson: serializer.fromJson<String?>(json['pathJson']),
      userId: serializer.fromJson<int>(json['userId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'startTime': serializer.toJson<DateTime?>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'status': serializer.toJson<String>(status),
      'pathJson': serializer.toJson<String?>(pathJson),
      'userId': serializer.toJson<int>(userId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  RoutesTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<DateTime?> startTime = const Value.absent(),
    Value<DateTime?> endTime = const Value.absent(),
    String? status,
    Value<String?> pathJson = const Value.absent(),
    int? userId,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => RoutesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    status: status ?? this.status,
    pathJson: pathJson.present ? pathJson.value : this.pathJson,
    userId: userId ?? this.userId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  RoutesTableData copyWithCompanion(RoutesTableCompanion data) {
    return RoutesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      status: data.status.present ? data.status.value : this.status,
      pathJson: data.pathJson.present ? data.pathJson.value : this.pathJson,
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('pathJson: $pathJson, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    startTime,
    endTime,
    status,
    pathJson,
    userId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.status == this.status &&
          other.pathJson == this.pathJson &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RoutesTableCompanion extends UpdateCompanion<RoutesTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime?> startTime;
  final Value<DateTime?> endTime;
  final Value<String> status;
  final Value<String?> pathJson;
  final Value<int> userId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const RoutesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.status = const Value.absent(),
    this.pathJson = const Value.absent(),
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RoutesTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    required String status,
    this.pathJson = const Value.absent(),
    required int userId,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       status = Value(status),
       userId = Value(userId);
  static Insertable<RoutesTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? status,
    Expression<String>? pathJson,
    Expression<int>? userId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (status != null) 'status': status,
      if (pathJson != null) 'path_json': pathJson,
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RoutesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime?>? startTime,
    Value<DateTime?>? endTime,
    Value<String>? status,
    Value<String?>? pathJson,
    Value<int>? userId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return RoutesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      pathJson: pathJson ?? this.pathJson,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (pathJson.present) {
      map['path_json'] = Variable<String>(pathJson.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('status: $status, ')
          ..write('pathJson: $pathJson, ')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $TradingPointsTableTable extends TradingPointsTable
    with TableInfo<$TradingPointsTableTable, TradingPointsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradingPointsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _externalIdMeta = const VerificationMeta(
    'externalId',
  );
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
    'external_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _innMeta = const VerificationMeta('inn');
  @override
  late final GeneratedColumn<String> inn = GeneratedColumn<String>(
    'inn',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    externalId,
    name,
    inn,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trading_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<TradingPointsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
        _externalIdMeta,
        externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('inn')) {
      context.handle(
        _innMeta,
        inn.isAcceptableOrUnknown(data['inn']!, _innMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradingPointsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradingPointsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      externalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      inn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inn'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $TradingPointsTableTable createAlias(String alias) {
    return $TradingPointsTableTable(attachedDatabase, alias);
  }
}

class TradingPointsTableData extends DataClass
    implements Insertable<TradingPointsTableData> {
  final int id;
  final String externalId;
  final String name;
  final String? inn;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const TradingPointsTableData({
    required this.id,
    required this.externalId,
    required this.name,
    this.inn,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['external_id'] = Variable<String>(externalId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || inn != null) {
      map['inn'] = Variable<String>(inn);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TradingPointsTableCompanion toCompanion(bool nullToAbsent) {
    return TradingPointsTableCompanion(
      id: Value(id),
      externalId: Value(externalId),
      name: Value(name),
      inn: inn == null && nullToAbsent ? const Value.absent() : Value(inn),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TradingPointsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TradingPointsTableData(
      id: serializer.fromJson<int>(json['id']),
      externalId: serializer.fromJson<String>(json['externalId']),
      name: serializer.fromJson<String>(json['name']),
      inn: serializer.fromJson<String?>(json['inn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'externalId': serializer.toJson<String>(externalId),
      'name': serializer.toJson<String>(name),
      'inn': serializer.toJson<String?>(inn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TradingPointsTableData copyWith({
    int? id,
    String? externalId,
    String? name,
    Value<String?> inn = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => TradingPointsTableData(
    id: id ?? this.id,
    externalId: externalId ?? this.externalId,
    name: name ?? this.name,
    inn: inn.present ? inn.value : this.inn,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TradingPointsTableData copyWithCompanion(TradingPointsTableCompanion data) {
    return TradingPointsTableData(
      id: data.id.present ? data.id.value : this.id,
      externalId: data.externalId.present
          ? data.externalId.value
          : this.externalId,
      name: data.name.present ? data.name.value : this.name,
      inn: data.inn.present ? data.inn.value : this.inn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TradingPointsTableData(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, externalId, name, inn, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradingPointsTableData &&
          other.id == this.id &&
          other.externalId == this.externalId &&
          other.name == this.name &&
          other.inn == this.inn &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TradingPointsTableCompanion
    extends UpdateCompanion<TradingPointsTableData> {
  final Value<int> id;
  final Value<String> externalId;
  final Value<String> name;
  final Value<String?> inn;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const TradingPointsTableCompanion({
    this.id = const Value.absent(),
    this.externalId = const Value.absent(),
    this.name = const Value.absent(),
    this.inn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  TradingPointsTableCompanion.insert({
    this.id = const Value.absent(),
    required String externalId,
    required String name,
    this.inn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : externalId = Value(externalId),
       name = Value(name);
  static Insertable<TradingPointsTableData> custom({
    Expression<int>? id,
    Expression<String>? externalId,
    Expression<String>? name,
    Expression<String>? inn,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (externalId != null) 'external_id': externalId,
      if (name != null) 'name': name,
      if (inn != null) 'inn': inn,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  TradingPointsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? externalId,
    Value<String>? name,
    Value<String?>? inn,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return TradingPointsTableCompanion(
      id: id ?? this.id,
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      inn: inn ?? this.inn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (externalId.present) {
      map['external_id'] = Variable<String>(externalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (inn.present) {
      map['inn'] = Variable<String>(inn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradingPointsTableCompanion(')
          ..write('id: $id, ')
          ..write('externalId: $externalId, ')
          ..write('name: $name, ')
          ..write('inn: $inn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PointsOfInterestTableTable extends PointsOfInterestTable
    with TableInfo<$PointsOfInterestTableTable, PointsOfInterestTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointsOfInterestTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _routeIdMeta = const VerificationMeta(
    'routeId',
  );
  @override
  late final GeneratedColumn<int> routeId = GeneratedColumn<int>(
    'route_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedArrivalTimeMeta =
      const VerificationMeta('plannedArrivalTime');
  @override
  late final GeneratedColumn<DateTime> plannedArrivalTime =
      GeneratedColumn<DateTime>(
        'planned_arrival_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _plannedDepartureTimeMeta =
      const VerificationMeta('plannedDepartureTime');
  @override
  late final GeneratedColumn<DateTime> plannedDepartureTime =
      GeneratedColumn<DateTime>(
        'planned_departure_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualArrivalTimeMeta = const VerificationMeta(
    'actualArrivalTime',
  );
  @override
  late final GeneratedColumn<DateTime> actualArrivalTime =
      GeneratedColumn<DateTime>(
        'actual_arrival_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualDepartureTimeMeta =
      const VerificationMeta('actualDepartureTime');
  @override
  late final GeneratedColumn<DateTime> actualDepartureTime =
      GeneratedColumn<DateTime>(
        'actual_departure_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tradingPointIdMeta = const VerificationMeta(
    'tradingPointId',
  );
  @override
  late final GeneratedColumn<int> tradingPointId = GeneratedColumn<int>(
    'trading_point_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routeId,
    name,
    description,
    latitude,
    longitude,
    plannedArrivalTime,
    plannedDepartureTime,
    actualArrivalTime,
    actualDepartureTime,
    type,
    status,
    notes,
    tradingPointId,
    orderIndex,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'points_of_interest';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointsOfInterestTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_id')) {
      context.handle(
        _routeIdMeta,
        routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('planned_arrival_time')) {
      context.handle(
        _plannedArrivalTimeMeta,
        plannedArrivalTime.isAcceptableOrUnknown(
          data['planned_arrival_time']!,
          _plannedArrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('planned_departure_time')) {
      context.handle(
        _plannedDepartureTimeMeta,
        plannedDepartureTime.isAcceptableOrUnknown(
          data['planned_departure_time']!,
          _plannedDepartureTimeMeta,
        ),
      );
    }
    if (data.containsKey('actual_arrival_time')) {
      context.handle(
        _actualArrivalTimeMeta,
        actualArrivalTime.isAcceptableOrUnknown(
          data['actual_arrival_time']!,
          _actualArrivalTimeMeta,
        ),
      );
    }
    if (data.containsKey('actual_departure_time')) {
      context.handle(
        _actualDepartureTimeMeta,
        actualDepartureTime.isAcceptableOrUnknown(
          data['actual_departure_time']!,
          _actualDepartureTimeMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('trading_point_id')) {
      context.handle(
        _tradingPointIdMeta,
        tradingPointId.isAcceptableOrUnknown(
          data['trading_point_id']!,
          _tradingPointIdMeta,
        ),
      );
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointsOfInterestTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointsOfInterestTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      routeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}route_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      plannedArrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_arrival_time'],
      ),
      plannedDepartureTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}planned_departure_time'],
      ),
      actualArrivalTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_arrival_time'],
      ),
      actualDepartureTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_departure_time'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      tradingPointId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trading_point_id'],
      ),
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $PointsOfInterestTableTable createAlias(String alias) {
    return $PointsOfInterestTableTable(attachedDatabase, alias);
  }
}

class PointsOfInterestTableData extends DataClass
    implements Insertable<PointsOfInterestTableData> {
  final int id;
  final int routeId;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final DateTime? plannedArrivalTime;
  final DateTime? plannedDepartureTime;
  final DateTime? actualArrivalTime;
  final DateTime? actualDepartureTime;
  final String type;
  final String status;
  final String? notes;
  final int? tradingPointId;
  final int orderIndex;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PointsOfInterestTableData({
    required this.id,
    required this.routeId,
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    this.plannedArrivalTime,
    this.plannedDepartureTime,
    this.actualArrivalTime,
    this.actualDepartureTime,
    required this.type,
    required this.status,
    this.notes,
    this.tradingPointId,
    required this.orderIndex,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['route_id'] = Variable<int>(routeId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || plannedArrivalTime != null) {
      map['planned_arrival_time'] = Variable<DateTime>(plannedArrivalTime);
    }
    if (!nullToAbsent || plannedDepartureTime != null) {
      map['planned_departure_time'] = Variable<DateTime>(plannedDepartureTime);
    }
    if (!nullToAbsent || actualArrivalTime != null) {
      map['actual_arrival_time'] = Variable<DateTime>(actualArrivalTime);
    }
    if (!nullToAbsent || actualDepartureTime != null) {
      map['actual_departure_time'] = Variable<DateTime>(actualDepartureTime);
    }
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || tradingPointId != null) {
      map['trading_point_id'] = Variable<int>(tradingPointId);
    }
    map['order_index'] = Variable<int>(orderIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PointsOfInterestTableCompanion toCompanion(bool nullToAbsent) {
    return PointsOfInterestTableCompanion(
      id: Value(id),
      routeId: Value(routeId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      latitude: Value(latitude),
      longitude: Value(longitude),
      plannedArrivalTime: plannedArrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedArrivalTime),
      plannedDepartureTime: plannedDepartureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedDepartureTime),
      actualArrivalTime: actualArrivalTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualArrivalTime),
      actualDepartureTime: actualDepartureTime == null && nullToAbsent
          ? const Value.absent()
          : Value(actualDepartureTime),
      type: Value(type),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      tradingPointId: tradingPointId == null && nullToAbsent
          ? const Value.absent()
          : Value(tradingPointId),
      orderIndex: Value(orderIndex),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PointsOfInterestTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointsOfInterestTableData(
      id: serializer.fromJson<int>(json['id']),
      routeId: serializer.fromJson<int>(json['routeId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      plannedArrivalTime: serializer.fromJson<DateTime?>(
        json['plannedArrivalTime'],
      ),
      plannedDepartureTime: serializer.fromJson<DateTime?>(
        json['plannedDepartureTime'],
      ),
      actualArrivalTime: serializer.fromJson<DateTime?>(
        json['actualArrivalTime'],
      ),
      actualDepartureTime: serializer.fromJson<DateTime?>(
        json['actualDepartureTime'],
      ),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      tradingPointId: serializer.fromJson<int?>(json['tradingPointId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'routeId': serializer.toJson<int>(routeId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'plannedArrivalTime': serializer.toJson<DateTime?>(plannedArrivalTime),
      'plannedDepartureTime': serializer.toJson<DateTime?>(
        plannedDepartureTime,
      ),
      'actualArrivalTime': serializer.toJson<DateTime?>(actualArrivalTime),
      'actualDepartureTime': serializer.toJson<DateTime?>(actualDepartureTime),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'tradingPointId': serializer.toJson<int?>(tradingPointId),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PointsOfInterestTableData copyWith({
    int? id,
    int? routeId,
    String? name,
    Value<String?> description = const Value.absent(),
    double? latitude,
    double? longitude,
    Value<DateTime?> plannedArrivalTime = const Value.absent(),
    Value<DateTime?> plannedDepartureTime = const Value.absent(),
    Value<DateTime?> actualArrivalTime = const Value.absent(),
    Value<DateTime?> actualDepartureTime = const Value.absent(),
    String? type,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<int?> tradingPointId = const Value.absent(),
    int? orderIndex,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => PointsOfInterestTableData(
    id: id ?? this.id,
    routeId: routeId ?? this.routeId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    plannedArrivalTime: plannedArrivalTime.present
        ? plannedArrivalTime.value
        : this.plannedArrivalTime,
    plannedDepartureTime: plannedDepartureTime.present
        ? plannedDepartureTime.value
        : this.plannedDepartureTime,
    actualArrivalTime: actualArrivalTime.present
        ? actualArrivalTime.value
        : this.actualArrivalTime,
    actualDepartureTime: actualDepartureTime.present
        ? actualDepartureTime.value
        : this.actualDepartureTime,
    type: type ?? this.type,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    tradingPointId: tradingPointId.present
        ? tradingPointId.value
        : this.tradingPointId,
    orderIndex: orderIndex ?? this.orderIndex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  PointsOfInterestTableData copyWithCompanion(
    PointsOfInterestTableCompanion data,
  ) {
    return PointsOfInterestTableData(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      plannedArrivalTime: data.plannedArrivalTime.present
          ? data.plannedArrivalTime.value
          : this.plannedArrivalTime,
      plannedDepartureTime: data.plannedDepartureTime.present
          ? data.plannedDepartureTime.value
          : this.plannedDepartureTime,
      actualArrivalTime: data.actualArrivalTime.present
          ? data.actualArrivalTime.value
          : this.actualArrivalTime,
      actualDepartureTime: data.actualDepartureTime.present
          ? data.actualDepartureTime.value
          : this.actualDepartureTime,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      tradingPointId: data.tradingPointId.present
          ? data.tradingPointId.value
          : this.tradingPointId,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointsOfInterestTableData(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('plannedArrivalTime: $plannedArrivalTime, ')
          ..write('plannedDepartureTime: $plannedDepartureTime, ')
          ..write('actualArrivalTime: $actualArrivalTime, ')
          ..write('actualDepartureTime: $actualDepartureTime, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('tradingPointId: $tradingPointId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    routeId,
    name,
    description,
    latitude,
    longitude,
    plannedArrivalTime,
    plannedDepartureTime,
    actualArrivalTime,
    actualDepartureTime,
    type,
    status,
    notes,
    tradingPointId,
    orderIndex,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointsOfInterestTableData &&
          other.id == this.id &&
          other.routeId == this.routeId &&
          other.name == this.name &&
          other.description == this.description &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.plannedArrivalTime == this.plannedArrivalTime &&
          other.plannedDepartureTime == this.plannedDepartureTime &&
          other.actualArrivalTime == this.actualArrivalTime &&
          other.actualDepartureTime == this.actualDepartureTime &&
          other.type == this.type &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.tradingPointId == this.tradingPointId &&
          other.orderIndex == this.orderIndex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PointsOfInterestTableCompanion
    extends UpdateCompanion<PointsOfInterestTableData> {
  final Value<int> id;
  final Value<int> routeId;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<DateTime?> plannedArrivalTime;
  final Value<DateTime?> plannedDepartureTime;
  final Value<DateTime?> actualArrivalTime;
  final Value<DateTime?> actualDepartureTime;
  final Value<String> type;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int?> tradingPointId;
  final Value<int> orderIndex;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PointsOfInterestTableCompanion({
    this.id = const Value.absent(),
    this.routeId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.plannedArrivalTime = const Value.absent(),
    this.plannedDepartureTime = const Value.absent(),
    this.actualArrivalTime = const Value.absent(),
    this.actualDepartureTime = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.tradingPointId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PointsOfInterestTableCompanion.insert({
    this.id = const Value.absent(),
    required int routeId,
    required String name,
    this.description = const Value.absent(),
    required double latitude,
    required double longitude,
    this.plannedArrivalTime = const Value.absent(),
    this.plannedDepartureTime = const Value.absent(),
    this.actualArrivalTime = const Value.absent(),
    this.actualDepartureTime = const Value.absent(),
    required String type,
    required String status,
    this.notes = const Value.absent(),
    this.tradingPointId = const Value.absent(),
    required int orderIndex,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : routeId = Value(routeId),
       name = Value(name),
       latitude = Value(latitude),
       longitude = Value(longitude),
       type = Value(type),
       status = Value(status),
       orderIndex = Value(orderIndex);
  static Insertable<PointsOfInterestTableData> custom({
    Expression<int>? id,
    Expression<int>? routeId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<DateTime>? plannedArrivalTime,
    Expression<DateTime>? plannedDepartureTime,
    Expression<DateTime>? actualArrivalTime,
    Expression<DateTime>? actualDepartureTime,
    Expression<String>? type,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? tradingPointId,
    Expression<int>? orderIndex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routeId != null) 'route_id': routeId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (plannedArrivalTime != null)
        'planned_arrival_time': plannedArrivalTime,
      if (plannedDepartureTime != null)
        'planned_departure_time': plannedDepartureTime,
      if (actualArrivalTime != null) 'actual_arrival_time': actualArrivalTime,
      if (actualDepartureTime != null)
        'actual_departure_time': actualDepartureTime,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (tradingPointId != null) 'trading_point_id': tradingPointId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PointsOfInterestTableCompanion copyWith({
    Value<int>? id,
    Value<int>? routeId,
    Value<String>? name,
    Value<String?>? description,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<DateTime?>? plannedArrivalTime,
    Value<DateTime?>? plannedDepartureTime,
    Value<DateTime?>? actualArrivalTime,
    Value<DateTime?>? actualDepartureTime,
    Value<String>? type,
    Value<String>? status,
    Value<String?>? notes,
    Value<int?>? tradingPointId,
    Value<int>? orderIndex,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PointsOfInterestTableCompanion(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      plannedArrivalTime: plannedArrivalTime ?? this.plannedArrivalTime,
      plannedDepartureTime: plannedDepartureTime ?? this.plannedDepartureTime,
      actualArrivalTime: actualArrivalTime ?? this.actualArrivalTime,
      actualDepartureTime: actualDepartureTime ?? this.actualDepartureTime,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      tradingPointId: tradingPointId ?? this.tradingPointId,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (routeId.present) {
      map['route_id'] = Variable<int>(routeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (plannedArrivalTime.present) {
      map['planned_arrival_time'] = Variable<DateTime>(
        plannedArrivalTime.value,
      );
    }
    if (plannedDepartureTime.present) {
      map['planned_departure_time'] = Variable<DateTime>(
        plannedDepartureTime.value,
      );
    }
    if (actualArrivalTime.present) {
      map['actual_arrival_time'] = Variable<DateTime>(actualArrivalTime.value);
    }
    if (actualDepartureTime.present) {
      map['actual_departure_time'] = Variable<DateTime>(
        actualDepartureTime.value,
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (tradingPointId.present) {
      map['trading_point_id'] = Variable<int>(tradingPointId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointsOfInterestTableCompanion(')
          ..write('id: $id, ')
          ..write('routeId: $routeId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('plannedArrivalTime: $plannedArrivalTime, ')
          ..write('plannedDepartureTime: $plannedDepartureTime, ')
          ..write('actualArrivalTime: $actualArrivalTime, ')
          ..write('actualDepartureTime: $actualDepartureTime, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('tradingPointId: $tradingPointId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PointStatusHistoryTableTable extends PointStatusHistoryTable
    with TableInfo<$PointStatusHistoryTableTable, PointStatusHistoryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PointStatusHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _pointIdMeta = const VerificationMeta(
    'pointId',
  );
  @override
  late final GeneratedColumn<int> pointId = GeneratedColumn<int>(
    'point_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromStatusMeta = const VerificationMeta(
    'fromStatus',
  );
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
    'from_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toStatusMeta = const VerificationMeta(
    'toStatus',
  );
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changedByMeta = const VerificationMeta(
    'changedBy',
  );
  @override
  late final GeneratedColumn<String> changedBy = GeneratedColumn<String>(
    'changed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    pointId,
    fromStatus,
    toStatus,
    changedBy,
    reason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'point_status_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<PointStatusHistoryTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('point_id')) {
      context.handle(
        _pointIdMeta,
        pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta),
      );
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
        _fromStatusMeta,
        fromStatus.isAcceptableOrUnknown(data['from_status']!, _fromStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(
        _toStatusMeta,
        toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('changed_by')) {
      context.handle(
        _changedByMeta,
        changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta),
      );
    } else if (isInserting) {
      context.missing(_changedByMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointStatusHistoryTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointStatusHistoryTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      pointId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}point_id'],
      )!,
      fromStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_status'],
      )!,
      toStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_status'],
      )!,
      changedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}changed_by'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $PointStatusHistoryTableTable createAlias(String alias) {
    return $PointStatusHistoryTableTable(attachedDatabase, alias);
  }
}

class PointStatusHistoryTableData extends DataClass
    implements Insertable<PointStatusHistoryTableData> {
  final int id;
  final int pointId;
  final String fromStatus;
  final String toStatus;
  final String changedBy;
  final String? reason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PointStatusHistoryTableData({
    required this.id,
    required this.pointId,
    required this.fromStatus,
    required this.toStatus,
    required this.changedBy,
    this.reason,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['point_id'] = Variable<int>(pointId);
    map['from_status'] = Variable<String>(fromStatus);
    map['to_status'] = Variable<String>(toStatus);
    map['changed_by'] = Variable<String>(changedBy);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PointStatusHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return PointStatusHistoryTableCompanion(
      id: Value(id),
      pointId: Value(pointId),
      fromStatus: Value(fromStatus),
      toStatus: Value(toStatus),
      changedBy: Value(changedBy),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PointStatusHistoryTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointStatusHistoryTableData(
      id: serializer.fromJson<int>(json['id']),
      pointId: serializer.fromJson<int>(json['pointId']),
      fromStatus: serializer.fromJson<String>(json['fromStatus']),
      toStatus: serializer.fromJson<String>(json['toStatus']),
      changedBy: serializer.fromJson<String>(json['changedBy']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pointId': serializer.toJson<int>(pointId),
      'fromStatus': serializer.toJson<String>(fromStatus),
      'toStatus': serializer.toJson<String>(toStatus),
      'changedBy': serializer.toJson<String>(changedBy),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PointStatusHistoryTableData copyWith({
    int? id,
    int? pointId,
    String? fromStatus,
    String? toStatus,
    String? changedBy,
    Value<String?> reason = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => PointStatusHistoryTableData(
    id: id ?? this.id,
    pointId: pointId ?? this.pointId,
    fromStatus: fromStatus ?? this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    changedBy: changedBy ?? this.changedBy,
    reason: reason.present ? reason.value : this.reason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  PointStatusHistoryTableData copyWithCompanion(
    PointStatusHistoryTableCompanion data,
  ) {
    return PointStatusHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      changedBy: data.changedBy.present ? data.changedBy.value : this.changedBy,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PointStatusHistoryTableData(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedBy: $changedBy, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    pointId,
    fromStatus,
    toStatus,
    changedBy,
    reason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PointStatusHistoryTableData &&
          other.id == this.id &&
          other.pointId == this.pointId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.changedBy == this.changedBy &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PointStatusHistoryTableCompanion
    extends UpdateCompanion<PointStatusHistoryTableData> {
  final Value<int> id;
  final Value<int> pointId;
  final Value<String> fromStatus;
  final Value<String> toStatus;
  final Value<String> changedBy;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const PointStatusHistoryTableCompanion({
    this.id = const Value.absent(),
    this.pointId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.changedBy = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PointStatusHistoryTableCompanion.insert({
    this.id = const Value.absent(),
    required int pointId,
    required String fromStatus,
    required String toStatus,
    required String changedBy,
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : pointId = Value(pointId),
       fromStatus = Value(fromStatus),
       toStatus = Value(toStatus),
       changedBy = Value(changedBy);
  static Insertable<PointStatusHistoryTableData> custom({
    Expression<int>? id,
    Expression<int>? pointId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<String>? changedBy,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pointId != null) 'point_id': pointId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (changedBy != null) 'changed_by': changedBy,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PointStatusHistoryTableCompanion copyWith({
    Value<int>? id,
    Value<int>? pointId,
    Value<String>? fromStatus,
    Value<String>? toStatus,
    Value<String>? changedBy,
    Value<String?>? reason,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return PointStatusHistoryTableCompanion(
      id: id ?? this.id,
      pointId: pointId ?? this.pointId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedBy: changedBy ?? this.changedBy,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pointId.present) {
      map['point_id'] = Variable<int>(pointId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(fromStatus.value);
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(toStatus.value);
    }
    if (changedBy.present) {
      map['changed_by'] = Variable<String>(changedBy.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PointStatusHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('pointId: $pointId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedBy: $changedBy, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserEntriesTable userEntries = $UserEntriesTable(this);
  late final $UserTracksTable userTracks = $UserTracksTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  late final $RoutesTableTable routesTable = $RoutesTableTable(this);
  late final $TradingPointsTableTable tradingPointsTable =
      $TradingPointsTableTable(this);
  late final $PointsOfInterestTableTable pointsOfInterestTable =
      $PointsOfInterestTableTable(this);
  late final $PointStatusHistoryTableTable pointStatusHistoryTable =
      $PointStatusHistoryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userEntries,
    userTracks,
    trackPoints,
    routesTable,
    tradingPointsTable,
    pointsOfInterestTable,
    pointStatusHistoryTable,
  ];
}

typedef $$UserEntriesTableCreateCompanionBuilder =
    UserEntriesCompanion Function({
      Value<int> id,
      required String externalId,
      required String lastName,
      required String firstName,
      Value<String?> middleName,
      required String phoneNumber,
      required String hashedPassword,
      required String role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncAt,
    });
typedef $$UserEntriesTableUpdateCompanionBuilder =
    UserEntriesCompanion Function({
      Value<int> id,
      Value<String> externalId,
      Value<String> lastName,
      Value<String> firstName,
      Value<String?> middleName,
      Value<String> phoneNumber,
      Value<String> hashedPassword,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> lastSyncAt,
    });

final class $$UserEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $UserEntriesTable, UserEntry> {
  $$UserEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserTracksTable, List<UserTrackData>>
  _userTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userTracks,
    aliasName: $_aliasNameGenerator(db.userEntries.id, db.userTracks.userId),
  );

  $$UserTracksTableProcessedTableManager get userTracksRefs {
    final manager = $$UserTracksTableTableManager(
      $_db,
      $_db.userTracks,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userTracksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UserEntriesTable> {
  $$UserEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userTracksRefs(
    Expression<bool> Function($$UserTracksTableFilterComposer f) f,
  ) {
    final $$UserTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userTracks,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTracksTableFilterComposer(
            $db: $db,
            $table: $db.userTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserEntriesTable> {
  $$UserEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserEntriesTable> {
  $$UserEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hashedPassword => $composableBuilder(
    column: $table.hashedPassword,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> userTracksRefs<T extends Object>(
    Expression<T> Function($$UserTracksTableAnnotationComposer a) f,
  ) {
    final $$UserTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userTracks,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.userTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserEntriesTable,
          UserEntry,
          $$UserEntriesTableFilterComposer,
          $$UserEntriesTableOrderingComposer,
          $$UserEntriesTableAnnotationComposer,
          $$UserEntriesTableCreateCompanionBuilder,
          $$UserEntriesTableUpdateCompanionBuilder,
          (UserEntry, $$UserEntriesTableReferences),
          UserEntry,
          PrefetchHooks Function({bool userTracksRefs})
        > {
  $$UserEntriesTableTableManager(_$AppDatabase db, $UserEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String?> middleName = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> hashedPassword = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => UserEntriesCompanion(
                id: id,
                externalId: externalId,
                lastName: lastName,
                firstName: firstName,
                middleName: middleName,
                phoneNumber: phoneNumber,
                hashedPassword: hashedPassword,
                role: role,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String externalId,
                required String lastName,
                required String firstName,
                Value<String?> middleName = const Value.absent(),
                required String phoneNumber,
                required String hashedPassword,
                required String role,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => UserEntriesCompanion.insert(
                id: id,
                externalId: externalId,
                lastName: lastName,
                firstName: firstName,
                middleName: middleName,
                phoneNumber: phoneNumber,
                hashedPassword: hashedPassword,
                role: role,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userTracksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userTracksRefs) db.userTracks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userTracksRefs)
                    await $_getPrefetchedData<
                      UserEntry,
                      $UserEntriesTable,
                      UserTrackData
                    >(
                      currentTable: table,
                      referencedTable: $$UserEntriesTableReferences
                          ._userTracksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserEntriesTableReferences(
                            db,
                            table,
                            p0,
                          ).userTracksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserEntriesTable,
      UserEntry,
      $$UserEntriesTableFilterComposer,
      $$UserEntriesTableOrderingComposer,
      $$UserEntriesTableAnnotationComposer,
      $$UserEntriesTableCreateCompanionBuilder,
      $$UserEntriesTableUpdateCompanionBuilder,
      (UserEntry, $$UserEntriesTableReferences),
      UserEntry,
      PrefetchHooks Function({bool userTracksRefs})
    >;
typedef $$UserTracksTableCreateCompanionBuilder =
    UserTracksCompanion Function({
      Value<int> id,
      required int userId,
      Value<int?> routeId,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<double> totalDistanceMeters,
      Value<int> movingTimeSeconds,
      Value<int> totalTimeSeconds,
      Value<double> averageSpeedKmh,
      Value<double> maxSpeedKmh,
      required String status,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UserTracksTableUpdateCompanionBuilder =
    UserTracksCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int?> routeId,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<double> totalDistanceMeters,
      Value<int> movingTimeSeconds,
      Value<int> totalTimeSeconds,
      Value<double> averageSpeedKmh,
      Value<double> maxSpeedKmh,
      Value<String> status,
      Value<String?> metadata,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UserTracksTableReferences
    extends BaseReferences<_$AppDatabase, $UserTracksTable, UserTrackData> {
  $$UserTracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserEntriesTable _userIdTable(_$AppDatabase db) =>
      db.userEntries.createAlias(
        $_aliasNameGenerator(db.userTracks.userId, db.userEntries.id),
      );

  $$UserEntriesTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UserEntriesTableTableManager(
      $_db,
      $_db.userEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TrackPointsTable, List<TrackPointData>>
  _trackPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackPoints,
    aliasName: $_aliasNameGenerator(db.userTracks.id, db.trackPoints.trackId),
  );

  $$TrackPointsTableProcessedTableManager get trackPointsRefs {
    final manager = $$TrackPointsTableTableManager(
      $_db,
      $_db.trackPoints,
    ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserTracksTableFilterComposer
    extends Composer<_$AppDatabase, $UserTracksTable> {
  $$UserTracksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTimeSeconds => $composableBuilder(
    column: $table.totalTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserEntriesTableFilterComposer get userId {
    final $$UserEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserEntriesTableFilterComposer(
            $db: $db,
            $table: $db.userEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> trackPointsRefs(
    Expression<bool> Function($$TrackPointsTableFilterComposer f) f,
  ) {
    final $$TrackPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableFilterComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTracksTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTracksTable> {
  $$UserTracksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTimeSeconds => $composableBuilder(
    column: $table.totalTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserEntriesTableOrderingComposer get userId {
    final $$UserEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.userEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserTracksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTracksTable> {
  $$UserTracksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<double> get totalDistanceMeters => $composableBuilder(
    column: $table.totalDistanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get movingTimeSeconds => $composableBuilder(
    column: $table.movingTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTimeSeconds => $composableBuilder(
    column: $table.totalTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get averageSpeedKmh => $composableBuilder(
    column: $table.averageSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKmh => $composableBuilder(
    column: $table.maxSpeedKmh,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UserEntriesTableAnnotationComposer get userId {
    final $$UserEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.userEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> trackPointsRefs<T extends Object>(
    Expression<T> Function($$TrackPointsTableAnnotationComposer a) f,
  ) {
    final $$TrackPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPoints,
      getReferencedColumn: (t) => t.trackId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserTracksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTracksTable,
          UserTrackData,
          $$UserTracksTableFilterComposer,
          $$UserTracksTableOrderingComposer,
          $$UserTracksTableAnnotationComposer,
          $$UserTracksTableCreateCompanionBuilder,
          $$UserTracksTableUpdateCompanionBuilder,
          (UserTrackData, $$UserTracksTableReferences),
          UserTrackData,
          PrefetchHooks Function({bool userId, bool trackPointsRefs})
        > {
  $$UserTracksTableTableManager(_$AppDatabase db, $UserTracksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTracksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTracksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTracksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int?> routeId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<int> movingTimeSeconds = const Value.absent(),
                Value<int> totalTimeSeconds = const Value.absent(),
                Value<double> averageSpeedKmh = const Value.absent(),
                Value<double> maxSpeedKmh = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserTracksCompanion(
                id: id,
                userId: userId,
                routeId: routeId,
                startTime: startTime,
                endTime: endTime,
                totalDistanceMeters: totalDistanceMeters,
                movingTimeSeconds: movingTimeSeconds,
                totalTimeSeconds: totalTimeSeconds,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                status: status,
                metadata: metadata,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<int?> routeId = const Value.absent(),
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<double> totalDistanceMeters = const Value.absent(),
                Value<int> movingTimeSeconds = const Value.absent(),
                Value<int> totalTimeSeconds = const Value.absent(),
                Value<double> averageSpeedKmh = const Value.absent(),
                Value<double> maxSpeedKmh = const Value.absent(),
                required String status,
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserTracksCompanion.insert(
                id: id,
                userId: userId,
                routeId: routeId,
                startTime: startTime,
                endTime: endTime,
                totalDistanceMeters: totalDistanceMeters,
                movingTimeSeconds: movingTimeSeconds,
                totalTimeSeconds: totalTimeSeconds,
                averageSpeedKmh: averageSpeedKmh,
                maxSpeedKmh: maxSpeedKmh,
                status: status,
                metadata: metadata,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserTracksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, trackPointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (trackPointsRefs) db.trackPoints],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$UserTracksTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$UserTracksTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trackPointsRefs)
                    await $_getPrefetchedData<
                      UserTrackData,
                      $UserTracksTable,
                      TrackPointData
                    >(
                      currentTable: table,
                      referencedTable: $$UserTracksTableReferences
                          ._trackPointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserTracksTableReferences(
                            db,
                            table,
                            p0,
                          ).trackPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.trackId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserTracksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTracksTable,
      UserTrackData,
      $$UserTracksTableFilterComposer,
      $$UserTracksTableOrderingComposer,
      $$UserTracksTableAnnotationComposer,
      $$UserTracksTableCreateCompanionBuilder,
      $$UserTracksTableUpdateCompanionBuilder,
      (UserTrackData, $$UserTracksTableReferences),
      UserTrackData,
      PrefetchHooks Function({bool userId, bool trackPointsRefs})
    >;
typedef $$TrackPointsTableCreateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      required int trackId,
      required double latitude,
      required double longitude,
      required DateTime timestamp,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> altitudeAccuracy,
      Value<double?> speedKmh,
      Value<double?> bearing,
      Value<double?> distanceFromPrevious,
      Value<int?> timeFromPrevious,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });
typedef $$TrackPointsTableUpdateCompanionBuilder =
    TrackPointsCompanion Function({
      Value<int> id,
      Value<int> trackId,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime> timestamp,
      Value<double?> accuracy,
      Value<double?> altitude,
      Value<double?> altitudeAccuracy,
      Value<double?> speedKmh,
      Value<double?> bearing,
      Value<double?> distanceFromPrevious,
      Value<int?> timeFromPrevious,
      Value<String?> metadata,
      Value<DateTime> createdAt,
    });

final class $$TrackPointsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackPointsTable, TrackPointData> {
  $$TrackPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserTracksTable _trackIdTable(_$AppDatabase db) =>
      db.userTracks.createAlias(
        $_aliasNameGenerator(db.trackPoints.trackId, db.userTracks.id),
      );

  $$UserTracksTableProcessedTableManager get trackId {
    final $_column = $_itemColumn<int>('track_id')!;

    final manager = $$UserTracksTableTableManager(
      $_db,
      $_db.userTracks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackPointsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeAccuracy => $composableBuilder(
    column: $table.altitudeAccuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bearing => $composableBuilder(
    column: $table.bearing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceFromPrevious => $composableBuilder(
    column: $table.distanceFromPrevious,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeFromPrevious => $composableBuilder(
    column: $table.timeFromPrevious,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UserTracksTableFilterComposer get trackId {
    final $$UserTracksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.userTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTracksTableFilterComposer(
            $db: $db,
            $table: $db.userTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitude => $composableBuilder(
    column: $table.altitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeAccuracy => $composableBuilder(
    column: $table.altitudeAccuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKmh => $composableBuilder(
    column: $table.speedKmh,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bearing => $composableBuilder(
    column: $table.bearing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceFromPrevious => $composableBuilder(
    column: $table.distanceFromPrevious,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeFromPrevious => $composableBuilder(
    column: $table.timeFromPrevious,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserTracksTableOrderingComposer get trackId {
    final $$UserTracksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.userTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTracksTableOrderingComposer(
            $db: $db,
            $table: $db.userTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointsTable> {
  $$TrackPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<double> get altitude =>
      $composableBuilder(column: $table.altitude, builder: (column) => column);

  GeneratedColumn<double> get altitudeAccuracy => $composableBuilder(
    column: $table.altitudeAccuracy,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedKmh =>
      $composableBuilder(column: $table.speedKmh, builder: (column) => column);

  GeneratedColumn<double> get bearing =>
      $composableBuilder(column: $table.bearing, builder: (column) => column);

  GeneratedColumn<double> get distanceFromPrevious => $composableBuilder(
    column: $table.distanceFromPrevious,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeFromPrevious => $composableBuilder(
    column: $table.timeFromPrevious,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UserTracksTableAnnotationComposer get trackId {
    final $$UserTracksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.trackId,
      referencedTable: $db.userTracks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserTracksTableAnnotationComposer(
            $db: $db,
            $table: $db.userTracks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointsTable,
          TrackPointData,
          $$TrackPointsTableFilterComposer,
          $$TrackPointsTableOrderingComposer,
          $$TrackPointsTableAnnotationComposer,
          $$TrackPointsTableCreateCompanionBuilder,
          $$TrackPointsTableUpdateCompanionBuilder,
          (TrackPointData, $$TrackPointsTableReferences),
          TrackPointData,
          PrefetchHooks Function({bool trackId})
        > {
  $$TrackPointsTableTableManager(_$AppDatabase db, $TrackPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> trackId = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> altitudeAccuracy = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<double?> bearing = const Value.absent(),
                Value<double?> distanceFromPrevious = const Value.absent(),
                Value<int?> timeFromPrevious = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TrackPointsCompanion(
                id: id,
                trackId: trackId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
                accuracy: accuracy,
                altitude: altitude,
                altitudeAccuracy: altitudeAccuracy,
                speedKmh: speedKmh,
                bearing: bearing,
                distanceFromPrevious: distanceFromPrevious,
                timeFromPrevious: timeFromPrevious,
                metadata: metadata,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int trackId,
                required double latitude,
                required double longitude,
                required DateTime timestamp,
                Value<double?> accuracy = const Value.absent(),
                Value<double?> altitude = const Value.absent(),
                Value<double?> altitudeAccuracy = const Value.absent(),
                Value<double?> speedKmh = const Value.absent(),
                Value<double?> bearing = const Value.absent(),
                Value<double?> distanceFromPrevious = const Value.absent(),
                Value<int?> timeFromPrevious = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TrackPointsCompanion.insert(
                id: id,
                trackId: trackId,
                latitude: latitude,
                longitude: longitude,
                timestamp: timestamp,
                accuracy: accuracy,
                altitude: altitude,
                altitudeAccuracy: altitudeAccuracy,
                speedKmh: speedKmh,
                bearing: bearing,
                distanceFromPrevious: distanceFromPrevious,
                timeFromPrevious: timeFromPrevious,
                metadata: metadata,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (trackId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.trackId,
                                referencedTable: $$TrackPointsTableReferences
                                    ._trackIdTable(db),
                                referencedColumn: $$TrackPointsTableReferences
                                    ._trackIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointsTable,
      TrackPointData,
      $$TrackPointsTableFilterComposer,
      $$TrackPointsTableOrderingComposer,
      $$TrackPointsTableAnnotationComposer,
      $$TrackPointsTableCreateCompanionBuilder,
      $$TrackPointsTableUpdateCompanionBuilder,
      (TrackPointData, $$TrackPointsTableReferences),
      TrackPointData,
      PrefetchHooks Function({bool trackId})
    >;
typedef $$RoutesTableTableCreateCompanionBuilder =
    RoutesTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      required String status,
      Value<String?> pathJson,
      required int userId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$RoutesTableTableUpdateCompanionBuilder =
    RoutesTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<DateTime?> startTime,
      Value<DateTime?> endTime,
      Value<String> status,
      Value<String?> pathJson,
      Value<int> userId,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$RoutesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RoutesTableTable> {
  $$RoutesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pathJson => $composableBuilder(
    column: $table.pathJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutesTableTable> {
  $$RoutesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pathJson => $composableBuilder(
    column: $table.pathJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutesTableTable> {
  $$RoutesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get pathJson =>
      $composableBuilder(column: $table.pathJson, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RoutesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutesTableTable,
          RoutesTableData,
          $$RoutesTableTableFilterComposer,
          $$RoutesTableTableOrderingComposer,
          $$RoutesTableTableAnnotationComposer,
          $$RoutesTableTableCreateCompanionBuilder,
          $$RoutesTableTableUpdateCompanionBuilder,
          (
            RoutesTableData,
            BaseReferences<_$AppDatabase, $RoutesTableTable, RoutesTableData>,
          ),
          RoutesTableData,
          PrefetchHooks Function()
        > {
  $$RoutesTableTableTableManager(_$AppDatabase db, $RoutesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> pathJson = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => RoutesTableCompanion(
                id: id,
                name: name,
                description: description,
                startTime: startTime,
                endTime: endTime,
                status: status,
                pathJson: pathJson,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<DateTime?> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                required String status,
                Value<String?> pathJson = const Value.absent(),
                required int userId,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => RoutesTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                startTime: startTime,
                endTime: endTime,
                status: status,
                pathJson: pathJson,
                userId: userId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutesTableTable,
      RoutesTableData,
      $$RoutesTableTableFilterComposer,
      $$RoutesTableTableOrderingComposer,
      $$RoutesTableTableAnnotationComposer,
      $$RoutesTableTableCreateCompanionBuilder,
      $$RoutesTableTableUpdateCompanionBuilder,
      (
        RoutesTableData,
        BaseReferences<_$AppDatabase, $RoutesTableTable, RoutesTableData>,
      ),
      RoutesTableData,
      PrefetchHooks Function()
    >;
typedef $$TradingPointsTableTableCreateCompanionBuilder =
    TradingPointsTableCompanion Function({
      Value<int> id,
      required String externalId,
      required String name,
      Value<String?> inn,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$TradingPointsTableTableUpdateCompanionBuilder =
    TradingPointsTableCompanion Function({
      Value<int> id,
      Value<String> externalId,
      Value<String> name,
      Value<String?> inn,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$TradingPointsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TradingPointsTableTable> {
  $$TradingPointsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inn => $composableBuilder(
    column: $table.inn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TradingPointsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TradingPointsTableTable> {
  $$TradingPointsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inn => $composableBuilder(
    column: $table.inn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TradingPointsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradingPointsTableTable> {
  $$TradingPointsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get externalId => $composableBuilder(
    column: $table.externalId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get inn =>
      $composableBuilder(column: $table.inn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TradingPointsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TradingPointsTableTable,
          TradingPointsTableData,
          $$TradingPointsTableTableFilterComposer,
          $$TradingPointsTableTableOrderingComposer,
          $$TradingPointsTableTableAnnotationComposer,
          $$TradingPointsTableTableCreateCompanionBuilder,
          $$TradingPointsTableTableUpdateCompanionBuilder,
          (
            TradingPointsTableData,
            BaseReferences<
              _$AppDatabase,
              $TradingPointsTableTable,
              TradingPointsTableData
            >,
          ),
          TradingPointsTableData,
          PrefetchHooks Function()
        > {
  $$TradingPointsTableTableTableManager(
    _$AppDatabase db,
    $TradingPointsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradingPointsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradingPointsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradingPointsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> externalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> inn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TradingPointsTableCompanion(
                id: id,
                externalId: externalId,
                name: name,
                inn: inn,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String externalId,
                required String name,
                Value<String?> inn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => TradingPointsTableCompanion.insert(
                id: id,
                externalId: externalId,
                name: name,
                inn: inn,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TradingPointsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TradingPointsTableTable,
      TradingPointsTableData,
      $$TradingPointsTableTableFilterComposer,
      $$TradingPointsTableTableOrderingComposer,
      $$TradingPointsTableTableAnnotationComposer,
      $$TradingPointsTableTableCreateCompanionBuilder,
      $$TradingPointsTableTableUpdateCompanionBuilder,
      (
        TradingPointsTableData,
        BaseReferences<
          _$AppDatabase,
          $TradingPointsTableTable,
          TradingPointsTableData
        >,
      ),
      TradingPointsTableData,
      PrefetchHooks Function()
    >;
typedef $$PointsOfInterestTableTableCreateCompanionBuilder =
    PointsOfInterestTableCompanion Function({
      Value<int> id,
      required int routeId,
      required String name,
      Value<String?> description,
      required double latitude,
      required double longitude,
      Value<DateTime?> plannedArrivalTime,
      Value<DateTime?> plannedDepartureTime,
      Value<DateTime?> actualArrivalTime,
      Value<DateTime?> actualDepartureTime,
      required String type,
      required String status,
      Value<String?> notes,
      Value<int?> tradingPointId,
      required int orderIndex,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$PointsOfInterestTableTableUpdateCompanionBuilder =
    PointsOfInterestTableCompanion Function({
      Value<int> id,
      Value<int> routeId,
      Value<String> name,
      Value<String?> description,
      Value<double> latitude,
      Value<double> longitude,
      Value<DateTime?> plannedArrivalTime,
      Value<DateTime?> plannedDepartureTime,
      Value<DateTime?> actualArrivalTime,
      Value<DateTime?> actualDepartureTime,
      Value<String> type,
      Value<String> status,
      Value<String?> notes,
      Value<int?> tradingPointId,
      Value<int> orderIndex,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$PointsOfInterestTableTableFilterComposer
    extends Composer<_$AppDatabase, $PointsOfInterestTableTable> {
  $$PointsOfInterestTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedArrivalTime => $composableBuilder(
    column: $table.plannedArrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get plannedDepartureTime => $composableBuilder(
    column: $table.plannedDepartureTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualArrivalTime => $composableBuilder(
    column: $table.actualArrivalTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualDepartureTime => $composableBuilder(
    column: $table.actualDepartureTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tradingPointId => $composableBuilder(
    column: $table.tradingPointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PointsOfInterestTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PointsOfInterestTableTable> {
  $$PointsOfInterestTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get routeId => $composableBuilder(
    column: $table.routeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedArrivalTime => $composableBuilder(
    column: $table.plannedArrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get plannedDepartureTime => $composableBuilder(
    column: $table.plannedDepartureTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualArrivalTime => $composableBuilder(
    column: $table.actualArrivalTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualDepartureTime => $composableBuilder(
    column: $table.actualDepartureTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tradingPointId => $composableBuilder(
    column: $table.tradingPointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PointsOfInterestTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointsOfInterestTableTable> {
  $$PointsOfInterestTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get routeId =>
      $composableBuilder(column: $table.routeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedArrivalTime => $composableBuilder(
    column: $table.plannedArrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get plannedDepartureTime => $composableBuilder(
    column: $table.plannedDepartureTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualArrivalTime => $composableBuilder(
    column: $table.actualArrivalTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualDepartureTime => $composableBuilder(
    column: $table.actualDepartureTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get tradingPointId => $composableBuilder(
    column: $table.tradingPointId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PointsOfInterestTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointsOfInterestTableTable,
          PointsOfInterestTableData,
          $$PointsOfInterestTableTableFilterComposer,
          $$PointsOfInterestTableTableOrderingComposer,
          $$PointsOfInterestTableTableAnnotationComposer,
          $$PointsOfInterestTableTableCreateCompanionBuilder,
          $$PointsOfInterestTableTableUpdateCompanionBuilder,
          (
            PointsOfInterestTableData,
            BaseReferences<
              _$AppDatabase,
              $PointsOfInterestTableTable,
              PointsOfInterestTableData
            >,
          ),
          PointsOfInterestTableData,
          PrefetchHooks Function()
        > {
  $$PointsOfInterestTableTableTableManager(
    _$AppDatabase db,
    $PointsOfInterestTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointsOfInterestTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PointsOfInterestTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PointsOfInterestTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> routeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<DateTime?> plannedArrivalTime = const Value.absent(),
                Value<DateTime?> plannedDepartureTime = const Value.absent(),
                Value<DateTime?> actualArrivalTime = const Value.absent(),
                Value<DateTime?> actualDepartureTime = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> tradingPointId = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PointsOfInterestTableCompanion(
                id: id,
                routeId: routeId,
                name: name,
                description: description,
                latitude: latitude,
                longitude: longitude,
                plannedArrivalTime: plannedArrivalTime,
                plannedDepartureTime: plannedDepartureTime,
                actualArrivalTime: actualArrivalTime,
                actualDepartureTime: actualDepartureTime,
                type: type,
                status: status,
                notes: notes,
                tradingPointId: tradingPointId,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int routeId,
                required String name,
                Value<String?> description = const Value.absent(),
                required double latitude,
                required double longitude,
                Value<DateTime?> plannedArrivalTime = const Value.absent(),
                Value<DateTime?> plannedDepartureTime = const Value.absent(),
                Value<DateTime?> actualArrivalTime = const Value.absent(),
                Value<DateTime?> actualDepartureTime = const Value.absent(),
                required String type,
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<int?> tradingPointId = const Value.absent(),
                required int orderIndex,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PointsOfInterestTableCompanion.insert(
                id: id,
                routeId: routeId,
                name: name,
                description: description,
                latitude: latitude,
                longitude: longitude,
                plannedArrivalTime: plannedArrivalTime,
                plannedDepartureTime: plannedDepartureTime,
                actualArrivalTime: actualArrivalTime,
                actualDepartureTime: actualDepartureTime,
                type: type,
                status: status,
                notes: notes,
                tradingPointId: tradingPointId,
                orderIndex: orderIndex,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PointsOfInterestTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointsOfInterestTableTable,
      PointsOfInterestTableData,
      $$PointsOfInterestTableTableFilterComposer,
      $$PointsOfInterestTableTableOrderingComposer,
      $$PointsOfInterestTableTableAnnotationComposer,
      $$PointsOfInterestTableTableCreateCompanionBuilder,
      $$PointsOfInterestTableTableUpdateCompanionBuilder,
      (
        PointsOfInterestTableData,
        BaseReferences<
          _$AppDatabase,
          $PointsOfInterestTableTable,
          PointsOfInterestTableData
        >,
      ),
      PointsOfInterestTableData,
      PrefetchHooks Function()
    >;
typedef $$PointStatusHistoryTableTableCreateCompanionBuilder =
    PointStatusHistoryTableCompanion Function({
      Value<int> id,
      required int pointId,
      required String fromStatus,
      required String toStatus,
      required String changedBy,
      Value<String?> reason,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$PointStatusHistoryTableTableUpdateCompanionBuilder =
    PointStatusHistoryTableCompanion Function({
      Value<int> id,
      Value<int> pointId,
      Value<String> fromStatus,
      Value<String> toStatus,
      Value<String> changedBy,
      Value<String?> reason,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$PointStatusHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $PointStatusHistoryTableTable> {
  $$PointStatusHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PointStatusHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PointStatusHistoryTableTable> {
  $$PointStatusHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pointId => $composableBuilder(
    column: $table.pointId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changedBy => $composableBuilder(
    column: $table.changedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PointStatusHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PointStatusHistoryTableTable> {
  $$PointStatusHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pointId =>
      $composableBuilder(column: $table.pointId, builder: (column) => column);

  GeneratedColumn<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<String> get changedBy =>
      $composableBuilder(column: $table.changedBy, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PointStatusHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PointStatusHistoryTableTable,
          PointStatusHistoryTableData,
          $$PointStatusHistoryTableTableFilterComposer,
          $$PointStatusHistoryTableTableOrderingComposer,
          $$PointStatusHistoryTableTableAnnotationComposer,
          $$PointStatusHistoryTableTableCreateCompanionBuilder,
          $$PointStatusHistoryTableTableUpdateCompanionBuilder,
          (
            PointStatusHistoryTableData,
            BaseReferences<
              _$AppDatabase,
              $PointStatusHistoryTableTable,
              PointStatusHistoryTableData
            >,
          ),
          PointStatusHistoryTableData,
          PrefetchHooks Function()
        > {
  $$PointStatusHistoryTableTableTableManager(
    _$AppDatabase db,
    $PointStatusHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointStatusHistoryTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PointStatusHistoryTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PointStatusHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> pointId = const Value.absent(),
                Value<String> fromStatus = const Value.absent(),
                Value<String> toStatus = const Value.absent(),
                Value<String> changedBy = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PointStatusHistoryTableCompanion(
                id: id,
                pointId: pointId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedBy: changedBy,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int pointId,
                required String fromStatus,
                required String toStatus,
                required String changedBy,
                Value<String?> reason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => PointStatusHistoryTableCompanion.insert(
                id: id,
                pointId: pointId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedBy: changedBy,
                reason: reason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PointStatusHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PointStatusHistoryTableTable,
      PointStatusHistoryTableData,
      $$PointStatusHistoryTableTableFilterComposer,
      $$PointStatusHistoryTableTableOrderingComposer,
      $$PointStatusHistoryTableTableAnnotationComposer,
      $$PointStatusHistoryTableTableCreateCompanionBuilder,
      $$PointStatusHistoryTableTableUpdateCompanionBuilder,
      (
        PointStatusHistoryTableData,
        BaseReferences<
          _$AppDatabase,
          $PointStatusHistoryTableTable,
          PointStatusHistoryTableData
        >,
      ),
      PointStatusHistoryTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserEntriesTableTableManager get userEntries =>
      $$UserEntriesTableTableManager(_db, _db.userEntries);
  $$UserTracksTableTableManager get userTracks =>
      $$UserTracksTableTableManager(_db, _db.userTracks);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
  $$RoutesTableTableTableManager get routesTable =>
      $$RoutesTableTableTableManager(_db, _db.routesTable);
  $$TradingPointsTableTableTableManager get tradingPointsTable =>
      $$TradingPointsTableTableTableManager(_db, _db.tradingPointsTable);
  $$PointsOfInterestTableTableTableManager get pointsOfInterestTable =>
      $$PointsOfInterestTableTableTableManager(_db, _db.pointsOfInterestTable);
  $$PointStatusHistoryTableTableTableManager get pointStatusHistoryTable =>
      $$PointStatusHistoryTableTableTableManager(
        _db,
        _db.pointStatusHistoryTable,
      );
}
