import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AcercaDeTab extends StatelessWidget {
  const AcercaDeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información de la Aplicación',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Nombre', 'Keimagrade'),
            _buildInfoRow('Versión', '1.0.0'),
            _buildInfoRow('Descripción', 'Sistema de gestión de notas escolares'),
            _buildInfoRow('Desarrollador', 'Keimagrade Team'),
          ],
        ),
      );

  Widget _buildInfoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                '$label: ',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
}
