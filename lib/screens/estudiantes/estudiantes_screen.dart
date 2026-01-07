import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:excel/excel.dart' as excel;
import 'dart:io';
import '../../models/estudiante.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../providers/asignatura_provider.dart';
import '../../providers/colegio_provider.dart';
import '../../providers/estudiante_provider.dart';
import '../../providers/grado_provider.dart';
import '../../providers/seccion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class EstudiantesScreen extends StatefulWidget {
  const EstudiantesScreen({Key? key}) : super(key: key);

  @override
  State<EstudiantesScreen> createState() => _EstudiantesScreenState();
}

class _EstudiantesScreenState extends State<EstudiantesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String? selectedSexoFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<AnioLectivoProvider>().cargarAnios();
      await context.read<ColegioProvider>().cargarColegios();
      await context.read<AsignaturaProvider>().cargarAsignaturas();
      await context.read<GradoProvider>().cargarGrados();
      await context.read<SeccionProvider>().cargarSecciones();

      // Forzar selección de año por defecto e iniciar cascada total
      if (mounted) {
        final anioProvider = context.read<AnioLectivoProvider>();
        final anioPorDefecto = anioProvider.anios.firstWhere(
          (a) => a.porDefecto == 1,
          orElse: () => anioProvider.anios.isNotEmpty
              ? anioProvider.anios.first
              : anioProvider.anios.first,
        );

        if (anioProvider.anios.isNotEmpty) {
          anioProvider.seleccionarAnio(anioPorDefecto);
          await _seleccionarEnCascadaDesdeAnio(anioPorDefecto.id!);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showEstudianteDialog({Estudiante? estudiante}) async {
    // Controllers for student basic info
    final estudianteController =
        TextEditingController(text: estudiante?.estudiante ?? '');
    final identidadController =
        TextEditingController(text: estudiante?.numeroIdentidad ?? '');
    final telefonoController =
        TextEditingController(text: estudiante?.telefono ?? '');
    final emailController =
        TextEditingController(text: estudiante?.email ?? '');
    final direccionController =
        TextEditingController(text: estudiante?.direccion ?? '');

    // State for assignment fields
    String? selectedSexo = estudiante?.sexo;
    int? selectedAnioId = context.read<AnioLectivoProvider>().selectedAnio?.id;
    int? selectedColegioId;
    int? selectedGradoId;
    int? selectedSeccionId;
    Set<int> selectedAsignaturasIds = {};

    // If editing existing student, load their assignments
    if (estudiante != null) {
      try {
        final estudianteProvider = context.read<EstudianteProvider>();
        final asignaciones = await estudianteProvider
            .obtenerAsignacionesEstudiante(estudiante.id!);

        if (asignaciones.isNotEmpty) {
          // Use the first assignment as reference (assuming one main assignment per student)
          final primeraAsignacion = asignaciones.first;
          selectedAnioId = primeraAsignacion['anio_lectivo_id'];
          selectedColegioId = primeraAsignacion['colegio_id'];
          selectedGradoId = primeraAsignacion['grado_id'];
          selectedSeccionId = primeraAsignacion['seccion_id'];

          // Get all asignaturas for this student
          selectedAsignaturasIds =
              asignaciones.map((a) => a['asignatura_id'] as int).toSet();
        }
      } catch (e) {
        print('Error loading student assignments: $e');
      }
    } else {
      // Initialize selected subjects with all default subjects for new student
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final asignaturas = context.read<AsignaturaProvider>().asignaturas;
        selectedAsignaturasIds = asignaturas.map((a) => a.id!).toSet();
      });
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            estudiante == null ? 'Agregar Estudiante' : 'Editar Estudiante',
            style: TextStyle(
              color: AppTheme.getTextPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student basic info
                Text(
                  'Información del Estudiante',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Estudiante',
                  controller: estudianteController,
                  hint: 'Nombre completo del estudiante',
                ),
                const SizedBox(height: 12),
                // Sex selection
                Text(
                  'Sexo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Masculino'),
                        value: 'Masculino',
                        groupValue: selectedSexo,
                        onChanged: (value) =>
                            setState(() => selectedSexo = value),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Femenino'),
                        value: 'Femenino',
                        groupValue: selectedSexo,
                        onChanged: (value) =>
                            setState(() => selectedSexo = value),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Academic assignment info
                Text(
                  'Asignación Académica',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 12),

                // Academic year (default to active)
                Consumer<AnioLectivoProvider>(
                  builder: (context, provider, _) =>
                      DropdownButtonFormField<int>(
                    initialValue: selectedAnioId,
                    decoration: InputDecoration(
                      labelText: 'Año Lectivo',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: provider.anios
                        .map((anio) => DropdownMenuItem(
                              value: anio.id,
                              child: Text(anio.nombre),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedAnioId = value),
                  ),
                ),
                const SizedBox(height: 12),

                // School
                Consumer<ColegioProvider>(
                  builder: (context, provider, _) =>
                      DropdownButtonFormField<int>(
                    initialValue: selectedColegioId,
                    decoration: InputDecoration(
                      labelText: 'Colegio',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: provider.colegios
                        .map((colegio) => DropdownMenuItem(
                              value: colegio.id,
                              child: Text(colegio.nombre),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedColegioId = value),
                  ),
                ),
                const SizedBox(height: 12),

                // Subjects (multi-select with all pre-selected)
                Text(
                  'Asignaturas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Consumer<AsignaturaProvider>(
                  builder: (context, provider, _) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTheme.getTextTertiary(context)
                              .withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: provider.asignaturas
                          .map((asignatura) => CheckboxListTile(
                                title: Text(asignatura.nombre),
                                value: selectedAsignaturasIds
                                    .contains(asignatura.id),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      selectedAsignaturasIds
                                          .add(asignatura.id!);
                                    } else {
                                      selectedAsignaturasIds
                                          .remove(asignatura.id);
                                    }
                                  });
                                },
                                dense: true,
                                activeColor: Theme.of(context).primaryColor,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Grade
                Consumer<GradoProvider>(
                  builder: (context, provider, _) =>
                      DropdownButtonFormField<int>(
                    initialValue: selectedGradoId,
                    decoration: InputDecoration(
                      labelText: 'Grado',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: provider.grados
                        .map((grado) => DropdownMenuItem(
                              value: grado.id,
                              child: Text(grado.nombre),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedGradoId = value),
                  ),
                ),
                const SizedBox(height: 12),

                // Section
                Consumer<SeccionProvider>(
                  builder: (context, provider, _) =>
                      DropdownButtonFormField<int>(
                    initialValue: selectedSeccionId,
                    decoration: InputDecoration(
                      labelText: 'Sección',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    items: provider.secciones
                        .map((seccion) => DropdownMenuItem(
                              value: seccion.id,
                              child: Text(seccion.letra),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedSeccionId = value),
                  ),
                ),
                const SizedBox(height: 20),

                // Optional fields (less relevant)
                Text(
                  'Información Adicional (Opcional)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Número de Identidad',
                  controller: identidadController,
                  hint: 'Número de identidad (opcional)',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Teléfono',
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  hint: 'Teléfono de contacto (opcional)',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Dirección',
                  controller: direccionController,
                  hint: 'Dirección del estudiante (opcional)',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.getTextSecondary(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validation
                if (estudianteController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('El nombre del estudiante es requerido')),
                  );
                  return;
                }

                if (selectedAnioId == null ||
                    selectedColegioId == null ||
                    selectedGradoId == null ||
                    selectedSeccionId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Completa todos los campos académicos')),
                  );
                  return;
                }

                if (selectedAsignaturasIds.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Selecciona al menos una asignatura')),
                  );
                  return;
                }

                // Create student
                final nuevoEstudiante = Estudiante(
                  id: estudiante?.id,
                  estudiante: estudianteController.text,
                  numeroIdentidad: identidadController.text.isNotEmpty
                      ? identidadController.text
                      : null,
                  telefono: telefonoController.text.isNotEmpty
                      ? telefonoController.text
                      : null,
                  email: emailController.text.isNotEmpty
                      ? emailController.text
                      : null,
                  direccion: direccionController.text.isNotEmpty
                      ? direccionController.text
                      : null,
                  sexo: selectedSexo,
                );

                final provider = context.read<EstudianteProvider>();

                try {
                  if (estudiante == null) {
                    // Create student and assignments
                    await provider.crearEstudianteConAsignaciones(
                      nuevoEstudiante,
                      selectedAnioId!,
                      selectedColegioId!,
                      selectedAsignaturasIds.toList(),
                      selectedGradoId!,
                      selectedSeccionId!,
                    );
                  } else {
                    // Update student (assignments update not implemented yet)
                    await provider.actualizarEstudiante(nuevoEstudiante);
                  }

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text(estudiante == null ? 'Agregar' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importarDesdeExcel() async {
    try {
      // Solicitar permisos en Android
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Se necesitan permisos de almacenamiento para importar')),
          );
          return;
        }
      }

      // Abrir selector de archivos
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        dialogTitle: 'Seleccionar archivo Excel',
      );

      if (result == null) return;

      final file = File(result.files.single.path!);
      await _procesarArchivoExcel(file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al importar: ${e.toString()}')),
      );
    }
  }

  Future<void> _procesarArchivoExcel(File file) async {
    final provider = context.read<EstudianteProvider>();

    // Mostrar diálogo de progreso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Procesando archivo Excel...'),
          ],
        ),
      ),
    );

    try {
      // Leer el archivo Excel
      final bytes = file.readAsBytesSync();
      final excelFile = excel.Excel.decodeBytes(bytes);
      final sheet = excelFile.tables.values.first;

      // Obtener encabezados
      final headers = _obtenerEncabezados(sheet);

      // Validar encabezados usando el provider
      if (!provider.validarEncabezados(headers)) {
        Navigator.pop(context);
        _mostrarErrorEncabezados(headers);
        return;
      }

      // Procesar filas y extraer datos
      final datosImportacion = <DatosImportacionExcel>[];
      final errores = <String>[];

      for (int row = 1; row < 1000; row++) {
        try {
          // Verificar si la fila tiene datos
          final primeracelda = sheet.cell(
              excel.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
          if (primeracelda.value == null) break;

          // Extraer datos de la fila como mapa
          final fila = <String, String?>{};
          for (int col = 0; col < headers.length; col++) {
            final cell = sheet.cell(excel.CellIndex.indexByColumnRow(
                columnIndex: col, rowIndex: row));
            fila[headers[col]] = cell.value?.toString();
          }

          // Usar el provider para extraer los datos
          final datos =
              provider.extraerDatosDeFilaExcel(fila: fila, headers: headers);
          if (datos != null) {
            datosImportacion.add(datos);
          }
        } catch (e) {
          errores.add('Fila ${row + 1}: ${e.toString()}');
        }
      }

      Navigator.pop(context);

      if (datosImportacion.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('No se encontraron estudiantes válidos en el archivo')),
        );
        return;
      }

      // Mostrar resumen y confirmar importación
      _mostrarResumenImportacion(datosImportacion, errores);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al procesar el archivo: ${e.toString()}')),
      );
    }
  }

  List<String> _obtenerEncabezados(excel.Sheet sheet) {
    final headers = <String>[];
    for (int col = 0; col < 20; col++) {
      try {
        final cell = sheet.cell(
            excel.CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
        final value = cell.value?.toString() ?? '';
        if (value.isNotEmpty) {
          headers.add(value);
        }
      } catch (e) {
        break;
      }
    }
    return headers;
  }

  void _mostrarErrorEncabezados(List<String> headers) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Encabezados incorrectos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('El archivo debe contener las siguientes columnas:'),
            const SizedBox(height: 8),
            ...EstudianteProvider.encabezadosRequeridos.map((h) => Text(
                  '- ${h[0].toUpperCase()}${h.substring(1)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 16),
            Text('Encabezados encontrados: ${headers.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _mostrarResumenImportacion(
      List<DatosImportacionExcel> datos, List<String> errores) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Resumen de Importación'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registros encontrados: ${datos.length}'),
            if (errores.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Errores: ${errores.length}',
                  style: TextStyle(color: AppTheme.getErrorColor(context))),
            ],
            const SizedBox(height: 16),
            const Text('¿Desea importar estos estudiantes?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmarImportacion(datos);
            },
            child: const Text('Importar'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarImportacion(List<DatosImportacionExcel> datos) async {
    // Mostrar diálogo de progreso
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Importando estudiantes...'),
          ],
        ),
      ),
    );

    try {
      // Llamar al provider para hacer la importación
      final resultado =
          await context.read<EstudianteProvider>().importarDatosExcel(datos);

      Navigator.pop(context);

      // Recargar providers relacionados
      context.read<AnioLectivoProvider>().cargarAnios();
      context.read<ColegioProvider>().cargarColegios();
      context.read<AsignaturaProvider>().cargarAsignaturas();
      context.read<GradoProvider>().cargarGrados();
      context.read<SeccionProvider>().cargarSecciones();

      // Mostrar resultado
      _mostrarResultadoImportacion(resultado);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error durante la importación: ${e.toString()}')),
      );
    }
  }

  void _mostrarResultadoImportacion(ResultadoImportacion resultado) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Importación Completada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (resultado.nuevosEstudiantes > 0)
              Text('✓ Nuevos estudiantes: ${resultado.nuevosEstudiantes}',
                  style: const TextStyle(color: Colors.green)),
            if (resultado.asignacionesCreadas > 0)
              Text('✓ Asignaciones creadas: ${resultado.asignacionesCreadas}',
                  style: const TextStyle(color: Colors.green)),
            if (resultado.duplicadosOmitidos > 0)
              Text('⚠ Duplicados omitidos: ${resultado.duplicadosOmitidos}',
                  style: const TextStyle(color: Colors.orange)),
            if (resultado.errores > 0)
              Text('✗ Errores: ${resultado.errores}',
                  style: TextStyle(color: AppTheme.getErrorColor(context))),
            if (resultado.sinCambios)
              Text('No se realizaron cambios - todos los datos ya existían.',
                  style: TextStyle(color: AppTheme.getTextSecondary(context))),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  List<Estudiante> _filtrarEstudiantes(List<Estudiante> estudiantes) {
    final query = _searchController.text.toLowerCase();

    return estudiantes.where((estudiante) {
      // Filter by search query
      bool matchesSearch = query.isEmpty ||
          estudiante.nombreCompleto.toLowerCase().contains(query) ||
          (estudiante.numeroIdentidad?.toLowerCase().contains(query) ?? false);

      // Filter by gender
      bool matchesGender = selectedSexoFilter == null ||
          estudiante.sexo == selectedSexoFilter;

      return matchesSearch && matchesGender;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final anioProvider = Provider.of<AnioLectivoProvider>(context);
    final colegioProvider = Provider.of<ColegioProvider>(context);
    final asignaturaProvider = Provider.of<AsignaturaProvider>(context);
    final gradoProvider = Provider.of<GradoProvider>(context);
    final seccionProvider = Provider.of<SeccionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudiantes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(anioProvider, colegioProvider, asignaturaProvider,
              gradoProvider, seccionProvider),
          const SizedBox(height: 16),
          _buildEstudiantesList(),
        ],
      ),
    );
  }

  void _aplicarFiltros() {
    final anioProvider = context.read<AnioLectivoProvider>();
    final colegioProvider = context.read<ColegioProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Aplicar filtros con enfoque híbrido: repositorio + local
    context.read<EstudianteProvider>().aplicarFiltros(
          anioLectivoId: anioProvider.selectedAnio?.id,
          colegioId: colegioProvider.selectedColegio?.id,
          asignaturaId: asignaturaProvider.selectedAsignatura?.id,
          gradoId: gradoProvider.selectedGrado?.id,
          seccionId: seccionProvider.selectedSeccion?.id,
          sexo: selectedSexoFilter, // Aplicar filtro de sexo a nivel de repositorio
        );
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar año lectivo
  Future<void> _seleccionarEnCascadaDesdeAnio(int anioLectivoId) async {
    final estudianteProvider = context.read<EstudianteProvider>();
    final colegioProvider = context.read<ColegioProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener colegios disponibles y seleccionar el primero
    final colegiosIds =
        await estudianteProvider.obtenerColegiosDisponibles(anioLectivoId);
    if (colegiosIds.isNotEmpty) {
      final currentSelectedId = colegioProvider.selectedColegio?.id;
      if (currentSelectedId == null ||
          !colegiosIds.contains(currentSelectedId)) {
        final lista = colegioProvider.colegios
            .where((c) => colegiosIds.contains(c.id))
            .toList();
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));

        final colegioDisponible = lista.first;
        colegioProvider.seleccionarColegio(colegioDisponible);
      }

      await _seleccionarEnCascadaDesdeColegio(
          anioLectivoId, colegioProvider.selectedColegio!.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar colegio
  Future<void> _seleccionarEnCascadaDesdeColegio(
      int anioLectivoId, int colegioId) async {
    final estudianteProvider = context.read<EstudianteProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener asignaturas disponibles y seleccionar la primera
    final asignaturasIds = await estudianteProvider
        .obtenerAsignaturasDisponibles(anioLectivoId, colegioId);
    if (asignaturasIds.isNotEmpty) {
      final currentSelectedId = asignaturaProvider.selectedAsignatura?.id;
      if (currentSelectedId == null ||
          !asignaturasIds.contains(currentSelectedId)) {
        final lista = asignaturaProvider.asignaturas
            .where((a) => asignaturasIds.contains(a.id))
            .toList();
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));

        final asignaturaDisponible = lista.first;
        asignaturaProvider.seleccionarAsignatura(asignaturaDisponible);
      }

      await _seleccionarEnCascadaDesdeAsignatura(
          anioLectivoId, colegioId, asignaturaProvider.selectedAsignatura!.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar asignatura
  Future<void> _seleccionarEnCascadaDesdeAsignatura(
      int anioLectivoId, int colegioId, int asignaturaId) async {
    final estudianteProvider = context.read<EstudianteProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener grados disponibles y seleccionar el primero
    final gradosIds = await estudianteProvider.obtenerGradosDisponibles(
        anioLectivoId, colegioId, asignaturaId);
    if (gradosIds.isNotEmpty) {
      final currentSelectedId = gradoProvider.selectedGrado?.id;
      if (currentSelectedId == null || !gradosIds.contains(currentSelectedId)) {
        final lista = gradoProvider.grados
            .where((g) => gradosIds.contains(g.id))
            .toList();
        lista.sort((a, b) => a.numero.compareTo(b.numero));

        final gradoDisponible = lista.first;
        gradoProvider.seleccionarGrado(gradoDisponible);
      }

      await _seleccionarEnCascadaDesdeGrado(anioLectivoId, colegioId,
          asignaturaId, gradoProvider.selectedGrado!.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar grado
  Future<void> _seleccionarEnCascadaDesdeGrado(
      int anioLectivoId, int colegioId, int asignaturaId, int gradoId) async {
    final estudianteProvider = context.read<EstudianteProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener secciones disponibles y seleccionar la primera
    final seccionesIds = await estudianteProvider.obtenerSeccionesDisponibles(
        anioLectivoId, colegioId, asignaturaId, gradoId);
    if (seccionesIds.isNotEmpty) {
      final currentSelectedId = seccionProvider.selectedSeccion?.id;
      if (currentSelectedId == null ||
          !seccionesIds.contains(currentSelectedId)) {
        final lista = seccionProvider.secciones
            .where((s) => seccionesIds.contains(s.id))
            .toList();
        lista.sort((a, b) => a.letra.compareTo(b.letra));

        final seccionDisponible = lista.first;
        seccionProvider.seleccionarSeccion(seccionDisponible);
      }
    }

    // Aplicar filtros finales
    _aplicarFiltros();
  }

  /// Busca y selecciona el año lectivo más cercano disponible para un colegio específico
  Future<void> _seleccionarAnioCercanoDesdeColegio(int colegioId) async {
    final estudianteProvider = context.read<EstudianteProvider>();
    final anioProvider = context.read<AnioLectivoProvider>();

    // Buscar años disponibles para este colegio
    final aniosIds =
        await estudianteProvider.obtenerAniosDisponiblesDesdeColegio(colegioId);

    if (aniosIds.isNotEmpty) {
      final currentSelectedId = anioProvider.selectedAnio?.id;
      if (currentSelectedId == null || !aniosIds.contains(currentSelectedId)) {
        // Seleccionar el año más reciente disponible
        final anioDisponible = anioProvider.anios.firstWhere(
          (a) => aniosIds.contains(a.id),
          orElse: () => anioProvider.anios.first,
        );
        anioProvider.seleccionarAnio(anioDisponible);
      }

      // Continuar la cascada desde colegio con el año seleccionado
      await _seleccionarEnCascadaDesdeColegio(
          anioProvider.selectedAnio!.id!, colegioId);
    }
  }

  Widget _buildFilters(
    AnioLectivoProvider anioProvider,
    ColegioProvider colegioProvider,
    AsignaturaProvider asignaturaProvider,
    GradoProvider gradoProvider,
    SeccionProvider seccionProvider,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // First row: Filters
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Consumer<EstudianteProvider>(
                          builder: (context, provider, _) {
                            if (provider.tieneFiltrosActivos) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  onPressed: () => provider.limpiarFiltros(),
                                  icon: const Icon(Icons.refresh_rounded,
                                      size: 24),
                                  tooltip: 'Limpiar filtros',
                                  color: AppTheme.getErrorColor(context),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(
                          width: 150,
                          child: _buildDropdown(
                            label: 'Año Lectivo',
                            value: anioProvider.selectedAnio?.nombre ??
                                'Seleccionar',
                            items: anioProvider.anios
                                .map((anio) => anio.nombre)
                                .toList(),
                            onChanged: (value) async {
                              if (value != null) {
                                final selectedAnio =
                                    anioProvider.anios.firstWhere(
                                  (anio) => anio.nombre == value,
                                  orElse: () => anioProvider.anios.first,
                                );
                                anioProvider.seleccionarAnio(selectedAnio);
                                // Selección en cascada automática
                                await _seleccionarEnCascadaDesdeAnio(
                                    selectedAnio.id!);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 150,
                          child: _buildDropdown(
                            label: 'Colegio',
                            value: colegioProvider.selectedColegio?.nombre ??
                                'Seleccionar',
                            items: colegioProvider.colegios
                                .map((colegio) => colegio.nombre)
                                .toList(),
                            onChanged: (value) async {
                              if (value != null) {
                                final selectedColegio =
                                    colegioProvider.colegios.firstWhere(
                                  (colegio) => colegio.nombre == value,
                                  orElse: () => colegioProvider.colegios.first,
                                );
                                colegioProvider
                                    .seleccionarColegio(selectedColegio);

                                // Si hay año lectivo seleccionado, hacer cascada desde colegio
                                if (anioProvider.selectedAnio != null) {
                                  await _seleccionarEnCascadaDesdeColegio(
                                    anioProvider.selectedAnio!.id!,
                                    selectedColegio.id!,
                                  );
                                }
                                // Si no hay año lectivo pero hay colegio, buscar años disponibles para este colegio
                                else {
                                  await _seleccionarAnioCercanoDesdeColegio(
                                      selectedColegio.id!);
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 150,
                          child: _buildDropdown(
                            label: 'Asignatura',
                            value:
                                asignaturaProvider.selectedAsignatura?.nombre ??
                                    'Seleccionar',
                            items: asignaturaProvider.asignaturas
                                .map((a) => a.nombre)
                                .toList(),
                            onChanged: (value) async {
                              if (value != null &&
                                  anioProvider.selectedAnio != null &&
                                  colegioProvider.selectedColegio != null) {
                                final selected =
                                    asignaturaProvider.asignaturas.firstWhere(
                                  (a) => a.nombre == value,
                                  orElse: () =>
                                      asignaturaProvider.asignaturas.first,
                                );
                                asignaturaProvider
                                    .seleccionarAsignatura(selected);
                                // Selección en cascada
                                await _seleccionarEnCascadaDesdeAsignatura(
                                  anioProvider.selectedAnio!.id!,
                                  colegioProvider.selectedColegio!.id!,
                                  selected.id!,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 150,
                          child: _buildDropdown(
                            label: 'Grado',
                            value: gradoProvider.selectedGrado?.nombre ??
                                'Seleccionar',
                            items: gradoProvider.grados
                                .map((g) => g.nombre)
                                .toList(),
                            onChanged: (value) async {
                              if (value != null &&
                                  anioProvider.selectedAnio != null &&
                                  colegioProvider.selectedColegio != null &&
                                  asignaturaProvider.selectedAsignatura !=
                                      null) {
                                final selected =
                                    gradoProvider.grados.firstWhere(
                                  (g) => g.nombre == value,
                                  orElse: () => gradoProvider.grados.first,
                                );
                                gradoProvider.seleccionarGrado(selected);
                                // Selección en cascada
                                await _seleccionarEnCascadaDesdeGrado(
                                  anioProvider.selectedAnio!.id!,
                                  colegioProvider.selectedColegio!.id!,
                                  asignaturaProvider.selectedAsignatura!.id!,
                                  selected.id!,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: _buildDropdown(
                            label: 'Sección',
                            value: seccionProvider.selectedSeccion?.letra ??
                                'Seleccionar',
                            items: seccionProvider.secciones
                                .map((s) => s.letra)
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                final selected =
                                    seccionProvider.secciones.firstWhere(
                                  (s) => s.letra == value,
                                  orElse: () => seccionProvider.secciones.first,
                                );
                                seccionProvider.seleccionarSeccion(selected);
                                _aplicarFiltros();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 120,
                          child: _buildDropdown(
                            label: 'Sexo',
                            value: selectedSexoFilter ?? 'Todos',
                            items: const ['Todos', 'Masculino', 'Femenino'],
                            onChanged: (value) {
                              setState(() {
                                selectedSexoFilter = value == 'Todos' ? null : value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        ListenableBuilder(
                          listenable: Listenable.merge(
                              [_searchController, _searchFocusNode]),
                          builder: (context, _) {
                            final hasText = _searchController.text.isNotEmpty;
                            final hasFocus = _searchFocusNode.hasFocus;
                            final double width =
                                (hasText || hasFocus) ? 220 : 120;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: width,
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Buscar...',
                                  prefixIcon:
                                      const Icon(Icons.search, size: 20),
                                  suffixIcon: hasText
                                      ? IconButton(
                                          icon:
                                              const Icon(Icons.clear, size: 18),
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {});
                                          },
                                        )
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  isDense: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Second row: Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showEstudianteDialog,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Agregar Estudiante'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _importarDesdeExcel,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Importar Excel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) =>
      DropdownButtonFormField<String>(
        initialValue:
            value != 'Seleccionar' && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
      );

  Widget _buildEstudiantesList() => Consumer<EstudianteProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          }

          if (provider.estudiantes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    message: 'No hay estudiantes registrados',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showEstudianteDialog,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Agregar Primer Estudiante'),
                  ),
                ],
              ),
            );
          }

          final estudiantesFiltrados =
              _filtrarEstudiantes(provider.estudiantes);

          return Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columnas por fila
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.3, // Cards anchas pero un poco más altas
              ),
              itemCount: estudiantesFiltrados.length,
              itemBuilder: (context, index) {
                final estudiante = estudiantesFiltrados[index];
                return CustomCard(
                  onTap: () => provider.seleccionarEstudiante(estudiante),
                  backgroundColor:
                      provider.selectedEstudiante?.id == estudiante.id
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del estudiante
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              estudiante.nombreCompleto,
                              style: TextStyle(
                                color: AppTheme.getTextPrimary(context),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (provider.selectedEstudiante?.id == estudiante.id)
                            Icon(Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                                size: 16),
                        ],
                      ),

                      // Información adicional
                      if (estudiante.numeroIdentidad != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${estudiante.numeroIdentidad!}',
                          style: TextStyle(
                            color: AppTheme.getTextSecondary(context),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Información de contacto (más compacta)
                      const SizedBox(height: 8),
                      if (estudiante.telefono != null)
                        _InfoRowCompact(
                            icon: Icons.phone, label: estudiante.telefono!),
                      if (estudiante.email != null)
                        _InfoRowCompact(
                            icon: Icons.email, label: estudiante.email!),
                      if (estudiante.direccion != null)
                        _InfoRowCompact(
                            icon: Icons.location_on,
                            label: estudiante.direccion!),

                      // Spacer para empujar los botones abajo
                      const Spacer(),

                      // Botones de acción (más pequeños)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () =>
                                _showEstudianteDialog(estudiante: estudiante),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            color: AppTheme.getErrorColor(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              DialogHelper.showDeleteConfirmation(
                                context: context,
                                itemName: estudiante.nombreCompleto,
                                onConfirm: () =>
                                    provider.eliminarEstudiante(estudiante.id!),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.getTextTertiary(context)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  color: AppTheme.getTextTertiary(context), fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

class _InfoRowCompact extends StatelessWidget {
  const _InfoRowCompact({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 12, color: AppTheme.getTextTertiary(context)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  color: AppTheme.getTextTertiary(context), fontSize: 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
}
