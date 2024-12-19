// screens/license_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';
import 'package:app_gestion_activos/screens/license/edit_license_type_screen.dart';
import 'package:app_gestion_activos/screens/license/add_license_type_screen.dart';

class LicenseSettingsScreen extends StatefulWidget {
  @override
  _LicenseSettingsScreenState createState() => _LicenseSettingsScreenState();
}

class _LicenseSettingsScreenState extends State<LicenseSettingsScreen> {
  final LicenseService _licenciaService = LicenseService();
  List<TipoLicencia> _tiposLicencia = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTiposLicencia();
  }

  Future<void> _loadTiposLicencia() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<TipoLicencia> tiposLicencia =
      await _licenciaService.fetchTiposLicencia();
      setState(() {
        _tiposLicencia = tiposLicencia;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading license types: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showLicenseTypeDetails(TipoLicencia tipoLicencia) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(tipoLicencia.nombreTipoLicencia),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Descripción: ${tipoLicencia.descripcionTipoLicencia}'),
                Text(
                    'Creado por usuario ID: ${tipoLicencia.tipoLicenciaCreadaPor}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLicenseType(int id) async {
    try {
      await _licenciaService.deleteTipoLicencia(id);
      _loadTiposLicencia();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tipo de Licencia eliminada exitosamente.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting license type')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tipos de Licencias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tiposLicencia.isEmpty
          ? const Center(child: Text('No license types found.'))
          : ListView.builder(
        itemCount: _tiposLicencia.length,
        itemBuilder: (context, index) {
          final tipoLicencia = _tiposLicencia[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(tipoLicencia.nombreTipoLicencia),
              subtitle: Text(
                  'Creado por: ${tipoLicencia.tipoLicenciaCreadaPor}'),
              onTap: () => _showLicenseTypeDetails(tipoLicencia),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditLicenseTypeScreen(
                              licenseType: tipoLicencia),
                        ),
                      ).then((_)=> _loadTiposLicencia());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _deleteLicenseType(tipoLicencia.idTipoLicencia);
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddLicenseTypeScreen(),
            ),
          ).then((_) => _loadTiposLicencia());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}