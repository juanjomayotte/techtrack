// screens/license_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/Licencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';
import 'package:app_gestion_activos/screens/license/edit_license_screen.dart';
import 'package:app_gestion_activos/screens/license/add_license_screen.dart';
import 'package:intl/intl.dart';


class LicenseScreen extends StatefulWidget {
  @override
  _LicenseScreenState createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final LicenseService _licenciaService = LicenseService();
  List<Licencia> _licencias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLicencias();
  }

  Future<void> _loadLicencias() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Licencia> licencias = await _licenciaService.fetchLicencias();
      setState(() {
        _licencias = licencias;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error cargando las licencias: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showLicenseDetails(Licencia licencia) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(licencia.nombreLicencia),
          content: SingleChildScrollView(
            child: ListBody(children: [
              Text('Descripción: ${licencia.descripcionLicencia ?? 'N/A'}'),
              Text('Tipo Licencia: ${licencia.tipoLicencia?.nombreTipoLicencia ?? 'N/A'}'),
              Text('Fecha Inicio: ${DateFormat('yyyy-MM-dd').format(licencia.fechaInicio)}'),
              Text('Fecha Expiración: ${DateFormat('yyyy-MM-dd').format(licencia.fechaExpiracion)}'),
              Text('Estado: ${licencia.estadoLicencia}'),
              Text('Máximo Usuarios: ${licencia.maximoUsuarios ?? 'N/A'}'),
              Text('Software: ${licencia.software?.nombreSoftware ?? 'N/A'}'),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLicense(int id) async {
    try {
      await _licenciaService.deleteLicencia(id);
      _loadLicencias();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Licencia eliminada exitosamente.')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error eliminando licencia: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Licencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración de Licencias',
            onPressed: () {
              Navigator.pushNamed(context, '/license_settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _licencias.isEmpty
          ? Center(child: Text('No se han encontrado licencias.'))
          : ListView.builder(
        itemCount: _licencias.length,
        itemBuilder: (context, index) {
          final licencia = _licencias[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(licencia.nombreLicencia),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo: ${licencia.tipoLicencia?.nombreTipoLicencia ?? "N/A"}'),
                  Text('Software: ${licencia.software?.nombreSoftware ?? "N/A"}'),
                  Text('Estado: ${licencia.estadoLicencia}'),
                ],
              ),
              onTap: () => _showLicenseDetails(licencia),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditLicenseScreen(license: licencia),
                        ),
                      );
                      if (result == true) {
                        _loadLicencias();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () =>
                        _deleteLicense(licencia.idLicencia),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddLicenseScreen(),
            ),
          );
          if (result == true) {
            _loadLicencias();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}