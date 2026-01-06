import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/nota.dart';
import '../../models/nota_detalle.dart';
import '../../models/corte_evaluativo.dart';
import '../../models/estudiante.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../providers/estudiante_provider.dart';
import '../../providers/asignatura_provider.dart';
import '../../providers/colegio_provider.dart';
import '../../providers/corte_evaluativo_provider.dart';
import '../../providers/notas_provider.dart';
import '../../providers/grado_provider.dart';
import '../../providers/seccion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({Key? key}) : super(key: key);

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<NotasProvider>().cargarNotas();
      await context.read<AnioLectivoProvider>().cargarAnios();
      await context.read<ColegioProvider>().cargarColegios();
      await context.read<AsignaturaProvider>().cargarAsignaturas();
      await context.read<GradoProvider>().cargarGrados();
      await context.read<SeccionProvider>().cargarSecciones();
      await context.read<CorteEvaluativoProvider>().cargarCortes();

      // Si hay un año seleccionado (por defecto), iniciar la cascada automáticamente
      final anioProvider = context.read<AnioLectivoProvider>();
      if (anioProvider.selectedAnio != null) {
        await _seleccionarEnCascadaDesdeAnio(anioProvider.selectedAnio!.id!);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final anioProvider = Provider.of<AnioLectivoProvider>(context);
    final colegioProvider = Provider.of<ColegioProvider>(context);
    final asignaturaProvider = Provider.of<AsignaturaProvider>(context);
    final gradoProvider = Provider.of<GradoProvider>(context);
    final seccionProvider = Provider.of<SeccionProvider>(context);
    final corteProvider = Provider.of<CorteEvaluativoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilters(anioProvider, colegioProvider, asignaturaProvider, gradoProvider, seccionProvider, corteProvider),
          const SizedBox(height: 16),
          _buildContent(),
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

    final anioId = anioProvider.selectedAnio?.id;
    final colegioId = colegioProvider.selectedColegio?.id;
    final asignaturaId = asignaturaProvider.selectedAsignatura?.id;
    final gradoId = gradoProvider.selectedGrado?.id;
    final seccionId = seccionProvider.selectedSeccion?.id;

    context.read<NotasProvider>().aplicarFiltros(
      anioLectivoId: anioId,
      colegioId: colegioId,
      asignaturaId: asignaturaId,
      gradoId: gradoId,
      seccionId: seccionId,
    );

    // Also apply filters to EstudianteProvider so the table shows filtered students
    context.read<EstudianteProvider>().aplicarFiltros(
      anioLectivoId: anioId,
      colegioId: colegioId,
      asignaturaId: asignaturaId,
      gradoId: gradoId,
      seccionId: seccionId,
    );
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar año lectivo
  Future<void> _seleccionarEnCascadaDesdeAnio(int anioLectivoId) async {
    final notasProvider = context.read<NotasProvider>();
    final colegioProvider = context.read<ColegioProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener colegios disponibles y seleccionar el primero
    final colegiosIds = await notasProvider.obtenerColegiosDisponibles(anioLectivoId);

    if (colegiosIds.isNotEmpty) {
      final colegioDisponible = colegioProvider.colegios.firstWhere(
        (c) => colegiosIds.contains(c.id),
        orElse: () => colegioProvider.colegios.first,
      );
      colegioProvider.seleccionarColegio(colegioDisponible);

      await _seleccionarEnCascadaDesdeColegio(anioLectivoId, colegioDisponible.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar colegio
  Future<void> _seleccionarEnCascadaDesdeColegio(int anioLectivoId, int colegioId) async {
    final notasProvider = context.read<NotasProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener asignaturas disponibles y seleccionar la primera
    final asignaturasIds = await notasProvider.obtenerAsignaturasDisponibles(anioLectivoId, colegioId);

    if (asignaturasIds.isNotEmpty) {
      final asignaturaDisponible = asignaturaProvider.asignaturas.firstWhere(
        (a) => asignaturasIds.contains(a.id),
        orElse: () => asignaturaProvider.asignaturas.first,
      );
      asignaturaProvider.seleccionarAsignatura(asignaturaDisponible);

      await _seleccionarEnCascadaDesdeAsignatura(anioLectivoId, colegioId, asignaturaDisponible.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar asignatura
  Future<void> _seleccionarEnCascadaDesdeAsignatura(int anioLectivoId, int colegioId, int asignaturaId) async {
    final notasProvider = context.read<NotasProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener grados disponibles y seleccionar el primero
    final gradosIds = await notasProvider.obtenerGradosDisponibles(anioLectivoId, colegioId, asignaturaId);

    if (gradosIds.isNotEmpty) {
      final gradoDisponible = gradoProvider.grados.firstWhere(
        (g) => gradosIds.contains(g.id),
        orElse: () => gradoProvider.grados.first,
      );
      gradoProvider.seleccionarGrado(gradoDisponible);

      await _seleccionarEnCascadaDesdeGrado(anioLectivoId, colegioId, asignaturaId, gradoDisponible.id!);
    }
  }

  /// Selecciona automáticamente los filtros en cascada después de seleccionar grado
  Future<void> _seleccionarEnCascadaDesdeGrado(int anioLectivoId, int colegioId, int asignaturaId, int gradoId) async {
    final notasProvider = context.read<NotasProvider>();
    final seccionProvider = context.read<SeccionProvider>();

    // Obtener secciones disponibles y seleccionar la primera
    final seccionesIds = await notasProvider.obtenerSeccionesDisponibles(anioLectivoId, colegioId, asignaturaId, gradoId);

    if (seccionesIds.isNotEmpty) {
      final seccionDisponible = seccionProvider.secciones.firstWhere(
        (s) => seccionesIds.contains(s.id),
        orElse: () => seccionProvider.secciones.first,
      );
      seccionProvider.seleccionarSeccion(seccionDisponible);
    }

    // Aplicar filtros finales
    _aplicarFiltros();
  }

  /// Busca y selecciona el año lectivo más cercano disponible para un colegio específico
  Future<void> _seleccionarAnioCercanoDesdeColegio(int colegioId) async {
    final notasProvider = context.read<NotasProvider>();
    final anioProvider = context.read<AnioLectivoProvider>();

    // Buscar años disponibles para este colegio
    final aniosIds = await notasProvider.obtenerAniosDisponiblesDesdeColegio(colegioId);

    if (aniosIds.isNotEmpty) {
      // Seleccionar el año más reciente disponible
      final anioDisponible = anioProvider.anios.firstWhere(
        (a) => aniosIds.contains(a.id),
        orElse: () => anioProvider.anios.firstWhere(
          (a) => aniosIds.contains(a.id),
          orElse: () => anioProvider.anios.first,
        ),
      );
      anioProvider.seleccionarAnio(anioDisponible);

      // Continuar la cascada desde colegio con el año seleccionado
      await _seleccionarEnCascadaDesdeColegio(anioDisponible.id!, colegioId);
    }
  }

  Widget _buildFilters(
    AnioLectivoProvider anioProvider,
    ColegioProvider colegioProvider,
    AsignaturaProvider asignaturaProvider,
    GradoProvider gradoProvider,
    SeccionProvider seccionProvider,
    CorteEvaluativoProvider corteProvider,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: _buildDropdown(
                      label: 'Año Lectivo',
                      value: anioProvider.selectedAnio?.nombre ?? 'Seleccionar',
                      items: anioProvider.anios.map((anio) => anio.nombre).toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          final selectedAnio = anioProvider.anios.firstWhere(
                            (anio) => anio.nombre == value,
                            orElse: () => anioProvider.anios.first,
                          );
                          anioProvider.seleccionarAnio(selectedAnio);
                          // Reset Corte filter when changing year
                          context.read<NotasProvider>().aplicarFiltroCorte(null);
                          // Selección en cascada automática
                          await _seleccionarEnCascadaDesdeAnio(selectedAnio.id!);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer<NotasProvider>(
                    builder: (context, notasProvider, _) {
                      final anioLectivoId = context.read<AnioLectivoProvider>().selectedAnio?.id;
                      final cortesDisponibles = notasProvider.obtenerCortesDisponibles(anioLectivoId ?? 1);
                      return FutureBuilder<List<CorteEvaluativo>>(
                        future: cortesDisponibles,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(width: 150, child: Center(child: CircularProgressIndicator()));
                          }

                          final cortesFiltrados = snapshot.data ?? [];
                          final corteSeleccionado = corteProvider.selectedCorte;

                          return SizedBox(
                            width: 150,
                            child: _buildDropdown(
                              label: 'Corte Evaluativo',
                              value: corteSeleccionado?.nombre ?? 'Seleccionar',
                              items: cortesFiltrados.map((corte) => corte.nombre).toList(),
                              onChanged: (value) {
                                if (value != null && cortesFiltrados.isNotEmpty) {
                                  final selectedCorte = cortesFiltrados.firstWhere(
                                    (corte) => corte.nombre == value,
                                    orElse: () => cortesFiltrados.first,
                                  );
                                  corteProvider.seleccionarCorte(selectedCorte);
                                  notasProvider.aplicarFiltroCorte(selectedCorte.id);

                                  // If all filters are now complete, apply them to EstudianteProvider for the table
                                  final anioId = context.read<AnioLectivoProvider>().selectedAnio?.id;
                                  final colegioId = context.read<ColegioProvider>().selectedColegio?.id;
                                  final asignaturaId = context.read<AsignaturaProvider>().selectedAsignatura?.id;
                                  final gradoId = context.read<GradoProvider>().selectedGrado?.id;
                                  final seccionId = context.read<SeccionProvider>().selectedSeccion?.id;

                                  if (anioId != null && colegioId != null && asignaturaId != null && gradoId != null && seccionId != null) {
                                    context.read<EstudianteProvider>().aplicarFiltros(
                                      anioLectivoId: anioId,
                                      colegioId: colegioId,
                                      asignaturaId: asignaturaId,
                                      gradoId: gradoId,
                                      seccionId: seccionId,
                                    );
                                  }
                                }
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 150,
                    child: _buildDropdown(
                      label: 'Colegio',
                      value: colegioProvider.selectedColegio?.nombre ?? 'Seleccionar',
                      items: colegioProvider.colegios.map((colegio) => colegio.nombre).toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          final selectedColegio = colegioProvider.colegios.firstWhere(
                            (colegio) => colegio.nombre == value,
                            orElse: () => colegioProvider.colegios.first,
                          );
                          colegioProvider.seleccionarColegio(selectedColegio);

                          // Reset Corte filter when changing colegio
                          context.read<NotasProvider>().aplicarFiltroCorte(null);

                          // Si hay año lectivo seleccionado, hacer cascada desde colegio
                          if (anioProvider.selectedAnio != null) {
                            await _seleccionarEnCascadaDesdeColegio(
                              anioProvider.selectedAnio!.id!,
                              selectedColegio.id!,
                            );
                          }
                          // Si no hay año lectivo pero hay colegio, buscar años disponibles para este colegio
                          else {
                            await _seleccionarAnioCercanoDesdeColegio(selectedColegio.id!);
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
                      value: asignaturaProvider.selectedAsignatura?.nombre ?? 'Seleccionar',
                      items: asignaturaProvider.asignaturas.map((a) => a.nombre).toList(),
                      onChanged: (value) async {
                        if (value != null &&
                            anioProvider.selectedAnio != null &&
                            colegioProvider.selectedColegio != null) {
                          final selected = asignaturaProvider.asignaturas.firstWhere(
                            (a) => a.nombre == value,
                            orElse: () => asignaturaProvider.asignaturas.first,
                          );
                          asignaturaProvider.seleccionarAsignatura(selected);
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
                      value: gradoProvider.selectedGrado?.nombre ?? 'Seleccionar',
                      items: gradoProvider.grados.map((g) => g.nombre).toList(),
                      onChanged: (value) async {
                        if (value != null &&
                            anioProvider.selectedAnio != null &&
                            colegioProvider.selectedColegio != null &&
                            asignaturaProvider.selectedAsignatura != null) {
                          final selected = gradoProvider.grados.firstWhere(
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
                      value: seccionProvider.selectedSeccion?.letra ?? 'Seleccionar',
                      items: seccionProvider.secciones.map((s) => s.letra).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final selected = seccionProvider.secciones.firstWhere(
                            (s) => s.letra == value,
                            orElse: () => seccionProvider.secciones.first,
                          );
                          seccionProvider.seleccionarSeccion(selected);
                          _aplicarFiltros();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Fila con botón de limpiar filtros y botón de búsqueda
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón para limpiar filtros
                Consumer<NotasProvider>(
                  builder: (context, provider, _) {
                    if (provider.tieneFiltrosActivos) {
                      return TextButton.icon(
                        onPressed: () {
                          provider.limpiarFiltros();
                        },
                        icon: const Icon(Icons.clear_all, size: 18),
                        label: const Text('Limpiar filtros'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                // Botón de búsqueda integrado
                FloatingActionButton(
                  onPressed: _showSearchDialog,
                  backgroundColor: AppTheme.primaryColor,
                  mini: true, // Tamaño más pequeño
                  child: const Icon(Icons.search, size: 20),
                  tooltip: 'Buscar estudiante',
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
        initialValue: value != 'Seleccionar' && items.contains(value) ? value : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Text(
              item,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        )).toList(),
        onChanged: onChanged,
        isExpanded: true,
      );

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text(
              'Buscar Estudiante',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Buscar estudiante',
              controller: _searchController,
              hint: 'Nombre o número de identidad',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) {
                final provider = context.read<NotasProvider>();
                if (provider.todosLosFiltrosCompletosConCorte()) {
                  // Use detailed search when Corte is selected
                  provider.buscarDetalladas(value);
                } else {
                  // Use regular search otherwise
                  provider.buscar(value);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cerrar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            TextButton(
              onPressed: () {
                _searchController.clear();
                final provider = context.read<NotasProvider>();
                if (provider.todosLosFiltrosCompletosConCorte()) {
                  provider.buscarDetalladas('');
                } else {
                  provider.limpiarBusqueda();
                }
              },
              child: const Text(
                'Limpiar',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotasList() => Consumer<NotasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            );
          }

          if (provider.notas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    message: 'No hay notas registradas',
                    icon: Icons.grade,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Configure los filtros para ver las notas',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          // Group by student
          final notasPorEstudiante = <int, List<Nota>>{};
          for (final nota in provider.notas) {
            notasPorEstudiante.putIfAbsent(nota.estudianteId, () => []).add(nota);
          }

          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notasPorEstudiante.length,
              itemBuilder: (context, index) {
                final estudianteId = notasPorEstudiante.keys.elementAt(index);
                final notasEstudiante = notasPorEstudiante[estudianteId]!;
                final estudiante = notasEstudiante.first;

                return CustomCard(
                  backgroundColor: AppTheme.surfaceColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  estudiante.estudianteNombreCompleto,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (estudiante.numeroIdentidad != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: ${estudiante.numeroIdentidad!}',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Grades for each evaluation cut
                      ...notasEstudiante.map((nota) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                nota.corteEvaluativoNombre,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${nota.puntosObtenidos}/${nota.puntosTotales}',
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getCalificacionColor(nota.calificacion),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    nota.calificacion,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${nota.porcentaje}%',
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );

  Widget _buildContent() => Consumer2<NotasProvider, CorteEvaluativoProvider>(
        builder: (context, notasProvider, corteProvider, _) {
          // If Corte is selected, show the editable grades table
          if (corteProvider.selectedCorte != null) {
            return _buildEditableGradesTable();
          } else {
            // Otherwise, show the list view
            return _buildNotasList();
          }
        },
      );

  Widget _buildEditableGradesTable() => Consumer3<NotasProvider, AsignaturaProvider, EstudianteProvider>(
        builder: (context, notasProvider, asignaturaProvider, estudianteProvider, _) {
          if (notasProvider.isLoading || estudianteProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            );
          }

          // Get filtered students
          final estudiantesFiltrados = _filtrarEstudiantes(estudianteProvider.estudiantes);

          if (estudiantesFiltrados.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    message: 'No hay estudiantes para calificar',
                    icon: Icons.people,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Configure los filtros para seleccionar estudiantes',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  color: AppTheme.surfaceColor,
                  child: Table(
                    border: TableBorder.all(color: AppTheme.textTertiary.withOpacity(0.3)),
                    columnWidths: _buildEditableTableColumnWidths(),
                    children: [
                      _buildEditableTableHeader(),
                      ...estudiantesFiltrados.map((estudiante) => _buildEditableTableRow(estudiante, asignaturaProvider.selectedAsignatura?.cualitativo ?? false)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

  Widget _buildNotasTable() => Consumer<NotasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            );
          }

          if (provider.notasDetalladas.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyState(
                    message: 'No hay notas registradas para este corte',
                    icon: Icons.table_chart,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Configure los filtros incluyendo el corte evaluativo',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            );
          }

          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  color: AppTheme.surfaceColor,
                  child: Table(
                    border: TableBorder.all(color: AppTheme.textTertiary.withOpacity(0.3)),
                    columnWidths: _buildTableColumnWidths(provider.notasDetalladas.first),
                    children: [
                      _buildTableHeader(provider.notasDetalladas.first),
                      ...provider.notasDetalladas.map(_buildTableRow),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

  Map<int, TableColumnWidth> _buildTableColumnWidths(NotaDetalle sampleNota) {
    final columnWidths = <int, TableColumnWidth>{};
    int colIndex = 0;

    // Student name column
    columnWidths[colIndex++] = const FixedColumnWidth(200);

    // Indicator columns (each indicator has 3 criteria + 1 total)
    for (final indicador in sampleNota.indicadores) {
      // 3 criteria columns
      for (int i = 0; i < 3; i++) {
        columnWidths[colIndex++] = const FixedColumnWidth(80);
      }
      // Total column for indicator
      columnWidths[colIndex++] = const FixedColumnWidth(100);
    }

    // Total column for cut
    columnWidths[colIndex++] = const FixedColumnWidth(120);

    return columnWidths;
  }

  TableRow _buildTableHeader(NotaDetalle sampleNota) {
    final headerCells = <TableCell>[];

    // Student header
    headerCells.add(const TableCell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Estudiante',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    ));

    // Indicator headers
    for (final indicador in sampleNota.indicadores) {
      // 3 criteria headers
      for (int i = 1; i <= 3; i++) {
        headerCells.add(TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              'C$i',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ));
      }
      // Total header for indicator
      headerCells.add(const TableCell(
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            'Total',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    // Total header for cut
    headerCells.add(const TableCell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Nota Final',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    ));

    return TableRow(
      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1)),
      children: headerCells,
    );
  }

  TableRow _buildTableRow(NotaDetalle nota) {
    final rowCells = <TableCell>[];

    // Student name cell
    rowCells.add(TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nota.estudianteNombreCompleto,
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            ),
            if (nota.numeroIdentidad != null)
              Text(
                'ID: ${nota.numeroIdentidad!}',
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              ),
          ],
        ),
      ),
    ));

    // Indicator cells
    for (final indicador in nota.indicadores) {
      // 3 criteria cells
      for (int i = 0; i < 3; i++) {
        final criterio = i < indicador.criterios.length ? indicador.criterios[i] : null;
        rowCells.add(TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              criterio != null ? criterio.puntosObtenidos.toString() : '0',
              style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
        ));
      }
      // Total cell for indicator
      rowCells.add(TableCell(
        child: Container(
          padding: const EdgeInsets.all(4),
          color: _getScoreColor(indicador.totalPuntos, indicador.totalMaximo),
          child: Text(
            '${indicador.totalPuntos}/${indicador.totalMaximo}',
            style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    // Total cell for cut
    rowCells.add(TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: _getCalificacionColor(nota.calificacion).withOpacity(0.2),
        child: Column(
          children: [
            Text(
              '${nota.totalPuntos}/${nota.totalMaximo}',
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getCalificacionColor(nota.calificacion),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                nota.calificacion,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${nota.porcentaje.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));

    return TableRow(
      children: rowCells,
    );
  }

  Color _getScoreColor(int puntos, int maximo) {
    if (maximo == 0) return Colors.grey.withOpacity(0.1);
    final porcentaje = puntos / maximo;
    if (porcentaje >= 0.9) return Colors.green.withOpacity(0.1);
    if (porcentaje >= 0.8) return Colors.lightGreen.withOpacity(0.1);
    if (porcentaje >= 0.7) return Colors.orange.withOpacity(0.1);
    if (porcentaje >= 0.6) return Colors.deepOrange.withOpacity(0.1);
    return Colors.red.withOpacity(0.1);
  }

  List<Estudiante> _filtrarEstudiantes(List<Estudiante> estudiantes) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return estudiantes;

    return estudiantes.where((estudiante) {
      final nombreCompleto = estudiante.nombreCompleto.toLowerCase();
      final identidad = estudiante.numeroIdentidad?.toLowerCase() ?? '';
      return nombreCompleto.contains(query) || identidad.contains(query);
    }).toList();
  }

  Map<int, TableColumnWidth> _buildEditableTableColumnWidths() {
    final columnWidths = <int, TableColumnWidth>{};
    int colIndex = 0;

    // Student name column
    columnWidths[colIndex++] = const FixedColumnWidth(200);

    // 5 indicators × (3 criteria + 1 total) = 20 columns
    for (int i = 0; i < 5; i++) {
      // 3 criteria columns per indicator
      for (int j = 0; j < 3; j++) {
        columnWidths[colIndex++] = const FixedColumnWidth(60);
      }
      // 1 total column per indicator
      columnWidths[colIndex++] = const FixedColumnWidth(80);
    }

    // Total points column
    columnWidths[colIndex++] = const FixedColumnWidth(100);

    return columnWidths;
  }

  TableRow _buildEditableTableHeader() {
    final headerCells = <TableCell>[];

    // Student header
    headerCells.add(const TableCell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Estudiante',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    ));

    // Indicator headers (I, II, III, IV, V)
    for (int indicadorIndex = 1; indicadorIndex <= 5; indicadorIndex++) {
      final romanNumeral = _getRomanNumeral(indicadorIndex);

      // 3 criteria headers per indicator
      for (int criterioIndex = 1; criterioIndex <= 3; criterioIndex++) {
        headerCells.add(TableCell(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Text(
              '$romanNumeral.$criterioIndex',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
        ));
      }

      // Total header for indicator
      headerCells.add(TableCell(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            '$romanNumeral Total',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ));
    }

    // Total points header
    headerCells.add(const TableCell(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Total Puntos',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          textAlign: TextAlign.center,
        ),
      ),
    ));

    return TableRow(
      decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1)),
      children: headerCells,
    );
  }

  TableRow _buildEditableTableRow(Estudiante estudiante, bool esCualitativa) {
    final rowCells = <TableCell>[];

    // Student name cell
    rowCells.add(TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              estudiante.nombreCompleto,
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
            ),
            if (estudiante.numeroIdentidad != null)
              Text(
                'ID: ${estudiante.numeroIdentidad!}',
                style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
              ),
          ],
        ),
      ),
    ));

    // Editable cells for each indicator and criteria
    int totalPuntos = 0;

    for (int indicadorIndex = 0; indicadorIndex < 5; indicadorIndex++) {
      int indicadorTotal = 0;

      // 3 criteria cells per indicator
      for (int criterioIndex = 0; criterioIndex < 3; criterioIndex++) {
        if (esCualitativa) {
          // For qualitative subjects, show dropdown or simple input
          rowCells.add(TableCell(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 30,
                child: TextFormField(
                  initialValue: '0',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    // Handle qualitative input (A, B, C, etc.)
                  },
                ),
              ),
            ),
          ));
        } else {
          // For quantitative subjects, show numeric input
          rowCells.add(TableCell(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                height: 30,
                child: TextFormField(
                  initialValue: '0',
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    final puntos = int.tryParse(value) ?? 0;
                    indicadorTotal += puntos;
                    // Update total calculations
                  },
                ),
              ),
            ),
          ));
        }
      }

      // Total cell for indicator
      rowCells.add(TableCell(
        child: Container(
          padding: const EdgeInsets.all(4),
          color: _getScoreColor(indicadorTotal, esCualitativa ? 12 : 20), // Max per indicator
          child: Text(
            '$indicadorTotal/${esCualitativa ? 12 : 20}',
            style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ));

      totalPuntos += indicadorTotal;
    }

    // Total points cell
    rowCells.add(TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: _getScoreColor(totalPuntos, esCualitativa ? 60 : 100), // Max total
        child: Column(
          children: [
            Text(
              '$totalPuntos/${esCualitativa ? 60 : 100}',
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getCalificacionColor(_calculateGrade(totalPuntos, esCualitativa)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _calculateGrade(totalPuntos, esCualitativa),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ));

    return TableRow(
      children: rowCells,
    );
  }

  String _getRomanNumeral(int number) {
    switch (number) {
      case 1: return 'I';
      case 2: return 'II';
      case 3: return 'III';
      case 4: return 'IV';
      case 5: return 'V';
      default: return number.toString();
    }
  }

  String _calculateGrade(int puntos, bool esCualitativa) {
    if (esCualitativa) {
      // Qualitative grading logic
      if (puntos >= 54) return 'A';
      if (puntos >= 48) return 'B';
      if (puntos >= 42) return 'C';
      if (puntos >= 36) return 'D';
      return 'F';
    } else {
      // Quantitative grading logic
      final porcentaje = (puntos / 100) * 100;
      if (porcentaje >= 90) return 'A';
      if (porcentaje >= 80) return 'B';
      if (porcentaje >= 70) return 'C';
      if (porcentaje >= 60) return 'D';
      return 'F';
    }
  }

  Color _getCalificacionColor(String calificacion) {
    switch (calificacion) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
