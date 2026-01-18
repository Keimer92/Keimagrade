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
    Future.microtask(() async {
      if (!mounted) return;
      await context.read<GradoProvider>().cargarGrados();
    });
  }

  void _showGradoDialog({Grado? grado}) {
    final numeroController =
        TextEditingController(text: grado?.numero.toString() ?? '');
    final nombreController = TextEditingController(text: grado?.nombre ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          grado == null ? 'Agregar Grado' : 'Editar Grado',
          style: TextStyle(
            color: AppTheme.getTextPrimary(context),
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
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppTheme.getTextSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (numeroController.text.isEmpty ||
                  nombreController.text.isEmpty) {
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

              final provider = context.read<GradoProvider>();
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              if (grado == null) {
                final exito = await provider.crearGrado(nuevoGrado);
                if (!exito) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                          'No se puede crear el grado. Ya existe un grado con número $numero o nombre "$nombre"'),
                      backgroundColor: AppTheme.errorColor,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                  return; // No cerrar el diálogo si hay error
                }
              } else {
                await provider.actualizarGrado(nuevoGrado);
              }

              navigator.pop();
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
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
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
                          ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                          : Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '${grado.numero}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
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
                            style: TextStyle(
                              color: AppTheme.getTextPrimary(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (provider.selectedGrado?.id == grado.id)
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Cualitativo:',
                                    style: TextStyle(
                                      color: AppTheme.getTextTertiary(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: grado.cualitativo,
                                    activeColor:
                                        Theme.of(context).primaryColor,
                                    inactiveThumbColor:
                                        AppTheme.getTextTertiary(context),
                                    inactiveTrackColor: AppTheme.cardColor,
                                    onChanged: (value) {
                                      final updatedGrado =
                                          grado.copyWith(cualitativo: value);
                                      provider.actualizarGrado(updatedGrado);
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context).primaryColor,
                                        size: 18),
                                    onPressed: () =>
                                        _showGradoDialog(grado: grado),
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: AppTheme.getErrorColor(context),
                                        size: 18),
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
