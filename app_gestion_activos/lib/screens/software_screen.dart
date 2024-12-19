//screens/software_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart';
import 'package:app_gestion_activos/screens/inventory/add_software_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_software_screen.dart';
import 'package:app_gestion_activos/screens/software_settings_screen.dart';
import 'package:app_gestion_activos/widgets/confirmation_dialog.dart';

class SoftwareScreen extends StatefulWidget {
  const SoftwareScreen({super.key});

  @override
  _SoftwareScreenState createState() => _SoftwareScreenState();
}

class _SoftwareScreenState extends State<SoftwareScreen> {
  bool _isLoading = false;
  List<Software> _softwares = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final softwares = await InventoryService.fetchSoftwares();

      List<Software> modelSoftwares = [];

      for (var serviceSoftware in softwares) {
        TipoSoftware? tipoSoftware;

        if (serviceSoftware.tipoSoftwareId != null) {
          tipoSoftware = await InventoryService.fetchTipoSoftwareById(serviceSoftware.tipoSoftwareId!)
              .catchError((e) => null);
        }

        final modelSoftware = Software(
          idSoftware: serviceSoftware.idSoftware,
          nombreSoftware: serviceSoftware.nombreSoftware,
          versionSoftware: serviceSoftware.versionSoftware,
          tipoSoftwareId: serviceSoftware.tipoSoftwareId,
          tipoSoftware: tipoSoftware,
          requiereActualizacion: serviceSoftware.requiereActualizacion,
          estaEnListaNegra: serviceSoftware.estaEnListaNegra,
          licenciaVinculadaSoftwareId: serviceSoftware.licenciaVinculadaSoftwareId,
          contratoVinculadoSoftwareId: serviceSoftware.contratoVinculadoSoftwareId,
          softwareCreadoPorId: serviceSoftware.softwareCreadoPorId,
        );
        modelSoftwares.add(modelSoftware);
      }

      setState(() {
        _softwares = modelSoftwares;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching softwares: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener softwares: $e')),
      );
    }
  }

  Future<void> _deleteSoftware(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: 'Confirmar Eliminación',
        message: '¿Está seguro de que desea eliminar este software?',
      ),
    );

    if (confirmDelete == true) {
      try {
        await InventoryService.deleteSoftware(id);
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Software eliminado con éxito')),
        );
      } catch (e) {
        print('Error deleting software: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el software: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Software'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SoftwareSettingsScreen()),
              ).then((_) => _fetchData());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _softwares.isEmpty
          ? const Center(child: Text("No hay software"))
          : ListView.builder(
        itemCount: _softwares.length,
        itemBuilder: (context, index) {
          final software = _softwares[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(software.nombreSoftware),
              subtitle: Text('Versión: ${software.versionSoftware}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditSoftwareScreen(software: software),
                        ),
                      ).then((_) => _fetchData());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteSoftware(software.idSoftware),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(software.nombreSoftware),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Versión: ${software.versionSoftware}'),
                        Text('Tipo: ${software.tipoSoftware?.nombreTipoSoftware ?? "N/A"}'),
                        Text('Requiere Actualización: ${software.requiereActualizacion ? "Sí" : "No"}'),
                        Text('En Lista Negra: ${software.estaEnListaNegra ? "Sí" : "No"}'),
                        Text('ID de Licencia: ${software.licenciaVinculadaSoftwareId ?? "N/A"}'),
                        Text('ID de Contrato: ${software.contratoVinculadoSoftwareId ?? "N/A"}'),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSoftwareScreen()),
          ).then((_) => _fetchData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}