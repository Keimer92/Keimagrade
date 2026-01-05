import 'package:flutter/material.dart';
import 'screens/globales/globales_screen.dart';
import 'screens/ajustes/ajustes_screen.dart';
import 'screens/evaluaciones/evaluaciones_screen.dart';
import 'screens/estudiantes/estudiantes_screen.dart';
import 'screens/notas/notas_screen.dart';
import 'theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const NotasScreen(),
    const GlobalesScreen(),
    const EvaluacionesScreen(),
    const EstudiantesScreen(),
    const Center(
      child: Text(
        'Proximamente: Reportes',
        style: TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 18,
        ),
      ),
    ),
    const AjustesScreen(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: [
            // Navigation rail on the left side
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: AppTheme.surfaceColor,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Keimagrade',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.grade),
                  selectedIcon: Icon(Icons.grade, color: AppTheme.primaryColor),
                  label: Text('Notas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  selectedIcon:
                      Icon(Icons.settings, color: AppTheme.primaryColor),
                  label: Text('Globales'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.edit),
                  selectedIcon: Icon(Icons.edit, color: AppTheme.primaryColor),
                  label: Text('Evaluaciones'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people),
                  selectedIcon:
                      Icon(Icons.people, color: AppTheme.primaryColor),
                  label: Text('Estudiantes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.assessment),
                  selectedIcon:
                      Icon(Icons.assessment, color: AppTheme.primaryColor),
                  label: Text('Reportes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_applications),
                  selectedIcon: Icon(Icons.settings_applications,
                      color: AppTheme.primaryColor),
                  label: Text('Ajustes'),
                ),
              ],
            ),
            // Main content area
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      );
}
