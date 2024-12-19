//screens/license/add_license_type_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';

class AddLicenseTypeScreen extends StatefulWidget {
  @override
  _AddLicenseTypeScreenState createState() => _AddLicenseTypeScreenState();
}

class _AddLicenseTypeScreenState extends State<AddLicenseTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _creadoPorController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _creadoPorController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && !_isSubmitting) {
      setState(() {
        _isSubmitting = true;
      });
      _formKey.currentState!.save();
      final newLicenseType = TipoLicencia(
          idTipoLicencia: 0,
          nombreTipoLicencia: _nombreController.text,
          descripcionTipoLicencia: _descripcionController.text,
          tipoLicenciaCreadaPor: int.parse(_creadoPorController.text)
      );


      try {
        final licenciaService = LicenseService();
        await licenciaService.createTipoLicencia(newLicenseType);
        if(mounted){
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tipo de Licencia creada exitosamente.')),
          );
        }
      } catch (e) {
        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear el Tipo de Licencia: $e')),
          );
        }
        print("Error creando: $e");
      } finally {
        if(mounted){
          setState(() {
            _isSubmitting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Tipo de Licencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, ingresa un nombre' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Por favor, ingresa una descripción.' : null,
              ),
              TextFormField(
                controller: _creadoPorController,
                decoration: InputDecoration(labelText: 'Creado Por'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese un Id de Usuario';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, ingrese un número entero.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm, // Disable button when submitting
                child: _isSubmitting
                    ? CircularProgressIndicator() // Show loader when submitting
                    : Text('Crear Tipo de Licencia'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}