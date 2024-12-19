//screens/contract_settings_screen.dart

import 'package:flutter/material.dart';

class ContractSettingsScreen extends StatelessWidget {
  const ContractSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Contratos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Tipos de Contrato'),
                subtitle: const Text('Administrar tipos de contrato'),
                onTap: () {
                  Navigator.pushNamed(context, '/contract_types');
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}