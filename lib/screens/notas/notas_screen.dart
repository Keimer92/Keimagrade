import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/nota.dart';
import '../../models/nota_detalle.dart';
import '../../models/estudiante.dart';
import '../../models/indicador_evaluacion.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../providers/estudiante_provider.dart';
import '../../providers/asignatura_provider.dart';
import '../../providers/colegio_provider.dart';
import '../../providers/corte_evaluativo_provider.dart';
import '../../providers/notas_provider.dart';
import '../../providers/grado_provider.dart';
import '../../providers/seccion_provider.dart';
import '../../providers/indicador_evaluacion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class NotasScreen extends StatefulWidget {
  const NotasScreen({Key? key}) : super(key: key);

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};
  String? _sexoSeleccionado = 'Todos';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final anioP = context.read<AnioLectivoProvider>();
      final colegioP = context.read<ColegioProvider>();
      final asignaturaP = context.read<AsignaturaProvider>();
      final gradoP = context.read<GradoProvider>();
      final seccionP = context.read<SeccionProvider>();

      await anioP.cargarAnios();
      await colegioP.cargarColegios();
      await asignaturaP.cargarAsignaturas();
      await gradoP.cargarGrados();
      await seccionP.cargarSecciones();

      if (mounted) {
        if (anioP.anios.isNotEmpty) {
          final anioPorDefecto = anioP.anios.firstWhere(
            (a) => a.porDefecto,
            orElse: () => anioP.anios.first,
          );
          anioP.seleccionarAnio(anioPorDefecto);
          await _seleccionarEnCascadaDesdeAnio(anioPorDefecto.id!);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    for (final node in _focusNodes.values) {
      node.dispose();
    }
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  FocusNode _getOrCreateFocusNode(int studentId, int criterionId) {
    final key = '$studentId-$criterionId';
    if (!_focusNodes.containsKey(key)) {
      _focusNodes[key] = FocusNode();
    }
    return _focusNodes[key]!;
  }

  TextEditingController _getOrCreateController(
      int studentId, int criterionId, String initialValue) {
    final key = '$studentId-$criterionId';
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: initialValue);
    } else {
      if (!_focusNodes.containsKey(key) ||
          (!_focusNodes[key]!.hasFocus &&
              _controllers[key]!.text != initialValue)) {
        _controllers[key]!.text = initialValue;
      }
    }
    return _controllers[key]!;
  }

  void _moverEnfoque(
      List<Estudiante> estudiantes,
      List<IndicadorEvaluacion> indicadores,
      int studentIndex,
      int indicatorIndex,
      int criterionIndex,
      LogicalKeyboardKey key) {
    int nextStudentIndex = studentIndex;
    int nextIndicatorIndex = indicatorIndex;
    int nextCriterionIndex = criterionIndex;

    if (key == LogicalKeyboardKey.arrowDown) {
      nextStudentIndex++;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      nextStudentIndex--;
    } else if (key == LogicalKeyboardKey.arrowRight) {
      nextCriterionIndex++;
      if (nextCriterionIndex >= 3) {
        nextCriterionIndex = 0;
        nextIndicatorIndex++;
      }
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      nextCriterionIndex--;
      if (nextCriterionIndex < 0) {
        nextCriterionIndex = 2;
        nextIndicatorIndex--;
      }
    }

    if (nextStudentIndex >= 0 &&
        nextStudentIndex < estudiantes.length &&
        nextIndicatorIndex >= 0 &&
        nextIndicatorIndex < indicadores.length) {
      final nextStudent = estudiantes[nextStudentIndex];
      final nextIndicador = indicadores[nextIndicatorIndex];
      if (nextCriterionIndex < nextIndicador.criterios.length) {
        final nextCriterio = nextIndicador.criterios[nextCriterionIndex];
        _getOrCreateFocusNode(nextStudent.id!, nextCriterio.id!).requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          _buildFilters(anioProvider, colegioProvider, asignaturaProvider,
              gradoProvider, seccionProvider, corteProvider),
          const SizedBox(height: 16),
          _buildContent(),
        ],
      ),
    );
  }

  Future<void> _aplicarFiltros() async {
    final anioId = context.read<AnioLectivoProvider>().selectedAnio?.id;
    final colegioId = context.read<ColegioProvider>().selectedColegio?.id;
    final asignaturaId =
        context.read<AsignaturaProvider>().selectedAsignatura?.id;
    final gradoId = context.read<GradoProvider>().selectedGrado?.id;
    final seccionId = context.read<SeccionProvider>().selectedSeccion?.id;

    await context.read<NotasProvider>().aplicarFiltros(
          anioLectivoId: anioId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
        );

    if (!mounted) return;
    await context.read<EstudianteProvider>().aplicarFiltros(
          anioLectivoId: anioId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
          sexo: _sexoSeleccionado,
        );
  }

  Future<void> _seleccionarEnCascadaDesdeAnio(int anioLectivoId) async {
    final notasProvider = context.read<NotasProvider>();
    final colegioProvider = context.read<ColegioProvider>();
    final corteProvider = context.read<CorteEvaluativoProvider>();
    final indProvider = context.read<IndicadorEvaluacionProvider>();

    await corteProvider.cargarCortesPorAnio(anioLectivoId);
    final cortesDisponibles = corteProvider.cortes;

    if (cortesDisponibles.isNotEmpty) {
      if (corteProvider.selectedCorte == null ||
          !cortesDisponibles
              .any((c) => c.id == corteProvider.selectedCorte?.id)) {
        final primerCorte = cortesDisponibles.first;
        corteProvider.seleccionarCorte(primerCorte);
        await notasProvider.aplicarFiltroCorte(primerCorte.id);
        await indProvider.cargarIndicadoresPorCorte(primerCorte.id!);
      }
    }

    final colegiosIds =
        await notasProvider.obtenerColegiosDisponibles(anioLectivoId);

    if (!mounted) return;

    if (colegiosIds.isNotEmpty) {
      if (colegioProvider.selectedColegio == null ||
          !colegiosIds.contains(colegioProvider.selectedColegio?.id)) {
        final listaColegios = colegioProvider.colegios
            .where((c) => colegiosIds.contains(c.id))
            .toList();
        listaColegios.sort((a, b) => a.nombre.compareTo(b.nombre));
        colegioProvider.seleccionarColegio(listaColegios.first);
      }
      await _seleccionarEnCascadaDesdeColegio(
          anioLectivoId, colegioProvider.selectedColegio!.id!);
    }
  }

  Future<void> _seleccionarEnCascadaDesdeColegio(
      int anioLectivoId, int colegioId) async {
    final notasProvider = context.read<NotasProvider>();
    final asignaturaProvider = context.read<AsignaturaProvider>();
    final asignaturasIds = await notasProvider.obtenerAsignaturasDisponibles(
        anioLectivoId, colegioId);

    if (!mounted) return;

    if (asignaturasIds.isNotEmpty) {
      if (asignaturaProvider.selectedAsignatura == null ||
          !asignaturasIds.contains(asignaturaProvider.selectedAsignatura?.id)) {
        final lista = asignaturaProvider.asignaturas
            .where((a) => asignaturasIds.contains(a.id))
            .toList();
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));
        asignaturaProvider.seleccionarAsignatura(lista.first);
      }
      await _seleccionarEnCascadaDesdeAsignatura(
          anioLectivoId, colegioId, asignaturaProvider.selectedAsignatura!.id!);
    }
  }

  Future<void> _seleccionarEnCascadaDesdeAsignatura(
      int anioLectivoId, int colegioId, int asignaturaId) async {
    final notasProvider = context.read<NotasProvider>();
    final gradoProvider = context.read<GradoProvider>();
    final gradosIds = await notasProvider.obtenerGradosDisponibles(
        anioLectivoId, colegioId, asignaturaId);

    if (!mounted) return;

    if (gradosIds.isNotEmpty) {
      if (gradoProvider.selectedGrado == null ||
          !gradosIds.contains(gradoProvider.selectedGrado?.id)) {
        final lista = gradoProvider.grados
            .where((g) => gradosIds.contains(g.id))
            .toList();
        lista.sort((a, b) => a.numero.compareTo(b.numero));
        gradoProvider.seleccionarGrado(lista.first);
      }
      await _seleccionarEnCascadaDesdeGrado(anioLectivoId, colegioId,
          asignaturaId, gradoProvider.selectedGrado!.id!);
    }
  }

  Future<void> _seleccionarEnCascadaDesdeGrado(
      int anioLectivoId, int colegioIdParam, int asignaturaIdParam, int gradoIdParam) async {
    final notasProvider = context.read<NotasProvider>();
    final seccionProvider = context.read<SeccionProvider>();
    final seccionesIds = await notasProvider.obtenerSeccionesDisponibles(
        anioLectivoId, colegioIdParam, asignaturaIdParam, gradoIdParam);

    if (!mounted) return;

    if (seccionesIds.isNotEmpty) {
      if (seccionProvider.selectedSeccion == null ||
          !seccionesIds.contains(seccionProvider.selectedSeccion?.id)) {
        final lista = seccionProvider.secciones
            .where((s) => seccionesIds.contains(s.id))
            .toList();
        lista.sort((a, b) => a.letra.compareTo(b.letra));
        seccionProvider.seleccionarSeccion(lista.first);
      }
    }

    // Aplicar filtros sin incluir el filtro de sexo durante el proceso en cascada
    // para evitar interferir con la carga inicial de datos
    final anioId = context.read<AnioLectivoProvider>().selectedAnio?.id;
    final colegioId = context.read<ColegioProvider>().selectedColegio?.id;
    final asignaturaId = context.read<AsignaturaProvider>().selectedAsignatura?.id;
    final gradoId = context.read<GradoProvider>().selectedGrado?.id;
    final seccionId = context.read<SeccionProvider>().selectedSeccion?.id;

    if (!mounted) return;

    final provider = context.read<NotasProvider>();
    await provider.aplicarFiltros(
          anioLectivoId: anioId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
        );

    if (!mounted) return;

    // Aplicar filtros de estudiantes SIN el filtro de sexo durante el proceso en cascada
    await context.read<EstudianteProvider>().aplicarFiltros(
          anioLectivoId: anioId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
          sexo: null, // No aplicar filtro de sexo durante el proceso en cascada
        );
  }

  Future<void> _seleccionarAnioCercanoDesdeColegio(int colegioId) async {
    final notasProvider = context.read<NotasProvider>();
    final anioProvider = context.read<AnioLectivoProvider>();
    final aniosIds =
        await notasProvider.obtenerAniosDisponiblesDesdeColegio(colegioId);

    if (aniosIds.isNotEmpty) {
      if (!mounted) return;
      if (anioProvider.selectedAnio == null ||
          !aniosIds.contains(anioProvider.selectedAnio?.id)) {
        final anioDisponible = anioProvider.anios.firstWhere(
            (a) => aniosIds.contains(a.id),
            orElse: () => anioProvider.anios.first);
        anioProvider.seleccionarAnio(anioDisponible);
      }
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
    CorteEvaluativoProvider corteProvider,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).scaffoldBackgroundColor,
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
                      items: anioProvider.anios
                          .map((anio) => anio.nombre)
                          .toList(),
                      onChanged: (value) async {
                        if (value != null) {
                          final selectedAnio = anioProvider.anios.firstWhere(
                              (anio) => anio.nombre == value,
                              orElse: () => anioProvider.anios.first);
                          anioProvider.seleccionarAnio(selectedAnio);
                          corteProvider.seleccionarCorte(null);
                          await context
                              .read<NotasProvider>()
                              .aplicarFiltroCorte(null);
                          await _seleccionarEnCascadaDesdeAnio(
                              selectedAnio.id!);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer<CorteEvaluativoProvider>(
                    builder: (context, corteProvider, _) {
                      if (corteProvider.isLoading) {
                        return const SizedBox(
                            width: 150,
                            child: Center(child: CircularProgressIndicator()));
                      }
                      final cortesFiltrados = corteProvider.cortes;
                      final corteSeleccionado = corteProvider.selectedCorte;
                      return SizedBox(
                        width: 150,
                        child: _buildDropdown(
                          label: 'Corte Evaluativo',
                          value: corteSeleccionado?.nombre ?? 'Seleccionar',
                          items: cortesFiltrados
                              .map((corte) => corte.nombre)
                              .toList(),
                          onChanged: (value) async {
                            if (value != null && cortesFiltrados.isNotEmpty) {
                              final selectedCorte = cortesFiltrados.firstWhere(
                                  (corte) => corte.nombre == value,
                                  orElse: () => cortesFiltrados.first);
                              corteProvider.seleccionarCorte(selectedCorte);

                              final notasP = context.read<NotasProvider>();
                              final indicadorP =
                                  context.read<IndicadorEvaluacionProvider>();

                              await notasP.aplicarFiltroCorte(selectedCorte.id);
                              await indicadorP.cargarIndicadoresPorCorte(
                                  selectedCorte.id!);

                              if (!mounted) return;
                              await _aplicarFiltros();
                            }
                          },
                        ),
                      );
                    },
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
                          final selectedColegio = colegioProvider.colegios
                              .firstWhere((colegio) => colegio.nombre == value,
                                  orElse: () => colegioProvider.colegios.first);
                          colegioProvider.seleccionarColegio(selectedColegio);
                          if (anioProvider.selectedAnio != null) {
                            await _seleccionarEnCascadaDesdeColegio(
                                anioProvider.selectedAnio!.id!,
                                selectedColegio.id!);
                          } else {
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
                      value: asignaturaProvider.selectedAsignatura?.nombre ??
                          'Seleccionar',
                      items: asignaturaProvider.asignaturas
                          .map((a) => a.nombre)
                          .toList(),
                      onChanged: (value) async {
                        if (value != null &&
                            anioProvider.selectedAnio != null &&
                            colegioProvider.selectedColegio != null) {
                          final selected = asignaturaProvider.asignaturas
                              .firstWhere((a) => a.nombre == value,
                                  orElse: () =>
                                      asignaturaProvider.asignaturas.first);
                          asignaturaProvider.seleccionarAsignatura(selected);
                          await _seleccionarEnCascadaDesdeAsignatura(
                              anioProvider.selectedAnio!.id!,
                              colegioProvider.selectedColegio!.id!,
                              selected.id!);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 150,
                    child: _buildDropdown(
                      label: 'Grado',
                      value:
                          gradoProvider.selectedGrado?.nombre ?? 'Seleccionar',
                      items: gradoProvider.grados.map((g) => g.nombre).toList(),
                      onChanged: (value) async {
                        if (value != null &&
                            anioProvider.selectedAnio != null &&
                            colegioProvider.selectedColegio != null &&
                            asignaturaProvider.selectedAsignatura != null) {
                          final selected = gradoProvider.grados.firstWhere(
                              (g) => g.nombre == value,
                              orElse: () => gradoProvider.grados.first);
                          gradoProvider.seleccionarGrado(selected);
                          await _seleccionarEnCascadaDesdeGrado(
                              anioProvider.selectedAnio!.id!,
                              colegioProvider.selectedColegio!.id!,
                              asignaturaProvider.selectedAsignatura!.id!,
                              selected.id!);
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
                      onChanged: (value) async {
                          if (value != null) {
                            final selected = seccionProvider.secciones.firstWhere(
                                (s) => s.letra == value,
                                orElse: () => seccionProvider.secciones.first);
                            seccionProvider.seleccionarSeccion(selected);
                            await _aplicarFiltros();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 120,
                      child: _buildDropdown(
                        label: 'Sexo',
                        value: _sexoSeleccionado ?? 'Todos',
                        items: const ['Todos', 'Masculino', 'Femenino'],
                        onChanged: (value) async {
                          if (value != null) {
                            setState(() {
                              _sexoSeleccionado = value == 'Todos' ? null : value;
                            });
                            await _aplicarFiltros();
                          }
                        },
                      ),
                    ),
                  const SizedBox(width: 12),
                  ListenableBuilder(
                    listenable:
                        Listenable.merge([_searchController, _searchFocusNode]),
                    builder: (context, _) {
                      final hasText = _searchController.text.isNotEmpty;
                      final hasFocus = _searchFocusNode.hasFocus;
                      final double width = (hasText || hasFocus) ? 220 : 120;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: width,
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (value) {
                            final provider = context.read<NotasProvider>();
                            if (provider.todosLosFiltrosCompletosConCorte()) {
                              provider.buscarDetalladas(value);
                            } else {
                              provider.buscar(value);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Buscar...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: hasText
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      final provider =
                                          context.read<NotasProvider>();
                                      if (provider
                                          .todosLosFiltrosCompletosConCorte()) {
                                        provider.buscarDetalladas('');
                                      } else {
                                        provider.buscar('');
                                      }
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
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => _guardarTodasLasNotas(context),
                    icon: const Icon(Icons.save_rounded, size: 24),
                    tooltip: 'Guardar todas las notas',
                    color: AppTheme.getPrimaryColor(context),
                  ),
                ],
              ),
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
        value:
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
                child: Text(item, overflow: TextOverflow.ellipsis)))
            .toList(),
        onChanged: onChanged,
        isExpanded: true,
      );

  Widget _buildNotasList() => Consumer<NotasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)));
          }
          if (provider.notas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                      message: 'No hay notas registradas', icon: Icons.grade),
                  const SizedBox(height: 24),
                  Text('Configure los filtros para ver las notas',
                      style:
                          TextStyle(color: AppTheme.getTextSecondary(context))),
                ],
              ),
            );
          }
          final notasPorEstudiante = <int, List<Nota>>{};
          for (final nota in provider.notas) {
            notasPorEstudiante
                .putIfAbsent(nota.estudianteId, () => [])
                .add(nota);
          }
          return Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notasPorEstudiante.length,
              itemBuilder: (context, index) {
                final estudianteId = notasPorEstudiante.keys.elementAt(index);
                final notasEstudiante = notasPorEstudiante[estudianteId]!;
                final estudianteFirst = notasEstudiante.first;
                return CustomCard(
                  backgroundColor: Theme.of(context).cardColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(estudianteFirst.estudianteNombreCompleto,
                          style: TextStyle(
                              color: AppTheme.getTextPrimary(context),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      if (estudianteFirst.numeroIdentidad != null)
                        Text('ID: ${estudianteFirst.numeroIdentidad!}',
                            style: TextStyle(
                                color: AppTheme.getTextSecondary(context),
                                fontSize: 12)),
                      const SizedBox(height: 12),
                      ...notasEstudiante.map((nota) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(nota.corteEvaluativoNombre,
                                        style: TextStyle(
                                            color: AppTheme.getTextSecondary(
                                                context),
                                            fontSize: 14))),
                                Row(
                                  children: [
                                    Text(
                                        '${nota.puntosObtenidos}/${nota.puntosTotales}',
                                        style: TextStyle(
                                            color: AppTheme.getTextPrimary(
                                                context),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: _getCalificacionColor(
                                              nota.calificacion),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Text(nota.calificacion,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('${nota.porcentaje}%',
                                        style: TextStyle(
                                            color: AppTheme.getTextSecondary(
                                                context),
                                            fontSize: 12)),
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
          if (corteProvider.selectedCorte != null) {
            return _buildEditableGradesTable();
          } else {
            return _buildNotasList();
          }
        },
      );

  Widget _buildEditableGradesTable() => Consumer5<
          NotasProvider,
          AsignaturaProvider,
          EstudianteProvider,
          IndicadorEvaluacionProvider,
          GradoProvider>(
        builder: (context, notasProvider, asignaturaProvider,
            estudianteProvider, indicadorProvider, gradoProvider, _) {
          if (notasProvider.isLoading ||
              estudianteProvider.isLoading ||
              indicadorProvider.isLoading) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)));
          }
          final estudiantesFiltrados =
              _filtrarEstudiantes(estudianteProvider.estudiantes);
          if (indicadorProvider.indicadores.isEmpty) {
            return const Center(
                child: EmptyState(
                    message: 'No hay indicadores configurados',
                    icon: Icons.assignment_late));
          }
          if (estudiantesFiltrados.isEmpty) {
            return const Center(
                child: EmptyState(
                    message: 'No hay estudiantes para calificar',
                    icon: Icons.people));
          }

          final esCualitativaAsignatura =
              asignaturaProvider.selectedAsignatura?.cualitativo ?? false;
          final esCualitativoGrado =
              gradoProvider.selectedGrado?.cualitativo ?? false;

          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: Table(
                    border: TableBorder.all(
                        color:
                            AppTheme.getTextTertiary(context).withValues(alpha: 0.3)),
                    columnWidths: _buildEditableTableColumnWidths(
                        indicadorProvider.indicadores),
                    children: [
                      ..._buildEditableTableHeadersWithConfig(
                          indicadorProvider.indicadores),
                      ...List.generate(
                        estudiantesFiltrados.length,
                        (index) {
                          final estudiante = estudiantesFiltrados[index];
                          final notaDetalle =
                              notasProvider.notasDetalladas.firstWhere(
                            (n) => n.estudianteId == estudiante.id,
                            orElse: () => _crearNotaVacia(
                                estudiante,
                                indicadorProvider.indicadores,
                                context
                                    .read<CorteEvaluativoProvider>()
                                    .selectedCorte!
                                    .id!,
                                context
                                    .read<CorteEvaluativoProvider>()
                                    .selectedCorte!
                                    .nombre),
                          );
                          return _buildEditableTableRowWithConfig(
                              estudiante,
                              esCualitativaAsignatura,
                              notaDetalle.indicadores,
                              index,
                              estudiantesFiltrados,
                              indicadorProvider.indicadores,
                              soloCualitativo: esCualitativaAsignatura ||
                                  esCualitativoGrado);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

  Map<int, TableColumnWidth> _buildEditableTableColumnWidths(
      List<IndicadorEvaluacion> indicadores) {
    final columnWidths = <int, TableColumnWidth>{};
    int colIndex = 0;
    columnWidths[colIndex++] = const FixedColumnWidth(200);
    for (int i = 0; i < indicadores.length; i++) {
      for (int j = 0; j < 3; j++) {
        columnWidths[colIndex++] = const FixedColumnWidth(60);
      }
      columnWidths[colIndex++] = const FixedColumnWidth(80);
    }
    columnWidths[colIndex++] = const FixedColumnWidth(100);
    return columnWidths;
  }

  List<TableRow> _buildEditableTableHeadersWithConfig(
      List<IndicadorEvaluacion> indicadores) {
    final firstRowCells = <TableCell>[];
    final secondRowCells = <TableCell>[];
    firstRowCells.add(TableCell(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Estudiante',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimary(context)),
                textAlign: TextAlign.center))));
    secondRowCells.add(const TableCell(child: SizedBox.shrink()));
    for (final indicador in indicadores) {
      for (int i = 0; i < 4; i++) {
        firstRowCells.add(TableCell(
            child: Tooltip(
                message: indicador.descripcion,
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Indicador ${indicador.numero}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getTextPrimary(context),
                            fontSize: 11),
                        textAlign: TextAlign.center)))));
      }

      for (int i = 0; i < 3; i++) {
        final criterio =
            i < indicador.criterios.length ? indicador.criterios[i] : null;

        secondRowCells.add(TableCell(
            child: Tooltip(
                message: criterio?.descripcion ?? 'Criterio ${i + 1}',
                child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text('C${i + 1}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.getTextPrimary(context),
                            fontSize: 10),
                        textAlign: TextAlign.center)))));
      }
      secondRowCells.add(TableCell(
          child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text('Total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextPrimary(context),
                      fontSize: 10),
                  textAlign: TextAlign.center))));
    }
    firstRowCells.add(TableCell(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Total Puntos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimary(context)),
                textAlign: TextAlign.center))));
    secondRowCells.add(const TableCell(child: SizedBox.shrink()));
    return [
      TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
          children: firstRowCells),
      TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.05)),
          children: secondRowCells),
    ];
  }

  TableRow _buildEditableTableRowWithConfig(
      Estudiante estudiante,
      bool esCualitativa,
      List<IndicadorDetalle> indicadores,
      int studentIndex,
      List<Estudiante> totalEstudiantes,
      List<IndicadorEvaluacion> totalIndicadores,
      {bool soloCualitativo = false}) {
    final rowCells = <TableCell>[];
    final esCualitativaReal = esCualitativa || soloCualitativo;

    rowCells.add(TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(estudiante.nombreCompleto,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.getTextPrimary(context))),
          if (estudiante.numeroIdentidad != null)
            Text('ID: ${estudiante.numeroIdentidad!}',
                style: TextStyle(
                    fontSize: 10, color: AppTheme.getTextSecondary(context))),
        ]),
      ),
    ));

    double totalPuntosRow = 0;
    for (int indicatorIndex = 0;
        indicatorIndex < indicadores.length;
        indicatorIndex++) {
      final indicador = indicadores[indicatorIndex];
      double indicadorTotalVal = 0;
      final indicadorModa = esCualitativaReal ? _calcularModaIndicador(indicador.criterios) : '';

      for (int criterioIndex = 0; criterioIndex < 3; criterioIndex++) {
        final criterio = indicador.criterios.length > criterioIndex
            ? indicador.criterios[criterioIndex]
            : null;
        if (criterio != null && !esCualitativaReal) indicadorTotalVal += criterio.puntosObtenidos;

        rowCells.add(TableCell(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              height: 30,
              child: criterio == null
                  ? const SizedBox.shrink()
                  : KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) {
                        if (event is KeyDownEvent &&
                            [
                              LogicalKeyboardKey.arrowUp,
                              LogicalKeyboardKey.arrowDown,
                              LogicalKeyboardKey.arrowLeft,
                              LogicalKeyboardKey.arrowRight
                            ].contains(event.logicalKey)) {
                          _moverEnfoque(
                              totalEstudiantes,
                              totalIndicadores,
                              studentIndex,
                              indicatorIndex,
                              criterioIndex,
                              event.logicalKey);
                        }
                      },
                      child: TextFormField(
                        controller: _getOrCreateController(
                            estudiante.id!,
                            criterio.id,
                            esCualitativaReal
                                ? (criterio.valorCualitativo ?? '')
                                : (criterio.puntosObtenidos % 1 == 0
                                    ? criterio.puntosObtenidos
                                        .toInt()
                                        .toString()
                                    : criterio.puntosObtenidos.toString())),
                        focusNode:
                            _getOrCreateFocusNode(estudiante.id!, criterio.id),
                        keyboardType: esCualitativaReal
                            ? TextInputType.text
                            : TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: esCualitativaReal
                                ? _getSiglaColor(
                                    criterio.valorCualitativo ?? '')
                                : AppTheme.getTextPrimary(context),
                            fontWeight: esCualitativaReal
                                ? FontWeight.bold
                                : FontWeight.normal),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            isDense: true),
                        inputFormatters: esCualitativaReal
                            ? [QualitativeInputFormatter()]
                            : [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                        onChanged: (value) async {
                          if (esCualitativaReal) {
                            final val = value.toUpperCase();
                            if (['AA', 'AS', 'AF', 'AI'].contains(val)) {
                              double f = 0;
                              if (val == 'AA') {
                                f = 1.0;
                              } else if (val == 'AS') {
                                f = 0.8;
                              } else if (val == 'AF') {
                                f = 0.6;
                              } else if (val == 'AI') {
                                f = 0.4;
                              }
                              await context
                                  .read<NotasProvider>()
                                  .guardarNotaManual(
                                      estudianteId: estudiante.id!,
                                      criterioId: criterio.id,
                                      valorCualitativo: val,
                                      puntosObtenidos:
                                          (f * criterio.puntosMaximos)
                                              .roundToDouble(),
                                      esCualitativa: true);
                            }
                          } else {
                            final pts = double.tryParse(value) ?? 0.0;
                            await context
                                .read<NotasProvider>()
                                .guardarNotaManual(
                                    estudianteId: estudiante.id!,
                                    criterioId: criterio.id,
                                    valorCualitativo: '',
                                    puntosObtenidos: pts.roundToDouble(),
                                    esCualitativa: false);
                          }
                        },
                        onTapOutside: (_) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ),
            ),
          ),
        ));
      }
      rowCells.add(TableCell(
          child: Container(
              padding: const EdgeInsets.all(4),
              color: esCualitativaReal
                  ? _getCalificacionColor(indicadorModa)
                  : _getScoreColor(indicadorTotalVal, indicador.totalMaximo),
              child: Text(
                  esCualitativaReal
                      ? indicadorModa
                      : '${indicadorTotalVal.round()}/${indicador.totalMaximo.toInt()}',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.getTextPrimary(context),
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center))));
      if (!esCualitativaReal) totalPuntosRow += indicadorTotalVal;
    }

    final double maxTotal =
        indicadores.fold(0, (sum, ind) => sum + ind.totalMaximo);
    final califFinal = esCualitativaReal
        ? _calcularModa(indicadores)
        : _calculateGrade(totalPuntosRow, false);

    rowCells.add(TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: esCualitativaReal
            ? _getCalificacionColor(califFinal).withValues(alpha: 0.2)
            : _getScoreColor(totalPuntosRow, maxTotal).withValues(alpha: 0.2),
        child: Column(children: [
          Text(esCualitativaReal
              ? califFinal
              : '${totalPuntosRow.round()}/${maxTotal.toInt()}',
              style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.getTextPrimary(context),
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: _getCalificacionColor(califFinal),
                borderRadius: BorderRadius.circular(8)),
            child: Text(califFinal,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    ));

    return TableRow(children: rowCells);
  }

  String _calculateGrade(double puntos, bool esCualitativa) {
    if (esCualitativa) {
      if (puntos >= 54) {
        return 'A';
      } else if (puntos >= 48) {
        return 'B';
      } else if (puntos >= 42) {
        return 'C';
      } else if (puntos >= 36) {
        return 'D';
      }
      return 'F';
    } else {
      final porcentaje = puntos; // Suponiendo que puntos es sobre 100
      if (porcentaje >= 90) {
        return 'A';
      } else if (porcentaje >= 80) {
        return 'B';
      } else if (porcentaje >= 70) {
        return 'C';
      } else if (porcentaje >= 60) {
        return 'D';
      }
      return 'F';
    }
  }

  Color _getCalificacionColor(String calificacion) {
    switch (calificacion) {
      case 'A':
      case 'AA':
        return Colors.green;
      case 'B':
      case 'AS':
        return Colors.lightGreen;
      case 'C':
      case 'AF':
        return Colors.orange;
      case 'D':
      case 'AI':
        return Colors.deepOrange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(double puntos, double maximo) {
    if (maximo == 0) return Colors.grey.withValues(alpha: 0.1);
    final porcentaje = puntos / maximo;
    if (porcentaje >= 0.9) {
      return Colors.green.withValues(alpha: 0.1);
    } else if (porcentaje >= 0.8) {
      return Colors.lightGreen.withValues(alpha: 0.1);
    } else if (porcentaje >= 0.7) {
      return Colors.orange.withValues(alpha: 0.1);
    } else if (porcentaje >= 0.6) {
      return Colors.deepOrange.withValues(alpha: 0.1);
    }
    return Colors.red.withValues(alpha: 0.1);
  }

  List<Estudiante> _filtrarEstudiantes(List<Estudiante> estudiantes) {
    final query = _searchController.text.toLowerCase();
    return query.isEmpty
        ? estudiantes
        : estudiantes
            .where((e) =>
                e.nombreCompleto.toLowerCase().contains(query) ||
                (e.numeroIdentidad?.toLowerCase().contains(query) ?? false))
            .toList();
  }

  Color _getSiglaColor(String sigla) {
    switch (sigla) {
      case 'AA':
        return Colors.green.shade700;
      case 'AS':
        return Colors.blue.shade700;
      case 'AF':
        return Colors.orange.shade800;
      case 'AI':
        return Colors.red.shade700;
      default:
        return AppTheme.getTextPrimary(context);
    }
  }

  Future<void> _guardarTodasLasNotas(BuildContext context) async {
    // Las notas se guardan automáticamente al cambiar el valor en el campo de texto.
    // Este botón ahora solo confirma que los datos locales están sincronizados.
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Todas las notas han sido guardadas correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  NotaDetalle _crearNotaVacia(Estudiante estudiante,
      List<IndicadorEvaluacion> indicadores, int corteId, String corteNombre) {
    final nombres = estudiante.nombreCompleto.split(' ');
    return NotaDetalle(
      estudianteId: estudiante.id!,
      estudianteNombre: nombres.isNotEmpty ? nombres[0] : '',
      estudianteApellido:
          nombres.length > 1 ? nombres.sublist(1).join(' ') : '',
      numeroIdentidad: estudiante.numeroIdentidad,
      corteId: corteId,
      corteNombre: corteNombre,
      totalPuntos: 0,
      totalMaximo: 100,
      porcentaje: 0,
      calificacion: '-',
      indicadores: indicadores
          .map((i) => IndicadorDetalle(
              id: i.id!,
              numero: i.numero,
              descripcion: i.descripcion,
              totalPuntos: 0,
              totalMaximo: i.puntosTotales,
              criterios: i.criterios
                  .map((c) => CriterioDetalle(
                      id: c.id!,
                      numero: c.numero,
                      descripcion: c.descripcion,
                      puntosMaximos: c.puntosMaximos,
                      puntosObtenidos: 0,
                      valorCualitativo: ''))
                  .toList()))
          .toList(),
    );
  }

  String _calcularModaIndicador(List<CriterioDetalle> criterios) {
    final qualifying = ['AA', 'AS', 'AF'];
    final Map<String, int> frecuencias = {};
    for (final cri in criterios) {
      final sigla = cri.valorCualitativo ?? '';
      if (qualifying.contains(sigla)) {
        frecuencias[sigla] = (frecuencias[sigla] ?? 0) + 1;
      }
    }
    if (frecuencias.isEmpty) return '-';
    final maxFreq = frecuencias.values.reduce((a, b) => a > b ? a : b);
    final tied = frecuencias.entries.where((e) => e.value == maxFreq).map((e) => e.key).toList();
    if (tied.length == 1) return tied[0];
    // En caso de empate, ordenar por valor ascendente y tomar el del medio
    final order = {'AA': 4, 'AS': 3, 'AF': 2};
    tied.sort((a, b) => order[a]!.compareTo(order[b]!)); // asc: AF, AS, AA
    final middleIndex = tied.length ~/ 2;
    return tied[middleIndex];
  }

  String _calcularModa(List<IndicadorDetalle> indicadores) {
    final qualifying = ['AA', 'AS', 'AF'];
    final Map<String, int> frecuencias = {};
    for (final ind in indicadores) {
      for (final cri in ind.criterios) {
        final sigla = cri.valorCualitativo ?? '';
        if (qualifying.contains(sigla)) {
          frecuencias[sigla] = (frecuencias[sigla] ?? 0) + 1;
        }
      }
    }
    if (frecuencias.isEmpty) return '-';
    final maxFreq = frecuencias.values.reduce((a, b) => a > b ? a : b);
    final tied = frecuencias.entries.where((e) => e.value == maxFreq).map((e) => e.key).toList();
    if (tied.length == 1) return tied[0];
    // En caso de empate, ordenar por valor ascendente y tomar el del medio
    final order = {'AA': 4, 'AS': 3, 'AF': 2};
    tied.sort((a, b) => order[a]!.compareTo(order[b]!)); // asc: AF, AS, AA
    final middleIndex = tied.length ~/ 2;
    return tied[middleIndex];
  }
}

class QualitativeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.toUpperCase();
    if (text.isEmpty) return newValue.copyWith(text: '');
    if (RegExp(r'^(A|AA|AS|AF|AI|S|F|I)$').hasMatch(text)) {
      return newValue.copyWith(
          text: text, selection: TextSelection.collapsed(offset: text.length));
    }
    return oldValue;
  }
}
