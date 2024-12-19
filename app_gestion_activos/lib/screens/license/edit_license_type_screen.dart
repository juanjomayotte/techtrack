// edit_license_type_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/services/license_service.dart';

class EditLicenseTypeScreen extends StatefulWidget {
  final TipoLicencia licenseType;

  EditLicenseTypeScreen({required this.licenseType});

  @override
  _EditLicenseTypeScreenState createState() => _EditLicenseTypeScreenState();
}

class _EditLicenseTypeScreenState extends State<EditLicenseTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _creadoPorController;


  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.licenseType.nombreTipoLicencia);
    _descripcionController = TextEditingController(text: widget.licenseType.descripcionTipoLicencia);
    _creadoPorController = TextEditingController(text: widget.licenseType.tipoLicenciaCreadaPor.toString());
  }

  @override
  void dispose(){
    _nombreController.dispose();
    _descripcionController.dispose();
    _creadoPorController.dispose();
    super.dispose();
  }
  Future<void> _submitForm() async{
    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      final editedLicenseType = TipoLicencia(
          idTipoLicencia: widget.licenseType.idTipoLicencia,
          nombreTipoLicencia: _nombreController.text,
          descripcionTipoLicencia: _descripcionController.text,
          tipoLicenciaCreadaPor: int.parse(_creadoPorController.text)
      );

      try {
        final licenciaService = LicenseService();
        await licenciaService.updateTipoLicencia(widget.licenseType.idTipoLicencia,editedLicenseType);
        Navigator.of(context).pop(true); // Pop with a result to refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el Tipo de Licencia: $e')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Tipo de Licencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) => value == null || value.isEmpty ? 'Por favor, ingrese un nombre' : null
              ),
              TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) => value == null || value.isEmpty ? 'or favor, ingrese una descripción' : null
              ),
              TextFormField(
                  controller: _creadoPorController,
                  decoration: InputDecoration(labelText: 'Creado Por'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un Id de Usuario';
                    }
                    if(int.tryParse(value) == null){
                      return 'Por favor, ingrese un número entero';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text('Guardar Cambios')),
            ],
          ),
        ),
      ),
    );
  }
}