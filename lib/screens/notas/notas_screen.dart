import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/nota.dart';
import '../../models/nota_detalle.dart';
import '../../models/corte_evaluativo.dart';
import '../../providers/anio_lectivo_provider.dart';
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
    Future.microtask(() {
      context.read<NotasProvider>().cargarNotas();
      context.read<AnioLectivoProvider>().cargarAnios();
      context.read<ColegioProvider>().cargarColegios();
      context.read<AsignaturaProvider>().cargarAsignaturas();
      context.read<GradoProvider>().cargarGrados();
      context.read<SeccionProvider>().cargarSecciones();
      context.read<CorteEvaluativoProvider>().cargarCortes();
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
          _buildSearch(),
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

    context.read<NotasProvider>().aplicarFiltros(
      anioLectivoId: anioProvider.selectedAnio?.id,
      colegioId: colegioProvider.selectedColegio?.id,
      asignaturaId: asignaturaProvider.selectedAsignatura?.id,
      gradoId: gradoProvider.selectedGrado?.id,
      seccionId: seccionProvider.selectedSeccion?.id,
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
        color: AppTheme.surfaceColor,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
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
                          return const Expanded(child: CircularProgressIndicator());
                        }

                        final cortesFiltrados = snapshot.data ?? [];
                        final corteSeleccionado = corteProvider.selectedCorte;

                        return Expanded(
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
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
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
                Expanded(
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
                Expanded(
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
                Expanded(
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
            const SizedBox(height: 12),
            // Botón para limpiar filtros
            Consumer<NotasProvider>(
              builder: (context, provider, _) {
                if (provider.tieneFiltrosActivos) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () {
                        provider.limpiarFiltros();
                      },
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Limpiar filtros'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
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
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      );

  Widget _buildSearch() => Consumer<NotasProvider>(
        builder: (context, provider, _) => Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.surfaceColor,
          child: Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'Buscar estudiante',
                  controller: _searchController,
                  hint: 'Nombre o número de identidad',
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) {
                    if (provider.todosLosFiltrosCompletosConCorte()) {
                      // Use detailed search when Corte is selected
                      context.read<NotasProvider>().buscarDetalladas(value);
                    } else {
                      // Use regular search otherwise
                      context.read<NotasProvider>().buscar(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _searchController.text.isNotEmpty
                    ? () {
                        _searchController.clear();
                        if (provider.todosLosFiltrosCompletosConCorte()) {
                          context.read<NotasProvider>().buscarDetalladas('');
                        } else {
                          context.read<NotasProvider>().limpiarBusqueda();
                        }
                      }
                    : null,
                color: _searchController.text.isNotEmpty ? AppTheme.primaryColor : AppTheme.textTertiary,
              ),
            ],
          ),
        ),
      );

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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    message: 'No hay notas registradas',
                    icon: Icons.grade,
                  ),
                  const SizedBox(height: 24),
                  const Text(
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

  Widget _buildContent() => Consumer<NotasProvider>(
        builder: (context, provider, _) {
          // If Corte is selected, show the detailed table
          if (provider.todosLosFiltrosCompletosConCorte()) {
            return _buildNotasTable();
          } else {
            // Otherwise, show the list view
            return _buildNotasList();
          }
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    message: 'No hay notas registradas para este corte',
                    icon: Icons.table_chart,
                  ),
                  const SizedBox(height: 24),
                  const Text(
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
                      ...provider.notasDetalladas.map((nota) => _buildTableRow(nota)),
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
