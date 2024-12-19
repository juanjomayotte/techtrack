import 'package:flutter/material.dart';

class DeviceSettingsScreen extends StatelessWidget {
  const DeviceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Dispositivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.devices),
                title: const Text('Modelos de Dispositivos'),
                subtitle: const Text('Administrar modelos de dispositivos'),
                onTap: () {
                  Navigator.pushNamed(context, '/device_models');
                },
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Tipos de Dispositivos'),
                subtitle: const Text('Administrar tipos de dispositivos'),
                onTap: () {
                  Navigator.pushNamed(context, '/device_types');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}