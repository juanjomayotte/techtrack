import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';

class DeviceTypesScreen extends StatefulWidget {
  const DeviceTypesScreen({super.key});

  @override
  _DeviceTypesScreenState createState() => _DeviceTypesScreenState();
}

class _DeviceTypesScreenState extends State<DeviceTypesScreen> {
  List<TipoDispositivo> _types = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTypes();
  }

  Future<void> _fetchTypes() async {
    try {
      final types = await InventoryService.fetchTiposDispositivos();
      setState(() {
        _types = types;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching device types: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteType(int typeId) async {
    try {
      await InventoryService.deleteTipoDispositivo(typeId);
      setState(() {
        _types.removeWhere((type) => type.idTipoDispositivo == typeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de dispositivo eliminado con éxito')),
      );
    } catch (e) {
      print('Error deleting device type: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar tipo de dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Dispositivos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _types.isEmpty
          ? const Center(child: Text("No hay tipos de dispositivos"))
          : ListView.builder(
        itemCount: _types.length,
        itemBuilder: (context, index) {
          final type = _types[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(type.nombreTipoDispositivo),
              subtitle: Text('Descripción: ${type.descripcionTipoDispositivo ?? "N/A"}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit_device_type',
                        arguments: type,
                      );
                      // Actualizar si hubo cambios
                      if (result == true) {
                        _fetchTypes();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteType(type.idTipoDispositivo);
                    },
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(type.nombreTipoDispositivo),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Descripción: ${type.descripcionTipoDispositivo ?? "N/A"}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_device_type');

          // Actualizar si hubo cambios
          if (result == true) {
            _fetchTypes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}