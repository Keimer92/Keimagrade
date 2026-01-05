import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/grado.dart';
import '../../providers/grado_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class GradoTab extends StatefulWidget {
  const GradoTab({Key? key}) : super(key: key);

  @override
  State<GradoTab> createState() => _GradoTabState();
}

class _GradoTabState extends State<GradoTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GradoProvider>().cargarGrados();
    });
  }

  void _showGradoDialog({Grado? grado}) {
    final numeroController = TextEditingController(text: grado?.numero.toString() ?? '');
    final nombreController = TextEditingController(text: grado?.nombre ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          grado == null ? 'Agregar Grado' : 'Editar Grado',
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
                label: 'Numero',
                controller: numeroController,
                keyboardType: TextInputType.number,
                hint: 'Ej: 1, 2, 3...',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Nombre',
                controller: nombreController,
                hint: 'Ej: 1er Grado',
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
            onPressed: () async {
              if (numeroController.text.isEmpty || nombreController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa todos los campos')),
                );
                return;
              }

              final numero = int.parse(numeroController.text);
              final nombre = nombreController.text.trim();

              final nuevoGrado = Grado(
                id: grado?.id,
                numero: numero,
                nombre: nombre,
              );

              if (grado == null) {
                final exito = await context.read<GradoProvider>().crearGrado(nuevoGrado);
                if (!exito && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No se puede crear el grado. Ya existe un grado con número $numero o nombre "$nombre"'),
                      backgroundColor: AppTheme.errorColor,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                  return; // No cerrar el diálogo si hay error
                }
              } else {
                context.read<GradoProvider>().actualizarGrado(nuevoGrado);
              }

              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(grado == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<GradoProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        }

        if (provider.grados.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const EmptyState(
                  message: 'No hay grados registrados',
                  icon: Icons.layers,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showGradoDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Grado'),
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
                onPressed: _showGradoDialog,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Grado'),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.6,
                ),
                itemCount: provider.grados.length,
                itemBuilder: (context, index) {
                  final grado = provider.grados[index];
                  return CustomCard(
                    onTap: () => provider.seleccionarGrado(grado),
                    backgroundColor: provider.selectedGrado?.id == grado.id
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.surfaceColor,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${grado.numero}',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          grado.nombre,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (provider.selectedGrado?.id == grado.id)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                        const SizedBox(height: 8),
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
                                  value: grado.cualitativo,
                                  activeThumbColor: AppTheme.primaryColor,
                                  inactiveThumbColor: AppTheme.textTertiary,
                                  inactiveTrackColor: AppTheme.cardColor,
                                  onChanged: (value) {
                                    final updatedGrado = grado.copyWith(cualitativo: value);
                                    provider.actualizarGrado(updatedGrado);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: AppTheme.primaryColor, size: 18),
                                  onPressed: () => _showGradoDialog(grado: grado),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppTheme.errorColor, size: 18),
                                  onPressed: () {
                                    DialogHelper.showDeleteConfirmation(
                                      context: context,
                                      itemName: grado.nombre,
                                      onConfirm: () {
                                        provider.eliminarGrado(grado.id!);
                                      },
                                    );
                                  },
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
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
