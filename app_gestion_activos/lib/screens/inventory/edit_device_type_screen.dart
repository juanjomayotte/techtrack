//screens/inventory/edit_device_type_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';

class EditDeviceTypeScreen extends StatefulWidget {
  final TipoDispositivo type;
  const EditDeviceTypeScreen({super.key, required this.type});

  @override
  _EditDeviceTypeScreenState createState() => _EditDeviceTypeScreenState();
}

class _EditDeviceTypeScreenState extends State<EditDeviceTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreTipo;
  String? _descripcion;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombreTipo = widget.type.nombreTipoDispositivo;
    _descripcion = widget.type.descripcionTipoDispositivo;
  }

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }


  Future<void> _editDeviceType() async {
    setState(() {
      _isLoading = true;
    });
    try {
      int? userId = await _getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el ID de usuario. Debe iniciar sesión.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      Map<String, dynamic> body = {
        'nombreTipoDispositivo': _nombreTipo,
        'descripcionTipoDispositivo': _descripcion,
        'tipoDispositivoModificadoPorId': userId, // Agregamos el ID del usuario que modifica
        'tipoDispositivoCreadoPorId': widget.type.tipoDispositivoCreadoPorId // Agregamos el id del usuario creador
      };

      final response = await http.put(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposDispositivos/${widget.type.idTipoDispositivo}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de Dispositivo actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el tipo de dispositivo. Código: ${response.statusCode}')),
        );
        print('Error updating device type: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el tipo de dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tipo de Dispositivo'),
      ),
      body:  _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _nombreTipo,
                  decoration: const InputDecoration(labelText: 'Nombre del Tipo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del tipo';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreTipo = value!,
                ),
                TextFormField(
                  initialValue: _descripcion,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcion = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _editDeviceType();
                      }
                    },
                    child: const Text('Actualizar Tipo de Dispositivo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}