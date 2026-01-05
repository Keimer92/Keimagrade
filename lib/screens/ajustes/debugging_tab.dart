import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/database_helper.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../providers/asignatura_provider.dart';
import '../../providers/colegio_provider.dart';
import '../../providers/grado_provider.dart';
import '../../providers/seccion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dialog_helper.dart';

class DebuggingTab extends StatelessWidget {
  const DebuggingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opciones de Debugging',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingOption(
              context: context,
              icon: Icons.delete_sweep,
              title: 'Borrar toda la base de datos',
              subtitle: 'Eliminar todos los datos almacenados',
              onTap: () => _showClearDatabaseDialog(context),
            ),
            const SizedBox(height: 16),
            _buildSettingOption(
              context: context,
              icon: Icons.refresh,
              title: 'Restablecer base de datos',
              subtitle: 'Crear nueva base de datos con datos por defecto',
              onTap: () => _showResetDatabaseDialog(context),
            ),
          ],
        ),
      );

  Widget _buildSettingOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => Card(
        color: AppTheme.surfaceColor,
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textSecondary,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textTertiary,
            size: 16,
          ),
          onTap: onTap,
        ),
      );

  void _showResetDatabaseDialog(BuildContext context) {
    DialogHelper.showCustomDialog(
      context: context,
      title: 'Restablecer Base de Datos',
      content: const Text(
        '¿Estás seguro de que deseas restablecer la base de datos?\n\nEsta acción eliminará todos los datos actuales y creará una nueva base de datos con la configuración y datos por defecto. Esta operación no se puede deshacer.',
        style: TextStyle(color: AppTheme.textSecondary),
      ),
      confirmText: 'Restablecer',
      cancelText: 'Cancelar',
      onConfirm: () => _resetDatabase(context),
    );
  }

  void _resetDatabase(BuildContext context) async {
    try {
      final databaseHelper = DatabaseHelper();
      await databaseHelper.resetDatabase();

      // Small delay to ensure database operation completes and connection is closed
      await Future.delayed(const Duration(milliseconds: 300));

      // Refresh all providers to reflect the new default data
      // Using try-catch for each provider to handle potential database factory issues
      try {
        await context.read<AnioLectivoProvider>().cargarAnios();
      } catch (e) {
        print('Error reloading AnioLectivoProvider: $e');
      }

      try {
        await context.read<ColegioProvider>().cargarColegios();
      } catch (e) {
        print('Error reloading ColegioProvider: $e');
      }

      try {
        await context.read<AsignaturaProvider>().cargarAsignaturas();
      } catch (e) {
        print('Error reloading AsignaturaProvider: $e');
      }

      try {
        await context.read<GradoProvider>().cargarGrados();
      } catch (e) {
        print('Error reloading GradoProvider: $e');
      }

      try {
        await context.read<SeccionProvider>().cargarSecciones();
      } catch (e) {
        print('Error reloading SeccionProvider: $e');
      }

      // Show success message
      if (context.mounted) {
        DialogHelper.showSuccessMessage(
          context: context,
          message: 'Base de datos restablecida exitosamente',
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        DialogHelper.showCustomDialog(
          context: context,
          title: 'Error',
          content: Text('Ocurrió un error al restablecer la base de datos: $e'),
        );
      }
    }
  }

  void _showClearDatabaseDialog(BuildContext context) {
    DialogHelper.showCustomDialog(
      context: context,
      title: 'Borrar Base de Datos',
      content: const Text(
        '¿Estás seguro de que deseas borrar toda la base de datos?\n\nEsta acción eliminará permanentemente todos los datos almacenados (años lectivos, colegios, asignaturas, grados y secciones). Esta operación no se puede deshacer.',
        style: TextStyle(color: AppTheme.textSecondary),
      ),
      confirmText: 'Borrar Todo',
      cancelText: 'Cancelar',
      onConfirm: () => _clearDatabase(context),
    );
  }

  void _clearDatabase(BuildContext context) async {
    try {
      final databaseHelper = DatabaseHelper();
      await databaseHelper.clearAllData();

      // Small delay to ensure database operation completes and connection is closed
      await Future.delayed(const Duration(milliseconds: 300));

      // Refresh all providers to reflect the cleared data
      // Using try-catch for each provider to handle potential database factory issues
      try {
        await context.read<AnioLectivoProvider>().cargarAnios();
      } catch (e) {
        print('Error reloading AnioLectivoProvider: $e');
      }

      try {
        await context.read<ColegioProvider>().cargarColegios();
      } catch (e) {
        print('Error reloading ColegioProvider: $e');
      }

      try {
        await context.read<AsignaturaProvider>().cargarAsignaturas();
      } catch (e) {
        print('Error reloading AsignaturaProvider: $e');
      }

      try {
        await context.read<GradoProvider>().cargarGrados();
      } catch (e) {
        print('Error reloading GradoProvider: $e');
      }

      try {
        await context.read<SeccionProvider>().cargarSecciones();
      } catch (e) {
        print('Error reloading SeccionProvider: $e');
      }

      // Show success message
      if (context.mounted) {
        DialogHelper.showSuccessMessage(
          context: context,
          message: 'Base de datos borrada exitosamente',
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        DialogHelper.showCustomDialog(
          context: context,
          title: 'Error',
          content: Text('Ocurrió un error al borrar la base de datos: $e'),
        );
      }
    }
  }
}
