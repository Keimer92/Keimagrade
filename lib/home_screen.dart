import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/apariencia_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // No necesitamos inicialización manual, el provider lo maneja
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Consumer<AparienciaProvider>(
        builder: (context, aparienciaProvider, _) {
          final activeScreens = aparienciaProvider.activeScreens;

          // Ajustar el índice seleccionado si es necesario
          if (_selectedIndex >= activeScreens.length && activeScreens.isNotEmpty) {
            _selectedIndex = 0;
          }

          return Scaffold(
            body: Row(
              children: [
                // Navigation rail on the left side
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  backgroundColor: AppTheme.backgroundColor,
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
                  destinations: activeScreens.map((screen) => NavigationRailDestination(
                    icon: Icon(screen['icon'] as IconData? ?? Icons.help),
                    selectedIcon: Icon(
                      screen['icon'] as IconData? ?? Icons.help,
                      color: AppTheme.primaryColor,
                    ),
                    label: Text(screen['title'] as String? ?? 'Pantalla'),
                  )).toList(),
                ),
                // Main content area
                Expanded(
                  child: activeScreens.isNotEmpty && _selectedIndex < activeScreens.length
                      ? activeScreens[_selectedIndex]['widget'] as Widget
                      : const Center(
                          child: Text(
                            'Cargando pantallas...',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      );
}
