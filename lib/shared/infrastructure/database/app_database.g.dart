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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserEntriesTable userEntries = $UserEntriesTable(this);
  late final $UserTracksTable userTracks = $UserTracksTable(this);
  late final $TrackPointsTable trackPoints = $TrackPointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userEntries,
    userTracks,
    trackPoints,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserEntriesTableTableManager get userEntries =>
      $$UserEntriesTableTableManager(_db, _db.userEntries);
  $$UserTracksTableTableManager get userTracks =>
      $$UserTracksTableTableManager(_db, _db.userTracks);
  $$TrackPointsTableTableManager get trackPoints =>
      $$TrackPointsTableTableManager(_db, _db.trackPoints);
}
