import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/colegio.dart';
import '../../providers/colegio_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/dialog_helper.dart';

class ColegioTab extends StatefulWidget {
  const ColegioTab({Key? key}) : super(key: key);

  @override
  State<ColegioTab> createState() => _ColegioTabState();
}

class _ColegioTabState extends State<ColegioTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ColegioProvider>().cargarColegios();
    });
  }

  void _showColegioDialog({Colegio? colegio}) {
    final nombreController = TextEditingController(text: colegio?.nombre ?? '');
    final direccionController =
        TextEditingController(text: colegio?.direccion ?? '');
    final telefonoController =
        TextEditingController(text: colegio?.telefono ?? '');
    final emailController = TextEditingController(text: colegio?.email ?? '');
    final directorController =
        TextEditingController(text: colegio?.director ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          colegio == null ? 'Agregar Colegio' : 'Editar Colegio',
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
                label: 'Nombre',
                controller: nombreController,
                hint: 'Nombre del colegio',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Direccion',
                controller: direccionController,
                hint: 'Direccion del colegio',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Telefono',
                controller: telefonoController,
                hint: 'Numero de telefono',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                hint: 'Email del colegio',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Director',
                controller: directorController,
                hint: 'Nombre del director',
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
            onPressed: () {
              if (nombreController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('El nombre es requerido')),
                );
                return;
              }

              final nuevoColegio = Colegio(
                id: colegio?.id,
                nombre: nombreController.text,
                direccion: direccionController.text,
                telefono: telefonoController.text,
                email: emailController.text,
                director: directorController.text,
              );

              if (colegio == null) {
                context.read<ColegioProvider>().crearColegio(nuevoColegio);
              } else {
                context.read<ColegioProvider>().actualizarColegio(nuevoColegio);
              }

              Navigator.pop(context);
            },
            child: Text(colegio == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Consumer<ColegioProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          }

          if (provider.colegios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EmptyState(
                    message: 'No hay colegios registrados',
                    icon: Icons.school,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showColegioDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar Colegio'),
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
                  onPressed: _showColegioDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Colegio'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.colegios.length,
                  itemBuilder: (context, index) {
                    final colegio = provider.colegios[index];
                    return CustomCard(
                      onTap: () => provider.seleccionarColegio(colegio),
                      backgroundColor:
                          provider.selectedColegio?.id == colegio.id
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Theme.of(context).cardColor,
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
                                      colegio.nombre,
                                      style: TextStyle(
                                        color: AppTheme.getTextPrimary(context),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Director: ${colegio.director}',
                                      style: TextStyle(
                                        color:
                                            AppTheme.getTextSecondary(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (provider.selectedColegio?.id == colegio.id)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.location_on,
                            label: colegio.direccion,
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.phone,
                            label: colegio.telefono,
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            icon: Icons.email,
                            label: colegio.email,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () =>
                                    _showColegioDialog(colegio: colegio),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: AppTheme.getErrorColor(context)),
                                onPressed: () {
                                  DialogHelper.showDeleteConfirmation(
                                    context: context,
                                    itemName: colegio.nombre,
                                    onConfirm: () {
                                      provider.eliminarColegio(colegio.id!);
                                    },
                                  );
                                },
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
  });
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.getTextTertiary(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.getTextTertiary(context),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}
