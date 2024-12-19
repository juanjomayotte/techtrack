import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/EstadoDispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _numeroSerie;
  String? _ubicacion;
  int? _modeloDispositivoId;
  int? _estadoDispositivoId;
  int? _softwareInstaladoId;
  int? _usuarioAsignadoId; // Allow null values for optional assignment
  bool _isLoading = false;

  List<ModeloDispositivo> _modelos = [];
  List<EstadoDispositivo> _estados = [];
  List<Software> _software = [];
  List<Usuario> _usuarios = [];

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
      final modelos = await InventoryService.fetchModelosDispositivo();
      final estados = await InventoryService.fetchEstadosDispositivo();
      final software = await InventoryService.fetchSoftwares();
      // Fetch users from auth_service
      final usersResponse = await http.get(
          Uri.parse('${ApiService.authBaseUrl}/api/users/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );

      List<Usuario> fetchedUsers = [];
      if (usersResponse.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(usersResponse.body);
        fetchedUsers = jsonBody.map((user) => Usuario.fromJson(user)).toList();
      }

      setState(() {
        _modelos = modelos;
        _estados = estados;
        _software = software;
        _usuarios = fetchedUsers;

        //Initialize dropdown values with the first values if they're not empty
        if(_modelos.isNotEmpty) _modeloDispositivoId = _modelos.first.idModeloDispositivo;
        if(_estados.isNotEmpty) _estadoDispositivoId = _estados.first.idEstadoDispositivo;
        if(_software.isNotEmpty) _softwareInstaladoId = _software.first.idSoftware;

        // Initialize _usuarioAsignadoId as null
        _usuarioAsignadoId = null;


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

  Future<void> _addDevice() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Conditionally include usuarioAsignadoId
      Map<String, dynamic> body = {
        'numeroSerieDispositivo': _numeroSerie,
        'ubicacionDispositivo': _ubicacion,
        'modeloDispositivoId': _modeloDispositivoId,
        'estadoDispositivoId': _estadoDispositivoId,
        'softwareInstaladoId': _softwareInstaladoId,
        'dispositivoCreadoPorId': 1, //TODO: Get User from context
      };

      if (_usuarioAsignadoId != null) {
        body['usuarioAsignadoId'] = _usuarioAsignadoId;
      }


      final response = await http.post(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/dispositivos/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Actualizamos la cantidad en el modelo de dispositivo
        if (_modeloDispositivoId != null) {
          try {
            final modelo = await InventoryService.fetchModeloDispositivoById(_modeloDispositivoId!);
            await InventoryService.updateModeloDispositivo(
                modelo.copyWith(cantidadEnInventario: modelo.cantidadEnInventario + 1)
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dispositivo guardado con éxito')),
            );
          } catch (e) {
            print('Error updating device model quantity: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al actualizar la cantidad del modelo')),
            );
          }
        }
        Navigator.pop(context, true); // Retorna true al cerrar esta pantalla
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar dispositivo: ${response.statusCode} - ${response.body}')),
        );
        print('Error adding device: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar dispositivo: $e')),
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
        title: const Text('Agregar Dispositivo'),
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
                  decoration: const InputDecoration(labelText: 'Número de Serie'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un número de serie';
                    }
                    return null;
                  },
                  onSaved: (value) => _numeroSerie = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ubicación'),
                  onSaved: (value) => _ubicacion = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  value: _modeloDispositivoId,
                  items: _modelos.map((modelo) {
                    return DropdownMenuItem<int>(
                      value: modelo.idModeloDispositivo,
                      child: Text(modelo.nombreModeloDispositivo),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _modeloDispositivoId = value),
                  onSaved: (value) => _modeloDispositivoId = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Estado'),
                  value: _estadoDispositivoId,
                  items: _estados.map((estado) {
                    return DropdownMenuItem<int>(
                      value: estado.idEstadoDispositivo,
                      child: Text(estado.nombreEstadoDispositivo),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _estadoDispositivoId = value),
                  onSaved: (value) => _estadoDispositivoId = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Software'),
                  value: _softwareInstaladoId,
                  items: _software.map((software) {
                    return DropdownMenuItem<int>(
                      value: software.idSoftware,
                      child: Text(software.nombreSoftware),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _softwareInstaladoId = value),
                  onSaved: (value) => _softwareInstaladoId = value,
                ),
                //User selection
                DropdownButtonFormField<int?>( //Allow null value
                  decoration: const InputDecoration(labelText: 'Usuario Asignado'),
                  value: _usuarioAsignadoId, // Use nullable variable
                  items: _usuarios.map((user) {
                    return DropdownMenuItem<int>(
                      value: user.idUsuario,
                      child: Text(user.nombreUsuario),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _usuarioAsignadoId = value), // Update nullable value
                  onSaved: (value) => _usuarioAsignadoId = value, // Update nullable value
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addDevice();
                      }
                    },
                    child: const Text('Agregar Dispositivo'),
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