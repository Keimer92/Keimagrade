import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/globales/globales_screen.dart';
import '../screens/ajustes/ajustes_screen.dart';
import '../screens/evaluaciones/evaluaciones_screen.dart';
import '../screens/estudiantes/estudiantes_screen.dart';
import '../screens/notas/notas_screen.dart';

class AparienciaProvider extends ChangeNotifier {
  AparienciaProvider() {
    _currentScreens = _defaultScreens.map(Map<String, dynamic>.from).toList();
    _loadConfiguration();
  }
  static const String _prefsKey = 'screen_order';
  static const String _themeModeKey = 'theme_mode';
  static const String _primaryColorKey = 'primary_color';

  ThemeMode _themeMode = ThemeMode.dark;
  Color _primaryColor = const Color(0xFFD4AF37); // Dorado por defecto

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  // Lista por defecto de las pantallas
  final List<Map<String, dynamic>> _defaultScreens = [
    {
      'id': 'notas',
      'title': 'Notas',
      'icon': Icons.grade,
      'widget': const NotasScreen(),
      'enabled': true,
    },
    {
      'id': 'globales',
      'title': 'Globales',
      'icon': Icons.settings,
      'widget': const GlobalesScreen(),
      'enabled': true,
    },
    {
      'id': 'evaluaciones',
      'title': 'Evaluaciones',
      'icon': Icons.edit,
      'widget': const EvaluacionesScreen(),
      'enabled': true,
    },
    {
      'id': 'estudiantes',
      'title': 'Estudiantes',
      'icon': Icons.people,
      'widget': const EstudiantesScreen(),
      'enabled': true,
    },
    {
      'id': 'reportes',
      'title': 'Reportes',
      'icon': Icons.assessment,
      'widget': const Center(
        child: Text(
          'Próximamente: Reportes',
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 18,
          ),
        ),
      ),
      'enabled': false,
    },
    {
      'id': 'ajustes',
      'title': 'Ajustes',
      'icon': Icons.settings_applications,
      'widget': const AjustesScreen(),
      'enabled': true,
    },
  ];

  List<Map<String, dynamic>> _currentScreens = [];

  List<Map<String, dynamic>> get screens {
    // Asegurar que siempre tengamos datos disponibles
    if (_currentScreens.isEmpty) {
      return _defaultScreens.map(Map<String, dynamic>.from).toList();
    }
    return _currentScreens;
  }

  List<Map<String, dynamic>> get activeScreens {
    final screensToUse = screens; // Usa el getter seguro
    return screensToUse.where((s) => s['enabled'] == true).toList();
  }

  Future<void> _loadConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList(_prefsKey);

    if (savedOrder != null && savedOrder.isNotEmpty) {
      final orderedScreens = <Map<String, dynamic>>[];

      for (final screenId in savedOrder) {
        final screen = _defaultScreens.firstWhere(
          (s) => s['id'] == screenId,
          orElse: () => <String, dynamic>{},
        );
        if (screen.isNotEmpty) {
          final screenCopy = Map<String, dynamic>.from(screen);
          final isEnabled = prefs.getBool('${_prefsKey}_${screenId}_enabled') ??
              screen['enabled'] as bool;
          screenCopy['enabled'] = isEnabled;
          orderedScreens.add(screenCopy);
        }
      }

      // Agregar pantallas nuevas
      for (final defaultScreen in _defaultScreens) {
        if (!orderedScreens.any((s) => s['id'] == defaultScreen['id'])) {
          orderedScreens.add(Map<String, dynamic>.from(defaultScreen));
        }
      }

      _currentScreens = orderedScreens;
    }

    // Cargar Tema
    final themeIndex = prefs.getInt(_themeModeKey) ?? 2; // Default to dark (2)
    _themeMode = ThemeMode.values[themeIndex];

    final colorValue = prefs.getInt(_primaryColorKey) ?? 0xFFD4AF37;
    _primaryColor = Color(colorValue);

    notifyListeners();
  }

  Future<void> saveConfiguration() async {
    final prefs = await SharedPreferences.getInstance();
    final screenIds = _currentScreens.map((s) => s['id'] as String).toList();
    await prefs.setStringList(_prefsKey, screenIds);

    for (final screen in _currentScreens) {
      final screenId = screen['id'] as String;
      final isEnabled = screen['enabled'] as bool;
      await prefs.setBool('${_prefsKey}_${screenId}_enabled', isEnabled);
    }

    await prefs.setInt(_themeModeKey, _themeMode.index);
    await prefs.setInt(_primaryColorKey, _primaryColor.value);
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void reorderScreens(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _currentScreens.removeAt(oldIndex);
    _currentScreens.insert(newIndex, item);
    notifyListeners();
  }

  void toggleScreen(int index, bool enabled) {
    _currentScreens[index]['enabled'] = enabled;
    notifyListeners();
  }

  void resetToDefault() {
    _currentScreens = _defaultScreens.map(Map<String, dynamic>.from).toList();
    notifyListeners();
  }

  // Método para aplicar cambios inmediatamente
  Future<void> applyChanges() async {
    await saveConfiguration();
    // Notificar a todos los listeners (incluyendo HomeScreen)
    notifyListeners();
  }
}
