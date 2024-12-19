//screens/inventory/edit_device_model_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;

class EditDeviceModelScreen extends StatefulWidget {
  final ModeloDispositivo model;
  const EditDeviceModelScreen({super.key, required this.model});

  @override
  _EditDeviceModelScreenState createState() => _EditDeviceModelScreenState();
}

class _EditDeviceModelScreenState extends State<EditDeviceModelScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreModelo;
  late String _marca;
  String? _descripcion;
  int? _tipoDispositivoId;
  bool _isLoading = false;
  List<TipoDispositivo> _tipos = [];

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }

  @override
  void initState() {
    super.initState();
    _nombreModelo = widget.model.nombreModeloDispositivo;
    _marca = widget.model.marca;
    _descripcion = widget.model.descripcionModeloDispositivo;
    _tipoDispositivoId = widget.model.tipoDispositivoId;
    _fetchData();
  }
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tipos = await InventoryService.fetchTiposDispositivos();

      setState(() {
        _tipos = tipos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener datos: $e')),
      );
    }
  }

  Future<void> _editDeviceModel() async {
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
        'nombreModeloDispositivo': _nombreModelo,
        'marca': _marca,
        'descripcionModeloDispositivo': _descripcion,
        'tipoDispositivoId': _tipoDispositivoId,
        'modeloDispositivoCreadoPorId': widget.model.modeloDispositivoCreadoPorId, // Incluimos el ID del creador
        'cantidadEnInventario': widget.model.cantidadEnInventario, // Incluimos la cantidad en inventario
      };

      final response = await http.put(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/modelosDispositivos/${widget.model.idModeloDispositivo}'),
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
          const SnackBar(content: Text('Modelo de Dispositivo actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el modelo de dispositivo. Código: ${response.statusCode}')),
        );
        print('Error creating device model: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el modelo de dispositivo: $e')),
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
        title: const Text('Editar Modelo de Dispositivo'),
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
                  initialValue: _nombreModelo,
                  decoration: const InputDecoration(labelText: 'Nombre del Modelo'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del modelo';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreModelo = value!,
                ),
                TextFormField(
                  initialValue: _marca,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la marca';
                    }
                    return null;
                  },
                  onSaved: (value) => _marca = value!,
                ),
                TextFormField(
                  initialValue: _descripcion,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcion = value,
                ),
                DropdownButtonFormField<int>(
                  value: _tipoDispositivoId,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo.idTipoDispositivo,
                      child: Text(tipo.nombreTipoDispositivo),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _tipoDispositivoId = value),
                  onSaved: (value) => _tipoDispositivoId = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _editDeviceModel();
                      }
                    },
                    child: const Text('Actualizar Modelo de Dispositivo'),
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