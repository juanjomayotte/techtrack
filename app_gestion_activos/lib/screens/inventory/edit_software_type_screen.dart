import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/models/TipoSoftware.dart';

class EditSoftwareTypeScreen extends StatefulWidget {
  final TipoSoftware type;
  const EditSoftwareTypeScreen({super.key, required this.type});

  @override
  _EditSoftwareTypeScreenState createState() => _EditSoftwareTypeScreenState();
}

class _EditSoftwareTypeScreenState extends State<EditSoftwareTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreTipo;
  String? _descripcion;
  bool _isLoading = false;

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }

  @override
  void initState() {
    super.initState();
    _nombreTipo = widget.type.nombreTipoSoftware;
    _descripcion = widget.type.descripcionTipoSoftware;
  }

  Future<void> _editSoftwareType() async {
    setState(() {
      _isLoading = true;
    });
    try {
      int? userId = await _getUserId();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No se encontró el ID de usuario. Debe iniciar sesión.')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      Map<String, dynamic> body = {
        'nombreTipoSoftware': _nombreTipo,
        'descripcionTipoSoftware': _descripcion,
        'tipoSoftwareCreadoPorId': widget.type.tipoSoftwareCreadoPorId
      };

      final response = await http.put(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tipossoftware/${widget.type.idTipoSoftware}'),
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
          const SnackBar(content: Text('Tipo de Software actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el tipo de software. Código: ${response.statusCode}')),
        );
        print('Error updating software type: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el tipo de software: $e')),
      );
    }
  }
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tipo de Software'),
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
                        _editSoftwareType();
                      }
                    },
                    child: const Text('Actualizar Tipo de Software'),
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