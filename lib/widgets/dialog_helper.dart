import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DialogHelper {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) =>
      showDialog<T>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            title,
            style: TextStyle(
              color: AppTheme.getTextPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: content,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                cancelText ?? 'Cancelar',
                style: TextStyle(color: AppTheme.getTextSecondary(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
              },
              child: Text(confirmText ?? 'Guardar'),
            ),
          ],
        ),
      );

  static Future<void> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    required VoidCallback onConfirm,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Confirmar eliminacion',
            style: TextStyle(
              color: AppTheme.getTextPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar "$itemName"?',
            style: TextStyle(color: AppTheme.getTextSecondary(context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.getTextSecondary(context)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        ),
      );

  static Future<void> showSuccessMessage({
    required BuildContext context,
    required String message,
  }) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.getTextPrimary(context),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
}
