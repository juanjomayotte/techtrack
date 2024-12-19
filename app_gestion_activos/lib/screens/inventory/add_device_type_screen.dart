//screens/inventory/add_device_type_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddDeviceTypeScreen extends StatefulWidget {
  const AddDeviceTypeScreen({super.key});

  @override
  _AddDeviceTypeScreenState createState() => _AddDeviceTypeScreenState();
}

class _AddDeviceTypeScreenState extends State<AddDeviceTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreTipo;
  String? _descripcion;
  bool _isLoading = false;


  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }

  Future<void> _addDeviceType() async {
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
        'tipoDispositivoCreadoPorId': userId,  // Agregamos el ID del usuario
      };

      final response = await http.post(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposDispositivos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de Dispositivo creado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el tipo de dispositivo. Código: ${response.statusCode}')),
        );
        print('Error creating device type: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el tipo de dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tipo de Dispositivo'),
      ),
      body: _isLoading
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
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcion = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addDeviceType();
                      }
                    },
                    child: const Text('Crear Tipo de Dispositivo'),
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