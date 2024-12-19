// screens/add_mantenimiento_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;

class AddMantenimientoScreen extends StatefulWidget {
  final Dispositivo? dispositivo;
  final Software? software;
  const AddMantenimientoScreen({super.key, this.dispositivo, this.software});

  @override
  _AddMantenimientoScreenState createState() => _AddMantenimientoScreenState();
}

class _AddMantenimientoScreenState extends State<AddMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _descripcionMantenimiento;
  String _situacionMantenimiento = 'Pendiente';
  String _prioridadMantenimiento = 'Baja';
  String? _observacionesMantenimiento;
  int? _softwareAsociadoMantenimientoId;
  int? _dispositivoAsociadoMantenimientoId;
  bool _isLoading = false;

  List<Dispositivo> _dispositivos = [];
  List<Software> _softwares = [];

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo que el ID de usuario es int
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
    if(widget.dispositivo != null){
      _dispositivoAsociadoMantenimientoId = widget.dispositivo?.idDispositivo;
    }
    if (widget.software != null) {
      _softwareAsociadoMantenimientoId = widget.software?.idSoftware;
    }
  }
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dispositivos = await InventoryService.fetchDispositivos();
      final softwares = await InventoryService.fetchSoftwares();
      setState(() {
        _dispositivos = dispositivos;
        _softwares = softwares;
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

  Future<void> _addMantenimiento() async {
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
        if(_softwareAsociadoMantenimientoId != null)
          'softwareAsociadoMantenimientoId': _softwareAsociadoMantenimientoId,
        'descripcionMantenimiento': _descripcionMantenimiento,
        'situacionMantenimiento': _situacionMantenimiento,
        'prioridadMantenimiento': _prioridadMantenimiento,
        'observacionesMantenimiento': _observacionesMantenimiento,
        'mantenimientoCreadoPorId': userId,
      };
      if(_dispositivoAsociadoMantenimientoId != null){
        body['dispositivoAsociadoMantenimientoId'] = _dispositivoAsociadoMantenimientoId;
      }

      final response = await http.post(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos/'),
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
          const SnackBar(content: Text('Mantenimiento creado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear el mantenimiento. Código: ${response.statusCode}')),
        );
        print('Error creating mantenimiento: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear el mantenimiento: $e')),
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
        title: const Text('Agregar Mantenimiento'),
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
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Dispositivo (opcional)'),
                  value: _dispositivoAsociadoMantenimientoId,
                  items: _dispositivos.map((dispositivo) {
                    return DropdownMenuItem<int>(
                      value: dispositivo.idDispositivo,
                      child: Text(dispositivo.numeroSerieDispositivo),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _dispositivoAsociadoMantenimientoId = value),
                  onSaved: (value) => _dispositivoAsociadoMantenimientoId = value,
                ),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Software (opcional)'),
                  value: _softwareAsociadoMantenimientoId,
                  items: _softwares.map((software) {
                    return DropdownMenuItem<int>(
                      value: software.idSoftware,
                      child: Text(software.nombreSoftware),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _softwareAsociadoMantenimientoId = value),
                  onSaved: (value) => _softwareAsociadoMantenimientoId = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcionMantenimiento = value,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Situación'),
                  value: _situacionMantenimiento,
                  items: <String>['Pendiente', 'En Progreso']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _situacionMantenimiento = value!),
                  onSaved: (value) => _situacionMantenimiento = value!,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Prioridad'),
                  value: _prioridadMantenimiento,
                  items: <String>['Baja', 'Media', 'Alta']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _prioridadMantenimiento = value!),
                  onSaved: (value) => _prioridadMantenimiento = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                  onSaved: (value) => _observacionesMantenimiento = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addMantenimiento();
                      }
                    },
                    child: const Text('Crear Mantenimiento'),
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