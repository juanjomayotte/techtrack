//screens/license/edit_license_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/Licencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';
import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:intl/intl.dart';

class EditLicenseScreen extends StatefulWidget {
  final Licencia license;

  EditLicenseScreen({required this.license});

  @override
  _EditLicenseScreenState createState() => _EditLicenseScreenState();
}

class _EditLicenseScreenState extends State<EditLicenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _tipoLicenciaController;
  late TextEditingController _softwareController;
  late TextEditingController _fechaInicioController;
  late TextEditingController _fechaExpiracionController;
  late String _estadoLicencia; // Changed to store selected value
  late TextEditingController _maximoUsuariosController;
  late Future<TipoLicencia?> _tipoLicenciaFuture;
  late Future<Software?> _softwareFuture;

  @override
  void initState() {
    super.initState();
    _nombreController =
        TextEditingController(text: widget.license.nombreLicencia);
    _descripcionController =
        TextEditingController(text: widget.license.descripcionLicencia ?? '');
    _tipoLicenciaController = TextEditingController();
    _softwareController = TextEditingController();
    _fechaInicioController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.license.fechaInicio));
    _fechaExpiracionController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(widget.license.fechaExpiracion));
    _estadoLicencia =
        widget.license.estadoLicencia; // Initialize with the current state
    _maximoUsuariosController = TextEditingController(
        text: widget.license.maximoUsuarios?.toString() ?? '');
    _tipoLicenciaFuture = _fetchTipoLicencia();
    _softwareFuture = _fetchSoftware();
  }

  Future<TipoLicencia?> _fetchTipoLicencia() async {
    final licenseService = LicenseService();
    return await licenseService
        .fetchTipoLicenciaById(widget.license.tipoLicenciaId);
  }

  Future<Software?> _fetchSoftware() async {
    final licenseService = LicenseService();
    print("Fetching software with ID: ${widget.license.softwareId}");
    return await licenseService.fetchSoftwareById(widget.license.softwareId);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _tipoLicenciaController.dispose();
    _softwareController.dispose();
    _fechaInicioController.dispose();
    _fechaExpiracionController.dispose();
    _maximoUsuariosController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int? maximoUsuarios;

      // Imprimir el valor ingresado en el campo de máximo usuarios
      print("Texto de máximo usuarios: ${_maximoUsuariosController.text}");

      if (_maximoUsuariosController.text.isNotEmpty) {
        try {
          maximoUsuarios = int.parse(_maximoUsuariosController.text);
          // Imprimir si se ha convertido correctamente a entero
          print("Maximo usuarios convertido: $maximoUsuarios");
        } catch (e) {
          print("Error al convertir a entero: $e");
          maximoUsuarios = 0; // Usar 0 si falla la conversión
        }
      } else {
        maximoUsuarios =
            widget.license.maximoUsuarios ?? 0; // Usar 0 si el valor es null
        // Imprimir el valor de maximoUsuarios en caso de que venga de la licencia original
        print("Maximo usuarios original: ${widget.license.maximoUsuarios}");
      }

      // Imprimir los valores del formulario antes de hacer el update
      print("Formulario enviado con los siguientes valores:");
      print("Nombre: ${_nombreController.text}");
      print("Descripción: ${_descripcionController.text}");
      print("Fecha Inicio: ${_fechaInicioController.text}");
      print("Fecha Expiración: ${_fechaExpiracionController.text}");
      print("Estado Licencia: $_estadoLicencia");
      print("Maximo Usuarios: $maximoUsuarios");

      final editedLicense = Licencia(
          idLicencia: widget.license.idLicencia,
          nombreLicencia: _nombreController.text.isNotEmpty
              ? _nombreController.text
              : widget.license.nombreLicencia,
          descripcionLicencia: _descripcionController.text.isNotEmpty
              ? _descripcionController.text
              : widget.license.descripcionLicencia,
          tipoLicenciaId: widget.license.tipoLicenciaId, // No modificar
          fechaInicio: _fechaInicioController.text.isNotEmpty
              ? DateTime.parse(_fechaInicioController.text)
              : widget.license.fechaInicio,
          fechaExpiracion: _fechaExpiracionController.text.isNotEmpty
              ? DateTime.parse(_fechaExpiracionController.text)
              : widget.license.fechaExpiracion,
          estadoLicencia: _estadoLicencia, // Se toma del formulario
          maximoUsuarios: maximoUsuarios, // Ahora siempre es un entero
          softwareId: widget.license.softwareId // No modificar
          );

      try {
        final licenciaService = LicenseService();
        final updatedLicense = await licenciaService.updateLicencia(
            widget.license.idLicencia, editedLicense);
        print("Licencia actualizada con éxito: $updatedLicense");
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Licencia actualizada con éxito')));
      } catch (e) {
        print("Error al actualizar licencia: $e");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update license: $e')));
      }
    } else {
      print("Formulario no válido.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Licencia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, ingrese un nombre'
                    : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              FutureBuilder<TipoLicencia?>(
                future: _tipoLicenciaFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error cargando la licencia: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final tipoLicencia = snapshot.data;
                    _tipoLicenciaController.text =
                        tipoLicencia?.nombreTipoLicencia ?? 'Unknown';

                    return TextFormField(
                      controller: _tipoLicenciaController,
                      enabled: false,
                      decoration: InputDecoration(labelText: 'Tipo Licencia'),
                    );
                  } else {
                    return const Text('No se encontró el Tipo de Licencia');
                  }
                },
              ),
              TextFormField(
                controller: _fechaInicioController,
                decoration:
                    InputDecoration(labelText: 'Fecha Inicio (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una fecha válida';
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
                decoration:
                    InputDecoration(labelText: 'Fecha Expiración (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese una fecha válida';
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
                decoration: InputDecoration(labelText: 'Máximo Usuarios'),
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
              FutureBuilder<Software?>(
                future: _softwareFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error cargando software: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final software = snapshot.data;

                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Software',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child:  Text(
                        software?.nombreSoftware ?? 'Unknown',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    );
                  } else {
                    return const Text('No se ha encontrado al Software');
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _submitForm, child: Text('Guardar cambios')),
            ],
          ),
        ),
      ),
    );
  }
}
