// add_license_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/Licencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';
import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:intl/intl.dart';

class AddLicenseScreen extends StatefulWidget {
  @override
  _AddLicenseScreenState createState() => _AddLicenseScreenState();
}

class _AddLicenseScreenState extends State<AddLicenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  TipoLicencia? _selectedTipoLicencia;
  Software? _selectedSoftware;
  final _fechaInicioController = TextEditingController();
  final _fechaExpiracionController = TextEditingController();
  String _estadoLicencia = 'Activa'; // Valor por defecto
  final _maximoUsuariosController = TextEditingController();
  late Future<List<TipoLicencia>> _tiposLicenciaFuture;
  late Future<List<Software>> _softwaresFuture;

  @override
  void initState() {
    super.initState();
    _tiposLicenciaFuture = _fetchTiposLicencia();
    _softwaresFuture = _fetchSoftwares();
  }

  Future<List<TipoLicencia>> _fetchTiposLicencia() async {
    final licenseService = LicenseService();
    return await licenseService.fetchTiposLicencia();
  }

  Future<List<Software>> _fetchSoftwares() async {
    final licenseService = LicenseService();
    return await licenseService.fetchSoftwares();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _fechaInicioController.dispose();
    _fechaExpiracionController.dispose();
    _maximoUsuariosController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      int? maximoUsuarios;
      if (_maximoUsuariosController.text.isNotEmpty) {
        try {
          maximoUsuarios = int.parse(_maximoUsuariosController.text);
        } catch (e) {
          print("Error al convertir a entero: $e");
          maximoUsuarios = 0;
        }
      } else{
        maximoUsuarios = 0;
      }
      final newLicense = Licencia(
        idLicencia: 0,
        nombreLicencia: _nombreController.text,
        descripcionLicencia: _descripcionController.text.isNotEmpty
            ? _descripcionController.text
            : null,
        tipoLicenciaId: _selectedTipoLicencia!.idTipoLicencia,
        fechaInicio: DateTime.parse(_fechaInicioController.text),
        fechaExpiracion: DateTime.parse(_fechaExpiracionController.text),
        estadoLicencia: _estadoLicencia,
        maximoUsuarios: maximoUsuarios,
        softwareId: _selectedSoftware!.idSoftware,
      );

      try {
        final licenciaService = LicenseService();
        await licenciaService.createLicencia(newLicense);
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Licencia creada con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la Licencia: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Licencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, ingrese un nombre' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              FutureBuilder<List<TipoLicencia>>(
                future: _tiposLicenciaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error cargando los tipos de licencia: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return DropdownButtonFormField<TipoLicencia>(
                      decoration:
                      const InputDecoration(labelText: 'Tipo Licencia'),
                      value: _selectedTipoLicencia,
                      items: snapshot.data!.map((tipoLicencia) {
                        return DropdownMenuItem<TipoLicencia>(
                          value: tipoLicencia,
                          child: Text(tipoLicencia.nombreTipoLicencia),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTipoLicencia = value;
                        });
                      },
                      validator: (value) => value == null ? 'Por favor, selecciones un Tipo de Licencia' : null,
                    );
                  } else {
                    return const Text('No se han encontrado tipos de licencia');
                  }
                },
              ),
              TextFormField(
                controller: _fechaInicioController,
                decoration:
                const InputDecoration(labelText: 'Fecha Inicio (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una fecha válida.';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parse(value);
                    return null;
                  } catch (e) {
                    return 'Por favor, ingrese una fecha válida (YYYY-MM-DD)';
                  }
                },
              ),
              TextFormField(
                controller: _fechaExpiracionController,
                decoration: const InputDecoration(
                    labelText: 'Fecha Expiración (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una fecha válida.';
                  }
                  try {
                    DateFormat('yyyy-MM-dd').parse(value);
                    return null;
                  } catch (e) {
                    return 'Por favor, ingrese una fecha válida (YYYY-MM-DD)';
                  }
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Estado'),
                value: _estadoLicencia,
                items: <String>['Activa', 'Inactiva', 'Expirada']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _estadoLicencia = value!),
                onSaved: (value) => _estadoLicencia = value!,
              ),
              TextFormField(
                controller: _maximoUsuariosController,
                decoration: const InputDecoration(labelText: 'Máximo Usuarios'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      int.tryParse(value) == null) {
                    return 'Por favor, ingrese un número válido o déjelo vacío.';
                  }
                  return null;
                },
              ),
              FutureBuilder<List<Software>>(
                future: _softwaresFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error cargando Softwares: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return DropdownButtonFormField<Software>(
                      decoration: const InputDecoration(labelText: 'Software'),
                      value: _selectedSoftware,
                      items: snapshot.data!.map((software) {
                        return DropdownMenuItem<Software>(
                          value: software,
                          child: Text(software.nombreSoftware),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSoftware = value;
                        });
                      },
                      validator: (value) =>
                      value == null ? 'Por favor, elija un software' : null,
                    );
                  } else {
                    return const Text('No se ha encontrado ningún software');
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Crear Licencia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}