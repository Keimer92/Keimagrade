import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/anio_lectivo.dart';
import '../../providers/anio_lectivo_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class AnioLectivoTab extends StatefulWidget {
  const AnioLectivoTab({Key? key}) : super(key: key);

  @override
  State<AnioLectivoTab> createState() => _AnioLectivoTabState();
}

class _AnioLectivoTabState extends State<AnioLectivoTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AnioLectivoProvider>().cargarAnios();
    });
  }

  void _showAnioDialog({AnioLectivo? anio}) {
    final anioController = TextEditingController(text: anio?.anio.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          anio == null ? 'Agregar Año Lectivo' : 'Editar Año Lectivo',
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
                label: 'Año',
                controller: anioController,
                keyboardType: TextInputType.number,
                hint: 'Ej: 2024',
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
              if (anioController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa el campo año')),
                );
                return;
              }

              final nuevoAnio = AnioLectivo(
                id: anio?.id,
                anio: int.parse(anioController.text),
              );

              if (anio == null) {
                context.read<AnioLectivoProvider>().crearAnio(nuevoAnio);
              } else {
                context.read<AnioLectivoProvider>().actualizarAnio(nuevoAnio);
              }

              Navigator.pop(context);
            },
            child: Text(anio == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<AnioLectivoProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        }

        if (provider.anios.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyState(
                  message: 'No hay años lectivos registrados',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAnioDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Año Lectivo'),
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
                onPressed: _showAnioDialog,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Año Lectivo'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.anios.length,
                itemBuilder: (context, index) {
                  final anio = provider.anios[index];
                  return CustomCard(
                    onTap: () => provider.seleccionarAnio(anio),
                    backgroundColor: provider.selectedAnio?.id == anio.id
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
                                    anio.nombre,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${anio.anio}',
                                    style: const TextStyle(
                                      color: AppTheme.textTertiary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (provider.selectedAnio?.id == anio.id)
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
                                  'Predeterminado:',
                                  style: TextStyle(
                                    color: AppTheme.textTertiary,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: anio.activo,
                                  activeThumbColor: AppTheme.primaryColor,
                                  inactiveThumbColor: AppTheme.textTertiary,
                                  inactiveTrackColor: AppTheme.cardColor,
                                  onChanged: (value) {
                                    final updatedAnio = anio.copyWith(activo: value);
                                    provider.actualizarAnio(updatedAnio);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                                  onPressed: () => _showAnioDialog(anio: anio),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                                  onPressed: () {
                                    DialogHelper.showDeleteConfirmation(
                                      context: context,
                                      itemName: anio.nombre,
                                      onConfirm: () async {
                                        final exito = await provider.eliminarAnio(anio.id!);
                                        if (!exito && mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('No se puede eliminar el año lectivo porque tiene estudiantes, colegios u otros datos asociados'),
                                              backgroundColor: AppTheme.errorColor,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                        } else if (exito && mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Año lectivo eliminado correctamente'),
                                              backgroundColor: AppTheme.primaryColor,
                                            ),
                                          );
                                        }
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
