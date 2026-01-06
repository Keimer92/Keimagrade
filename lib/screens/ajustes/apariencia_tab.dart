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
  Widget build(BuildContext context) {
    return Consumer<AparienciaProvider>(
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
              // Header con explicación
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.surfaceColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.palette, color: AppTheme.primaryColor),
                            const SizedBox(width: 8),
                            const Text(
                              'Personalizar Apariencia',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await aparienciaProvider.applyChanges();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Cambios aplicados correctamente'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Aplicar Cambios'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: AppTheme.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Arrastra las pantallas para reordenarlas. Activa o desactiva las que no uses.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pantallas activas: ${screens.where((s) => s['enabled'] == true).length}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                      color: isEnabled ? AppTheme.surfaceColor : AppTheme.surfaceColor.withOpacity(0.5),
                      elevation: 4,
                      shadowColor: AppTheme.shadowColor,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          screen['icon'] as IconData? ?? Icons.help,
                          color: isEnabled ? AppTheme.primaryColor : AppTheme.textTertiary,
                          size: 28,
                        ),
                        title: Text(
                          screen['title'] as String? ?? 'Pantalla sin nombre',
                          style: TextStyle(
                            color: isEnabled ? AppTheme.textPrimary : AppTheme.textTertiary,
                            fontWeight: FontWeight.w600,
                            decoration: isEnabled ? null : TextDecoration.lineThrough,
                          ),
                        ),
                        subtitle: Text(
                          screen['description'] as String? ?? 'Sin descripción',
                          style: TextStyle(
                            color: isEnabled ? AppTheme.textSecondary : AppTheme.textTertiary,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Switch para activar/desactivar
                            Switch(
                              value: isEnabled,
                              onChanged: (value) => aparienciaProvider.toggleScreen(index, value),
                              activeColor: AppTheme.primaryColor,
                              inactiveTrackColor: AppTheme.cardColor,
                            ),
                            // Handle para arrastrar
                            if (isEnabled)
                              ReorderableDragStartListener(
                                index: index,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.drag_handle,
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onTap: () => aparienciaProvider.toggleScreen(index, !isEnabled),
                      ),
                    );
                  },
                ),
              ),

              // Footer informativo
              Container(
                padding: const EdgeInsets.all(16),
                color: AppTheme.surfaceColor,
                child: Center(
                  child: Text(
                    'Arrastra las pantallas para reordenarlas y presiona "Aplicar Cambios" para guardar.',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
