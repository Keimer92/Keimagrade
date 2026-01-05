import 'package:flutter/material.dart';
import 'anio_lectivo_tab.dart';
import 'asignatura_tab.dart';
import 'colegio_tab.dart';
import 'grado_tab.dart';
import 'seccion_tab.dart';

class GlobalesScreen extends StatefulWidget {
  const GlobalesScreen({Key? key}) : super(key: key);

  @override
  State<GlobalesScreen> createState() => _GlobalesScreenState();
}

class _GlobalesScreenState extends State<GlobalesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion Global'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.calendar_today),
              text: 'Año Lectivo',
            ),
            Tab(
              icon: Icon(Icons.school),
              text: 'Colegio',
            ),
            Tab(
              icon: Icon(Icons.book),
              text: 'Asignatura',
            ),
            Tab(
              icon: Icon(Icons.layers),
              text: 'Grado',
            ),
            Tab(
              icon: Icon(Icons.category),
              text: 'Seccion',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AnioLectivoTab(),
          ColegioTab(),
          AsignaturaTab(),
          GradoTab(),
          SeccionTab(),
        ],
      ),
    );
}
