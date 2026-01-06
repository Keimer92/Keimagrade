import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/apariencia_provider.dart';

class AparienciaTab extends StatefulWidget {
  const AparienciaTab({Key? key}) : super(key: key);

  @override
  State<AparienciaTab> createState() => _AparienciaTabState();
}

class _AparienciaTabState extends State<AparienciaTab> {
  @override
  Widget build(BuildContext context) => Consumer<AparienciaProvider>(
        builder: (context, aparienciaProvider, _) {
          final screens = aparienciaProvider.screens;

          // Asegurar que tenemos datos válidos
          if (screens.isEmpty) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: Column(
              children: [
                // Secciones de Tema y Color
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      // Selección de Modo de Tema
                      _buildThemeModeSelector(aparienciaProvider),
                      const SizedBox(height: 16),
                      // Selección de Color de Acento
                      _buildColorSelector(aparienciaProvider),
                    ],
                  ),
                ),

                // Divider elegante
                const Divider(),

                // Subtítulo para reordenar pantallas
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Organizar Pantallas',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => aparienciaProvider.resetToDefault(),
                        icon: const Icon(Icons.restore, size: 18),
                        label: const Text('Restablecer'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Lista ordenable
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: screens.length,
                    onReorder: aparienciaProvider.reorderScreens,
                    itemBuilder: (context, index) {
                      final screen = screens[index];
                      final isEnabled = screen['enabled'] as bool;

                      return Card(
                        key: ValueKey(screen['id'] ?? 'screen_$index'),
                        color: isEnabled
                            ? AppTheme.surfaceColor
                            : AppTheme.surfaceColor.withOpacity(0.5),
                        elevation: 4,
                        shadowColor: AppTheme.shadowColor,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            screen['icon'] as IconData? ?? Icons.help,
                            color: isEnabled
                                ? AppTheme.primaryColor
                                : AppTheme.textTertiary,
                            size: 28,
                          ),
                          title: Text(
                            screen['title'] as String? ?? 'Pantalla sin nombre',
                            style: TextStyle(
                              color: isEnabled
                                  ? AppTheme.textPrimary
                                  : AppTheme.textTertiary,
                              fontWeight: FontWeight.w600,
                              decoration:
                                  isEnabled ? null : TextDecoration.lineThrough,
                            ),
                          ),
                          subtitle: Text(
                            screen['description'] as String? ??
                                'Sin descripción',
                            style: TextStyle(
                              color: isEnabled
                                  ? AppTheme.textSecondary
                                  : AppTheme.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Switch para activar/desactivar
                              Switch(
                                value: isEnabled,
                                onChanged: (value) => aparienciaProvider
                                    .toggleScreen(index, value),
                                activeThumbColor: AppTheme.primaryColor,
                                inactiveTrackColor: AppTheme.cardColor,
                              ),
                              // Handle para arrastrar
                              if (isEnabled)
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.drag_handle,
                                      color: AppTheme.textTertiary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () => aparienciaProvider.toggleScreen(
                              index, !isEnabled),
                        ),
                      );
                    },
                  ),
                ),

                // Footer informativo con botón de guardar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    border: Border(
                        top: BorderSide(color: Colors.grey.withOpacity(0.2))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Presiona "Guardar" para aplicar todos los cambios de tema y orden.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await aparienciaProvider.applyChanges();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Configuración guardada'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );

  Widget _buildThemeModeSelector(AparienciaProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Modo de Visualización',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildModeCard(
              context: context,
              icon: Icons.light_mode,
              label: 'Claro',
              isSelected: provider.themeMode == ThemeMode.light,
              onTap: () => provider.setThemeMode(ThemeMode.light),
            ),
            _buildModeCard(
              context: context,
              icon: Icons.dark_mode,
              label: 'Oscuro',
              isSelected: provider.themeMode == ThemeMode.dark,
              onTap: () => provider.setThemeMode(ThemeMode.dark),
            ),
            _buildModeCard(
              context: context,
              icon: Icons.settings_brightness,
              label: 'Sistema',
              isSelected: provider.themeMode == ThemeMode.system,
              onTap: () => provider.setThemeMode(ThemeMode.system),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.textPrimary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(AparienciaProvider provider) {
    final List<Color> colors = [
      const Color(0xFFD4AF37), // Oro
      const Color(0xFFE91E63), // Magenta
      const Color(0xFFFF2D55), // Rosa
      const Color(0xFF2196F3), // Azul
      const Color(0xFFFFCC00), // Amarillo
      const Color(0xFF9C27B0), // Violeta
      const Color(0xFF00C7BE), // Mint
      const Color(0xFF4CAF50), // Verde
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color de Acento',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final color = colors[index];
              final isSelected = provider.primaryColor.value == color.value;
              return GestureDetector(
                onTap: () => provider.setPrimaryColor(color),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
