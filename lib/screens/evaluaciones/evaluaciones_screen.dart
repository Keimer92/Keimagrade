import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../providers/asignatura_provider.dart';
import '../../providers/corte_evaluativo_provider.dart';
import '../../providers/indicador_evaluacion_provider.dart';
import '../../providers/criterio_evaluacion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';

class EvaluacionesScreen extends StatefulWidget {
  const EvaluacionesScreen({Key? key}) : super(key: key);

  @override
  State<EvaluacionesScreen> createState() => _EvaluacionesScreenState();
}

class _EvaluacionesScreenState extends State<EvaluacionesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late CorteEvaluativoProvider _corteProvider;
  late IndicadorEvaluacionProvider _indicadorProvider;
  late CriterioEvaluacionProvider _criterioProvider;
  
  // Controladores para los campos de texto de criterios (solo para asignaturas cuantitativas)
  final List<TextEditingController> _criterioControllers = List.generate(15, (index) => TextEditingController());
  // Controladores para las descripciones de criterios
  final List<TextEditingController> _criterioDescripcionControllers = List.generate(15, (index) => TextEditingController());
  // Controladores para las descripciones de indicadores
  final List<TextEditingController> _indicadorDescripcionControllers = List.generate(5, (index) => TextEditingController());
  // Estado para los totales de indicadores (solo para asignaturas cuantitativas)
  final List<int> _indicadorTotales = List.filled(5, 20); // 5 indicadores, cada uno con 20 puntos por defecto
  // Estados de validación para criterios individuales
  final List<bool> _criterioErrores = List.filled(15, false);
  // Estados de validación para totales de indicadores
  final List<bool> _indicadorErrores = List.filled(5, false);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _corteProvider = CorteEvaluativoProvider();
    _indicadorProvider = IndicadorEvaluacionProvider();
    _criterioProvider = CriterioEvaluacionProvider();
    
    // Cargar datos iniciales
    Future.microtask(() {
      _corteProvider.cargarCortes();
      _indicadorProvider.cargarIndicadores();
      _criterioProvider.cargarCriterios();
      // Cargar asignaturas para que estén disponibles en el dropdown
      Provider.of<AsignaturaProvider>(context, listen: false).cargarAsignaturas();
    });
    
    // Configurar controladores con valores por defecto y listeners (solo para puntos)
    for (int i = 0; i < 15; i++) {
      final int numeroCriterio = (i % 3) + 1;
      final String defaultValue = numeroCriterio == 1 ? '7' : numeroCriterio == 2 ? '7' : '6';
      _criterioControllers[i].text = defaultValue;
      
      _criterioControllers[i].addListener(() {
        _validarCriterio(i);
        _calcularTotalIndicador(i ~/ 3);
      });
    }
    
    // Configurar descripciones por defecto para indicadores
    for (int i = 0; i < 5; i++) {
      _indicadorDescripcionControllers[i].text = 'Descripción del Indicador ${i + 1}';
    }
    
    // Configurar descripciones por defecto para criterios
    for (int i = 0; i < 15; i++) {
      final int numeroCriterio = (i % 3) + 1;
      _criterioDescripcionControllers[i].text = 'Descripción del Criterio $numeroCriterio';
    }
  }

  @override
  void dispose() {
    // Limpiar controladores
    for (final controller in _criterioControllers) {
      controller.dispose();
    }
    for (final controller in _criterioDescripcionControllers) {
      controller.dispose();
    }
    for (final controller in _indicadorDescripcionControllers) {
      controller.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  void _validarCriterio(int criterioIndex) {
    final text = _criterioControllers[criterioIndex].text;
    final value = int.tryParse(text) ?? 0;
    
    setState(() {
      _criterioErrores[criterioIndex] = value > 8;
    });
  }

  void _calcularTotalIndicador(int numeroIndicador) {
    if (numeroIndicador >= 0 && numeroIndicador < _indicadorTotales.length) {
      int total = 0;
      for (int i = 0; i < 3; i++) {
        final index = numeroIndicador * 3 + i;
        if (index < _criterioControllers.length) {
          final text = _criterioControllers[index].text;
          if (text.isNotEmpty) {
            final value = int.tryParse(text) ?? 0;
            total += value;
          }
        }
      }
      
      setState(() {
        _indicadorTotales[numeroIndicador] = total;
        _indicadorErrores[numeroIndicador] = total > 20;
      });
    }
  }

  bool _validarFormulario() {
    bool hayErrores = false;
    
    // Validar criterios individuales
    for (int i = 0; i < 15; i++) {
      if (_criterioErrores[i]) {
        hayErrores = true;
        break;
      }
    }
    
    // Validar totales de indicadores
    if (!hayErrores) {
      for (int i = 0; i < 5; i++) {
        if (_indicadorErrores[i]) {
          hayErrores = true;
          break;
        }
      }
    }
    
    return !hayErrores;
  }

  Future<void> _guardarEvaluaciones() async {
    if (!_validarFormulario()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor rectifique los errores de validación antes de guardar'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
      return;
    }

    try {
      // Aquí se guardarían las evaluaciones en la base de datos
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuración de evaluaciones guardada correctamente'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final asignaturaProvider = Provider.of<AsignaturaProvider>(context);
    final anioProvider = Provider.of<AnioLectivoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluaciones'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarEvaluaciones,
            tooltip: 'Guardar Configuración',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          _buildFilters(asignaturaProvider, anioProvider),
          const SizedBox(height: 16),
          
          // Pestañas de cortes
          Container(
            color: AppTheme.surfaceColor,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '1er Corte'),
                Tab(text: '2do Corte'),
                Tab(text: '3er Corte'),
                Tab(text: '4to Corte'),
              ],
            ),
          ),
          
          // Contenido de la pestaña seleccionada
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCorteContent(1),
                _buildCorteContent(2),
                _buildCorteContent(3),
                _buildCorteContent(4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AsignaturaProvider asignaturaProvider, AnioLectivoProvider anioProvider) => Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.surfaceColor,
      child: Column(
        children: [
          // Asignatura
          _buildDropdown(
            label: 'Asignatura',
            value: asignaturaProvider.selectedAsignatura?.nombre ?? 'Seleccionar',
            items: asignaturaProvider.asignaturas.map((asignatura) => asignatura.nombre).toList(),
            onChanged: (value) {
              if (value != null) {
                final selectedAsignatura = asignaturaProvider.asignaturas.firstWhere(
                  (asignatura) => asignatura.nombre == value,
                  orElse: () => asignaturaProvider.asignaturas.first,
                );
                asignaturaProvider.seleccionarAsignatura(selectedAsignatura);
              }
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
  }) => DropdownButtonFormField<String>(
      initialValue: value != 'Seleccionar' ? value : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.cardColor),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
      onChanged: onChanged,
    );

  Widget _buildCorteContent(int numeroCorte) => Consumer<CorteEvaluativoProvider>(
      builder: (context, corteProvider, _) {
        if (corteProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        }

        final asignaturaProvider = Provider.of<AsignaturaProvider>(context);
        final esCualitativa = asignaturaProvider.selectedAsignatura?.cualitativo ?? false;

        // Tanto asignaturas cualitativas como cuantitativas pueden definir descripciones
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 5, // 5 indicadores por corte
          itemBuilder: (context, indicadorIndex) => _buildIndicadorExpansionTile(indicadorIndex + 1, numeroCorte, esCualitativa),
        );
      },
    );

  Widget _buildIndicadorExpansionTile(int numeroIndicador, int numeroCorte, bool esCualitativa) => ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Indicador $numeroIndicador',
            style: TextStyle(
              color: _indicadorErrores[numeroIndicador - 1] ? AppTheme.errorColor : AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Solo mostrar puntos para asignaturas cuantitativas
          if (!esCualitativa)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _indicadorErrores[numeroIndicador - 1] 
                    ? AppTheme.errorColor.withOpacity(0.2)
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _indicadorErrores[numeroIndicador - 1] 
                      ? AppTheme.errorColor 
                      : AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_indicadorErrores[numeroIndicador - 1])
                    Icon(
                      Icons.warning,
                      size: 14,
                      color: AppTheme.errorColor,
                    ),
                  const SizedBox(width: 4),
                  Text(
                    '20 puntos',
                    style: TextStyle(
                      color: _indicadorErrores[numeroIndicador - 1] ? AppTheme.errorColor : AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Cualitativo',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      children: [
        const SizedBox(height: 8),
        
        // Campo de descripción del indicador
        CustomTextField(
          label: 'Descripción del Indicador',
          hint: 'Describe qué se evalúa en este indicador',
          controller: _indicadorDescripcionControllers[numeroIndicador - 1],
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        
        // Criterios del indicador
        const Text(
          'Criterios de Evaluación',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        
        // Lista de criterios
        ...List.generate(3, (criterioIndex) => 
          _buildCriterioInput(criterioIndex + 1, numeroIndicador, esCualitativa)
        ),
        
        const SizedBox(height: 12),
        
        // Total del indicador (solo para cuantitativas)
        if (!esCualitativa) _buildIndicadorTotal(numeroIndicador),
        const SizedBox(height: 8),
      ],
    );

  Widget _buildCriterioInput(int numeroCriterio, int numeroIndicador, bool esCualitativa) {
    // Índice del controlador para este criterio específico
    final int controllerIndex = (numeroIndicador - 1) * 3 + (numeroCriterio - 1);
    final TextEditingController puntosController = _criterioControllers[controllerIndex];
    final TextEditingController descripcionController = _criterioDescripcionControllers[controllerIndex];
    final bool tieneError = _criterioErrores[controllerIndex];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: tieneError ? AppTheme.errorColor : AppTheme.cardColor.withOpacity(0.5),
          width: tieneError ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del criterio
          Row(
            children: [
              Text(
                'Criterio $numeroCriterio',
                style: TextStyle(
                  color: tieneError ? AppTheme.errorColor : AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (tieneError) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.warning,
                  size: 16,
                  color: AppTheme.errorColor,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          
          // Campo de descripción del criterio
          CustomTextField(
            label: 'Descripción del Criterio',
            hint: 'Describe qué se valora en este criterio',
            controller: descripcionController,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          
          // Campo de puntos (solo para asignaturas cuantitativas)
          if (!esCualitativa)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextField(
                        label: 'Puntos',
                        hint: '0-8',
                        keyboardType: TextInputType.number,
                        controller: puntosController,
                        errorText: tieneError ? 'Máximo 8 puntos permitidos' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '/ 8 puntos',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (tieneError) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Cada criterio no puede exceder 8 puntos',
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.text_fields,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Evaluación Cualitativa',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIndicadorTotal(int numeroIndicador) {
    final int total = _indicadorTotales[numeroIndicador - 1];
    final bool tieneError = _indicadorErrores[numeroIndicador - 1];
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tieneError 
            ? AppTheme.errorColor.withOpacity(0.1)
            : AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: tieneError ? AppTheme.errorColor : AppTheme.primaryColor,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                tieneError ? Icons.error : Icons.check_circle,
                color: tieneError ? AppTheme.errorColor : AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Total del Indicador',
                style: TextStyle(
                  color: tieneError ? AppTheme.errorColor : AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            '$total / 20 puntos',
            style: TextStyle(
              color: tieneError ? AppTheme.errorColor : AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
