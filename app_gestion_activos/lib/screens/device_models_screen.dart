//screens/device_models_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';

class DeviceModelsScreen extends StatefulWidget {
  const DeviceModelsScreen({super.key});

  @override
  _DeviceModelsScreenState createState() => _DeviceModelsScreenState();
}

class _DeviceModelsScreenState extends State<DeviceModelsScreen> {
  List<ModeloDispositivo> _models = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchModels();
  }

  Future<void> _fetchModels() async {
    try {
      final models = await InventoryService.fetchModelosDispositivo();
      List<ModeloDispositivo> modelModels = [];

      for (var model in models) {
        TipoDispositivo? tipoDispositivo;

        if (model.tipoDispositivoId != null) {
          tipoDispositivo = await InventoryService.fetchTipoDispositivoById(model.tipoDispositivoId!)
              .catchError((e) => null);
        }

        final modelModel = ModeloDispositivo(
          idModeloDispositivo: model.idModeloDispositivo,
          nombreModeloDispositivo: model.nombreModeloDispositivo,
          marca: model.marca,
          descripcionModeloDispositivo: model.descripcionModeloDispositivo,
          cantidadEnInventario: model.cantidadEnInventario,
          tipoDispositivoId: model.tipoDispositivoId,
          tipoDispositivo: tipoDispositivo,
          modeloDispositivoCreadoPorId: model.modeloDispositivoCreadoPorId,
        );
        modelModels.add(modelModel);
      }

      setState(() {
        _models = modelModels;
        _isLoading = false;
      });

    } catch (e) {
      print('Error fetching device models: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteModel(int modelId) async {
    try {
      await InventoryService.deleteModeloDispositivo(modelId);
      setState(() {
        _models.removeWhere((model) => model.idModeloDispositivo == modelId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modelo de dispositivo eliminado con éxito')),
      );
    } catch (e) {
      print('Error deleting device model: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar modelo de dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelos de Dispositivos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _models.isEmpty
          ? const Center(child: Text("No hay modelos de dispositivos"))
          : ListView.builder(
        itemCount: _models.length,
        itemBuilder: (context, index) {
          final model = _models[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(model.nombreModeloDispositivo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Marca: ${model.marca}'),
                  Text('Tipo Disp.: ${model.tipoDispositivo?.nombreTipoDispositivo ?? "N/A"}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit_device_model',
                        arguments: model,
                      );
                      // Actualizar si hubo cambios
                      if (result == true) {
                        _fetchModels();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteModel(model.idModeloDispositivo);
                    },
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(model.nombreModeloDispositivo),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Marca: ${model.marca}'),
                        Text('Descripción: ${model.descripcionModeloDispositivo ?? "N/A"}'),
                        Text('Tipo Disp.: ${model.tipoDispositivo?.nombreTipoDispositivo ?? "N/A"}'),
                        Text('Cantidad en Inventario: ${model.cantidadEnInventario}'),
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
          final result = await Navigator.pushNamed(context, '/add_device_model');

          // Actualizar si hubo cambios
          if (result == true) {
            _fetchModels();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}