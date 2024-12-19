// screens/edit_mantenimiento_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/Mantenimiento.dart';
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;

class EditMantenimientoScreen extends StatefulWidget {
  final Mantenimiento mantenimiento;
  const EditMantenimientoScreen({super.key, required this.mantenimiento});

  @override
  _EditMantenimientoScreenState createState() => _EditMantenimientoScreenState();
}

class _EditMantenimientoScreenState extends State<EditMantenimientoScreen> {
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
    return prefs.getInt('userId'); // Asumiendo that the ID de usuario es int
  }


  @override
  void initState() {
    super.initState();
    _descripcionMantenimiento = widget.mantenimiento.descripcionMantenimiento;
    _situacionMantenimiento = widget.mantenimiento.situacionMantenimiento;
    _prioridadMantenimiento = widget.mantenimiento.prioridadMantenimiento;
    _observacionesMantenimiento = widget.mantenimiento.observacionesMantenimiento;
    _softwareAsociadoMantenimientoId = widget.mantenimiento.softwareAsociadoMantenimientoId;
    _dispositivoAsociadoMantenimientoId = widget.mantenimiento.dispositivoAsociadoMantenimientoId;
    _fetchData();

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


  Future<void> _editMantenimiento() async {
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

      // Store the original situation
      final originalSituacionMantenimiento = widget.mantenimiento.situacionMantenimiento;
      Software? updatedSoftware;
      Dispositivo? updatedDevice;

      Map<String, dynamic> body = {
        if(_dispositivoAsociadoMantenimientoId != null)
          'dispositivoAsociadoMantenimientoId': _dispositivoAsociadoMantenimientoId,
        if(_softwareAsociadoMantenimientoId != null)
          'softwareAsociadoMantenimientoId': _softwareAsociadoMantenimientoId,
        'descripcionMantenimiento': _descripcionMantenimiento,
        'situacionMantenimiento': _situacionMantenimiento,
        'prioridadMantenimiento': _prioridadMantenimiento,
        'observacionesMantenimiento': _observacionesMantenimiento,
        'mantenimientoCreadoPorId': widget.mantenimiento.mantenimientoCreadoPorId,
      };

      if (_situacionMantenimiento == 'Finalizado' && originalSituacionMantenimiento != 'Finalizado') {
        if(_dispositivoAsociadoMantenimientoId != null){
          updatedDevice = await _showChangeDeviceStatusDialog(widget.mantenimiento.dispositivoAsociado!);
          if (updatedDevice != null){
            await InventoryService.updateDispositivo(updatedDevice);
          }
        }
        if(_softwareAsociadoMantenimientoId != null) {
          updatedSoftware = await _showChangeSoftwareStatusDialog(widget.mantenimiento.softwareAsociado!);
          if (updatedSoftware != null){
            await InventoryService.updateSoftware(updatedSoftware);
          }
        }
      }


      final response = await http.put(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos/${widget.mantenimiento.idMantenimiento}'),
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
          const SnackBar(content: Text('Mantenimiento actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el mantenimiento. Código: ${response.statusCode}')),
        );
        print('Error updating mantenimiento: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el mantenimiento: $e')),
      );
    }
  }


  Future<Software?> _showChangeSoftwareStatusDialog(Software software) async {
    bool? confirmChange = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finalizar Mantenimiento del Software'),
          content: const Text('¿Desea marcar el software como operativo?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sí'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
    if(confirmChange == true){
      final updatedSoftware = software.copyWith(
        requiereActualizacion: false,
        estaEnListaNegra: false,
      );
      return updatedSoftware;
    }
    return null;
  }


  Future<Dispositivo?> _showChangeDeviceStatusDialog(Dispositivo dispositivo) async {
    int? selectedStateId = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar Estado del Dispositivo'),
          content: const Text('Seleccione el nuevo estado del dispositivo:'),
          actions: <Widget>[
            TextButton(
              child: const Text('Disponible'),
              onPressed: () => Navigator.of(context).pop(4),
            ),
            TextButton(
              child: const Text('Fuera de servicio'),
              onPressed: () => Navigator.of(context).pop(5),
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

    if(selectedStateId != null){
      final updatedDevice = dispositivo.copyWith(estadoDispositivoId: selectedStateId);
      return updatedDevice;
    }
    return null;

  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Mantenimiento'),
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
                  initialValue: _descripcionMantenimiento,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcionMantenimiento = value,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Situación'),
                  value: _situacionMantenimiento,
                  items: <String>['Pendiente', 'En Progreso', 'Finalizado']
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
                  initialValue: _observacionesMantenimiento,
                  decoration: const InputDecoration(labelText: 'Observaciones'),
                  onSaved: (value) => _observacionesMantenimiento = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _editMantenimiento();
                      }
                    },
                    child: const Text('Actualizar Mantenimiento'),
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