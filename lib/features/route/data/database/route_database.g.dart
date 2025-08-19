// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_database.dart';

// ignore_for_file: type=lint
class $RoutesTableTable extends RoutesTable
    with TableInfo<$RoutesTableTable, RoutesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathJsonMeta =
      const VerificationMeta('pathJson');
  @override
  late final GeneratedColumn<String> pathJson = GeneratedColumn<String>(
      'path_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routes';
  @override
  VerificationContext validateIntegrity(Insertable<RoutesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('path_json')) {
      context.handle(_pathJsonMeta,
          pathJson.isAcceptableOrUnknown(data['path_json']!, _pathJsonMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time']),
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      pathJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path_json']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
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
  const RoutesTableData(
      {required this.id,
      required this.name,
      this.description,
      this.startTime,
      this.endTime,
      required this.status,
      this.pathJson,
      required this.userId,
      required this.createdAt,
      this.updatedAt});
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

  factory RoutesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
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

  RoutesTableData copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<DateTime?> startTime = const Value.absent(),
          Value<DateTime?> endTime = const Value.absent(),
          String? status,
          Value<String?> pathJson = const Value.absent(),
          int? userId,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      RoutesTableData(
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
      description:
          data.description.present ? data.description.value : this.description,
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
  int get hashCode => Object.hash(id, name, description, startTime, endTime,
      status, pathJson, userId, createdAt, updatedAt);
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
  })  : name = Value(name),
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

  RoutesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<DateTime?>? startTime,
      Value<DateTime?>? endTime,
      Value<String>? status,
      Value<String?>? pathJson,
      Value<int>? userId,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _externalIdMeta =
      const VerificationMeta('externalId');
  @override
  late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
      'external_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _innMeta = const VerificationMeta('inn');
  @override
  late final GeneratedColumn<String> inn = GeneratedColumn<String>(
      'inn', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, externalId, name, inn, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trading_points';
  @override
  VerificationContext validateIntegrity(
      Insertable<TradingPointsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('external_id')) {
      context.handle(
          _externalIdMeta,
          externalId.isAcceptableOrUnknown(
              data['external_id']!, _externalIdMeta));
    } else if (isInserting) {
      context.missing(_externalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('inn')) {
      context.handle(
          _innMeta, inn.isAcceptableOrUnknown(data['inn']!, _innMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradingPointsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradingPointsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      externalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}external_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      inn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}inn']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
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
  const TradingPointsTableData(
      {required this.id,
      required this.externalId,
      required this.name,
      this.inn,
      required this.createdAt,
      this.updatedAt});
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

  factory TradingPointsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
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

  TradingPointsTableData copyWith(
          {int? id,
          String? externalId,
          String? name,
          Value<String?> inn = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      TradingPointsTableData(
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
      externalId:
          data.externalId.present ? data.externalId.value : this.externalId,
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
  })  : externalId = Value(externalId),
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

  TradingPointsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? externalId,
      Value<String>? name,
      Value<String?>? inn,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _routeIdMeta =
      const VerificationMeta('routeId');
  @override
  late final GeneratedColumn<int> routeId = GeneratedColumn<int>(
      'route_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _plannedArrivalTimeMeta =
      const VerificationMeta('plannedArrivalTime');
  @override
  late final GeneratedColumn<DateTime> plannedArrivalTime =
      GeneratedColumn<DateTime>('planned_arrival_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _plannedDepartureTimeMeta =
      const VerificationMeta('plannedDepartureTime');
  @override
  late final GeneratedColumn<DateTime> plannedDepartureTime =
      GeneratedColumn<DateTime>('planned_departure_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actualArrivalTimeMeta =
      const VerificationMeta('actualArrivalTime');
  @override
  late final GeneratedColumn<DateTime> actualArrivalTime =
      GeneratedColumn<DateTime>('actual_arrival_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _actualDepartureTimeMeta =
      const VerificationMeta('actualDepartureTime');
  @override
  late final GeneratedColumn<DateTime> actualDepartureTime =
      GeneratedColumn<DateTime>('actual_departure_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tradingPointIdMeta =
      const VerificationMeta('tradingPointId');
  @override
  late final GeneratedColumn<int> tradingPointId = GeneratedColumn<int>(
      'trading_point_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'points_of_interest';
  @override
  VerificationContext validateIntegrity(
      Insertable<PointsOfInterestTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('route_id')) {
      context.handle(_routeIdMeta,
          routeId.isAcceptableOrUnknown(data['route_id']!, _routeIdMeta));
    } else if (isInserting) {
      context.missing(_routeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('planned_arrival_time')) {
      context.handle(
          _plannedArrivalTimeMeta,
          plannedArrivalTime.isAcceptableOrUnknown(
              data['planned_arrival_time']!, _plannedArrivalTimeMeta));
    }
    if (data.containsKey('planned_departure_time')) {
      context.handle(
          _plannedDepartureTimeMeta,
          plannedDepartureTime.isAcceptableOrUnknown(
              data['planned_departure_time']!, _plannedDepartureTimeMeta));
    }
    if (data.containsKey('actual_arrival_time')) {
      context.handle(
          _actualArrivalTimeMeta,
          actualArrivalTime.isAcceptableOrUnknown(
              data['actual_arrival_time']!, _actualArrivalTimeMeta));
    }
    if (data.containsKey('actual_departure_time')) {
      context.handle(
          _actualDepartureTimeMeta,
          actualDepartureTime.isAcceptableOrUnknown(
              data['actual_departure_time']!, _actualDepartureTimeMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('trading_point_id')) {
      context.handle(
          _tradingPointIdMeta,
          tradingPointId.isAcceptableOrUnknown(
              data['trading_point_id']!, _tradingPointIdMeta));
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointsOfInterestTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointsOfInterestTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      routeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}route_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude'])!,
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude'])!,
      plannedArrivalTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}planned_arrival_time']),
      plannedDepartureTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}planned_departure_time']),
      actualArrivalTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}actual_arrival_time']),
      actualDepartureTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}actual_departure_time']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      tradingPointId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trading_point_id']),
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
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
  const PointsOfInterestTableData(
      {required this.id,
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
      this.updatedAt});
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
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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

  factory PointsOfInterestTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PointsOfInterestTableData(
      id: serializer.fromJson<int>(json['id']),
      routeId: serializer.fromJson<int>(json['routeId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      plannedArrivalTime:
          serializer.fromJson<DateTime?>(json['plannedArrivalTime']),
      plannedDepartureTime:
          serializer.fromJson<DateTime?>(json['plannedDepartureTime']),
      actualArrivalTime:
          serializer.fromJson<DateTime?>(json['actualArrivalTime']),
      actualDepartureTime:
          serializer.fromJson<DateTime?>(json['actualDepartureTime']),
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
      'plannedDepartureTime':
          serializer.toJson<DateTime?>(plannedDepartureTime),
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

  PointsOfInterestTableData copyWith(
          {int? id,
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
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PointsOfInterestTableData(
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
        tradingPointId:
            tradingPointId.present ? tradingPointId.value : this.tradingPointId,
        orderIndex: orderIndex ?? this.orderIndex,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  PointsOfInterestTableData copyWithCompanion(
      PointsOfInterestTableCompanion data) {
    return PointsOfInterestTableData(
      id: data.id.present ? data.id.value : this.id,
      routeId: data.routeId.present ? data.routeId.value : this.routeId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
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
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
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
      updatedAt);
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
  })  : routeId = Value(routeId),
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

  PointsOfInterestTableCompanion copyWith(
      {Value<int>? id,
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
      Value<DateTime?>? updatedAt}) {
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
      map['planned_arrival_time'] =
          Variable<DateTime>(plannedArrivalTime.value);
    }
    if (plannedDepartureTime.present) {
      map['planned_departure_time'] =
          Variable<DateTime>(plannedDepartureTime.value);
    }
    if (actualArrivalTime.present) {
      map['actual_arrival_time'] = Variable<DateTime>(actualArrivalTime.value);
    }
    if (actualDepartureTime.present) {
      map['actual_departure_time'] =
          Variable<DateTime>(actualDepartureTime.value);
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
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pointIdMeta =
      const VerificationMeta('pointId');
  @override
  late final GeneratedColumn<int> pointId = GeneratedColumn<int>(
      'point_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fromStatusMeta =
      const VerificationMeta('fromStatus');
  @override
  late final GeneratedColumn<String> fromStatus = GeneratedColumn<String>(
      'from_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toStatusMeta =
      const VerificationMeta('toStatus');
  @override
  late final GeneratedColumn<String> toStatus = GeneratedColumn<String>(
      'to_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _changedByMeta =
      const VerificationMeta('changedBy');
  @override
  late final GeneratedColumn<String> changedBy = GeneratedColumn<String>(
      'changed_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pointId,
        fromStatus,
        toStatus,
        changedBy,
        reason,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'point_status_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<PointStatusHistoryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('point_id')) {
      context.handle(_pointIdMeta,
          pointId.isAcceptableOrUnknown(data['point_id']!, _pointIdMeta));
    } else if (isInserting) {
      context.missing(_pointIdMeta);
    }
    if (data.containsKey('from_status')) {
      context.handle(
          _fromStatusMeta,
          fromStatus.isAcceptableOrUnknown(
              data['from_status']!, _fromStatusMeta));
    } else if (isInserting) {
      context.missing(_fromStatusMeta);
    }
    if (data.containsKey('to_status')) {
      context.handle(_toStatusMeta,
          toStatus.isAcceptableOrUnknown(data['to_status']!, _toStatusMeta));
    } else if (isInserting) {
      context.missing(_toStatusMeta);
    }
    if (data.containsKey('changed_by')) {
      context.handle(_changedByMeta,
          changedBy.isAcceptableOrUnknown(data['changed_by']!, _changedByMeta));
    } else if (isInserting) {
      context.missing(_changedByMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PointStatusHistoryTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PointStatusHistoryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pointId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}point_id'])!,
      fromStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_status'])!,
      toStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_status'])!,
      changedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}changed_by'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
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
  const PointStatusHistoryTableData(
      {required this.id,
      required this.pointId,
      required this.fromStatus,
      required this.toStatus,
      required this.changedBy,
      this.reason,
      required this.createdAt,
      this.updatedAt});
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
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PointStatusHistoryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
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

  PointStatusHistoryTableData copyWith(
          {int? id,
          int? pointId,
          String? fromStatus,
          String? toStatus,
          String? changedBy,
          Value<String?> reason = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PointStatusHistoryTableData(
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
      PointStatusHistoryTableCompanion data) {
    return PointStatusHistoryTableData(
      id: data.id.present ? data.id.value : this.id,
      pointId: data.pointId.present ? data.pointId.value : this.pointId,
      fromStatus:
          data.fromStatus.present ? data.fromStatus.value : this.fromStatus,
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
  int get hashCode => Object.hash(id, pointId, fromStatus, toStatus, changedBy,
      reason, createdAt, updatedAt);
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
  })  : pointId = Value(pointId),
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

  PointStatusHistoryTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? pointId,
      Value<String>? fromStatus,
      Value<String>? toStatus,
      Value<String>? changedBy,
      Value<String?>? reason,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt}) {
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

abstract class _$RouteDatabase extends GeneratedDatabase {
  _$RouteDatabase(QueryExecutor e) : super(e);
  $RouteDatabaseManager get managers => $RouteDatabaseManager(this);
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
        routesTable,
        tradingPointsTable,
        pointsOfInterestTable,
        pointStatusHistoryTable
      ];
}

typedef $$RoutesTableTableCreateCompanionBuilder = RoutesTableCompanion
    Function({
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
typedef $$RoutesTableTableUpdateCompanionBuilder = RoutesTableCompanion
    Function({
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
    extends Composer<_$RouteDatabase, $RoutesTableTable> {
  $$RoutesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pathJson => $composableBuilder(
      column: $table.pathJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$RoutesTableTableOrderingComposer
    extends Composer<_$RouteDatabase, $RoutesTableTable> {
  $$RoutesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pathJson => $composableBuilder(
      column: $table.pathJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutesTableTableAnnotationComposer
    extends Composer<_$RouteDatabase, $RoutesTableTable> {
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
      column: $table.description, builder: (column) => column);

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

class $$RoutesTableTableTableManager extends RootTableManager<
    _$RouteDatabase,
    $RoutesTableTable,
    RoutesTableData,
    $$RoutesTableTableFilterComposer,
    $$RoutesTableTableOrderingComposer,
    $$RoutesTableTableAnnotationComposer,
    $$RoutesTableTableCreateCompanionBuilder,
    $$RoutesTableTableUpdateCompanionBuilder,
    (
      RoutesTableData,
      BaseReferences<_$RouteDatabase, $RoutesTableTable, RoutesTableData>
    ),
    RoutesTableData,
    PrefetchHooks Function()> {
  $$RoutesTableTableTableManager(_$RouteDatabase db, $RoutesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          }) =>
              RoutesTableCompanion(
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
          createCompanionCallback: ({
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
          }) =>
              RoutesTableCompanion.insert(
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
        ));
}

typedef $$RoutesTableTableProcessedTableManager = ProcessedTableManager<
    _$RouteDatabase,
    $RoutesTableTable,
    RoutesTableData,
    $$RoutesTableTableFilterComposer,
    $$RoutesTableTableOrderingComposer,
    $$RoutesTableTableAnnotationComposer,
    $$RoutesTableTableCreateCompanionBuilder,
    $$RoutesTableTableUpdateCompanionBuilder,
    (
      RoutesTableData,
      BaseReferences<_$RouteDatabase, $RoutesTableTable, RoutesTableData>
    ),
    RoutesTableData,
    PrefetchHooks Function()>;
typedef $$TradingPointsTableTableCreateCompanionBuilder
    = TradingPointsTableCompanion Function({
  Value<int> id,
  required String externalId,
  required String name,
  Value<String?> inn,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$TradingPointsTableTableUpdateCompanionBuilder
    = TradingPointsTableCompanion Function({
  Value<int> id,
  Value<String> externalId,
  Value<String> name,
  Value<String?> inn,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});

class $$TradingPointsTableTableFilterComposer
    extends Composer<_$RouteDatabase, $TradingPointsTableTable> {
  $$TradingPointsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inn => $composableBuilder(
      column: $table.inn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TradingPointsTableTableOrderingComposer
    extends Composer<_$RouteDatabase, $TradingPointsTableTable> {
  $$TradingPointsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get externalId => $composableBuilder(
      column: $table.externalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inn => $composableBuilder(
      column: $table.inn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TradingPointsTableTableAnnotationComposer
    extends Composer<_$RouteDatabase, $TradingPointsTableTable> {
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
      column: $table.externalId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get inn =>
      $composableBuilder(column: $table.inn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TradingPointsTableTableTableManager extends RootTableManager<
    _$RouteDatabase,
    $TradingPointsTableTable,
    TradingPointsTableData,
    $$TradingPointsTableTableFilterComposer,
    $$TradingPointsTableTableOrderingComposer,
    $$TradingPointsTableTableAnnotationComposer,
    $$TradingPointsTableTableCreateCompanionBuilder,
    $$TradingPointsTableTableUpdateCompanionBuilder,
    (
      TradingPointsTableData,
      BaseReferences<_$RouteDatabase, $TradingPointsTableTable,
          TradingPointsTableData>
    ),
    TradingPointsTableData,
    PrefetchHooks Function()> {
  $$TradingPointsTableTableTableManager(
      _$RouteDatabase db, $TradingPointsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradingPointsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradingPointsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradingPointsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> externalId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> inn = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              TradingPointsTableCompanion(
            id: id,
            externalId: externalId,
            name: name,
            inn: inn,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String externalId,
            required String name,
            Value<String?> inn = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              TradingPointsTableCompanion.insert(
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
        ));
}

typedef $$TradingPointsTableTableProcessedTableManager = ProcessedTableManager<
    _$RouteDatabase,
    $TradingPointsTableTable,
    TradingPointsTableData,
    $$TradingPointsTableTableFilterComposer,
    $$TradingPointsTableTableOrderingComposer,
    $$TradingPointsTableTableAnnotationComposer,
    $$TradingPointsTableTableCreateCompanionBuilder,
    $$TradingPointsTableTableUpdateCompanionBuilder,
    (
      TradingPointsTableData,
      BaseReferences<_$RouteDatabase, $TradingPointsTableTable,
          TradingPointsTableData>
    ),
    TradingPointsTableData,
    PrefetchHooks Function()>;
typedef $$PointsOfInterestTableTableCreateCompanionBuilder
    = PointsOfInterestTableCompanion Function({
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
typedef $$PointsOfInterestTableTableUpdateCompanionBuilder
    = PointsOfInterestTableCompanion Function({
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
    extends Composer<_$RouteDatabase, $PointsOfInterestTableTable> {
  $$PointsOfInterestTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get plannedArrivalTime => $composableBuilder(
      column: $table.plannedArrivalTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get plannedDepartureTime => $composableBuilder(
      column: $table.plannedDepartureTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualArrivalTime => $composableBuilder(
      column: $table.actualArrivalTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualDepartureTime => $composableBuilder(
      column: $table.actualDepartureTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tradingPointId => $composableBuilder(
      column: $table.tradingPointId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PointsOfInterestTableTableOrderingComposer
    extends Composer<_$RouteDatabase, $PointsOfInterestTableTable> {
  $$PointsOfInterestTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get routeId => $composableBuilder(
      column: $table.routeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get plannedArrivalTime => $composableBuilder(
      column: $table.plannedArrivalTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get plannedDepartureTime => $composableBuilder(
      column: $table.plannedDepartureTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualArrivalTime => $composableBuilder(
      column: $table.actualArrivalTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualDepartureTime => $composableBuilder(
      column: $table.actualDepartureTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tradingPointId => $composableBuilder(
      column: $table.tradingPointId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PointsOfInterestTableTableAnnotationComposer
    extends Composer<_$RouteDatabase, $PointsOfInterestTableTable> {
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
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedArrivalTime => $composableBuilder(
      column: $table.plannedArrivalTime, builder: (column) => column);

  GeneratedColumn<DateTime> get plannedDepartureTime => $composableBuilder(
      column: $table.plannedDepartureTime, builder: (column) => column);

  GeneratedColumn<DateTime> get actualArrivalTime => $composableBuilder(
      column: $table.actualArrivalTime, builder: (column) => column);

  GeneratedColumn<DateTime> get actualDepartureTime => $composableBuilder(
      column: $table.actualDepartureTime, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get tradingPointId => $composableBuilder(
      column: $table.tradingPointId, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PointsOfInterestTableTableTableManager extends RootTableManager<
    _$RouteDatabase,
    $PointsOfInterestTableTable,
    PointsOfInterestTableData,
    $$PointsOfInterestTableTableFilterComposer,
    $$PointsOfInterestTableTableOrderingComposer,
    $$PointsOfInterestTableTableAnnotationComposer,
    $$PointsOfInterestTableTableCreateCompanionBuilder,
    $$PointsOfInterestTableTableUpdateCompanionBuilder,
    (
      PointsOfInterestTableData,
      BaseReferences<_$RouteDatabase, $PointsOfInterestTableTable,
          PointsOfInterestTableData>
    ),
    PointsOfInterestTableData,
    PrefetchHooks Function()> {
  $$PointsOfInterestTableTableTableManager(
      _$RouteDatabase db, $PointsOfInterestTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointsOfInterestTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PointsOfInterestTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointsOfInterestTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
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
          }) =>
              PointsOfInterestTableCompanion(
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
          createCompanionCallback: ({
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
          }) =>
              PointsOfInterestTableCompanion.insert(
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
        ));
}

typedef $$PointsOfInterestTableTableProcessedTableManager
    = ProcessedTableManager<
        _$RouteDatabase,
        $PointsOfInterestTableTable,
        PointsOfInterestTableData,
        $$PointsOfInterestTableTableFilterComposer,
        $$PointsOfInterestTableTableOrderingComposer,
        $$PointsOfInterestTableTableAnnotationComposer,
        $$PointsOfInterestTableTableCreateCompanionBuilder,
        $$PointsOfInterestTableTableUpdateCompanionBuilder,
        (
          PointsOfInterestTableData,
          BaseReferences<_$RouteDatabase, $PointsOfInterestTableTable,
              PointsOfInterestTableData>
        ),
        PointsOfInterestTableData,
        PrefetchHooks Function()>;
typedef $$PointStatusHistoryTableTableCreateCompanionBuilder
    = PointStatusHistoryTableCompanion Function({
  Value<int> id,
  required int pointId,
  required String fromStatus,
  required String toStatus,
  required String changedBy,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
});
typedef $$PointStatusHistoryTableTableUpdateCompanionBuilder
    = PointStatusHistoryTableCompanion Function({
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
    extends Composer<_$RouteDatabase, $PointStatusHistoryTableTable> {
  $$PointStatusHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get pointId => $composableBuilder(
      column: $table.pointId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromStatus => $composableBuilder(
      column: $table.fromStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toStatus => $composableBuilder(
      column: $table.toStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PointStatusHistoryTableTableOrderingComposer
    extends Composer<_$RouteDatabase, $PointStatusHistoryTableTable> {
  $$PointStatusHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get pointId => $composableBuilder(
      column: $table.pointId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromStatus => $composableBuilder(
      column: $table.fromStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toStatus => $composableBuilder(
      column: $table.toStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changedBy => $composableBuilder(
      column: $table.changedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PointStatusHistoryTableTableAnnotationComposer
    extends Composer<_$RouteDatabase, $PointStatusHistoryTableTable> {
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
      column: $table.fromStatus, builder: (column) => column);

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

class $$PointStatusHistoryTableTableTableManager extends RootTableManager<
    _$RouteDatabase,
    $PointStatusHistoryTableTable,
    PointStatusHistoryTableData,
    $$PointStatusHistoryTableTableFilterComposer,
    $$PointStatusHistoryTableTableOrderingComposer,
    $$PointStatusHistoryTableTableAnnotationComposer,
    $$PointStatusHistoryTableTableCreateCompanionBuilder,
    $$PointStatusHistoryTableTableUpdateCompanionBuilder,
    (
      PointStatusHistoryTableData,
      BaseReferences<_$RouteDatabase, $PointStatusHistoryTableTable,
          PointStatusHistoryTableData>
    ),
    PointStatusHistoryTableData,
    PrefetchHooks Function()> {
  $$PointStatusHistoryTableTableTableManager(
      _$RouteDatabase db, $PointStatusHistoryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PointStatusHistoryTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$PointStatusHistoryTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PointStatusHistoryTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> pointId = const Value.absent(),
            Value<String> fromStatus = const Value.absent(),
            Value<String> toStatus = const Value.absent(),
            Value<String> changedBy = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PointStatusHistoryTableCompanion(
            id: id,
            pointId: pointId,
            fromStatus: fromStatus,
            toStatus: toStatus,
            changedBy: changedBy,
            reason: reason,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int pointId,
            required String fromStatus,
            required String toStatus,
            required String changedBy,
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
          }) =>
              PointStatusHistoryTableCompanion.insert(
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
        ));
}

typedef $$PointStatusHistoryTableTableProcessedTableManager
    = ProcessedTableManager<
        _$RouteDatabase,
        $PointStatusHistoryTableTable,
        PointStatusHistoryTableData,
        $$PointStatusHistoryTableTableFilterComposer,
        $$PointStatusHistoryTableTableOrderingComposer,
        $$PointStatusHistoryTableTableAnnotationComposer,
        $$PointStatusHistoryTableTableCreateCompanionBuilder,
        $$PointStatusHistoryTableTableUpdateCompanionBuilder,
        (
          PointStatusHistoryTableData,
          BaseReferences<_$RouteDatabase, $PointStatusHistoryTableTable,
              PointStatusHistoryTableData>
        ),
        PointStatusHistoryTableData,
        PrefetchHooks Function()>;

class $RouteDatabaseManager {
  final _$RouteDatabase _db;
  $RouteDatabaseManager(this._db);
  $$RoutesTableTableTableManager get routesTable =>
      $$RoutesTableTableTableManager(_db, _db.routesTable);
  $$TradingPointsTableTableTableManager get tradingPointsTable =>
      $$TradingPointsTableTableTableManager(_db, _db.tradingPointsTable);
  $$PointsOfInterestTableTableTableManager get pointsOfInterestTable =>
      $$PointsOfInterestTableTableTableManager(_db, _db.pointsOfInterestTable);
  $$PointStatusHistoryTableTableTableManager get pointStatusHistoryTable =>
      $$PointStatusHistoryTableTableTableManager(
          _db, _db.pointStatusHistoryTable);
}
