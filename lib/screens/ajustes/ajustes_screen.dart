import 'package:flutter/material.dart';
import 'acerca_de_tab.dart';
import 'debugging_tab.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes'),
          elevation: 0,
        bottom: const TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.info),
              text: 'Acerca de',
            ),
            Tab(
              icon: Icon(Icons.bug_report),
              text: 'Debugging',
            ),
          ],
        ),
        ),
        body: const TabBarView(
          children: [
            AcercaDeTab(),
            DebuggingTab(),
          ],
        ),
      ),
    );
}
