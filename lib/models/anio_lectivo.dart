class AnioLectivo {

  AnioLectivo({
    this.id,
    required this.anio,
    this.activo = true,
    this.porDefecto = false,
  });

  factory AnioLectivo.fromMap(Map<String, dynamic> map) => AnioLectivo(
      id: map['id'],
      anio: map['anio'],
      activo: map['activo'] == 1,
      porDefecto: map['porDefecto'] == 1,
    );
  final int? id;
  final int anio;
  final bool activo;
  final bool porDefecto;

  String get nombre => 'Año Lectivo $anio';

  Map<String, dynamic> toMap() => {
      'id': id,
      'anio': anio,
      'activo': activo ? 1 : 0,
      'porDefecto': porDefecto ? 1 : 0,
    };

  AnioLectivo copyWith({
    int? id,
    int? anio,
    bool? activo,
    bool? porDefecto,
  }) => AnioLectivo(
      id: id ?? this.id,
      anio: anio ?? this.anio,
      activo: activo ?? this.activo,
      porDefecto: porDefecto ?? this.porDefecto,
    );
}
