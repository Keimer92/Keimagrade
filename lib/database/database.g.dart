// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AnosLectivosTable extends AnosLectivos
    with TableInfo<$AnosLectivosTable, AnosLectivo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnosLectivosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _anioMeta = const VerificationMeta('anio');
  @override
  late final GeneratedColumn<int> anio = GeneratedColumn<int>(
      'anio', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _porDefectoMeta =
      const VerificationMeta('porDefecto');
  @override
  late final GeneratedColumn<bool> porDefecto = GeneratedColumn<bool>(
      'por_defecto', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("por_defecto" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, anio, activo, porDefecto];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anos_lectivos';
  @override
  VerificationContext validateIntegrity(Insertable<AnosLectivo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anio')) {
      context.handle(
          _anioMeta, anio.isAcceptableOrUnknown(data['anio']!, _anioMeta));
    } else if (isInserting) {
      context.missing(_anioMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('por_defecto')) {
      context.handle(
          _porDefectoMeta,
          porDefecto.isAcceptableOrUnknown(
              data['por_defecto']!, _porDefectoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {anio},
      ];
  @override
  AnosLectivo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnosLectivo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      anio: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      porDefecto: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}por_defecto'])!,
    );
  }

  @override
  $AnosLectivosTable createAlias(String alias) {
    return $AnosLectivosTable(attachedDatabase, alias);
  }
}

class AnosLectivo extends DataClass implements Insertable<AnosLectivo> {
  final int id;
  final int anio;
  final bool activo;
  final bool porDefecto;
  const AnosLectivo(
      {required this.id,
      required this.anio,
      required this.activo,
      required this.porDefecto});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anio'] = Variable<int>(anio);
    map['activo'] = Variable<bool>(activo);
    map['por_defecto'] = Variable<bool>(porDefecto);
    return map;
  }

  AnosLectivosCompanion toCompanion(bool nullToAbsent) {
    return AnosLectivosCompanion(
      id: Value(id),
      anio: Value(anio),
      activo: Value(activo),
      porDefecto: Value(porDefecto),
    );
  }

  factory AnosLectivo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnosLectivo(
      id: serializer.fromJson<int>(json['id']),
      anio: serializer.fromJson<int>(json['anio']),
      activo: serializer.fromJson<bool>(json['activo']),
      porDefecto: serializer.fromJson<bool>(json['porDefecto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'anio': serializer.toJson<int>(anio),
      'activo': serializer.toJson<bool>(activo),
      'porDefecto': serializer.toJson<bool>(porDefecto),
    };
  }

  AnosLectivo copyWith({int? id, int? anio, bool? activo, bool? porDefecto}) =>
      AnosLectivo(
        id: id ?? this.id,
        anio: anio ?? this.anio,
        activo: activo ?? this.activo,
        porDefecto: porDefecto ?? this.porDefecto,
      );
  AnosLectivo copyWithCompanion(AnosLectivosCompanion data) {
    return AnosLectivo(
      id: data.id.present ? data.id.value : this.id,
      anio: data.anio.present ? data.anio.value : this.anio,
      activo: data.activo.present ? data.activo.value : this.activo,
      porDefecto:
          data.porDefecto.present ? data.porDefecto.value : this.porDefecto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnosLectivo(')
          ..write('id: $id, ')
          ..write('anio: $anio, ')
          ..write('activo: $activo, ')
          ..write('porDefecto: $porDefecto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, anio, activo, porDefecto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnosLectivo &&
          other.id == this.id &&
          other.anio == this.anio &&
          other.activo == this.activo &&
          other.porDefecto == this.porDefecto);
}

class AnosLectivosCompanion extends UpdateCompanion<AnosLectivo> {
  final Value<int> id;
  final Value<int> anio;
  final Value<bool> activo;
  final Value<bool> porDefecto;
  const AnosLectivosCompanion({
    this.id = const Value.absent(),
    this.anio = const Value.absent(),
    this.activo = const Value.absent(),
    this.porDefecto = const Value.absent(),
  });
  AnosLectivosCompanion.insert({
    this.id = const Value.absent(),
    required int anio,
    this.activo = const Value.absent(),
    this.porDefecto = const Value.absent(),
  }) : anio = Value(anio);
  static Insertable<AnosLectivo> custom({
    Expression<int>? id,
    Expression<int>? anio,
    Expression<bool>? activo,
    Expression<bool>? porDefecto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anio != null) 'anio': anio,
      if (activo != null) 'activo': activo,
      if (porDefecto != null) 'por_defecto': porDefecto,
    });
  }

  AnosLectivosCompanion copyWith(
      {Value<int>? id,
      Value<int>? anio,
      Value<bool>? activo,
      Value<bool>? porDefecto}) {
    return AnosLectivosCompanion(
      id: id ?? this.id,
      anio: anio ?? this.anio,
      activo: activo ?? this.activo,
      porDefecto: porDefecto ?? this.porDefecto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (anio.present) {
      map['anio'] = Variable<int>(anio.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (porDefecto.present) {
      map['por_defecto'] = Variable<bool>(porDefecto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnosLectivosCompanion(')
          ..write('id: $id, ')
          ..write('anio: $anio, ')
          ..write('activo: $activo, ')
          ..write('porDefecto: $porDefecto')
          ..write(')'))
        .toString();
  }
}

class $ColegiosTable extends Colegios with TableInfo<$ColegiosTable, Colegio> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ColegiosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directorMeta =
      const VerificationMeta('director');
  @override
  late final GeneratedColumn<String> director = GeneratedColumn<String>(
      'director', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, direccion, telefono, email, director, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'colegios';
  @override
  VerificationContext validateIntegrity(Insertable<Colegio> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    } else if (isInserting) {
      context.missing(_direccionMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    } else if (isInserting) {
      context.missing(_telefonoMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('director')) {
      context.handle(_directorMeta,
          director.isAcceptableOrUnknown(data['director']!, _directorMeta));
    } else if (isInserting) {
      context.missing(_directorMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Colegio map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Colegio(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion'])!,
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      director: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}director'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $ColegiosTable createAlias(String alias) {
    return $ColegiosTable(attachedDatabase, alias);
  }
}

class Colegio extends DataClass implements Insertable<Colegio> {
  final int id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;
  final String director;
  final bool activo;
  const Colegio(
      {required this.id,
      required this.nombre,
      required this.direccion,
      required this.telefono,
      required this.email,
      required this.director,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['direccion'] = Variable<String>(direccion);
    map['telefono'] = Variable<String>(telefono);
    map['email'] = Variable<String>(email);
    map['director'] = Variable<String>(director);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  ColegiosCompanion toCompanion(bool nullToAbsent) {
    return ColegiosCompanion(
      id: Value(id),
      nombre: Value(nombre),
      direccion: Value(direccion),
      telefono: Value(telefono),
      email: Value(email),
      director: Value(director),
      activo: Value(activo),
    );
  }

  factory Colegio.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Colegio(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      direccion: serializer.fromJson<String>(json['direccion']),
      telefono: serializer.fromJson<String>(json['telefono']),
      email: serializer.fromJson<String>(json['email']),
      director: serializer.fromJson<String>(json['director']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'direccion': serializer.toJson<String>(direccion),
      'telefono': serializer.toJson<String>(telefono),
      'email': serializer.toJson<String>(email),
      'director': serializer.toJson<String>(director),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Colegio copyWith(
          {int? id,
          String? nombre,
          String? direccion,
          String? telefono,
          String? email,
          String? director,
          bool? activo}) =>
      Colegio(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        direccion: direccion ?? this.direccion,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
        director: director ?? this.director,
        activo: activo ?? this.activo,
      );
  Colegio copyWithCompanion(ColegiosCompanion data) {
    return Colegio(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      director: data.director.present ? data.director.value : this.director,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Colegio(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('director: $director, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, direccion, telefono, email, director, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Colegio &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.direccion == this.direccion &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.director == this.director &&
          other.activo == this.activo);
}

class ColegiosCompanion extends UpdateCompanion<Colegio> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> direccion;
  final Value<String> telefono;
  final Value<String> email;
  final Value<String> director;
  final Value<bool> activo;
  const ColegiosCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.direccion = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.director = const Value.absent(),
    this.activo = const Value.absent(),
  });
  ColegiosCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String direccion,
    required String telefono,
    required String email,
    required String director,
    this.activo = const Value.absent(),
  })  : nombre = Value(nombre),
        direccion = Value(direccion),
        telefono = Value(telefono),
        email = Value(email),
        director = Value(director);
  static Insertable<Colegio> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? direccion,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? director,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (direccion != null) 'direccion': direccion,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (director != null) 'director': director,
      if (activo != null) 'activo': activo,
    });
  }

  ColegiosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String>? direccion,
      Value<String>? telefono,
      Value<String>? email,
      Value<String>? director,
      Value<bool>? activo}) {
    return ColegiosCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      director: director ?? this.director,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (director.present) {
      map['director'] = Variable<String>(director.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ColegiosCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('director: $director, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $AsignaturasTable extends Asignaturas
    with TableInfo<$AsignaturasTable, Asignatura> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AsignaturasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
      'codigo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _horasMeta = const VerificationMeta('horas');
  @override
  late final GeneratedColumn<int> horas = GeneratedColumn<int>(
      'horas', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _cualitativoMeta =
      const VerificationMeta('cualitativo');
  @override
  late final GeneratedColumn<bool> cualitativo = GeneratedColumn<bool>(
      'cualitativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cualitativo" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nombre, codigo, horas, activo, cualitativo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asignaturas';
  @override
  VerificationContext validateIntegrity(Insertable<Asignatura> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(_codigoMeta,
          codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta));
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('horas')) {
      context.handle(
          _horasMeta, horas.isAcceptableOrUnknown(data['horas']!, _horasMeta));
    } else if (isInserting) {
      context.missing(_horasMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('cualitativo')) {
      context.handle(
          _cualitativoMeta,
          cualitativo.isAcceptableOrUnknown(
              data['cualitativo']!, _cualitativoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {codigo},
      ];
  @override
  Asignatura map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asignatura(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      codigo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}codigo'])!,
      horas: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}horas'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      cualitativo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cualitativo'])!,
    );
  }

  @override
  $AsignaturasTable createAlias(String alias) {
    return $AsignaturasTable(attachedDatabase, alias);
  }
}

class Asignatura extends DataClass implements Insertable<Asignatura> {
  final int id;
  final String nombre;
  final String codigo;
  final int horas;
  final bool activo;
  final bool cualitativo;
  const Asignatura(
      {required this.id,
      required this.nombre,
      required this.codigo,
      required this.horas,
      required this.activo,
      required this.cualitativo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['horas'] = Variable<int>(horas);
    map['activo'] = Variable<bool>(activo);
    map['cualitativo'] = Variable<bool>(cualitativo);
    return map;
  }

  AsignaturasCompanion toCompanion(bool nullToAbsent) {
    return AsignaturasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      horas: Value(horas),
      activo: Value(activo),
      cualitativo: Value(cualitativo),
    );
  }

  factory Asignatura.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asignatura(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      horas: serializer.fromJson<int>(json['horas']),
      activo: serializer.fromJson<bool>(json['activo']),
      cualitativo: serializer.fromJson<bool>(json['cualitativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'horas': serializer.toJson<int>(horas),
      'activo': serializer.toJson<bool>(activo),
      'cualitativo': serializer.toJson<bool>(cualitativo),
    };
  }

  Asignatura copyWith(
          {int? id,
          String? nombre,
          String? codigo,
          int? horas,
          bool? activo,
          bool? cualitativo}) =>
      Asignatura(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
        horas: horas ?? this.horas,
        activo: activo ?? this.activo,
        cualitativo: cualitativo ?? this.cualitativo,
      );
  Asignatura copyWithCompanion(AsignaturasCompanion data) {
    return Asignatura(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      horas: data.horas.present ? data.horas.value : this.horas,
      activo: data.activo.present ? data.activo.value : this.activo,
      cualitativo:
          data.cualitativo.present ? data.cualitativo.value : this.cualitativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asignatura(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('horas: $horas, ')
          ..write('activo: $activo, ')
          ..write('cualitativo: $cualitativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nombre, codigo, horas, activo, cualitativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asignatura &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.horas == this.horas &&
          other.activo == this.activo &&
          other.cualitativo == this.cualitativo);
}

class AsignaturasCompanion extends UpdateCompanion<Asignatura> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<int> horas;
  final Value<bool> activo;
  final Value<bool> cualitativo;
  const AsignaturasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.horas = const Value.absent(),
    this.activo = const Value.absent(),
    this.cualitativo = const Value.absent(),
  });
  AsignaturasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String codigo,
    required int horas,
    this.activo = const Value.absent(),
    this.cualitativo = const Value.absent(),
  })  : nombre = Value(nombre),
        codigo = Value(codigo),
        horas = Value(horas);
  static Insertable<Asignatura> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<int>? horas,
    Expression<bool>? activo,
    Expression<bool>? cualitativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (horas != null) 'horas': horas,
      if (activo != null) 'activo': activo,
      if (cualitativo != null) 'cualitativo': cualitativo,
    });
  }

  AsignaturasCompanion copyWith(
      {Value<int>? id,
      Value<String>? nombre,
      Value<String>? codigo,
      Value<int>? horas,
      Value<bool>? activo,
      Value<bool>? cualitativo}) {
    return AsignaturasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      horas: horas ?? this.horas,
      activo: activo ?? this.activo,
      cualitativo: cualitativo ?? this.cualitativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (horas.present) {
      map['horas'] = Variable<int>(horas.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (cualitativo.present) {
      map['cualitativo'] = Variable<bool>(cualitativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AsignaturasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('horas: $horas, ')
          ..write('activo: $activo, ')
          ..write('cualitativo: $cualitativo')
          ..write(')'))
        .toString();
  }
}

class $GradosTable extends Grados with TableInfo<$GradosTable, Grado> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GradosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
      'numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _cualitativoMeta =
      const VerificationMeta('cualitativo');
  @override
  late final GeneratedColumn<bool> cualitativo = GeneratedColumn<bool>(
      'cualitativo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cualitativo" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, numero, nombre, activo, cualitativo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grados';
  @override
  VerificationContext validateIntegrity(Insertable<Grado> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    if (data.containsKey('cualitativo')) {
      context.handle(
          _cualitativoMeta,
          cualitativo.isAcceptableOrUnknown(
              data['cualitativo']!, _cualitativoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Grado map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Grado(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
      cualitativo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cualitativo'])!,
    );
  }

  @override
  $GradosTable createAlias(String alias) {
    return $GradosTable(attachedDatabase, alias);
  }
}

class Grado extends DataClass implements Insertable<Grado> {
  final int id;
  final int numero;
  final String nombre;
  final bool activo;
  final bool cualitativo;
  const Grado(
      {required this.id,
      required this.numero,
      required this.nombre,
      required this.activo,
      required this.cualitativo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['numero'] = Variable<int>(numero);
    map['nombre'] = Variable<String>(nombre);
    map['activo'] = Variable<bool>(activo);
    map['cualitativo'] = Variable<bool>(cualitativo);
    return map;
  }

  GradosCompanion toCompanion(bool nullToAbsent) {
    return GradosCompanion(
      id: Value(id),
      numero: Value(numero),
      nombre: Value(nombre),
      activo: Value(activo),
      cualitativo: Value(cualitativo),
    );
  }

  factory Grado.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Grado(
      id: serializer.fromJson<int>(json['id']),
      numero: serializer.fromJson<int>(json['numero']),
      nombre: serializer.fromJson<String>(json['nombre']),
      activo: serializer.fromJson<bool>(json['activo']),
      cualitativo: serializer.fromJson<bool>(json['cualitativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'numero': serializer.toJson<int>(numero),
      'nombre': serializer.toJson<String>(nombre),
      'activo': serializer.toJson<bool>(activo),
      'cualitativo': serializer.toJson<bool>(cualitativo),
    };
  }

  Grado copyWith(
          {int? id,
          int? numero,
          String? nombre,
          bool? activo,
          bool? cualitativo}) =>
      Grado(
        id: id ?? this.id,
        numero: numero ?? this.numero,
        nombre: nombre ?? this.nombre,
        activo: activo ?? this.activo,
        cualitativo: cualitativo ?? this.cualitativo,
      );
  Grado copyWithCompanion(GradosCompanion data) {
    return Grado(
      id: data.id.present ? data.id.value : this.id,
      numero: data.numero.present ? data.numero.value : this.numero,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      activo: data.activo.present ? data.activo.value : this.activo,
      cualitativo:
          data.cualitativo.present ? data.cualitativo.value : this.cualitativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Grado(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo, ')
          ..write('cualitativo: $cualitativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, numero, nombre, activo, cualitativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Grado &&
          other.id == this.id &&
          other.numero == this.numero &&
          other.nombre == this.nombre &&
          other.activo == this.activo &&
          other.cualitativo == this.cualitativo);
}

class GradosCompanion extends UpdateCompanion<Grado> {
  final Value<int> id;
  final Value<int> numero;
  final Value<String> nombre;
  final Value<bool> activo;
  final Value<bool> cualitativo;
  const GradosCompanion({
    this.id = const Value.absent(),
    this.numero = const Value.absent(),
    this.nombre = const Value.absent(),
    this.activo = const Value.absent(),
    this.cualitativo = const Value.absent(),
  });
  GradosCompanion.insert({
    this.id = const Value.absent(),
    required int numero,
    required String nombre,
    this.activo = const Value.absent(),
    this.cualitativo = const Value.absent(),
  })  : numero = Value(numero),
        nombre = Value(nombre);
  static Insertable<Grado> custom({
    Expression<int>? id,
    Expression<int>? numero,
    Expression<String>? nombre,
    Expression<bool>? activo,
    Expression<bool>? cualitativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (numero != null) 'numero': numero,
      if (nombre != null) 'nombre': nombre,
      if (activo != null) 'activo': activo,
      if (cualitativo != null) 'cualitativo': cualitativo,
    });
  }

  GradosCompanion copyWith(
      {Value<int>? id,
      Value<int>? numero,
      Value<String>? nombre,
      Value<bool>? activo,
      Value<bool>? cualitativo}) {
    return GradosCompanion(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
      cualitativo: cualitativo ?? this.cualitativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (cualitativo.present) {
      map['cualitativo'] = Variable<bool>(cualitativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GradosCompanion(')
          ..write('id: $id, ')
          ..write('numero: $numero, ')
          ..write('nombre: $nombre, ')
          ..write('activo: $activo, ')
          ..write('cualitativo: $cualitativo')
          ..write(')'))
        .toString();
  }
}

class $SeccionesTable extends Secciones
    with TableInfo<$SeccionesTable, Seccione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeccionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _letraMeta = const VerificationMeta('letra');
  @override
  late final GeneratedColumn<String> letra = GeneratedColumn<String>(
      'letra', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, letra, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'secciones';
  @override
  VerificationContext validateIntegrity(Insertable<Seccione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('letra')) {
      context.handle(
          _letraMeta, letra.isAcceptableOrUnknown(data['letra']!, _letraMeta));
    } else if (isInserting) {
      context.missing(_letraMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {letra},
      ];
  @override
  Seccione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Seccione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      letra: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}letra'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $SeccionesTable createAlias(String alias) {
    return $SeccionesTable(attachedDatabase, alias);
  }
}

class Seccione extends DataClass implements Insertable<Seccione> {
  final int id;
  final String letra;
  final bool activo;
  const Seccione({required this.id, required this.letra, required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['letra'] = Variable<String>(letra);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  SeccionesCompanion toCompanion(bool nullToAbsent) {
    return SeccionesCompanion(
      id: Value(id),
      letra: Value(letra),
      activo: Value(activo),
    );
  }

  factory Seccione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Seccione(
      id: serializer.fromJson<int>(json['id']),
      letra: serializer.fromJson<String>(json['letra']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'letra': serializer.toJson<String>(letra),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Seccione copyWith({int? id, String? letra, bool? activo}) => Seccione(
        id: id ?? this.id,
        letra: letra ?? this.letra,
        activo: activo ?? this.activo,
      );
  Seccione copyWithCompanion(SeccionesCompanion data) {
    return Seccione(
      id: data.id.present ? data.id.value : this.id,
      letra: data.letra.present ? data.letra.value : this.letra,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Seccione(')
          ..write('id: $id, ')
          ..write('letra: $letra, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, letra, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Seccione &&
          other.id == this.id &&
          other.letra == this.letra &&
          other.activo == this.activo);
}

class SeccionesCompanion extends UpdateCompanion<Seccione> {
  final Value<int> id;
  final Value<String> letra;
  final Value<bool> activo;
  const SeccionesCompanion({
    this.id = const Value.absent(),
    this.letra = const Value.absent(),
    this.activo = const Value.absent(),
  });
  SeccionesCompanion.insert({
    this.id = const Value.absent(),
    required String letra,
    this.activo = const Value.absent(),
  }) : letra = Value(letra);
  static Insertable<Seccione> custom({
    Expression<int>? id,
    Expression<String>? letra,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (letra != null) 'letra': letra,
      if (activo != null) 'activo': activo,
    });
  }

  SeccionesCompanion copyWith(
      {Value<int>? id, Value<String>? letra, Value<bool>? activo}) {
    return SeccionesCompanion(
      id: id ?? this.id,
      letra: letra ?? this.letra,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (letra.present) {
      map['letra'] = Variable<String>(letra.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeccionesCompanion(')
          ..write('id: $id, ')
          ..write('letra: $letra, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $CortesEvaluativosTable extends CortesEvaluativos
    with TableInfo<$CortesEvaluativosTable, CortesEvaluativo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CortesEvaluativosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _anioLectivoIdMeta =
      const VerificationMeta('anioLectivoId');
  @override
  late final GeneratedColumn<int> anioLectivoId = GeneratedColumn<int>(
      'anio_lectivo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES anos_lectivos (id)'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
      'numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
      'nombre', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puntosTotalesMeta =
      const VerificationMeta('puntosTotales');
  @override
  late final GeneratedColumn<int> puntosTotales = GeneratedColumn<int>(
      'puntos_totales', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(100));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, anioLectivoId, numero, nombre, puntosTotales, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cortes_evaluativos';
  @override
  VerificationContext validateIntegrity(Insertable<CortesEvaluativo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anio_lectivo_id')) {
      context.handle(
          _anioLectivoIdMeta,
          anioLectivoId.isAcceptableOrUnknown(
              data['anio_lectivo_id']!, _anioLectivoIdMeta));
    } else if (isInserting) {
      context.missing(_anioLectivoIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(_nombreMeta,
          nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta));
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('puntos_totales')) {
      context.handle(
          _puntosTotalesMeta,
          puntosTotales.isAcceptableOrUnknown(
              data['puntos_totales']!, _puntosTotalesMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {anioLectivoId, numero},
      ];
  @override
  CortesEvaluativo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CortesEvaluativo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      anioLectivoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio_lectivo_id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero'])!,
      nombre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nombre'])!,
      puntosTotales: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}puntos_totales'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $CortesEvaluativosTable createAlias(String alias) {
    return $CortesEvaluativosTable(attachedDatabase, alias);
  }
}

class CortesEvaluativo extends DataClass
    implements Insertable<CortesEvaluativo> {
  final int id;
  final int anioLectivoId;
  final int numero;
  final String nombre;
  final int puntosTotales;
  final bool activo;
  const CortesEvaluativo(
      {required this.id,
      required this.anioLectivoId,
      required this.numero,
      required this.nombre,
      required this.puntosTotales,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anio_lectivo_id'] = Variable<int>(anioLectivoId);
    map['numero'] = Variable<int>(numero);
    map['nombre'] = Variable<String>(nombre);
    map['puntos_totales'] = Variable<int>(puntosTotales);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  CortesEvaluativosCompanion toCompanion(bool nullToAbsent) {
    return CortesEvaluativosCompanion(
      id: Value(id),
      anioLectivoId: Value(anioLectivoId),
      numero: Value(numero),
      nombre: Value(nombre),
      puntosTotales: Value(puntosTotales),
      activo: Value(activo),
    );
  }

  factory CortesEvaluativo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CortesEvaluativo(
      id: serializer.fromJson<int>(json['id']),
      anioLectivoId: serializer.fromJson<int>(json['anioLectivoId']),
      numero: serializer.fromJson<int>(json['numero']),
      nombre: serializer.fromJson<String>(json['nombre']),
      puntosTotales: serializer.fromJson<int>(json['puntosTotales']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'anioLectivoId': serializer.toJson<int>(anioLectivoId),
      'numero': serializer.toJson<int>(numero),
      'nombre': serializer.toJson<String>(nombre),
      'puntosTotales': serializer.toJson<int>(puntosTotales),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  CortesEvaluativo copyWith(
          {int? id,
          int? anioLectivoId,
          int? numero,
          String? nombre,
          int? puntosTotales,
          bool? activo}) =>
      CortesEvaluativo(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        numero: numero ?? this.numero,
        nombre: nombre ?? this.nombre,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
      );
  CortesEvaluativo copyWithCompanion(CortesEvaluativosCompanion data) {
    return CortesEvaluativo(
      id: data.id.present ? data.id.value : this.id,
      anioLectivoId: data.anioLectivoId.present
          ? data.anioLectivoId.value
          : this.anioLectivoId,
      numero: data.numero.present ? data.numero.value : this.numero,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      puntosTotales: data.puntosTotales.present
          ? data.puntosTotales.value
          : this.puntosTotales,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CortesEvaluativo(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('numero: $numero, ')
          ..write('nombre: $nombre, ')
          ..write('puntosTotales: $puntosTotales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, anioLectivoId, numero, nombre, puntosTotales, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CortesEvaluativo &&
          other.id == this.id &&
          other.anioLectivoId == this.anioLectivoId &&
          other.numero == this.numero &&
          other.nombre == this.nombre &&
          other.puntosTotales == this.puntosTotales &&
          other.activo == this.activo);
}

class CortesEvaluativosCompanion extends UpdateCompanion<CortesEvaluativo> {
  final Value<int> id;
  final Value<int> anioLectivoId;
  final Value<int> numero;
  final Value<String> nombre;
  final Value<int> puntosTotales;
  final Value<bool> activo;
  const CortesEvaluativosCompanion({
    this.id = const Value.absent(),
    this.anioLectivoId = const Value.absent(),
    this.numero = const Value.absent(),
    this.nombre = const Value.absent(),
    this.puntosTotales = const Value.absent(),
    this.activo = const Value.absent(),
  });
  CortesEvaluativosCompanion.insert({
    this.id = const Value.absent(),
    required int anioLectivoId,
    required int numero,
    required String nombre,
    this.puntosTotales = const Value.absent(),
    this.activo = const Value.absent(),
  })  : anioLectivoId = Value(anioLectivoId),
        numero = Value(numero),
        nombre = Value(nombre);
  static Insertable<CortesEvaluativo> custom({
    Expression<int>? id,
    Expression<int>? anioLectivoId,
    Expression<int>? numero,
    Expression<String>? nombre,
    Expression<int>? puntosTotales,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anioLectivoId != null) 'anio_lectivo_id': anioLectivoId,
      if (numero != null) 'numero': numero,
      if (nombre != null) 'nombre': nombre,
      if (puntosTotales != null) 'puntos_totales': puntosTotales,
      if (activo != null) 'activo': activo,
    });
  }

  CortesEvaluativosCompanion copyWith(
      {Value<int>? id,
      Value<int>? anioLectivoId,
      Value<int>? numero,
      Value<String>? nombre,
      Value<int>? puntosTotales,
      Value<bool>? activo}) {
    return CortesEvaluativosCompanion(
      id: id ?? this.id,
      anioLectivoId: anioLectivoId ?? this.anioLectivoId,
      numero: numero ?? this.numero,
      nombre: nombre ?? this.nombre,
      puntosTotales: puntosTotales ?? this.puntosTotales,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (anioLectivoId.present) {
      map['anio_lectivo_id'] = Variable<int>(anioLectivoId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (puntosTotales.present) {
      map['puntos_totales'] = Variable<int>(puntosTotales.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CortesEvaluativosCompanion(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('numero: $numero, ')
          ..write('nombre: $nombre, ')
          ..write('puntosTotales: $puntosTotales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $IndicadoresEvaluacionTable extends IndicadoresEvaluacion
    with TableInfo<$IndicadoresEvaluacionTable, IndicadoresEvaluacionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IndicadoresEvaluacionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _anioLectivoIdMeta =
      const VerificationMeta('anioLectivoId');
  @override
  late final GeneratedColumn<int> anioLectivoId = GeneratedColumn<int>(
      'anio_lectivo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES anos_lectivos (id)'));
  static const VerificationMeta _corteIdMeta =
      const VerificationMeta('corteId');
  @override
  late final GeneratedColumn<int> corteId = GeneratedColumn<int>(
      'corte_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES cortes_evaluativos (id)'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
      'numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puntosTotalesMeta =
      const VerificationMeta('puntosTotales');
  @override
  late final GeneratedColumn<double> puntosTotales = GeneratedColumn<double>(
      'puntos_totales', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(20.0));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, anioLectivoId, corteId, numero, descripcion, puntosTotales, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'indicadores_evaluacion';
  @override
  VerificationContext validateIntegrity(
      Insertable<IndicadoresEvaluacionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anio_lectivo_id')) {
      context.handle(
          _anioLectivoIdMeta,
          anioLectivoId.isAcceptableOrUnknown(
              data['anio_lectivo_id']!, _anioLectivoIdMeta));
    } else if (isInserting) {
      context.missing(_anioLectivoIdMeta);
    }
    if (data.containsKey('corte_id')) {
      context.handle(_corteIdMeta,
          corteId.isAcceptableOrUnknown(data['corte_id']!, _corteIdMeta));
    } else if (isInserting) {
      context.missing(_corteIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('puntos_totales')) {
      context.handle(
          _puntosTotalesMeta,
          puntosTotales.isAcceptableOrUnknown(
              data['puntos_totales']!, _puntosTotalesMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {anioLectivoId, corteId, numero},
      ];
  @override
  IndicadoresEvaluacionData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IndicadoresEvaluacionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      anioLectivoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio_lectivo_id'])!,
      corteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}corte_id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      puntosTotales: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}puntos_totales'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $IndicadoresEvaluacionTable createAlias(String alias) {
    return $IndicadoresEvaluacionTable(attachedDatabase, alias);
  }
}

class IndicadoresEvaluacionData extends DataClass
    implements Insertable<IndicadoresEvaluacionData> {
  final int id;
  final int anioLectivoId;
  final int corteId;
  final int numero;
  final String descripcion;
  final double puntosTotales;
  final bool activo;
  const IndicadoresEvaluacionData(
      {required this.id,
      required this.anioLectivoId,
      required this.corteId,
      required this.numero,
      required this.descripcion,
      required this.puntosTotales,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anio_lectivo_id'] = Variable<int>(anioLectivoId);
    map['corte_id'] = Variable<int>(corteId);
    map['numero'] = Variable<int>(numero);
    map['descripcion'] = Variable<String>(descripcion);
    map['puntos_totales'] = Variable<double>(puntosTotales);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  IndicadoresEvaluacionCompanion toCompanion(bool nullToAbsent) {
    return IndicadoresEvaluacionCompanion(
      id: Value(id),
      anioLectivoId: Value(anioLectivoId),
      corteId: Value(corteId),
      numero: Value(numero),
      descripcion: Value(descripcion),
      puntosTotales: Value(puntosTotales),
      activo: Value(activo),
    );
  }

  factory IndicadoresEvaluacionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IndicadoresEvaluacionData(
      id: serializer.fromJson<int>(json['id']),
      anioLectivoId: serializer.fromJson<int>(json['anioLectivoId']),
      corteId: serializer.fromJson<int>(json['corteId']),
      numero: serializer.fromJson<int>(json['numero']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      puntosTotales: serializer.fromJson<double>(json['puntosTotales']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'anioLectivoId': serializer.toJson<int>(anioLectivoId),
      'corteId': serializer.toJson<int>(corteId),
      'numero': serializer.toJson<int>(numero),
      'descripcion': serializer.toJson<String>(descripcion),
      'puntosTotales': serializer.toJson<double>(puntosTotales),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  IndicadoresEvaluacionData copyWith(
          {int? id,
          int? anioLectivoId,
          int? corteId,
          int? numero,
          String? descripcion,
          double? puntosTotales,
          bool? activo}) =>
      IndicadoresEvaluacionData(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        corteId: corteId ?? this.corteId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
      );
  IndicadoresEvaluacionData copyWithCompanion(
      IndicadoresEvaluacionCompanion data) {
    return IndicadoresEvaluacionData(
      id: data.id.present ? data.id.value : this.id,
      anioLectivoId: data.anioLectivoId.present
          ? data.anioLectivoId.value
          : this.anioLectivoId,
      corteId: data.corteId.present ? data.corteId.value : this.corteId,
      numero: data.numero.present ? data.numero.value : this.numero,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      puntosTotales: data.puntosTotales.present
          ? data.puntosTotales.value
          : this.puntosTotales,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IndicadoresEvaluacionData(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('corteId: $corteId, ')
          ..write('numero: $numero, ')
          ..write('descripcion: $descripcion, ')
          ..write('puntosTotales: $puntosTotales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, anioLectivoId, corteId, numero, descripcion, puntosTotales, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IndicadoresEvaluacionData &&
          other.id == this.id &&
          other.anioLectivoId == this.anioLectivoId &&
          other.corteId == this.corteId &&
          other.numero == this.numero &&
          other.descripcion == this.descripcion &&
          other.puntosTotales == this.puntosTotales &&
          other.activo == this.activo);
}

class IndicadoresEvaluacionCompanion
    extends UpdateCompanion<IndicadoresEvaluacionData> {
  final Value<int> id;
  final Value<int> anioLectivoId;
  final Value<int> corteId;
  final Value<int> numero;
  final Value<String> descripcion;
  final Value<double> puntosTotales;
  final Value<bool> activo;
  const IndicadoresEvaluacionCompanion({
    this.id = const Value.absent(),
    this.anioLectivoId = const Value.absent(),
    this.corteId = const Value.absent(),
    this.numero = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.puntosTotales = const Value.absent(),
    this.activo = const Value.absent(),
  });
  IndicadoresEvaluacionCompanion.insert({
    this.id = const Value.absent(),
    required int anioLectivoId,
    required int corteId,
    required int numero,
    required String descripcion,
    this.puntosTotales = const Value.absent(),
    this.activo = const Value.absent(),
  })  : anioLectivoId = Value(anioLectivoId),
        corteId = Value(corteId),
        numero = Value(numero),
        descripcion = Value(descripcion);
  static Insertable<IndicadoresEvaluacionData> custom({
    Expression<int>? id,
    Expression<int>? anioLectivoId,
    Expression<int>? corteId,
    Expression<int>? numero,
    Expression<String>? descripcion,
    Expression<double>? puntosTotales,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anioLectivoId != null) 'anio_lectivo_id': anioLectivoId,
      if (corteId != null) 'corte_id': corteId,
      if (numero != null) 'numero': numero,
      if (descripcion != null) 'descripcion': descripcion,
      if (puntosTotales != null) 'puntos_totales': puntosTotales,
      if (activo != null) 'activo': activo,
    });
  }

  IndicadoresEvaluacionCompanion copyWith(
      {Value<int>? id,
      Value<int>? anioLectivoId,
      Value<int>? corteId,
      Value<int>? numero,
      Value<String>? descripcion,
      Value<double>? puntosTotales,
      Value<bool>? activo}) {
    return IndicadoresEvaluacionCompanion(
      id: id ?? this.id,
      anioLectivoId: anioLectivoId ?? this.anioLectivoId,
      corteId: corteId ?? this.corteId,
      numero: numero ?? this.numero,
      descripcion: descripcion ?? this.descripcion,
      puntosTotales: puntosTotales ?? this.puntosTotales,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (anioLectivoId.present) {
      map['anio_lectivo_id'] = Variable<int>(anioLectivoId.value);
    }
    if (corteId.present) {
      map['corte_id'] = Variable<int>(corteId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (puntosTotales.present) {
      map['puntos_totales'] = Variable<double>(puntosTotales.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IndicadoresEvaluacionCompanion(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('corteId: $corteId, ')
          ..write('numero: $numero, ')
          ..write('descripcion: $descripcion, ')
          ..write('puntosTotales: $puntosTotales, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $CriteriosEvaluacionTable extends CriteriosEvaluacion
    with TableInfo<$CriteriosEvaluacionTable, CriteriosEvaluacionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CriteriosEvaluacionTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _anioLectivoIdMeta =
      const VerificationMeta('anioLectivoId');
  @override
  late final GeneratedColumn<int> anioLectivoId = GeneratedColumn<int>(
      'anio_lectivo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES anos_lectivos (id)'));
  static const VerificationMeta _indicadorIdMeta =
      const VerificationMeta('indicadorId');
  @override
  late final GeneratedColumn<int> indicadorId = GeneratedColumn<int>(
      'indicador_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES indicadores_evaluacion (id)'));
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
      'numero', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descripcionMeta =
      const VerificationMeta('descripcion');
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
      'descripcion', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _puntosMaximosMeta =
      const VerificationMeta('puntosMaximos');
  @override
  late final GeneratedColumn<double> puntosMaximos = GeneratedColumn<double>(
      'puntos_maximos', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(8.0));
  static const VerificationMeta _puntosObtenidosMeta =
      const VerificationMeta('puntosObtenidos');
  @override
  late final GeneratedColumn<double> puntosObtenidos = GeneratedColumn<double>(
      'puntos_obtenidos', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        anioLectivoId,
        indicadorId,
        numero,
        descripcion,
        puntosMaximos,
        puntosObtenidos,
        activo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'criterios_evaluacion';
  @override
  VerificationContext validateIntegrity(
      Insertable<CriteriosEvaluacionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anio_lectivo_id')) {
      context.handle(
          _anioLectivoIdMeta,
          anioLectivoId.isAcceptableOrUnknown(
              data['anio_lectivo_id']!, _anioLectivoIdMeta));
    } else if (isInserting) {
      context.missing(_anioLectivoIdMeta);
    }
    if (data.containsKey('indicador_id')) {
      context.handle(
          _indicadorIdMeta,
          indicadorId.isAcceptableOrUnknown(
              data['indicador_id']!, _indicadorIdMeta));
    } else if (isInserting) {
      context.missing(_indicadorIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(_numeroMeta,
          numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta));
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
          _descripcionMeta,
          descripcion.isAcceptableOrUnknown(
              data['descripcion']!, _descripcionMeta));
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('puntos_maximos')) {
      context.handle(
          _puntosMaximosMeta,
          puntosMaximos.isAcceptableOrUnknown(
              data['puntos_maximos']!, _puntosMaximosMeta));
    }
    if (data.containsKey('puntos_obtenidos')) {
      context.handle(
          _puntosObtenidosMeta,
          puntosObtenidos.isAcceptableOrUnknown(
              data['puntos_obtenidos']!, _puntosObtenidosMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {anioLectivoId, indicadorId, numero},
      ];
  @override
  CriteriosEvaluacionData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CriteriosEvaluacionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      anioLectivoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio_lectivo_id'])!,
      indicadorId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}indicador_id'])!,
      numero: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}numero'])!,
      descripcion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descripcion'])!,
      puntosMaximos: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}puntos_maximos'])!,
      puntosObtenidos: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}puntos_obtenidos'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $CriteriosEvaluacionTable createAlias(String alias) {
    return $CriteriosEvaluacionTable(attachedDatabase, alias);
  }
}

class CriteriosEvaluacionData extends DataClass
    implements Insertable<CriteriosEvaluacionData> {
  final int id;
  final int anioLectivoId;
  final int indicadorId;
  final int numero;
  final String descripcion;
  final double puntosMaximos;
  final double puntosObtenidos;
  final bool activo;
  const CriteriosEvaluacionData(
      {required this.id,
      required this.anioLectivoId,
      required this.indicadorId,
      required this.numero,
      required this.descripcion,
      required this.puntosMaximos,
      required this.puntosObtenidos,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anio_lectivo_id'] = Variable<int>(anioLectivoId);
    map['indicador_id'] = Variable<int>(indicadorId);
    map['numero'] = Variable<int>(numero);
    map['descripcion'] = Variable<String>(descripcion);
    map['puntos_maximos'] = Variable<double>(puntosMaximos);
    map['puntos_obtenidos'] = Variable<double>(puntosObtenidos);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  CriteriosEvaluacionCompanion toCompanion(bool nullToAbsent) {
    return CriteriosEvaluacionCompanion(
      id: Value(id),
      anioLectivoId: Value(anioLectivoId),
      indicadorId: Value(indicadorId),
      numero: Value(numero),
      descripcion: Value(descripcion),
      puntosMaximos: Value(puntosMaximos),
      puntosObtenidos: Value(puntosObtenidos),
      activo: Value(activo),
    );
  }

  factory CriteriosEvaluacionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CriteriosEvaluacionData(
      id: serializer.fromJson<int>(json['id']),
      anioLectivoId: serializer.fromJson<int>(json['anioLectivoId']),
      indicadorId: serializer.fromJson<int>(json['indicadorId']),
      numero: serializer.fromJson<int>(json['numero']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      puntosMaximos: serializer.fromJson<double>(json['puntosMaximos']),
      puntosObtenidos: serializer.fromJson<double>(json['puntosObtenidos']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'anioLectivoId': serializer.toJson<int>(anioLectivoId),
      'indicadorId': serializer.toJson<int>(indicadorId),
      'numero': serializer.toJson<int>(numero),
      'descripcion': serializer.toJson<String>(descripcion),
      'puntosMaximos': serializer.toJson<double>(puntosMaximos),
      'puntosObtenidos': serializer.toJson<double>(puntosObtenidos),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  CriteriosEvaluacionData copyWith(
          {int? id,
          int? anioLectivoId,
          int? indicadorId,
          int? numero,
          String? descripcion,
          double? puntosMaximos,
          double? puntosObtenidos,
          bool? activo}) =>
      CriteriosEvaluacionData(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        indicadorId: indicadorId ?? this.indicadorId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosMaximos: puntosMaximos ?? this.puntosMaximos,
        puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
        activo: activo ?? this.activo,
      );
  CriteriosEvaluacionData copyWithCompanion(CriteriosEvaluacionCompanion data) {
    return CriteriosEvaluacionData(
      id: data.id.present ? data.id.value : this.id,
      anioLectivoId: data.anioLectivoId.present
          ? data.anioLectivoId.value
          : this.anioLectivoId,
      indicadorId:
          data.indicadorId.present ? data.indicadorId.value : this.indicadorId,
      numero: data.numero.present ? data.numero.value : this.numero,
      descripcion:
          data.descripcion.present ? data.descripcion.value : this.descripcion,
      puntosMaximos: data.puntosMaximos.present
          ? data.puntosMaximos.value
          : this.puntosMaximos,
      puntosObtenidos: data.puntosObtenidos.present
          ? data.puntosObtenidos.value
          : this.puntosObtenidos,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CriteriosEvaluacionData(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('numero: $numero, ')
          ..write('descripcion: $descripcion, ')
          ..write('puntosMaximos: $puntosMaximos, ')
          ..write('puntosObtenidos: $puntosObtenidos, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, anioLectivoId, indicadorId, numero,
      descripcion, puntosMaximos, puntosObtenidos, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CriteriosEvaluacionData &&
          other.id == this.id &&
          other.anioLectivoId == this.anioLectivoId &&
          other.indicadorId == this.indicadorId &&
          other.numero == this.numero &&
          other.descripcion == this.descripcion &&
          other.puntosMaximos == this.puntosMaximos &&
          other.puntosObtenidos == this.puntosObtenidos &&
          other.activo == this.activo);
}

class CriteriosEvaluacionCompanion
    extends UpdateCompanion<CriteriosEvaluacionData> {
  final Value<int> id;
  final Value<int> anioLectivoId;
  final Value<int> indicadorId;
  final Value<int> numero;
  final Value<String> descripcion;
  final Value<double> puntosMaximos;
  final Value<double> puntosObtenidos;
  final Value<bool> activo;
  const CriteriosEvaluacionCompanion({
    this.id = const Value.absent(),
    this.anioLectivoId = const Value.absent(),
    this.indicadorId = const Value.absent(),
    this.numero = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.puntosMaximos = const Value.absent(),
    this.puntosObtenidos = const Value.absent(),
    this.activo = const Value.absent(),
  });
  CriteriosEvaluacionCompanion.insert({
    this.id = const Value.absent(),
    required int anioLectivoId,
    required int indicadorId,
    required int numero,
    required String descripcion,
    this.puntosMaximos = const Value.absent(),
    this.puntosObtenidos = const Value.absent(),
    this.activo = const Value.absent(),
  })  : anioLectivoId = Value(anioLectivoId),
        indicadorId = Value(indicadorId),
        numero = Value(numero),
        descripcion = Value(descripcion);
  static Insertable<CriteriosEvaluacionData> custom({
    Expression<int>? id,
    Expression<int>? anioLectivoId,
    Expression<int>? indicadorId,
    Expression<int>? numero,
    Expression<String>? descripcion,
    Expression<double>? puntosMaximos,
    Expression<double>? puntosObtenidos,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anioLectivoId != null) 'anio_lectivo_id': anioLectivoId,
      if (indicadorId != null) 'indicador_id': indicadorId,
      if (numero != null) 'numero': numero,
      if (descripcion != null) 'descripcion': descripcion,
      if (puntosMaximos != null) 'puntos_maximos': puntosMaximos,
      if (puntosObtenidos != null) 'puntos_obtenidos': puntosObtenidos,
      if (activo != null) 'activo': activo,
    });
  }

  CriteriosEvaluacionCompanion copyWith(
      {Value<int>? id,
      Value<int>? anioLectivoId,
      Value<int>? indicadorId,
      Value<int>? numero,
      Value<String>? descripcion,
      Value<double>? puntosMaximos,
      Value<double>? puntosObtenidos,
      Value<bool>? activo}) {
    return CriteriosEvaluacionCompanion(
      id: id ?? this.id,
      anioLectivoId: anioLectivoId ?? this.anioLectivoId,
      indicadorId: indicadorId ?? this.indicadorId,
      numero: numero ?? this.numero,
      descripcion: descripcion ?? this.descripcion,
      puntosMaximos: puntosMaximos ?? this.puntosMaximos,
      puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (anioLectivoId.present) {
      map['anio_lectivo_id'] = Variable<int>(anioLectivoId.value);
    }
    if (indicadorId.present) {
      map['indicador_id'] = Variable<int>(indicadorId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (puntosMaximos.present) {
      map['puntos_maximos'] = Variable<double>(puntosMaximos.value);
    }
    if (puntosObtenidos.present) {
      map['puntos_obtenidos'] = Variable<double>(puntosObtenidos.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CriteriosEvaluacionCompanion(')
          ..write('id: $id, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('indicadorId: $indicadorId, ')
          ..write('numero: $numero, ')
          ..write('descripcion: $descripcion, ')
          ..write('puntosMaximos: $puntosMaximos, ')
          ..write('puntosObtenidos: $puntosObtenidos, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $EstudiantesTable extends Estudiantes
    with TableInfo<$EstudiantesTable, Estudiante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EstudiantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _estudianteMeta =
      const VerificationMeta('estudiante');
  @override
  late final GeneratedColumn<String> estudiante = GeneratedColumn<String>(
      'estudiante', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numeroIdentidadMeta =
      const VerificationMeta('numeroIdentidad');
  @override
  late final GeneratedColumn<String> numeroIdentidad = GeneratedColumn<String>(
      'numero_identidad', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _telefonoMeta =
      const VerificationMeta('telefono');
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
      'telefono', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _direccionMeta =
      const VerificationMeta('direccion');
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
      'direccion', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sexoMeta = const VerificationMeta('sexo');
  @override
  late final GeneratedColumn<String> sexo = GeneratedColumn<String>(
      'sexo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        estudiante,
        numeroIdentidad,
        telefono,
        email,
        direccion,
        sexo,
        activo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'estudiantes';
  @override
  VerificationContext validateIntegrity(Insertable<Estudiante> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('estudiante')) {
      context.handle(
          _estudianteMeta,
          estudiante.isAcceptableOrUnknown(
              data['estudiante']!, _estudianteMeta));
    } else if (isInserting) {
      context.missing(_estudianteMeta);
    }
    if (data.containsKey('numero_identidad')) {
      context.handle(
          _numeroIdentidadMeta,
          numeroIdentidad.isAcceptableOrUnknown(
              data['numero_identidad']!, _numeroIdentidadMeta));
    }
    if (data.containsKey('telefono')) {
      context.handle(_telefonoMeta,
          telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('direccion')) {
      context.handle(_direccionMeta,
          direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta));
    }
    if (data.containsKey('sexo')) {
      context.handle(
          _sexoMeta, sexo.isAcceptableOrUnknown(data['sexo']!, _sexoMeta));
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Estudiante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Estudiante(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      estudiante: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}estudiante'])!,
      numeroIdentidad: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}numero_identidad']),
      telefono: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}telefono']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      direccion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direccion']),
      sexo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sexo']),
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $EstudiantesTable createAlias(String alias) {
    return $EstudiantesTable(attachedDatabase, alias);
  }
}

class Estudiante extends DataClass implements Insertable<Estudiante> {
  final int id;
  final String estudiante;
  final String? numeroIdentidad;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? sexo;
  final bool activo;
  const Estudiante(
      {required this.id,
      required this.estudiante,
      this.numeroIdentidad,
      this.telefono,
      this.email,
      this.direccion,
      this.sexo,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['estudiante'] = Variable<String>(estudiante);
    if (!nullToAbsent || numeroIdentidad != null) {
      map['numero_identidad'] = Variable<String>(numeroIdentidad);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || sexo != null) {
      map['sexo'] = Variable<String>(sexo);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  EstudiantesCompanion toCompanion(bool nullToAbsent) {
    return EstudiantesCompanion(
      id: Value(id),
      estudiante: Value(estudiante),
      numeroIdentidad: numeroIdentidad == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroIdentidad),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      sexo: sexo == null && nullToAbsent ? const Value.absent() : Value(sexo),
      activo: Value(activo),
    );
  }

  factory Estudiante.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Estudiante(
      id: serializer.fromJson<int>(json['id']),
      estudiante: serializer.fromJson<String>(json['estudiante']),
      numeroIdentidad: serializer.fromJson<String?>(json['numeroIdentidad']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      sexo: serializer.fromJson<String?>(json['sexo']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estudiante': serializer.toJson<String>(estudiante),
      'numeroIdentidad': serializer.toJson<String?>(numeroIdentidad),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'direccion': serializer.toJson<String?>(direccion),
      'sexo': serializer.toJson<String?>(sexo),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Estudiante copyWith(
          {int? id,
          String? estudiante,
          Value<String?> numeroIdentidad = const Value.absent(),
          Value<String?> telefono = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> direccion = const Value.absent(),
          Value<String?> sexo = const Value.absent(),
          bool? activo}) =>
      Estudiante(
        id: id ?? this.id,
        estudiante: estudiante ?? this.estudiante,
        numeroIdentidad: numeroIdentidad.present
            ? numeroIdentidad.value
            : this.numeroIdentidad,
        telefono: telefono.present ? telefono.value : this.telefono,
        email: email.present ? email.value : this.email,
        direccion: direccion.present ? direccion.value : this.direccion,
        sexo: sexo.present ? sexo.value : this.sexo,
        activo: activo ?? this.activo,
      );
  Estudiante copyWithCompanion(EstudiantesCompanion data) {
    return Estudiante(
      id: data.id.present ? data.id.value : this.id,
      estudiante:
          data.estudiante.present ? data.estudiante.value : this.estudiante,
      numeroIdentidad: data.numeroIdentidad.present
          ? data.numeroIdentidad.value
          : this.numeroIdentidad,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      sexo: data.sexo.present ? data.sexo.value : this.sexo,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Estudiante(')
          ..write('id: $id, ')
          ..write('estudiante: $estudiante, ')
          ..write('numeroIdentidad: $numeroIdentidad, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('sexo: $sexo, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, estudiante, numeroIdentidad, telefono,
      email, direccion, sexo, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Estudiante &&
          other.id == this.id &&
          other.estudiante == this.estudiante &&
          other.numeroIdentidad == this.numeroIdentidad &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.direccion == this.direccion &&
          other.sexo == this.sexo &&
          other.activo == this.activo);
}

class EstudiantesCompanion extends UpdateCompanion<Estudiante> {
  final Value<int> id;
  final Value<String> estudiante;
  final Value<String?> numeroIdentidad;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> direccion;
  final Value<String?> sexo;
  final Value<bool> activo;
  const EstudiantesCompanion({
    this.id = const Value.absent(),
    this.estudiante = const Value.absent(),
    this.numeroIdentidad = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.sexo = const Value.absent(),
    this.activo = const Value.absent(),
  });
  EstudiantesCompanion.insert({
    this.id = const Value.absent(),
    required String estudiante,
    this.numeroIdentidad = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.direccion = const Value.absent(),
    this.sexo = const Value.absent(),
    this.activo = const Value.absent(),
  }) : estudiante = Value(estudiante);
  static Insertable<Estudiante> custom({
    Expression<int>? id,
    Expression<String>? estudiante,
    Expression<String>? numeroIdentidad,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? direccion,
    Expression<String>? sexo,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estudiante != null) 'estudiante': estudiante,
      if (numeroIdentidad != null) 'numero_identidad': numeroIdentidad,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (direccion != null) 'direccion': direccion,
      if (sexo != null) 'sexo': sexo,
      if (activo != null) 'activo': activo,
    });
  }

  EstudiantesCompanion copyWith(
      {Value<int>? id,
      Value<String>? estudiante,
      Value<String?>? numeroIdentidad,
      Value<String?>? telefono,
      Value<String?>? email,
      Value<String?>? direccion,
      Value<String?>? sexo,
      Value<bool>? activo}) {
    return EstudiantesCompanion(
      id: id ?? this.id,
      estudiante: estudiante ?? this.estudiante,
      numeroIdentidad: numeroIdentidad ?? this.numeroIdentidad,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      sexo: sexo ?? this.sexo,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (estudiante.present) {
      map['estudiante'] = Variable<String>(estudiante.value);
    }
    if (numeroIdentidad.present) {
      map['numero_identidad'] = Variable<String>(numeroIdentidad.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (sexo.present) {
      map['sexo'] = Variable<String>(sexo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstudiantesCompanion(')
          ..write('id: $id, ')
          ..write('estudiante: $estudiante, ')
          ..write('numeroIdentidad: $numeroIdentidad, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('direccion: $direccion, ')
          ..write('sexo: $sexo, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $EstudiantesAsignacionesTable extends EstudiantesAsignaciones
    with TableInfo<$EstudiantesAsignacionesTable, EstudiantesAsignacione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EstudiantesAsignacionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _estudianteIdMeta =
      const VerificationMeta('estudianteId');
  @override
  late final GeneratedColumn<int> estudianteId = GeneratedColumn<int>(
      'estudiante_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES estudiantes (id)'));
  static const VerificationMeta _anioLectivoIdMeta =
      const VerificationMeta('anioLectivoId');
  @override
  late final GeneratedColumn<int> anioLectivoId = GeneratedColumn<int>(
      'anio_lectivo_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES anos_lectivos (id)'));
  static const VerificationMeta _colegioIdMeta =
      const VerificationMeta('colegioId');
  @override
  late final GeneratedColumn<int> colegioId = GeneratedColumn<int>(
      'colegio_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES colegios (id)'));
  static const VerificationMeta _asignaturaIdMeta =
      const VerificationMeta('asignaturaId');
  @override
  late final GeneratedColumn<int> asignaturaId = GeneratedColumn<int>(
      'asignatura_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES asignaturas (id)'));
  static const VerificationMeta _gradoIdMeta =
      const VerificationMeta('gradoId');
  @override
  late final GeneratedColumn<int> gradoId = GeneratedColumn<int>(
      'grado_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES grados (id)'));
  static const VerificationMeta _seccionIdMeta =
      const VerificationMeta('seccionId');
  @override
  late final GeneratedColumn<int> seccionId = GeneratedColumn<int>(
      'seccion_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES secciones (id)'));
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
      'activo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("activo" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        estudianteId,
        anioLectivoId,
        colegioId,
        asignaturaId,
        gradoId,
        seccionId,
        activo
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'estudiantes_asignaciones';
  @override
  VerificationContext validateIntegrity(
      Insertable<EstudiantesAsignacione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('estudiante_id')) {
      context.handle(
          _estudianteIdMeta,
          estudianteId.isAcceptableOrUnknown(
              data['estudiante_id']!, _estudianteIdMeta));
    } else if (isInserting) {
      context.missing(_estudianteIdMeta);
    }
    if (data.containsKey('anio_lectivo_id')) {
      context.handle(
          _anioLectivoIdMeta,
          anioLectivoId.isAcceptableOrUnknown(
              data['anio_lectivo_id']!, _anioLectivoIdMeta));
    } else if (isInserting) {
      context.missing(_anioLectivoIdMeta);
    }
    if (data.containsKey('colegio_id')) {
      context.handle(_colegioIdMeta,
          colegioId.isAcceptableOrUnknown(data['colegio_id']!, _colegioIdMeta));
    } else if (isInserting) {
      context.missing(_colegioIdMeta);
    }
    if (data.containsKey('asignatura_id')) {
      context.handle(
          _asignaturaIdMeta,
          asignaturaId.isAcceptableOrUnknown(
              data['asignatura_id']!, _asignaturaIdMeta));
    } else if (isInserting) {
      context.missing(_asignaturaIdMeta);
    }
    if (data.containsKey('grado_id')) {
      context.handle(_gradoIdMeta,
          gradoId.isAcceptableOrUnknown(data['grado_id']!, _gradoIdMeta));
    } else if (isInserting) {
      context.missing(_gradoIdMeta);
    }
    if (data.containsKey('seccion_id')) {
      context.handle(_seccionIdMeta,
          seccionId.isAcceptableOrUnknown(data['seccion_id']!, _seccionIdMeta));
    } else if (isInserting) {
      context.missing(_seccionIdMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(_activoMeta,
          activo.isAcceptableOrUnknown(data['activo']!, _activoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {
          estudianteId,
          anioLectivoId,
          colegioId,
          asignaturaId,
          gradoId,
          seccionId
        },
      ];
  @override
  EstudiantesAsignacione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EstudiantesAsignacione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      estudianteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estudiante_id'])!,
      anioLectivoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}anio_lectivo_id'])!,
      colegioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}colegio_id'])!,
      asignaturaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}asignatura_id'])!,
      gradoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grado_id'])!,
      seccionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}seccion_id'])!,
      activo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}activo'])!,
    );
  }

  @override
  $EstudiantesAsignacionesTable createAlias(String alias) {
    return $EstudiantesAsignacionesTable(attachedDatabase, alias);
  }
}

class EstudiantesAsignacione extends DataClass
    implements Insertable<EstudiantesAsignacione> {
  final int id;
  final int estudianteId;
  final int anioLectivoId;
  final int colegioId;
  final int asignaturaId;
  final int gradoId;
  final int seccionId;
  final bool activo;
  const EstudiantesAsignacione(
      {required this.id,
      required this.estudianteId,
      required this.anioLectivoId,
      required this.colegioId,
      required this.asignaturaId,
      required this.gradoId,
      required this.seccionId,
      required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['estudiante_id'] = Variable<int>(estudianteId);
    map['anio_lectivo_id'] = Variable<int>(anioLectivoId);
    map['colegio_id'] = Variable<int>(colegioId);
    map['asignatura_id'] = Variable<int>(asignaturaId);
    map['grado_id'] = Variable<int>(gradoId);
    map['seccion_id'] = Variable<int>(seccionId);
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  EstudiantesAsignacionesCompanion toCompanion(bool nullToAbsent) {
    return EstudiantesAsignacionesCompanion(
      id: Value(id),
      estudianteId: Value(estudianteId),
      anioLectivoId: Value(anioLectivoId),
      colegioId: Value(colegioId),
      asignaturaId: Value(asignaturaId),
      gradoId: Value(gradoId),
      seccionId: Value(seccionId),
      activo: Value(activo),
    );
  }

  factory EstudiantesAsignacione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EstudiantesAsignacione(
      id: serializer.fromJson<int>(json['id']),
      estudianteId: serializer.fromJson<int>(json['estudianteId']),
      anioLectivoId: serializer.fromJson<int>(json['anioLectivoId']),
      colegioId: serializer.fromJson<int>(json['colegioId']),
      asignaturaId: serializer.fromJson<int>(json['asignaturaId']),
      gradoId: serializer.fromJson<int>(json['gradoId']),
      seccionId: serializer.fromJson<int>(json['seccionId']),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estudianteId': serializer.toJson<int>(estudianteId),
      'anioLectivoId': serializer.toJson<int>(anioLectivoId),
      'colegioId': serializer.toJson<int>(colegioId),
      'asignaturaId': serializer.toJson<int>(asignaturaId),
      'gradoId': serializer.toJson<int>(gradoId),
      'seccionId': serializer.toJson<int>(seccionId),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  EstudiantesAsignacione copyWith(
          {int? id,
          int? estudianteId,
          int? anioLectivoId,
          int? colegioId,
          int? asignaturaId,
          int? gradoId,
          int? seccionId,
          bool? activo}) =>
      EstudiantesAsignacione(
        id: id ?? this.id,
        estudianteId: estudianteId ?? this.estudianteId,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        colegioId: colegioId ?? this.colegioId,
        asignaturaId: asignaturaId ?? this.asignaturaId,
        gradoId: gradoId ?? this.gradoId,
        seccionId: seccionId ?? this.seccionId,
        activo: activo ?? this.activo,
      );
  EstudiantesAsignacione copyWithCompanion(
      EstudiantesAsignacionesCompanion data) {
    return EstudiantesAsignacione(
      id: data.id.present ? data.id.value : this.id,
      estudianteId: data.estudianteId.present
          ? data.estudianteId.value
          : this.estudianteId,
      anioLectivoId: data.anioLectivoId.present
          ? data.anioLectivoId.value
          : this.anioLectivoId,
      colegioId: data.colegioId.present ? data.colegioId.value : this.colegioId,
      asignaturaId: data.asignaturaId.present
          ? data.asignaturaId.value
          : this.asignaturaId,
      gradoId: data.gradoId.present ? data.gradoId.value : this.gradoId,
      seccionId: data.seccionId.present ? data.seccionId.value : this.seccionId,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EstudiantesAsignacione(')
          ..write('id: $id, ')
          ..write('estudianteId: $estudianteId, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('colegioId: $colegioId, ')
          ..write('asignaturaId: $asignaturaId, ')
          ..write('gradoId: $gradoId, ')
          ..write('seccionId: $seccionId, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, estudianteId, anioLectivoId, colegioId,
      asignaturaId, gradoId, seccionId, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EstudiantesAsignacione &&
          other.id == this.id &&
          other.estudianteId == this.estudianteId &&
          other.anioLectivoId == this.anioLectivoId &&
          other.colegioId == this.colegioId &&
          other.asignaturaId == this.asignaturaId &&
          other.gradoId == this.gradoId &&
          other.seccionId == this.seccionId &&
          other.activo == this.activo);
}

class EstudiantesAsignacionesCompanion
    extends UpdateCompanion<EstudiantesAsignacione> {
  final Value<int> id;
  final Value<int> estudianteId;
  final Value<int> anioLectivoId;
  final Value<int> colegioId;
  final Value<int> asignaturaId;
  final Value<int> gradoId;
  final Value<int> seccionId;
  final Value<bool> activo;
  const EstudiantesAsignacionesCompanion({
    this.id = const Value.absent(),
    this.estudianteId = const Value.absent(),
    this.anioLectivoId = const Value.absent(),
    this.colegioId = const Value.absent(),
    this.asignaturaId = const Value.absent(),
    this.gradoId = const Value.absent(),
    this.seccionId = const Value.absent(),
    this.activo = const Value.absent(),
  });
  EstudiantesAsignacionesCompanion.insert({
    this.id = const Value.absent(),
    required int estudianteId,
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
    this.activo = const Value.absent(),
  })  : estudianteId = Value(estudianteId),
        anioLectivoId = Value(anioLectivoId),
        colegioId = Value(colegioId),
        asignaturaId = Value(asignaturaId),
        gradoId = Value(gradoId),
        seccionId = Value(seccionId);
  static Insertable<EstudiantesAsignacione> custom({
    Expression<int>? id,
    Expression<int>? estudianteId,
    Expression<int>? anioLectivoId,
    Expression<int>? colegioId,
    Expression<int>? asignaturaId,
    Expression<int>? gradoId,
    Expression<int>? seccionId,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estudianteId != null) 'estudiante_id': estudianteId,
      if (anioLectivoId != null) 'anio_lectivo_id': anioLectivoId,
      if (colegioId != null) 'colegio_id': colegioId,
      if (asignaturaId != null) 'asignatura_id': asignaturaId,
      if (gradoId != null) 'grado_id': gradoId,
      if (seccionId != null) 'seccion_id': seccionId,
      if (activo != null) 'activo': activo,
    });
  }

  EstudiantesAsignacionesCompanion copyWith(
      {Value<int>? id,
      Value<int>? estudianteId,
      Value<int>? anioLectivoId,
      Value<int>? colegioId,
      Value<int>? asignaturaId,
      Value<int>? gradoId,
      Value<int>? seccionId,
      Value<bool>? activo}) {
    return EstudiantesAsignacionesCompanion(
      id: id ?? this.id,
      estudianteId: estudianteId ?? this.estudianteId,
      anioLectivoId: anioLectivoId ?? this.anioLectivoId,
      colegioId: colegioId ?? this.colegioId,
      asignaturaId: asignaturaId ?? this.asignaturaId,
      gradoId: gradoId ?? this.gradoId,
      seccionId: seccionId ?? this.seccionId,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (estudianteId.present) {
      map['estudiante_id'] = Variable<int>(estudianteId.value);
    }
    if (anioLectivoId.present) {
      map['anio_lectivo_id'] = Variable<int>(anioLectivoId.value);
    }
    if (colegioId.present) {
      map['colegio_id'] = Variable<int>(colegioId.value);
    }
    if (asignaturaId.present) {
      map['asignatura_id'] = Variable<int>(asignaturaId.value);
    }
    if (gradoId.present) {
      map['grado_id'] = Variable<int>(gradoId.value);
    }
    if (seccionId.present) {
      map['seccion_id'] = Variable<int>(seccionId.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EstudiantesAsignacionesCompanion(')
          ..write('id: $id, ')
          ..write('estudianteId: $estudianteId, ')
          ..write('anioLectivoId: $anioLectivoId, ')
          ..write('colegioId: $colegioId, ')
          ..write('asignaturaId: $asignaturaId, ')
          ..write('gradoId: $gradoId, ')
          ..write('seccionId: $seccionId, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $NotasEstudiantesTable extends NotasEstudiantes
    with TableInfo<$NotasEstudiantesTable, NotasEstudiante> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotasEstudiantesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _estudianteIdMeta =
      const VerificationMeta('estudianteId');
  @override
  late final GeneratedColumn<int> estudianteId = GeneratedColumn<int>(
      'estudiante_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES estudiantes (id)'));
  static const VerificationMeta _criterioIdMeta =
      const VerificationMeta('criterioId');
  @override
  late final GeneratedColumn<int> criterioId = GeneratedColumn<int>(
      'criterio_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES criterios_evaluacion (id)'));
  static const VerificationMeta _valorCualitativoMeta =
      const VerificationMeta('valorCualitativo');
  @override
  late final GeneratedColumn<String> valorCualitativo = GeneratedColumn<String>(
      'valor_cualitativo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _puntosObtenidosMeta =
      const VerificationMeta('puntosObtenidos');
  @override
  late final GeneratedColumn<double> puntosObtenidos = GeneratedColumn<double>(
      'puntos_obtenidos', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, estudianteId, criterioId, valorCualitativo, puntosObtenidos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notas_estudiantes';
  @override
  VerificationContext validateIntegrity(Insertable<NotasEstudiante> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('estudiante_id')) {
      context.handle(
          _estudianteIdMeta,
          estudianteId.isAcceptableOrUnknown(
              data['estudiante_id']!, _estudianteIdMeta));
    } else if (isInserting) {
      context.missing(_estudianteIdMeta);
    }
    if (data.containsKey('criterio_id')) {
      context.handle(
          _criterioIdMeta,
          criterioId.isAcceptableOrUnknown(
              data['criterio_id']!, _criterioIdMeta));
    } else if (isInserting) {
      context.missing(_criterioIdMeta);
    }
    if (data.containsKey('valor_cualitativo')) {
      context.handle(
          _valorCualitativoMeta,
          valorCualitativo.isAcceptableOrUnknown(
              data['valor_cualitativo']!, _valorCualitativoMeta));
    }
    if (data.containsKey('puntos_obtenidos')) {
      context.handle(
          _puntosObtenidosMeta,
          puntosObtenidos.isAcceptableOrUnknown(
              data['puntos_obtenidos']!, _puntosObtenidosMeta));
    } else if (isInserting) {
      context.missing(_puntosObtenidosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {estudianteId, criterioId},
      ];
  @override
  NotasEstudiante map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotasEstudiante(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      estudianteId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}estudiante_id'])!,
      criterioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}criterio_id'])!,
      valorCualitativo: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}valor_cualitativo']),
      puntosObtenidos: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}puntos_obtenidos'])!,
    );
  }

  @override
  $NotasEstudiantesTable createAlias(String alias) {
    return $NotasEstudiantesTable(attachedDatabase, alias);
  }
}

class NotasEstudiante extends DataClass implements Insertable<NotasEstudiante> {
  final int id;
  final int estudianteId;
  final int criterioId;
  final String? valorCualitativo;
  final double puntosObtenidos;
  const NotasEstudiante(
      {required this.id,
      required this.estudianteId,
      required this.criterioId,
      this.valorCualitativo,
      required this.puntosObtenidos});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['estudiante_id'] = Variable<int>(estudianteId);
    map['criterio_id'] = Variable<int>(criterioId);
    if (!nullToAbsent || valorCualitativo != null) {
      map['valor_cualitativo'] = Variable<String>(valorCualitativo);
    }
    map['puntos_obtenidos'] = Variable<double>(puntosObtenidos);
    return map;
  }

  NotasEstudiantesCompanion toCompanion(bool nullToAbsent) {
    return NotasEstudiantesCompanion(
      id: Value(id),
      estudianteId: Value(estudianteId),
      criterioId: Value(criterioId),
      valorCualitativo: valorCualitativo == null && nullToAbsent
          ? const Value.absent()
          : Value(valorCualitativo),
      puntosObtenidos: Value(puntosObtenidos),
    );
  }

  factory NotasEstudiante.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotasEstudiante(
      id: serializer.fromJson<int>(json['id']),
      estudianteId: serializer.fromJson<int>(json['estudianteId']),
      criterioId: serializer.fromJson<int>(json['criterioId']),
      valorCualitativo: serializer.fromJson<String?>(json['valorCualitativo']),
      puntosObtenidos: serializer.fromJson<double>(json['puntosObtenidos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'estudianteId': serializer.toJson<int>(estudianteId),
      'criterioId': serializer.toJson<int>(criterioId),
      'valorCualitativo': serializer.toJson<String?>(valorCualitativo),
      'puntosObtenidos': serializer.toJson<double>(puntosObtenidos),
    };
  }

  NotasEstudiante copyWith(
          {int? id,
          int? estudianteId,
          int? criterioId,
          Value<String?> valorCualitativo = const Value.absent(),
          double? puntosObtenidos}) =>
      NotasEstudiante(
        id: id ?? this.id,
        estudianteId: estudianteId ?? this.estudianteId,
        criterioId: criterioId ?? this.criterioId,
        valorCualitativo: valorCualitativo.present
            ? valorCualitativo.value
            : this.valorCualitativo,
        puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
      );
  NotasEstudiante copyWithCompanion(NotasEstudiantesCompanion data) {
    return NotasEstudiante(
      id: data.id.present ? data.id.value : this.id,
      estudianteId: data.estudianteId.present
          ? data.estudianteId.value
          : this.estudianteId,
      criterioId:
          data.criterioId.present ? data.criterioId.value : this.criterioId,
      valorCualitativo: data.valorCualitativo.present
          ? data.valorCualitativo.value
          : this.valorCualitativo,
      puntosObtenidos: data.puntosObtenidos.present
          ? data.puntosObtenidos.value
          : this.puntosObtenidos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotasEstudiante(')
          ..write('id: $id, ')
          ..write('estudianteId: $estudianteId, ')
          ..write('criterioId: $criterioId, ')
          ..write('valorCualitativo: $valorCualitativo, ')
          ..write('puntosObtenidos: $puntosObtenidos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, estudianteId, criterioId, valorCualitativo, puntosObtenidos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotasEstudiante &&
          other.id == this.id &&
          other.estudianteId == this.estudianteId &&
          other.criterioId == this.criterioId &&
          other.valorCualitativo == this.valorCualitativo &&
          other.puntosObtenidos == this.puntosObtenidos);
}

class NotasEstudiantesCompanion extends UpdateCompanion<NotasEstudiante> {
  final Value<int> id;
  final Value<int> estudianteId;
  final Value<int> criterioId;
  final Value<String?> valorCualitativo;
  final Value<double> puntosObtenidos;
  const NotasEstudiantesCompanion({
    this.id = const Value.absent(),
    this.estudianteId = const Value.absent(),
    this.criterioId = const Value.absent(),
    this.valorCualitativo = const Value.absent(),
    this.puntosObtenidos = const Value.absent(),
  });
  NotasEstudiantesCompanion.insert({
    this.id = const Value.absent(),
    required int estudianteId,
    required int criterioId,
    this.valorCualitativo = const Value.absent(),
    required double puntosObtenidos,
  })  : estudianteId = Value(estudianteId),
        criterioId = Value(criterioId),
        puntosObtenidos = Value(puntosObtenidos);
  static Insertable<NotasEstudiante> custom({
    Expression<int>? id,
    Expression<int>? estudianteId,
    Expression<int>? criterioId,
    Expression<String>? valorCualitativo,
    Expression<double>? puntosObtenidos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (estudianteId != null) 'estudiante_id': estudianteId,
      if (criterioId != null) 'criterio_id': criterioId,
      if (valorCualitativo != null) 'valor_cualitativo': valorCualitativo,
      if (puntosObtenidos != null) 'puntos_obtenidos': puntosObtenidos,
    });
  }

  NotasEstudiantesCompanion copyWith(
      {Value<int>? id,
      Value<int>? estudianteId,
      Value<int>? criterioId,
      Value<String?>? valorCualitativo,
      Value<double>? puntosObtenidos}) {
    return NotasEstudiantesCompanion(
      id: id ?? this.id,
      estudianteId: estudianteId ?? this.estudianteId,
      criterioId: criterioId ?? this.criterioId,
      valorCualitativo: valorCualitativo ?? this.valorCualitativo,
      puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (estudianteId.present) {
      map['estudiante_id'] = Variable<int>(estudianteId.value);
    }
    if (criterioId.present) {
      map['criterio_id'] = Variable<int>(criterioId.value);
    }
    if (valorCualitativo.present) {
      map['valor_cualitativo'] = Variable<String>(valorCualitativo.value);
    }
    if (puntosObtenidos.present) {
      map['puntos_obtenidos'] = Variable<double>(puntosObtenidos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotasEstudiantesCompanion(')
          ..write('id: $id, ')
          ..write('estudianteId: $estudianteId, ')
          ..write('criterioId: $criterioId, ')
          ..write('valorCualitativo: $valorCualitativo, ')
          ..write('puntosObtenidos: $puntosObtenidos')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnosLectivosTable anosLectivos = $AnosLectivosTable(this);
  late final $ColegiosTable colegios = $ColegiosTable(this);
  late final $AsignaturasTable asignaturas = $AsignaturasTable(this);
  late final $GradosTable grados = $GradosTable(this);
  late final $SeccionesTable secciones = $SeccionesTable(this);
  late final $CortesEvaluativosTable cortesEvaluativos =
      $CortesEvaluativosTable(this);
  late final $IndicadoresEvaluacionTable indicadoresEvaluacion =
      $IndicadoresEvaluacionTable(this);
  late final $CriteriosEvaluacionTable criteriosEvaluacion =
      $CriteriosEvaluacionTable(this);
  late final $EstudiantesTable estudiantes = $EstudiantesTable(this);
  late final $EstudiantesAsignacionesTable estudiantesAsignaciones =
      $EstudiantesAsignacionesTable(this);
  late final $NotasEstudiantesTable notasEstudiantes =
      $NotasEstudiantesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        anosLectivos,
        colegios,
        asignaturas,
        grados,
        secciones,
        cortesEvaluativos,
        indicadoresEvaluacion,
        criteriosEvaluacion,
        estudiantes,
        estudiantesAsignaciones,
        notasEstudiantes
      ];
}

typedef $$AnosLectivosTableCreateCompanionBuilder = AnosLectivosCompanion
    Function({
  Value<int> id,
  required int anio,
  Value<bool> activo,
  Value<bool> porDefecto,
});
typedef $$AnosLectivosTableUpdateCompanionBuilder = AnosLectivosCompanion
    Function({
  Value<int> id,
  Value<int> anio,
  Value<bool> activo,
  Value<bool> porDefecto,
});

final class $$AnosLectivosTableReferences
    extends BaseReferences<_$AppDatabase, $AnosLectivosTable, AnosLectivo> {
  $$AnosLectivosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CortesEvaluativosTable, List<CortesEvaluativo>>
      _cortesEvaluativosRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.cortesEvaluativos,
              aliasName: $_aliasNameGenerator(
                  db.anosLectivos.id, db.cortesEvaluativos.anioLectivoId));

  $$CortesEvaluativosTableProcessedTableManager get cortesEvaluativosRefs {
    final manager = $$CortesEvaluativosTableTableManager(
            $_db, $_db.cortesEvaluativos)
        .filter((f) => f.anioLectivoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_cortesEvaluativosRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$IndicadoresEvaluacionTable,
      List<IndicadoresEvaluacionData>> _indicadoresEvaluacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.indicadoresEvaluacion,
          aliasName: $_aliasNameGenerator(
              db.anosLectivos.id, db.indicadoresEvaluacion.anioLectivoId));

  $$IndicadoresEvaluacionTableProcessedTableManager
      get indicadoresEvaluacionRefs {
    final manager = $$IndicadoresEvaluacionTableTableManager(
            $_db, $_db.indicadoresEvaluacion)
        .filter((f) => f.anioLectivoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_indicadoresEvaluacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CriteriosEvaluacionTable,
      List<CriteriosEvaluacionData>> _criteriosEvaluacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.criteriosEvaluacion,
          aliasName: $_aliasNameGenerator(
              db.anosLectivos.id, db.criteriosEvaluacion.anioLectivoId));

  $$CriteriosEvaluacionTableProcessedTableManager get criteriosEvaluacionRefs {
    final manager = $$CriteriosEvaluacionTableTableManager(
            $_db, $_db.criteriosEvaluacion)
        .filter((f) => f.anioLectivoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_criteriosEvaluacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.anosLectivos.id, db.estudiantesAsignaciones.anioLectivoId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.anioLectivoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AnosLectivosTableFilterComposer
    extends Composer<_$AppDatabase, $AnosLectivosTable> {
  $$AnosLectivosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get porDefecto => $composableBuilder(
      column: $table.porDefecto, builder: (column) => ColumnFilters(column));

  Expression<bool> cortesEvaluativosRefs(
      Expression<bool> Function($$CortesEvaluativosTableFilterComposer f) f) {
    final $$CortesEvaluativosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.cortesEvaluativos,
        getReferencedColumn: (t) => t.anioLectivoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CortesEvaluativosTableFilterComposer(
              $db: $db,
              $table: $db.cortesEvaluativos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> indicadoresEvaluacionRefs(
      Expression<bool> Function($$IndicadoresEvaluacionTableFilterComposer f)
          f) {
    final $$IndicadoresEvaluacionTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableFilterComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> criteriosEvaluacionRefs(
      Expression<bool> Function($$CriteriosEvaluacionTableFilterComposer f) f) {
    final $$CriteriosEvaluacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.criteriosEvaluacion,
        getReferencedColumn: (t) => t.anioLectivoId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CriteriosEvaluacionTableFilterComposer(
              $db: $db,
              $table: $db.criteriosEvaluacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AnosLectivosTableOrderingComposer
    extends Composer<_$AppDatabase, $AnosLectivosTable> {
  $$AnosLectivosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get anio => $composableBuilder(
      column: $table.anio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get porDefecto => $composableBuilder(
      column: $table.porDefecto, builder: (column) => ColumnOrderings(column));
}

class $$AnosLectivosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnosLectivosTable> {
  $$AnosLectivosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get anio =>
      $composableBuilder(column: $table.anio, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<bool> get porDefecto => $composableBuilder(
      column: $table.porDefecto, builder: (column) => column);

  Expression<T> cortesEvaluativosRefs<T extends Object>(
      Expression<T> Function($$CortesEvaluativosTableAnnotationComposer a) f) {
    final $$CortesEvaluativosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.cortesEvaluativos,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CortesEvaluativosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cortesEvaluativos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> indicadoresEvaluacionRefs<T extends Object>(
      Expression<T> Function($$IndicadoresEvaluacionTableAnnotationComposer a)
          f) {
    final $$IndicadoresEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> criteriosEvaluacionRefs<T extends Object>(
      Expression<T> Function($$CriteriosEvaluacionTableAnnotationComposer a)
          f) {
    final $$CriteriosEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.criteriosEvaluacion,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CriteriosEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.criteriosEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.anioLectivoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AnosLectivosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnosLectivosTable,
    AnosLectivo,
    $$AnosLectivosTableFilterComposer,
    $$AnosLectivosTableOrderingComposer,
    $$AnosLectivosTableAnnotationComposer,
    $$AnosLectivosTableCreateCompanionBuilder,
    $$AnosLectivosTableUpdateCompanionBuilder,
    (AnosLectivo, $$AnosLectivosTableReferences),
    AnosLectivo,
    PrefetchHooks Function(
        {bool cortesEvaluativosRefs,
        bool indicadoresEvaluacionRefs,
        bool criteriosEvaluacionRefs,
        bool estudiantesAsignacionesRefs})> {
  $$AnosLectivosTableTableManager(_$AppDatabase db, $AnosLectivosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnosLectivosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnosLectivosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnosLectivosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> anio = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<bool> porDefecto = const Value.absent(),
          }) =>
              AnosLectivosCompanion(
            id: id,
            anio: anio,
            activo: activo,
            porDefecto: porDefecto,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int anio,
            Value<bool> activo = const Value.absent(),
            Value<bool> porDefecto = const Value.absent(),
          }) =>
              AnosLectivosCompanion.insert(
            id: id,
            anio: anio,
            activo: activo,
            porDefecto: porDefecto,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AnosLectivosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {cortesEvaluativosRefs = false,
              indicadoresEvaluacionRefs = false,
              criteriosEvaluacionRefs = false,
              estudiantesAsignacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cortesEvaluativosRefs) db.cortesEvaluativos,
                if (indicadoresEvaluacionRefs) db.indicadoresEvaluacion,
                if (criteriosEvaluacionRefs) db.criteriosEvaluacion,
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cortesEvaluativosRefs)
                    await $_getPrefetchedData<AnosLectivo, $AnosLectivosTable, CortesEvaluativo>(
                        currentTable: table,
                        referencedTable: $$AnosLectivosTableReferences
                            ._cortesEvaluativosRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnosLectivosTableReferences(db, table, p0)
                                .cortesEvaluativosRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.anioLectivoId == item.id),
                        typedResults: items),
                  if (indicadoresEvaluacionRefs)
                    await $_getPrefetchedData<AnosLectivo, $AnosLectivosTable,
                            IndicadoresEvaluacionData>(
                        currentTable: table,
                        referencedTable: $$AnosLectivosTableReferences
                            ._indicadoresEvaluacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnosLectivosTableReferences(db, table, p0)
                                .indicadoresEvaluacionRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.anioLectivoId == item.id),
                        typedResults: items),
                  if (criteriosEvaluacionRefs)
                    await $_getPrefetchedData<AnosLectivo, $AnosLectivosTable,
                            CriteriosEvaluacionData>(
                        currentTable: table,
                        referencedTable: $$AnosLectivosTableReferences
                            ._criteriosEvaluacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnosLectivosTableReferences(db, table, p0)
                                .criteriosEvaluacionRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.anioLectivoId == item.id),
                        typedResults: items),
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<AnosLectivo, $AnosLectivosTable,
                            EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$AnosLectivosTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AnosLectivosTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.anioLectivoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AnosLectivosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnosLectivosTable,
    AnosLectivo,
    $$AnosLectivosTableFilterComposer,
    $$AnosLectivosTableOrderingComposer,
    $$AnosLectivosTableAnnotationComposer,
    $$AnosLectivosTableCreateCompanionBuilder,
    $$AnosLectivosTableUpdateCompanionBuilder,
    (AnosLectivo, $$AnosLectivosTableReferences),
    AnosLectivo,
    PrefetchHooks Function(
        {bool cortesEvaluativosRefs,
        bool indicadoresEvaluacionRefs,
        bool criteriosEvaluacionRefs,
        bool estudiantesAsignacionesRefs})>;
typedef $$ColegiosTableCreateCompanionBuilder = ColegiosCompanion Function({
  Value<int> id,
  required String nombre,
  required String direccion,
  required String telefono,
  required String email,
  required String director,
  Value<bool> activo,
});
typedef $$ColegiosTableUpdateCompanionBuilder = ColegiosCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> direccion,
  Value<String> telefono,
  Value<String> email,
  Value<String> director,
  Value<bool> activo,
});

final class $$ColegiosTableReferences
    extends BaseReferences<_$AppDatabase, $ColegiosTable, Colegio> {
  $$ColegiosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.colegios.id, db.estudiantesAsignaciones.colegioId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.colegioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ColegiosTableFilterComposer
    extends Composer<_$AppDatabase, $ColegiosTable> {
  $$ColegiosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get director => $composableBuilder(
      column: $table.director, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.colegioId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ColegiosTableOrderingComposer
    extends Composer<_$AppDatabase, $ColegiosTable> {
  $$ColegiosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get director => $composableBuilder(
      column: $table.director, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$ColegiosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ColegiosTable> {
  $$ColegiosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get director =>
      $composableBuilder(column: $table.director, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.colegioId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ColegiosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ColegiosTable,
    Colegio,
    $$ColegiosTableFilterComposer,
    $$ColegiosTableOrderingComposer,
    $$ColegiosTableAnnotationComposer,
    $$ColegiosTableCreateCompanionBuilder,
    $$ColegiosTableUpdateCompanionBuilder,
    (Colegio, $$ColegiosTableReferences),
    Colegio,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})> {
  $$ColegiosTableTableManager(_$AppDatabase db, $ColegiosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ColegiosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ColegiosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ColegiosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> direccion = const Value.absent(),
            Value<String> telefono = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> director = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              ColegiosCompanion(
            id: id,
            nombre: nombre,
            direccion: direccion,
            telefono: telefono,
            email: email,
            director: director,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String direccion,
            required String telefono,
            required String email,
            required String director,
            Value<bool> activo = const Value.absent(),
          }) =>
              ColegiosCompanion.insert(
            id: id,
            nombre: nombre,
            direccion: direccion,
            telefono: telefono,
            email: email,
            director: director,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ColegiosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({estudiantesAsignacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<Colegio, $ColegiosTable,
                            EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$ColegiosTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ColegiosTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.colegioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ColegiosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ColegiosTable,
    Colegio,
    $$ColegiosTableFilterComposer,
    $$ColegiosTableOrderingComposer,
    $$ColegiosTableAnnotationComposer,
    $$ColegiosTableCreateCompanionBuilder,
    $$ColegiosTableUpdateCompanionBuilder,
    (Colegio, $$ColegiosTableReferences),
    Colegio,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})>;
typedef $$AsignaturasTableCreateCompanionBuilder = AsignaturasCompanion
    Function({
  Value<int> id,
  required String nombre,
  required String codigo,
  required int horas,
  Value<bool> activo,
  Value<bool> cualitativo,
});
typedef $$AsignaturasTableUpdateCompanionBuilder = AsignaturasCompanion
    Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> codigo,
  Value<int> horas,
  Value<bool> activo,
  Value<bool> cualitativo,
});

final class $$AsignaturasTableReferences
    extends BaseReferences<_$AppDatabase, $AsignaturasTable, Asignatura> {
  $$AsignaturasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.asignaturas.id, db.estudiantesAsignaciones.asignaturaId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.asignaturaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AsignaturasTableFilterComposer
    extends Composer<_$AppDatabase, $AsignaturasTable> {
  $$AsignaturasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get horas => $composableBuilder(
      column: $table.horas, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => ColumnFilters(column));

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.asignaturaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AsignaturasTableOrderingComposer
    extends Composer<_$AppDatabase, $AsignaturasTable> {
  $$AsignaturasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get codigo => $composableBuilder(
      column: $table.codigo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get horas => $composableBuilder(
      column: $table.horas, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => ColumnOrderings(column));
}

class $$AsignaturasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AsignaturasTable> {
  $$AsignaturasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<int> get horas =>
      $composableBuilder(column: $table.horas, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => column);

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.asignaturaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$AsignaturasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AsignaturasTable,
    Asignatura,
    $$AsignaturasTableFilterComposer,
    $$AsignaturasTableOrderingComposer,
    $$AsignaturasTableAnnotationComposer,
    $$AsignaturasTableCreateCompanionBuilder,
    $$AsignaturasTableUpdateCompanionBuilder,
    (Asignatura, $$AsignaturasTableReferences),
    Asignatura,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})> {
  $$AsignaturasTableTableManager(_$AppDatabase db, $AsignaturasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AsignaturasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AsignaturasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AsignaturasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<String> codigo = const Value.absent(),
            Value<int> horas = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<bool> cualitativo = const Value.absent(),
          }) =>
              AsignaturasCompanion(
            id: id,
            nombre: nombre,
            codigo: codigo,
            horas: horas,
            activo: activo,
            cualitativo: cualitativo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
            required String codigo,
            required int horas,
            Value<bool> activo = const Value.absent(),
            Value<bool> cualitativo = const Value.absent(),
          }) =>
              AsignaturasCompanion.insert(
            id: id,
            nombre: nombre,
            codigo: codigo,
            horas: horas,
            activo: activo,
            cualitativo: cualitativo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AsignaturasTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({estudiantesAsignacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<Asignatura, $AsignaturasTable,
                            EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$AsignaturasTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AsignaturasTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.asignaturaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AsignaturasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AsignaturasTable,
    Asignatura,
    $$AsignaturasTableFilterComposer,
    $$AsignaturasTableOrderingComposer,
    $$AsignaturasTableAnnotationComposer,
    $$AsignaturasTableCreateCompanionBuilder,
    $$AsignaturasTableUpdateCompanionBuilder,
    (Asignatura, $$AsignaturasTableReferences),
    Asignatura,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})>;
typedef $$GradosTableCreateCompanionBuilder = GradosCompanion Function({
  Value<int> id,
  required int numero,
  required String nombre,
  Value<bool> activo,
  Value<bool> cualitativo,
});
typedef $$GradosTableUpdateCompanionBuilder = GradosCompanion Function({
  Value<int> id,
  Value<int> numero,
  Value<String> nombre,
  Value<bool> activo,
  Value<bool> cualitativo,
});

final class $$GradosTableReferences
    extends BaseReferences<_$AppDatabase, $GradosTable, Grado> {
  $$GradosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.grados.id, db.estudiantesAsignaciones.gradoId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.gradoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GradosTableFilterComposer
    extends Composer<_$AppDatabase, $GradosTable> {
  $$GradosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => ColumnFilters(column));

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.gradoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GradosTableOrderingComposer
    extends Composer<_$AppDatabase, $GradosTable> {
  $$GradosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => ColumnOrderings(column));
}

class $$GradosTableAnnotationComposer
    extends Composer<_$AppDatabase, $GradosTable> {
  $$GradosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<bool> get cualitativo => $composableBuilder(
      column: $table.cualitativo, builder: (column) => column);

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.gradoId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$GradosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GradosTable,
    Grado,
    $$GradosTableFilterComposer,
    $$GradosTableOrderingComposer,
    $$GradosTableAnnotationComposer,
    $$GradosTableCreateCompanionBuilder,
    $$GradosTableUpdateCompanionBuilder,
    (Grado, $$GradosTableReferences),
    Grado,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})> {
  $$GradosTableTableManager(_$AppDatabase db, $GradosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GradosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GradosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GradosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> numero = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<bool> activo = const Value.absent(),
            Value<bool> cualitativo = const Value.absent(),
          }) =>
              GradosCompanion(
            id: id,
            numero: numero,
            nombre: nombre,
            activo: activo,
            cualitativo: cualitativo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int numero,
            required String nombre,
            Value<bool> activo = const Value.absent(),
            Value<bool> cualitativo = const Value.absent(),
          }) =>
              GradosCompanion.insert(
            id: id,
            numero: numero,
            nombre: nombre,
            activo: activo,
            cualitativo: cualitativo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GradosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({estudiantesAsignacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<Grado, $GradosTable,
                            EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$GradosTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GradosTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.gradoId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GradosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GradosTable,
    Grado,
    $$GradosTableFilterComposer,
    $$GradosTableOrderingComposer,
    $$GradosTableAnnotationComposer,
    $$GradosTableCreateCompanionBuilder,
    $$GradosTableUpdateCompanionBuilder,
    (Grado, $$GradosTableReferences),
    Grado,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})>;
typedef $$SeccionesTableCreateCompanionBuilder = SeccionesCompanion Function({
  Value<int> id,
  required String letra,
  Value<bool> activo,
});
typedef $$SeccionesTableUpdateCompanionBuilder = SeccionesCompanion Function({
  Value<int> id,
  Value<String> letra,
  Value<bool> activo,
});

final class $$SeccionesTableReferences
    extends BaseReferences<_$AppDatabase, $SeccionesTable, Seccione> {
  $$SeccionesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.secciones.id, db.estudiantesAsignaciones.seccionId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.seccionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SeccionesTableFilterComposer
    extends Composer<_$AppDatabase, $SeccionesTable> {
  $$SeccionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get letra => $composableBuilder(
      column: $table.letra, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.seccionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SeccionesTableOrderingComposer
    extends Composer<_$AppDatabase, $SeccionesTable> {
  $$SeccionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get letra => $composableBuilder(
      column: $table.letra, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$SeccionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeccionesTable> {
  $$SeccionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get letra =>
      $composableBuilder(column: $table.letra, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.seccionId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SeccionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SeccionesTable,
    Seccione,
    $$SeccionesTableFilterComposer,
    $$SeccionesTableOrderingComposer,
    $$SeccionesTableAnnotationComposer,
    $$SeccionesTableCreateCompanionBuilder,
    $$SeccionesTableUpdateCompanionBuilder,
    (Seccione, $$SeccionesTableReferences),
    Seccione,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})> {
  $$SeccionesTableTableManager(_$AppDatabase db, $SeccionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeccionesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeccionesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeccionesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> letra = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              SeccionesCompanion(
            id: id,
            letra: letra,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String letra,
            Value<bool> activo = const Value.absent(),
          }) =>
              SeccionesCompanion.insert(
            id: id,
            letra: letra,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SeccionesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({estudiantesAsignacionesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<Seccione, $SeccionesTable, EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$SeccionesTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SeccionesTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.seccionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SeccionesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SeccionesTable,
    Seccione,
    $$SeccionesTableFilterComposer,
    $$SeccionesTableOrderingComposer,
    $$SeccionesTableAnnotationComposer,
    $$SeccionesTableCreateCompanionBuilder,
    $$SeccionesTableUpdateCompanionBuilder,
    (Seccione, $$SeccionesTableReferences),
    Seccione,
    PrefetchHooks Function({bool estudiantesAsignacionesRefs})>;
typedef $$CortesEvaluativosTableCreateCompanionBuilder
    = CortesEvaluativosCompanion Function({
  Value<int> id,
  required int anioLectivoId,
  required int numero,
  required String nombre,
  Value<int> puntosTotales,
  Value<bool> activo,
});
typedef $$CortesEvaluativosTableUpdateCompanionBuilder
    = CortesEvaluativosCompanion Function({
  Value<int> id,
  Value<int> anioLectivoId,
  Value<int> numero,
  Value<String> nombre,
  Value<int> puntosTotales,
  Value<bool> activo,
});

final class $$CortesEvaluativosTableReferences extends BaseReferences<
    _$AppDatabase, $CortesEvaluativosTable, CortesEvaluativo> {
  $$CortesEvaluativosTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AnosLectivosTable _anioLectivoIdTable(_$AppDatabase db) =>
      db.anosLectivos.createAlias($_aliasNameGenerator(
          db.cortesEvaluativos.anioLectivoId, db.anosLectivos.id));

  $$AnosLectivosTableProcessedTableManager get anioLectivoId {
    final $_column = $_itemColumn<int>('anio_lectivo_id')!;

    final manager = $$AnosLectivosTableTableManager($_db, $_db.anosLectivos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anioLectivoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$IndicadoresEvaluacionTable,
      List<IndicadoresEvaluacionData>> _indicadoresEvaluacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.indicadoresEvaluacion,
          aliasName: $_aliasNameGenerator(
              db.cortesEvaluativos.id, db.indicadoresEvaluacion.corteId));

  $$IndicadoresEvaluacionTableProcessedTableManager
      get indicadoresEvaluacionRefs {
    final manager = $$IndicadoresEvaluacionTableTableManager(
            $_db, $_db.indicadoresEvaluacion)
        .filter((f) => f.corteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_indicadoresEvaluacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CortesEvaluativosTableFilterComposer
    extends Composer<_$AppDatabase, $CortesEvaluativosTable> {
  $$CortesEvaluativosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  $$AnosLectivosTableFilterComposer get anioLectivoId {
    final $$AnosLectivosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableFilterComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> indicadoresEvaluacionRefs(
      Expression<bool> Function($$IndicadoresEvaluacionTableFilterComposer f)
          f) {
    final $$IndicadoresEvaluacionTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.corteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableFilterComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CortesEvaluativosTableOrderingComposer
    extends Composer<_$AppDatabase, $CortesEvaluativosTable> {
  $$CortesEvaluativosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nombre => $composableBuilder(
      column: $table.nombre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  $$AnosLectivosTableOrderingComposer get anioLectivoId {
    final $$AnosLectivosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableOrderingComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CortesEvaluativosTableAnnotationComposer
    extends Composer<_$AppDatabase, $CortesEvaluativosTable> {
  $$CortesEvaluativosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$AnosLectivosTableAnnotationComposer get anioLectivoId {
    final $$AnosLectivosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableAnnotationComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> indicadoresEvaluacionRefs<T extends Object>(
      Expression<T> Function($$IndicadoresEvaluacionTableAnnotationComposer a)
          f) {
    final $$IndicadoresEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.corteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CortesEvaluativosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CortesEvaluativosTable,
    CortesEvaluativo,
    $$CortesEvaluativosTableFilterComposer,
    $$CortesEvaluativosTableOrderingComposer,
    $$CortesEvaluativosTableAnnotationComposer,
    $$CortesEvaluativosTableCreateCompanionBuilder,
    $$CortesEvaluativosTableUpdateCompanionBuilder,
    (CortesEvaluativo, $$CortesEvaluativosTableReferences),
    CortesEvaluativo,
    PrefetchHooks Function(
        {bool anioLectivoId, bool indicadoresEvaluacionRefs})> {
  $$CortesEvaluativosTableTableManager(
      _$AppDatabase db, $CortesEvaluativosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CortesEvaluativosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CortesEvaluativosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CortesEvaluativosTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> anioLectivoId = const Value.absent(),
            Value<int> numero = const Value.absent(),
            Value<String> nombre = const Value.absent(),
            Value<int> puntosTotales = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              CortesEvaluativosCompanion(
            id: id,
            anioLectivoId: anioLectivoId,
            numero: numero,
            nombre: nombre,
            puntosTotales: puntosTotales,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int anioLectivoId,
            required int numero,
            required String nombre,
            Value<int> puntosTotales = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              CortesEvaluativosCompanion.insert(
            id: id,
            anioLectivoId: anioLectivoId,
            numero: numero,
            nombre: nombre,
            puntosTotales: puntosTotales,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CortesEvaluativosTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {anioLectivoId = false, indicadoresEvaluacionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (indicadoresEvaluacionRefs) db.indicadoresEvaluacion
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (anioLectivoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.anioLectivoId,
                    referencedTable: $$CortesEvaluativosTableReferences
                        ._anioLectivoIdTable(db),
                    referencedColumn: $$CortesEvaluativosTableReferences
                        ._anioLectivoIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (indicadoresEvaluacionRefs)
                    await $_getPrefetchedData<CortesEvaluativo,
                            $CortesEvaluativosTable, IndicadoresEvaluacionData>(
                        currentTable: table,
                        referencedTable: $$CortesEvaluativosTableReferences
                            ._indicadoresEvaluacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CortesEvaluativosTableReferences(db, table, p0)
                                .indicadoresEvaluacionRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.corteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CortesEvaluativosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CortesEvaluativosTable,
    CortesEvaluativo,
    $$CortesEvaluativosTableFilterComposer,
    $$CortesEvaluativosTableOrderingComposer,
    $$CortesEvaluativosTableAnnotationComposer,
    $$CortesEvaluativosTableCreateCompanionBuilder,
    $$CortesEvaluativosTableUpdateCompanionBuilder,
    (CortesEvaluativo, $$CortesEvaluativosTableReferences),
    CortesEvaluativo,
    PrefetchHooks Function(
        {bool anioLectivoId, bool indicadoresEvaluacionRefs})>;
typedef $$IndicadoresEvaluacionTableCreateCompanionBuilder
    = IndicadoresEvaluacionCompanion Function({
  Value<int> id,
  required int anioLectivoId,
  required int corteId,
  required int numero,
  required String descripcion,
  Value<double> puntosTotales,
  Value<bool> activo,
});
typedef $$IndicadoresEvaluacionTableUpdateCompanionBuilder
    = IndicadoresEvaluacionCompanion Function({
  Value<int> id,
  Value<int> anioLectivoId,
  Value<int> corteId,
  Value<int> numero,
  Value<String> descripcion,
  Value<double> puntosTotales,
  Value<bool> activo,
});

final class $$IndicadoresEvaluacionTableReferences extends BaseReferences<
    _$AppDatabase, $IndicadoresEvaluacionTable, IndicadoresEvaluacionData> {
  $$IndicadoresEvaluacionTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AnosLectivosTable _anioLectivoIdTable(_$AppDatabase db) =>
      db.anosLectivos.createAlias($_aliasNameGenerator(
          db.indicadoresEvaluacion.anioLectivoId, db.anosLectivos.id));

  $$AnosLectivosTableProcessedTableManager get anioLectivoId {
    final $_column = $_itemColumn<int>('anio_lectivo_id')!;

    final manager = $$AnosLectivosTableTableManager($_db, $_db.anosLectivos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anioLectivoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CortesEvaluativosTable _corteIdTable(_$AppDatabase db) =>
      db.cortesEvaluativos.createAlias($_aliasNameGenerator(
          db.indicadoresEvaluacion.corteId, db.cortesEvaluativos.id));

  $$CortesEvaluativosTableProcessedTableManager get corteId {
    final $_column = $_itemColumn<int>('corte_id')!;

    final manager =
        $$CortesEvaluativosTableTableManager($_db, $_db.cortesEvaluativos)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_corteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CriteriosEvaluacionTable,
      List<CriteriosEvaluacionData>> _criteriosEvaluacionRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.criteriosEvaluacion,
          aliasName: $_aliasNameGenerator(
              db.indicadoresEvaluacion.id, db.criteriosEvaluacion.indicadorId));

  $$CriteriosEvaluacionTableProcessedTableManager get criteriosEvaluacionRefs {
    final manager = $$CriteriosEvaluacionTableTableManager(
            $_db, $_db.criteriosEvaluacion)
        .filter((f) => f.indicadorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_criteriosEvaluacionRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$IndicadoresEvaluacionTableFilterComposer
    extends Composer<_$AppDatabase, $IndicadoresEvaluacionTable> {
  $$IndicadoresEvaluacionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  $$AnosLectivosTableFilterComposer get anioLectivoId {
    final $$AnosLectivosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableFilterComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CortesEvaluativosTableFilterComposer get corteId {
    final $$CortesEvaluativosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.corteId,
        referencedTable: $db.cortesEvaluativos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CortesEvaluativosTableFilterComposer(
              $db: $db,
              $table: $db.cortesEvaluativos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> criteriosEvaluacionRefs(
      Expression<bool> Function($$CriteriosEvaluacionTableFilterComposer f) f) {
    final $$CriteriosEvaluacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.criteriosEvaluacion,
        getReferencedColumn: (t) => t.indicadorId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CriteriosEvaluacionTableFilterComposer(
              $db: $db,
              $table: $db.criteriosEvaluacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$IndicadoresEvaluacionTableOrderingComposer
    extends Composer<_$AppDatabase, $IndicadoresEvaluacionTable> {
  $$IndicadoresEvaluacionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  $$AnosLectivosTableOrderingComposer get anioLectivoId {
    final $$AnosLectivosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableOrderingComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CortesEvaluativosTableOrderingComposer get corteId {
    final $$CortesEvaluativosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.corteId,
        referencedTable: $db.cortesEvaluativos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CortesEvaluativosTableOrderingComposer(
              $db: $db,
              $table: $db.cortesEvaluativos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IndicadoresEvaluacionTableAnnotationComposer
    extends Composer<_$AppDatabase, $IndicadoresEvaluacionTable> {
  $$IndicadoresEvaluacionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get puntosTotales => $composableBuilder(
      column: $table.puntosTotales, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$AnosLectivosTableAnnotationComposer get anioLectivoId {
    final $$AnosLectivosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableAnnotationComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CortesEvaluativosTableAnnotationComposer get corteId {
    final $$CortesEvaluativosTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.corteId,
            referencedTable: $db.cortesEvaluativos,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CortesEvaluativosTableAnnotationComposer(
                  $db: $db,
                  $table: $db.cortesEvaluativos,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> criteriosEvaluacionRefs<T extends Object>(
      Expression<T> Function($$CriteriosEvaluacionTableAnnotationComposer a)
          f) {
    final $$CriteriosEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.criteriosEvaluacion,
            getReferencedColumn: (t) => t.indicadorId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CriteriosEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.criteriosEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$IndicadoresEvaluacionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IndicadoresEvaluacionTable,
    IndicadoresEvaluacionData,
    $$IndicadoresEvaluacionTableFilterComposer,
    $$IndicadoresEvaluacionTableOrderingComposer,
    $$IndicadoresEvaluacionTableAnnotationComposer,
    $$IndicadoresEvaluacionTableCreateCompanionBuilder,
    $$IndicadoresEvaluacionTableUpdateCompanionBuilder,
    (IndicadoresEvaluacionData, $$IndicadoresEvaluacionTableReferences),
    IndicadoresEvaluacionData,
    PrefetchHooks Function(
        {bool anioLectivoId, bool corteId, bool criteriosEvaluacionRefs})> {
  $$IndicadoresEvaluacionTableTableManager(
      _$AppDatabase db, $IndicadoresEvaluacionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IndicadoresEvaluacionTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$IndicadoresEvaluacionTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IndicadoresEvaluacionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> anioLectivoId = const Value.absent(),
            Value<int> corteId = const Value.absent(),
            Value<int> numero = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> puntosTotales = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              IndicadoresEvaluacionCompanion(
            id: id,
            anioLectivoId: anioLectivoId,
            corteId: corteId,
            numero: numero,
            descripcion: descripcion,
            puntosTotales: puntosTotales,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int anioLectivoId,
            required int corteId,
            required int numero,
            required String descripcion,
            Value<double> puntosTotales = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              IndicadoresEvaluacionCompanion.insert(
            id: id,
            anioLectivoId: anioLectivoId,
            corteId: corteId,
            numero: numero,
            descripcion: descripcion,
            puntosTotales: puntosTotales,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IndicadoresEvaluacionTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {anioLectivoId = false,
              corteId = false,
              criteriosEvaluacionRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (criteriosEvaluacionRefs) db.criteriosEvaluacion
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (anioLectivoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.anioLectivoId,
                    referencedTable: $$IndicadoresEvaluacionTableReferences
                        ._anioLectivoIdTable(db),
                    referencedColumn: $$IndicadoresEvaluacionTableReferences
                        ._anioLectivoIdTable(db)
                        .id,
                  ) as T;
                }
                if (corteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.corteId,
                    referencedTable: $$IndicadoresEvaluacionTableReferences
                        ._corteIdTable(db),
                    referencedColumn: $$IndicadoresEvaluacionTableReferences
                        ._corteIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (criteriosEvaluacionRefs)
                    await $_getPrefetchedData<
                            IndicadoresEvaluacionData,
                            $IndicadoresEvaluacionTable,
                            CriteriosEvaluacionData>(
                        currentTable: table,
                        referencedTable: $$IndicadoresEvaluacionTableReferences
                            ._criteriosEvaluacionRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$IndicadoresEvaluacionTableReferences(
                                    db, table, p0)
                                .criteriosEvaluacionRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.indicadorId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$IndicadoresEvaluacionTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $IndicadoresEvaluacionTable,
        IndicadoresEvaluacionData,
        $$IndicadoresEvaluacionTableFilterComposer,
        $$IndicadoresEvaluacionTableOrderingComposer,
        $$IndicadoresEvaluacionTableAnnotationComposer,
        $$IndicadoresEvaluacionTableCreateCompanionBuilder,
        $$IndicadoresEvaluacionTableUpdateCompanionBuilder,
        (IndicadoresEvaluacionData, $$IndicadoresEvaluacionTableReferences),
        IndicadoresEvaluacionData,
        PrefetchHooks Function(
            {bool anioLectivoId, bool corteId, bool criteriosEvaluacionRefs})>;
typedef $$CriteriosEvaluacionTableCreateCompanionBuilder
    = CriteriosEvaluacionCompanion Function({
  Value<int> id,
  required int anioLectivoId,
  required int indicadorId,
  required int numero,
  required String descripcion,
  Value<double> puntosMaximos,
  Value<double> puntosObtenidos,
  Value<bool> activo,
});
typedef $$CriteriosEvaluacionTableUpdateCompanionBuilder
    = CriteriosEvaluacionCompanion Function({
  Value<int> id,
  Value<int> anioLectivoId,
  Value<int> indicadorId,
  Value<int> numero,
  Value<String> descripcion,
  Value<double> puntosMaximos,
  Value<double> puntosObtenidos,
  Value<bool> activo,
});

final class $$CriteriosEvaluacionTableReferences extends BaseReferences<
    _$AppDatabase, $CriteriosEvaluacionTable, CriteriosEvaluacionData> {
  $$CriteriosEvaluacionTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AnosLectivosTable _anioLectivoIdTable(_$AppDatabase db) =>
      db.anosLectivos.createAlias($_aliasNameGenerator(
          db.criteriosEvaluacion.anioLectivoId, db.anosLectivos.id));

  $$AnosLectivosTableProcessedTableManager get anioLectivoId {
    final $_column = $_itemColumn<int>('anio_lectivo_id')!;

    final manager = $$AnosLectivosTableTableManager($_db, $_db.anosLectivos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anioLectivoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $IndicadoresEvaluacionTable _indicadorIdTable(_$AppDatabase db) =>
      db.indicadoresEvaluacion.createAlias($_aliasNameGenerator(
          db.criteriosEvaluacion.indicadorId, db.indicadoresEvaluacion.id));

  $$IndicadoresEvaluacionTableProcessedTableManager get indicadorId {
    final $_column = $_itemColumn<int>('indicador_id')!;

    final manager = $$IndicadoresEvaluacionTableTableManager(
            $_db, $_db.indicadoresEvaluacion)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_indicadorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$NotasEstudiantesTable, List<NotasEstudiante>>
      _notasEstudiantesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.notasEstudiantes,
              aliasName: $_aliasNameGenerator(
                  db.criteriosEvaluacion.id, db.notasEstudiantes.criterioId));

  $$NotasEstudiantesTableProcessedTableManager get notasEstudiantesRefs {
    final manager =
        $$NotasEstudiantesTableTableManager($_db, $_db.notasEstudiantes)
            .filter((f) => f.criterioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_notasEstudiantesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CriteriosEvaluacionTableFilterComposer
    extends Composer<_$AppDatabase, $CriteriosEvaluacionTable> {
  $$CriteriosEvaluacionTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get puntosMaximos => $composableBuilder(
      column: $table.puntosMaximos, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  $$AnosLectivosTableFilterComposer get anioLectivoId {
    final $$AnosLectivosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableFilterComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IndicadoresEvaluacionTableFilterComposer get indicadorId {
    final $$IndicadoresEvaluacionTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.indicadorId,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableFilterComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<bool> notasEstudiantesRefs(
      Expression<bool> Function($$NotasEstudiantesTableFilterComposer f) f) {
    final $$NotasEstudiantesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasEstudiantes,
        getReferencedColumn: (t) => t.criterioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasEstudiantesTableFilterComposer(
              $db: $db,
              $table: $db.notasEstudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CriteriosEvaluacionTableOrderingComposer
    extends Composer<_$AppDatabase, $CriteriosEvaluacionTable> {
  $$CriteriosEvaluacionTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numero => $composableBuilder(
      column: $table.numero, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get puntosMaximos => $composableBuilder(
      column: $table.puntosMaximos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  $$AnosLectivosTableOrderingComposer get anioLectivoId {
    final $$AnosLectivosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableOrderingComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IndicadoresEvaluacionTableOrderingComposer get indicadorId {
    final $$IndicadoresEvaluacionTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.indicadorId,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableOrderingComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$CriteriosEvaluacionTableAnnotationComposer
    extends Composer<_$AppDatabase, $CriteriosEvaluacionTable> {
  $$CriteriosEvaluacionTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
      column: $table.descripcion, builder: (column) => column);

  GeneratedColumn<double> get puntosMaximos => $composableBuilder(
      column: $table.puntosMaximos, builder: (column) => column);

  GeneratedColumn<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$AnosLectivosTableAnnotationComposer get anioLectivoId {
    final $$AnosLectivosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableAnnotationComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$IndicadoresEvaluacionTableAnnotationComposer get indicadorId {
    final $$IndicadoresEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.indicadorId,
            referencedTable: $db.indicadoresEvaluacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$IndicadoresEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.indicadoresEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  Expression<T> notasEstudiantesRefs<T extends Object>(
      Expression<T> Function($$NotasEstudiantesTableAnnotationComposer a) f) {
    final $$NotasEstudiantesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasEstudiantes,
        getReferencedColumn: (t) => t.criterioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasEstudiantesTableAnnotationComposer(
              $db: $db,
              $table: $db.notasEstudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CriteriosEvaluacionTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CriteriosEvaluacionTable,
    CriteriosEvaluacionData,
    $$CriteriosEvaluacionTableFilterComposer,
    $$CriteriosEvaluacionTableOrderingComposer,
    $$CriteriosEvaluacionTableAnnotationComposer,
    $$CriteriosEvaluacionTableCreateCompanionBuilder,
    $$CriteriosEvaluacionTableUpdateCompanionBuilder,
    (CriteriosEvaluacionData, $$CriteriosEvaluacionTableReferences),
    CriteriosEvaluacionData,
    PrefetchHooks Function(
        {bool anioLectivoId, bool indicadorId, bool notasEstudiantesRefs})> {
  $$CriteriosEvaluacionTableTableManager(
      _$AppDatabase db, $CriteriosEvaluacionTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CriteriosEvaluacionTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CriteriosEvaluacionTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CriteriosEvaluacionTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> anioLectivoId = const Value.absent(),
            Value<int> indicadorId = const Value.absent(),
            Value<int> numero = const Value.absent(),
            Value<String> descripcion = const Value.absent(),
            Value<double> puntosMaximos = const Value.absent(),
            Value<double> puntosObtenidos = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              CriteriosEvaluacionCompanion(
            id: id,
            anioLectivoId: anioLectivoId,
            indicadorId: indicadorId,
            numero: numero,
            descripcion: descripcion,
            puntosMaximos: puntosMaximos,
            puntosObtenidos: puntosObtenidos,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int anioLectivoId,
            required int indicadorId,
            required int numero,
            required String descripcion,
            Value<double> puntosMaximos = const Value.absent(),
            Value<double> puntosObtenidos = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              CriteriosEvaluacionCompanion.insert(
            id: id,
            anioLectivoId: anioLectivoId,
            indicadorId: indicadorId,
            numero: numero,
            descripcion: descripcion,
            puntosMaximos: puntosMaximos,
            puntosObtenidos: puntosObtenidos,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CriteriosEvaluacionTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {anioLectivoId = false,
              indicadorId = false,
              notasEstudiantesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (notasEstudiantesRefs) db.notasEstudiantes
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (anioLectivoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.anioLectivoId,
                    referencedTable: $$CriteriosEvaluacionTableReferences
                        ._anioLectivoIdTable(db),
                    referencedColumn: $$CriteriosEvaluacionTableReferences
                        ._anioLectivoIdTable(db)
                        .id,
                  ) as T;
                }
                if (indicadorId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.indicadorId,
                    referencedTable: $$CriteriosEvaluacionTableReferences
                        ._indicadorIdTable(db),
                    referencedColumn: $$CriteriosEvaluacionTableReferences
                        ._indicadorIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (notasEstudiantesRefs)
                    await $_getPrefetchedData<CriteriosEvaluacionData,
                            $CriteriosEvaluacionTable, NotasEstudiante>(
                        currentTable: table,
                        referencedTable: $$CriteriosEvaluacionTableReferences
                            ._notasEstudiantesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CriteriosEvaluacionTableReferences(db, table, p0)
                                .notasEstudiantesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.criterioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CriteriosEvaluacionTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CriteriosEvaluacionTable,
    CriteriosEvaluacionData,
    $$CriteriosEvaluacionTableFilterComposer,
    $$CriteriosEvaluacionTableOrderingComposer,
    $$CriteriosEvaluacionTableAnnotationComposer,
    $$CriteriosEvaluacionTableCreateCompanionBuilder,
    $$CriteriosEvaluacionTableUpdateCompanionBuilder,
    (CriteriosEvaluacionData, $$CriteriosEvaluacionTableReferences),
    CriteriosEvaluacionData,
    PrefetchHooks Function(
        {bool anioLectivoId, bool indicadorId, bool notasEstudiantesRefs})>;
typedef $$EstudiantesTableCreateCompanionBuilder = EstudiantesCompanion
    Function({
  Value<int> id,
  required String estudiante,
  Value<String?> numeroIdentidad,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> direccion,
  Value<String?> sexo,
  Value<bool> activo,
});
typedef $$EstudiantesTableUpdateCompanionBuilder = EstudiantesCompanion
    Function({
  Value<int> id,
  Value<String> estudiante,
  Value<String?> numeroIdentidad,
  Value<String?> telefono,
  Value<String?> email,
  Value<String?> direccion,
  Value<String?> sexo,
  Value<bool> activo,
});

final class $$EstudiantesTableReferences
    extends BaseReferences<_$AppDatabase, $EstudiantesTable, Estudiante> {
  $$EstudiantesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EstudiantesAsignacionesTable,
      List<EstudiantesAsignacione>> _estudiantesAsignacionesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.estudiantesAsignaciones,
          aliasName: $_aliasNameGenerator(
              db.estudiantes.id, db.estudiantesAsignaciones.estudianteId));

  $$EstudiantesAsignacionesTableProcessedTableManager
      get estudiantesAsignacionesRefs {
    final manager = $$EstudiantesAsignacionesTableTableManager(
            $_db, $_db.estudiantesAsignaciones)
        .filter((f) => f.estudianteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_estudiantesAsignacionesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$NotasEstudiantesTable, List<NotasEstudiante>>
      _notasEstudiantesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.notasEstudiantes,
              aliasName: $_aliasNameGenerator(
                  db.estudiantes.id, db.notasEstudiantes.estudianteId));

  $$NotasEstudiantesTableProcessedTableManager get notasEstudiantesRefs {
    final manager = $$NotasEstudiantesTableTableManager(
            $_db, $_db.notasEstudiantes)
        .filter((f) => f.estudianteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_notasEstudiantesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EstudiantesTableFilterComposer
    extends Composer<_$AppDatabase, $EstudiantesTable> {
  $$EstudiantesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get estudiante => $composableBuilder(
      column: $table.estudiante, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get numeroIdentidad => $composableBuilder(
      column: $table.numeroIdentidad,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sexo => $composableBuilder(
      column: $table.sexo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  Expression<bool> estudiantesAsignacionesRefs(
      Expression<bool> Function($$EstudiantesAsignacionesTableFilterComposer f)
          f) {
    final $$EstudiantesAsignacionesTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.estudianteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableFilterComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> notasEstudiantesRefs(
      Expression<bool> Function($$NotasEstudiantesTableFilterComposer f) f) {
    final $$NotasEstudiantesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasEstudiantes,
        getReferencedColumn: (t) => t.estudianteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasEstudiantesTableFilterComposer(
              $db: $db,
              $table: $db.notasEstudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EstudiantesTableOrderingComposer
    extends Composer<_$AppDatabase, $EstudiantesTable> {
  $$EstudiantesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get estudiante => $composableBuilder(
      column: $table.estudiante, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get numeroIdentidad => $composableBuilder(
      column: $table.numeroIdentidad,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get telefono => $composableBuilder(
      column: $table.telefono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direccion => $composableBuilder(
      column: $table.direccion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sexo => $composableBuilder(
      column: $table.sexo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));
}

class $$EstudiantesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EstudiantesTable> {
  $$EstudiantesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get estudiante => $composableBuilder(
      column: $table.estudiante, builder: (column) => column);

  GeneratedColumn<String> get numeroIdentidad => $composableBuilder(
      column: $table.numeroIdentidad, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get sexo =>
      $composableBuilder(column: $table.sexo, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> estudiantesAsignacionesRefs<T extends Object>(
      Expression<T> Function($$EstudiantesAsignacionesTableAnnotationComposer a)
          f) {
    final $$EstudiantesAsignacionesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.estudiantesAsignaciones,
            getReferencedColumn: (t) => t.estudianteId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.estudiantesAsignaciones,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> notasEstudiantesRefs<T extends Object>(
      Expression<T> Function($$NotasEstudiantesTableAnnotationComposer a) f) {
    final $$NotasEstudiantesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.notasEstudiantes,
        getReferencedColumn: (t) => t.estudianteId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NotasEstudiantesTableAnnotationComposer(
              $db: $db,
              $table: $db.notasEstudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EstudiantesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EstudiantesTable,
    Estudiante,
    $$EstudiantesTableFilterComposer,
    $$EstudiantesTableOrderingComposer,
    $$EstudiantesTableAnnotationComposer,
    $$EstudiantesTableCreateCompanionBuilder,
    $$EstudiantesTableUpdateCompanionBuilder,
    (Estudiante, $$EstudiantesTableReferences),
    Estudiante,
    PrefetchHooks Function(
        {bool estudiantesAsignacionesRefs, bool notasEstudiantesRefs})> {
  $$EstudiantesTableTableManager(_$AppDatabase db, $EstudiantesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EstudiantesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EstudiantesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EstudiantesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> estudiante = const Value.absent(),
            Value<String?> numeroIdentidad = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> sexo = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              EstudiantesCompanion(
            id: id,
            estudiante: estudiante,
            numeroIdentidad: numeroIdentidad,
            telefono: telefono,
            email: email,
            direccion: direccion,
            sexo: sexo,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String estudiante,
            Value<String?> numeroIdentidad = const Value.absent(),
            Value<String?> telefono = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> direccion = const Value.absent(),
            Value<String?> sexo = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              EstudiantesCompanion.insert(
            id: id,
            estudiante: estudiante,
            numeroIdentidad: numeroIdentidad,
            telefono: telefono,
            email: email,
            direccion: direccion,
            sexo: sexo,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EstudiantesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {estudiantesAsignacionesRefs = false,
              notasEstudiantesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (estudiantesAsignacionesRefs) db.estudiantesAsignaciones,
                if (notasEstudiantesRefs) db.notasEstudiantes
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (estudiantesAsignacionesRefs)
                    await $_getPrefetchedData<Estudiante, $EstudiantesTable,
                            EstudiantesAsignacione>(
                        currentTable: table,
                        referencedTable: $$EstudiantesTableReferences
                            ._estudiantesAsignacionesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EstudiantesTableReferences(db, table, p0)
                                .estudiantesAsignacionesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.estudianteId == item.id),
                        typedResults: items),
                  if (notasEstudiantesRefs)
                    await $_getPrefetchedData<Estudiante, $EstudiantesTable,
                            NotasEstudiante>(
                        currentTable: table,
                        referencedTable: $$EstudiantesTableReferences
                            ._notasEstudiantesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EstudiantesTableReferences(db, table, p0)
                                .notasEstudiantesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.estudianteId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EstudiantesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EstudiantesTable,
    Estudiante,
    $$EstudiantesTableFilterComposer,
    $$EstudiantesTableOrderingComposer,
    $$EstudiantesTableAnnotationComposer,
    $$EstudiantesTableCreateCompanionBuilder,
    $$EstudiantesTableUpdateCompanionBuilder,
    (Estudiante, $$EstudiantesTableReferences),
    Estudiante,
    PrefetchHooks Function(
        {bool estudiantesAsignacionesRefs, bool notasEstudiantesRefs})>;
typedef $$EstudiantesAsignacionesTableCreateCompanionBuilder
    = EstudiantesAsignacionesCompanion Function({
  Value<int> id,
  required int estudianteId,
  required int anioLectivoId,
  required int colegioId,
  required int asignaturaId,
  required int gradoId,
  required int seccionId,
  Value<bool> activo,
});
typedef $$EstudiantesAsignacionesTableUpdateCompanionBuilder
    = EstudiantesAsignacionesCompanion Function({
  Value<int> id,
  Value<int> estudianteId,
  Value<int> anioLectivoId,
  Value<int> colegioId,
  Value<int> asignaturaId,
  Value<int> gradoId,
  Value<int> seccionId,
  Value<bool> activo,
});

final class $$EstudiantesAsignacionesTableReferences extends BaseReferences<
    _$AppDatabase, $EstudiantesAsignacionesTable, EstudiantesAsignacione> {
  $$EstudiantesAsignacionesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EstudiantesTable _estudianteIdTable(_$AppDatabase db) =>
      db.estudiantes.createAlias($_aliasNameGenerator(
          db.estudiantesAsignaciones.estudianteId, db.estudiantes.id));

  $$EstudiantesTableProcessedTableManager get estudianteId {
    final $_column = $_itemColumn<int>('estudiante_id')!;

    final manager = $$EstudiantesTableTableManager($_db, $_db.estudiantes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_estudianteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AnosLectivosTable _anioLectivoIdTable(_$AppDatabase db) =>
      db.anosLectivos.createAlias($_aliasNameGenerator(
          db.estudiantesAsignaciones.anioLectivoId, db.anosLectivos.id));

  $$AnosLectivosTableProcessedTableManager get anioLectivoId {
    final $_column = $_itemColumn<int>('anio_lectivo_id')!;

    final manager = $$AnosLectivosTableTableManager($_db, $_db.anosLectivos)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anioLectivoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ColegiosTable _colegioIdTable(_$AppDatabase db) =>
      db.colegios.createAlias($_aliasNameGenerator(
          db.estudiantesAsignaciones.colegioId, db.colegios.id));

  $$ColegiosTableProcessedTableManager get colegioId {
    final $_column = $_itemColumn<int>('colegio_id')!;

    final manager = $$ColegiosTableTableManager($_db, $_db.colegios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_colegioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $AsignaturasTable _asignaturaIdTable(_$AppDatabase db) =>
      db.asignaturas.createAlias($_aliasNameGenerator(
          db.estudiantesAsignaciones.asignaturaId, db.asignaturas.id));

  $$AsignaturasTableProcessedTableManager get asignaturaId {
    final $_column = $_itemColumn<int>('asignatura_id')!;

    final manager = $$AsignaturasTableTableManager($_db, $_db.asignaturas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_asignaturaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $GradosTable _gradoIdTable(_$AppDatabase db) => db.grados.createAlias(
      $_aliasNameGenerator(db.estudiantesAsignaciones.gradoId, db.grados.id));

  $$GradosTableProcessedTableManager get gradoId {
    final $_column = $_itemColumn<int>('grado_id')!;

    final manager = $$GradosTableTableManager($_db, $_db.grados)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_gradoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SeccionesTable _seccionIdTable(_$AppDatabase db) =>
      db.secciones.createAlias($_aliasNameGenerator(
          db.estudiantesAsignaciones.seccionId, db.secciones.id));

  $$SeccionesTableProcessedTableManager get seccionId {
    final $_column = $_itemColumn<int>('seccion_id')!;

    final manager = $$SeccionesTableTableManager($_db, $_db.secciones)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seccionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EstudiantesAsignacionesTableFilterComposer
    extends Composer<_$AppDatabase, $EstudiantesAsignacionesTable> {
  $$EstudiantesAsignacionesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnFilters(column));

  $$EstudiantesTableFilterComposer get estudianteId {
    final $$EstudiantesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableFilterComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnosLectivosTableFilterComposer get anioLectivoId {
    final $$AnosLectivosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableFilterComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ColegiosTableFilterComposer get colegioId {
    final $$ColegiosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.colegioId,
        referencedTable: $db.colegios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ColegiosTableFilterComposer(
              $db: $db,
              $table: $db.colegios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AsignaturasTableFilterComposer get asignaturaId {
    final $$AsignaturasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.asignaturaId,
        referencedTable: $db.asignaturas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignaturasTableFilterComposer(
              $db: $db,
              $table: $db.asignaturas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradosTableFilterComposer get gradoId {
    final $$GradosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradoId,
        referencedTable: $db.grados,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradosTableFilterComposer(
              $db: $db,
              $table: $db.grados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeccionesTableFilterComposer get seccionId {
    final $$SeccionesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seccionId,
        referencedTable: $db.secciones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeccionesTableFilterComposer(
              $db: $db,
              $table: $db.secciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiantesAsignacionesTableOrderingComposer
    extends Composer<_$AppDatabase, $EstudiantesAsignacionesTable> {
  $$EstudiantesAsignacionesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get activo => $composableBuilder(
      column: $table.activo, builder: (column) => ColumnOrderings(column));

  $$EstudiantesTableOrderingComposer get estudianteId {
    final $$EstudiantesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableOrderingComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnosLectivosTableOrderingComposer get anioLectivoId {
    final $$AnosLectivosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableOrderingComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ColegiosTableOrderingComposer get colegioId {
    final $$ColegiosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.colegioId,
        referencedTable: $db.colegios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ColegiosTableOrderingComposer(
              $db: $db,
              $table: $db.colegios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AsignaturasTableOrderingComposer get asignaturaId {
    final $$AsignaturasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.asignaturaId,
        referencedTable: $db.asignaturas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignaturasTableOrderingComposer(
              $db: $db,
              $table: $db.asignaturas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradosTableOrderingComposer get gradoId {
    final $$GradosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradoId,
        referencedTable: $db.grados,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradosTableOrderingComposer(
              $db: $db,
              $table: $db.grados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeccionesTableOrderingComposer get seccionId {
    final $$SeccionesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seccionId,
        referencedTable: $db.secciones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeccionesTableOrderingComposer(
              $db: $db,
              $table: $db.secciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiantesAsignacionesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EstudiantesAsignacionesTable> {
  $$EstudiantesAsignacionesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$EstudiantesTableAnnotationComposer get estudianteId {
    final $$EstudiantesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableAnnotationComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AnosLectivosTableAnnotationComposer get anioLectivoId {
    final $$AnosLectivosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.anioLectivoId,
        referencedTable: $db.anosLectivos,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AnosLectivosTableAnnotationComposer(
              $db: $db,
              $table: $db.anosLectivos,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ColegiosTableAnnotationComposer get colegioId {
    final $$ColegiosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.colegioId,
        referencedTable: $db.colegios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ColegiosTableAnnotationComposer(
              $db: $db,
              $table: $db.colegios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$AsignaturasTableAnnotationComposer get asignaturaId {
    final $$AsignaturasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.asignaturaId,
        referencedTable: $db.asignaturas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AsignaturasTableAnnotationComposer(
              $db: $db,
              $table: $db.asignaturas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$GradosTableAnnotationComposer get gradoId {
    final $$GradosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.gradoId,
        referencedTable: $db.grados,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GradosTableAnnotationComposer(
              $db: $db,
              $table: $db.grados,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SeccionesTableAnnotationComposer get seccionId {
    final $$SeccionesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.seccionId,
        referencedTable: $db.secciones,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SeccionesTableAnnotationComposer(
              $db: $db,
              $table: $db.secciones,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EstudiantesAsignacionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EstudiantesAsignacionesTable,
    EstudiantesAsignacione,
    $$EstudiantesAsignacionesTableFilterComposer,
    $$EstudiantesAsignacionesTableOrderingComposer,
    $$EstudiantesAsignacionesTableAnnotationComposer,
    $$EstudiantesAsignacionesTableCreateCompanionBuilder,
    $$EstudiantesAsignacionesTableUpdateCompanionBuilder,
    (EstudiantesAsignacione, $$EstudiantesAsignacionesTableReferences),
    EstudiantesAsignacione,
    PrefetchHooks Function(
        {bool estudianteId,
        bool anioLectivoId,
        bool colegioId,
        bool asignaturaId,
        bool gradoId,
        bool seccionId})> {
  $$EstudiantesAsignacionesTableTableManager(
      _$AppDatabase db, $EstudiantesAsignacionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EstudiantesAsignacionesTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$EstudiantesAsignacionesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EstudiantesAsignacionesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> estudianteId = const Value.absent(),
            Value<int> anioLectivoId = const Value.absent(),
            Value<int> colegioId = const Value.absent(),
            Value<int> asignaturaId = const Value.absent(),
            Value<int> gradoId = const Value.absent(),
            Value<int> seccionId = const Value.absent(),
            Value<bool> activo = const Value.absent(),
          }) =>
              EstudiantesAsignacionesCompanion(
            id: id,
            estudianteId: estudianteId,
            anioLectivoId: anioLectivoId,
            colegioId: colegioId,
            asignaturaId: asignaturaId,
            gradoId: gradoId,
            seccionId: seccionId,
            activo: activo,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int estudianteId,
            required int anioLectivoId,
            required int colegioId,
            required int asignaturaId,
            required int gradoId,
            required int seccionId,
            Value<bool> activo = const Value.absent(),
          }) =>
              EstudiantesAsignacionesCompanion.insert(
            id: id,
            estudianteId: estudianteId,
            anioLectivoId: anioLectivoId,
            colegioId: colegioId,
            asignaturaId: asignaturaId,
            gradoId: gradoId,
            seccionId: seccionId,
            activo: activo,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EstudiantesAsignacionesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {estudianteId = false,
              anioLectivoId = false,
              colegioId = false,
              asignaturaId = false,
              gradoId = false,
              seccionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (estudianteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.estudianteId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._estudianteIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._estudianteIdTable(db)
                        .id,
                  ) as T;
                }
                if (anioLectivoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.anioLectivoId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._anioLectivoIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._anioLectivoIdTable(db)
                        .id,
                  ) as T;
                }
                if (colegioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.colegioId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._colegioIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._colegioIdTable(db)
                        .id,
                  ) as T;
                }
                if (asignaturaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.asignaturaId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._asignaturaIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._asignaturaIdTable(db)
                        .id,
                  ) as T;
                }
                if (gradoId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.gradoId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._gradoIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._gradoIdTable(db)
                        .id,
                  ) as T;
                }
                if (seccionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.seccionId,
                    referencedTable: $$EstudiantesAsignacionesTableReferences
                        ._seccionIdTable(db),
                    referencedColumn: $$EstudiantesAsignacionesTableReferences
                        ._seccionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EstudiantesAsignacionesTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $EstudiantesAsignacionesTable,
        EstudiantesAsignacione,
        $$EstudiantesAsignacionesTableFilterComposer,
        $$EstudiantesAsignacionesTableOrderingComposer,
        $$EstudiantesAsignacionesTableAnnotationComposer,
        $$EstudiantesAsignacionesTableCreateCompanionBuilder,
        $$EstudiantesAsignacionesTableUpdateCompanionBuilder,
        (EstudiantesAsignacione, $$EstudiantesAsignacionesTableReferences),
        EstudiantesAsignacione,
        PrefetchHooks Function(
            {bool estudianteId,
            bool anioLectivoId,
            bool colegioId,
            bool asignaturaId,
            bool gradoId,
            bool seccionId})>;
typedef $$NotasEstudiantesTableCreateCompanionBuilder
    = NotasEstudiantesCompanion Function({
  Value<int> id,
  required int estudianteId,
  required int criterioId,
  Value<String?> valorCualitativo,
  required double puntosObtenidos,
});
typedef $$NotasEstudiantesTableUpdateCompanionBuilder
    = NotasEstudiantesCompanion Function({
  Value<int> id,
  Value<int> estudianteId,
  Value<int> criterioId,
  Value<String?> valorCualitativo,
  Value<double> puntosObtenidos,
});

final class $$NotasEstudiantesTableReferences extends BaseReferences<
    _$AppDatabase, $NotasEstudiantesTable, NotasEstudiante> {
  $$NotasEstudiantesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EstudiantesTable _estudianteIdTable(_$AppDatabase db) =>
      db.estudiantes.createAlias($_aliasNameGenerator(
          db.notasEstudiantes.estudianteId, db.estudiantes.id));

  $$EstudiantesTableProcessedTableManager get estudianteId {
    final $_column = $_itemColumn<int>('estudiante_id')!;

    final manager = $$EstudiantesTableTableManager($_db, $_db.estudiantes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_estudianteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CriteriosEvaluacionTable _criterioIdTable(_$AppDatabase db) =>
      db.criteriosEvaluacion.createAlias($_aliasNameGenerator(
          db.notasEstudiantes.criterioId, db.criteriosEvaluacion.id));

  $$CriteriosEvaluacionTableProcessedTableManager get criterioId {
    final $_column = $_itemColumn<int>('criterio_id')!;

    final manager =
        $$CriteriosEvaluacionTableTableManager($_db, $_db.criteriosEvaluacion)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_criterioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$NotasEstudiantesTableFilterComposer
    extends Composer<_$AppDatabase, $NotasEstudiantesTable> {
  $$NotasEstudiantesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valorCualitativo => $composableBuilder(
      column: $table.valorCualitativo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos,
      builder: (column) => ColumnFilters(column));

  $$EstudiantesTableFilterComposer get estudianteId {
    final $$EstudiantesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableFilterComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CriteriosEvaluacionTableFilterComposer get criterioId {
    final $$CriteriosEvaluacionTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.criterioId,
        referencedTable: $db.criteriosEvaluacion,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CriteriosEvaluacionTableFilterComposer(
              $db: $db,
              $table: $db.criteriosEvaluacion,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$NotasEstudiantesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotasEstudiantesTable> {
  $$NotasEstudiantesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valorCualitativo => $composableBuilder(
      column: $table.valorCualitativo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos,
      builder: (column) => ColumnOrderings(column));

  $$EstudiantesTableOrderingComposer get estudianteId {
    final $$EstudiantesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableOrderingComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CriteriosEvaluacionTableOrderingComposer get criterioId {
    final $$CriteriosEvaluacionTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.criterioId,
            referencedTable: $db.criteriosEvaluacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CriteriosEvaluacionTableOrderingComposer(
                  $db: $db,
                  $table: $db.criteriosEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$NotasEstudiantesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotasEstudiantesTable> {
  $$NotasEstudiantesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get valorCualitativo => $composableBuilder(
      column: $table.valorCualitativo, builder: (column) => column);

  GeneratedColumn<double> get puntosObtenidos => $composableBuilder(
      column: $table.puntosObtenidos, builder: (column) => column);

  $$EstudiantesTableAnnotationComposer get estudianteId {
    final $$EstudiantesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.estudianteId,
        referencedTable: $db.estudiantes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EstudiantesTableAnnotationComposer(
              $db: $db,
              $table: $db.estudiantes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CriteriosEvaluacionTableAnnotationComposer get criterioId {
    final $$CriteriosEvaluacionTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.criterioId,
            referencedTable: $db.criteriosEvaluacion,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CriteriosEvaluacionTableAnnotationComposer(
                  $db: $db,
                  $table: $db.criteriosEvaluacion,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$NotasEstudiantesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotasEstudiantesTable,
    NotasEstudiante,
    $$NotasEstudiantesTableFilterComposer,
    $$NotasEstudiantesTableOrderingComposer,
    $$NotasEstudiantesTableAnnotationComposer,
    $$NotasEstudiantesTableCreateCompanionBuilder,
    $$NotasEstudiantesTableUpdateCompanionBuilder,
    (NotasEstudiante, $$NotasEstudiantesTableReferences),
    NotasEstudiante,
    PrefetchHooks Function({bool estudianteId, bool criterioId})> {
  $$NotasEstudiantesTableTableManager(
      _$AppDatabase db, $NotasEstudiantesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotasEstudiantesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotasEstudiantesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotasEstudiantesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> estudianteId = const Value.absent(),
            Value<int> criterioId = const Value.absent(),
            Value<String?> valorCualitativo = const Value.absent(),
            Value<double> puntosObtenidos = const Value.absent(),
          }) =>
              NotasEstudiantesCompanion(
            id: id,
            estudianteId: estudianteId,
            criterioId: criterioId,
            valorCualitativo: valorCualitativo,
            puntosObtenidos: puntosObtenidos,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int estudianteId,
            required int criterioId,
            Value<String?> valorCualitativo = const Value.absent(),
            required double puntosObtenidos,
          }) =>
              NotasEstudiantesCompanion.insert(
            id: id,
            estudianteId: estudianteId,
            criterioId: criterioId,
            valorCualitativo: valorCualitativo,
            puntosObtenidos: puntosObtenidos,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NotasEstudiantesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({estudianteId = false, criterioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (estudianteId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.estudianteId,
                    referencedTable: $$NotasEstudiantesTableReferences
                        ._estudianteIdTable(db),
                    referencedColumn: $$NotasEstudiantesTableReferences
                        ._estudianteIdTable(db)
                        .id,
                  ) as T;
                }
                if (criterioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.criterioId,
                    referencedTable:
                        $$NotasEstudiantesTableReferences._criterioIdTable(db),
                    referencedColumn: $$NotasEstudiantesTableReferences
                        ._criterioIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$NotasEstudiantesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotasEstudiantesTable,
    NotasEstudiante,
    $$NotasEstudiantesTableFilterComposer,
    $$NotasEstudiantesTableOrderingComposer,
    $$NotasEstudiantesTableAnnotationComposer,
    $$NotasEstudiantesTableCreateCompanionBuilder,
    $$NotasEstudiantesTableUpdateCompanionBuilder,
    (NotasEstudiante, $$NotasEstudiantesTableReferences),
    NotasEstudiante,
    PrefetchHooks Function({bool estudianteId, bool criterioId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnosLectivosTableTableManager get anosLectivos =>
      $$AnosLectivosTableTableManager(_db, _db.anosLectivos);
  $$ColegiosTableTableManager get colegios =>
      $$ColegiosTableTableManager(_db, _db.colegios);
  $$AsignaturasTableTableManager get asignaturas =>
      $$AsignaturasTableTableManager(_db, _db.asignaturas);
  $$GradosTableTableManager get grados =>
      $$GradosTableTableManager(_db, _db.grados);
  $$SeccionesTableTableManager get secciones =>
      $$SeccionesTableTableManager(_db, _db.secciones);
  $$CortesEvaluativosTableTableManager get cortesEvaluativos =>
      $$CortesEvaluativosTableTableManager(_db, _db.cortesEvaluativos);
  $$IndicadoresEvaluacionTableTableManager get indicadoresEvaluacion =>
      $$IndicadoresEvaluacionTableTableManager(_db, _db.indicadoresEvaluacion);
  $$CriteriosEvaluacionTableTableManager get criteriosEvaluacion =>
      $$CriteriosEvaluacionTableTableManager(_db, _db.criteriosEvaluacion);
  $$EstudiantesTableTableManager get estudiantes =>
      $$EstudiantesTableTableManager(_db, _db.estudiantes);
  $$EstudiantesAsignacionesTableTableManager get estudiantesAsignaciones =>
      $$EstudiantesAsignacionesTableTableManager(
          _db, _db.estudiantesAsignaciones);
  $$NotasEstudiantesTableTableManager get notasEstudiantes =>
      $$NotasEstudiantesTableTableManager(_db, _db.notasEstudiantes);
}
