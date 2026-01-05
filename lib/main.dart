import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/anio_lectivo_provider.dart';
import 'providers/asignatura_provider.dart';
import 'providers/colegio_provider.dart';
import 'providers/grado_provider.dart';
import 'providers/notas_provider.dart';
import 'providers/seccion_provider.dart';
import 'providers/corte_evaluativo_provider.dart';
import 'providers/indicador_evaluacion_provider.dart';
import 'providers/criterio_evaluacion_provider.dart';
import 'providers/estudiante_provider.dart';
import 'providers/apariencia_provider.dart';
import 'home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnioLectivoProvider()),
        ChangeNotifierProvider(create: (_) => ColegioProvider()),
        ChangeNotifierProvider(create: (_) => AsignaturaProvider()),
        ChangeNotifierProvider(create: (_) => GradoProvider()),
        ChangeNotifierProvider(create: (_) => NotasProvider()),
        ChangeNotifierProvider(create: (_) => SeccionProvider()),
        ChangeNotifierProvider(create: (_) => CorteEvaluativoProvider()),
        ChangeNotifierProvider(create: (_) => IndicadorEvaluacionProvider()),
        ChangeNotifierProvider(create: (_) => CriterioEvaluacionProvider()),
        ChangeNotifierProvider(create: (_) => EstudianteProvider()),
        ChangeNotifierProvider(create: (_) => AparienciaProvider()),
      ],
      child: MaterialApp(
        title: 'Keimagrade',
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
}
