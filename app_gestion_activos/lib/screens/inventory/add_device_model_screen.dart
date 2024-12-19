//screens/inventory/add_device_model_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;

class AddDeviceModelScreen extends StatefulWidget {
  const AddDeviceModelScreen({super.key});

  @override
  _AddDeviceModelScreenState createState() => _AddDeviceModelScreenState();
}

class _AddDeviceModelScreenState extends State<AddDeviceModelScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreModelo;
  late String _marca;
  String? _descripcion;
  int? _tipoDispositivoId;
  bool _isLoading = false;
  List<TipoDispositivo> _tipos = [];
  int _cantidadEnInventario = 0; // Inicializamos la cantidad en 0

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }

  @override
  void initState() {
    super.initState();
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

  // Nueva función para consultar la cantidad en inventario
  Future<int> _fetchCantidadEnInventario() async {
    try {
      if(_tipoDispositivoId != null){
        final dispositivos = await InventoryService.fetchDispositivos();
        return dispositivos.where((dispositivo) => dispositivo.modeloDispositivoId == _tipoDispositivoId).length;
      }else{
        return 0;
      }

    } catch (e) {
      print('Error fetching cantidad en inventario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener cantidad en inventario: $e')),
      );
      return 0; // En caso de error, retornamos 0
    }
  }

  Future<void> _addDeviceModel() async {
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
      // Obtenemos la cantidad en inventario antes de enviar la petición
      _cantidadEnInventario = await _fetchCantidadEnInventario();

      Map<String, dynamic> body = {
        'nombreModeloDispositivo': _nombreModelo,
        'marca': _marca,
        'descripcionModeloDispositivo': _descripcion,
        'tipoDispositivoId': _tipoDispositivoId,
        'modeloDispositivoCreadoPorId': userId,
        'cantidadEnInventario': _cantidadEnInventario, // Enviamos la cantidad
      };

      final response = await http.post(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/modelosDispositivos/'),
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
          const SnackBar(content: Text('Modelo de Dispositivo creado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al crear el modelo de dispositivo. Código: ${response.statusCode}')),
        );
        print(
            'Error creating device model: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el modelo de dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Modelo de Dispositivo'),
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
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcion = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo.idTipoDispositivo,
                      child: Text(tipo.nombreTipoDispositivo),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _tipoDispositivoId = value),
                  onSaved: (value) => _tipoDispositivoId = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addDeviceModel();
                      }
                    },
                    child: const Text('Crear Modelo de Dispositivo'),
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