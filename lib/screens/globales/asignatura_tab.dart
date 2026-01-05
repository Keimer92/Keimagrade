import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/asignatura.dart';
import '../../providers/asignatura_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class AsignaturaTab extends StatefulWidget {
  const AsignaturaTab({Key? key}) : super(key: key);

  @override
  State<AsignaturaTab> createState() => _AsignaturaTabState();
}

class _AsignaturaTabState extends State<AsignaturaTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AsignaturaProvider>().cargarAsignaturas();
    });
  }

  void _showAsignaturaDialog({Asignatura? asignatura}) {
    final nombreController = TextEditingController(text: asignatura?.nombre ?? '');
    final codigoController = TextEditingController(text: asignatura?.codigo ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          asignatura == null ? 'Agregar Asignatura' : 'Editar Asignatura',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Nombre',
                controller: nombreController,
                hint: 'Nombre de la asignatura',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Codigo',
                controller: codigoController,
                hint: 'Codigo unico',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nombreController.text.isEmpty || codigoController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa los campos requeridos')),
                );
                return;
              }

              final nuevaAsignatura = Asignatura(
                id: asignatura?.id,
                nombre: nombreController.text,
                codigo: codigoController.text,
              );

              if (asignatura == null) {
                context.read<AsignaturaProvider>().crearAsignatura(nuevaAsignatura);
              } else {
                context.read<AsignaturaProvider>().actualizarAsignatura(nuevaAsignatura);
              }

              Navigator.pop(context);
            },
            child: Text(asignatura == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<AsignaturaProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        }

        if (provider.asignaturas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyState(
                  message: 'No hay asignaturas registradas',
                  icon: Icons.book,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAsignaturaDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Asignatura'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _showAsignaturaDialog,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Asignatura'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.asignaturas.length,
                itemBuilder: (context, index) {
                  final asignatura = provider.asignaturas[index];
                  return CustomCard(
                    onTap: () => provider.seleccionarAsignatura(asignatura),
                    backgroundColor: provider.selectedAsignatura?.id == asignatura.id
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.surfaceColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    asignatura.nombre,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Codigo: ${asignatura.codigo}',
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (provider.selectedAsignatura?.id == asignatura.id)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Cualitativo:',
                                  style: TextStyle(
                                    color: AppTheme.textTertiary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: asignatura.cualitativo,
                                  activeThumbColor: AppTheme.primaryColor,
                                  inactiveThumbColor: AppTheme.textTertiary,
                                  inactiveTrackColor: AppTheme.cardColor,
                                  onChanged: (value) {
                                    final updatedAsignatura = asignatura.copyWith(cualitativo: value);
                                    provider.actualizarAsignatura(updatedAsignatura);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                                  onPressed: () => _showAsignaturaDialog(asignatura: asignatura),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                                  onPressed: () {
                                    DialogHelper.showDeleteConfirmation(
                                      context: context,
                                      itemName: asignatura.nombre,
                                      onConfirm: () {
                                        provider.eliminarAsignatura(asignatura.id!);
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
}
