//screens/software_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart';
import 'package:app_gestion_activos/screens/inventory/add_software_type_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_software_type_screen.dart';
import 'package:app_gestion_activos/widgets/confirmation_dialog.dart';


class SoftwareSettingsScreen extends StatefulWidget {
  const SoftwareSettingsScreen({super.key});

  @override
  _SoftwareSettingsScreenState createState() => _SoftwareSettingsScreenState();
}

class _SoftwareSettingsScreenState extends State<SoftwareSettingsScreen> {
  bool _isLoading = false;
  List<TipoSoftware> _tipos = [];

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
      final tipos = await InventoryService.fetchTiposSoftware();
      setState(() {
        _tipos = tipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching TiposSoftware: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener Tipos de Software: $e')),
      );
    }
  }
  Future<void> _deleteTipoSoftware(int id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: 'Confirmar Eliminación',
        message: '¿Está seguro de que desea eliminar este tipo de software?',
      ),
    );
    if(confirmDelete == true){
      try {
        await InventoryService.deleteTipoSoftware(id);
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de software eliminado con éxito')),
        );
      } catch (e) {
        print('Error deleting TipoSoftware: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el Tipo de software: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Software'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _tipos.length,
        itemBuilder: (context, index) {
          final tipo = _tipos[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(tipo.nombreTipoSoftware),
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
                              EditSoftwareTypeScreen(type: tipo),
                        ),
                      ).then((_) => _fetchData());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTipoSoftware(tipo.idTipoSoftware),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(tipo.nombreTipoSoftware),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Descripción: ${tipo.descripcionTipoSoftware ?? "N/A"}'),
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
            MaterialPageRoute(builder: (context) => const AddSoftwareTypeScreen()),
          ).then((_) => _fetchData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}