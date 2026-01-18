import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/seccion.dart';
import '../../providers/seccion_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class SeccionTab extends StatefulWidget {
  const SeccionTab({Key? key}) : super(key: key);

  @override
  State<SeccionTab> createState() => _SeccionTabState();
}

class _SeccionTabState extends State<SeccionTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!mounted) return;
      await context.read<SeccionProvider>().cargarSecciones();
    });
  }

  void _showSeccionDialog({Seccion? seccion}) {
    final letraController = TextEditingController(text: seccion?.letra ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          seccion == null ? 'Agregar Sección' : 'Editar Sección',
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
                label: 'Letra',
                controller: letraController,
                hint: 'Ej: A, B, C...',
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
              if (letraController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa el campo letra')),
                );
                return;
              }

              final nuevaSeccion = Seccion(
                id: seccion?.id,
                letra: letraController.text.toUpperCase(),
              );

              final provider = context.read<SeccionProvider>();
              final navigator = Navigator.of(context);

              if (seccion == null) {
                await provider.crearSeccion(nuevaSeccion);
              } else {
                await provider.actualizarSeccion(nuevaSeccion);
              }

              navigator.pop();
            },
            child: Text(seccion == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<SeccionProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          }

          if (provider.secciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    message: 'No hay secciones registradas',
                    icon: Icons.category,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showSeccionDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Sección'),
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
                  onPressed: _showSeccionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Sección'),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: provider.secciones.length,
                  itemBuilder: (context, index) {
                    final seccion = provider.secciones[index];
                    return CustomCard(
                      onTap: () => provider.seleccionarSeccion(seccion),
                      backgroundColor:
                          provider.selectedSeccion?.id == seccion.id
                              ? AppTheme.secondaryColor.withValues(alpha: 0.2)
                              : Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                seccion.letra,
                                style: const TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sección ${seccion.letra}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.getTextPrimary(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (provider.selectedSeccion?.id == seccion.id)
                            const Icon(
                              Icons.check_circle,
                              color: AppTheme.secondaryColor,
                              size: 20,
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context).primaryColor,
                                    size: 18),
                                onPressed: () =>
                                    _showSeccionDialog(seccion: seccion),
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
                                    itemName: 'Sección ${seccion.letra}',
                                    onConfirm: () {
                                      provider.eliminarSeccion(seccion.id!);
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
                    );
                  },
                ),
              ),
            ],
          );
        },
      );
}
