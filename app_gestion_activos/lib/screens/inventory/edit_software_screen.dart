//screens/inventory/edit_software_screen.dart
import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;

class EditSoftwareScreen extends StatefulWidget {
  final Software software;
  const EditSoftwareScreen({super.key, required this.software});

  @override
  _EditSoftwareScreenState createState() => _EditSoftwareScreenState();
}

class _EditSoftwareScreenState extends State<EditSoftwareScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreSoftware;
  late String _versionSoftware;
  int? _tipoSoftwareId;
  bool _requiereActualizacion = false;
  bool _estaEnListaNegra = false;
  int? _licenciaVinculadaSoftwareId;
  int? _contratoVinculadoSoftwareId;
  bool _isLoading = false;
  List<TipoSoftware> _tipos = [];

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Assuming the user ID is an int
  }

  @override
  void initState() {
    super.initState();
    _nombreSoftware = widget.software.nombreSoftware;
    _versionSoftware = widget.software.versionSoftware;
    _tipoSoftwareId = widget.software.tipoSoftwareId;
    _requiereActualizacion = widget.software.requiereActualizacion;
    _estaEnListaNegra = widget.software.estaEnListaNegra;
    _licenciaVinculadaSoftwareId = widget.software.licenciaVinculadaSoftwareId;
    _contratoVinculadoSoftwareId = widget.software.contratoVinculadoSoftwareId;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tipos = await InventoryService.fetchTiposSoftware();

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

  Future<void> _editSoftware() async {
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
        'nombreSoftware': _nombreSoftware,
        'versionSoftware': _versionSoftware,
        'requiereActualizacion': _requiereActualizacion,
        'estaEnListaNegra': _estaEnListaNegra,
        'softwareCreadoPorId': widget.software.softwareCreadoPorId
      };

      // Only add tipoSoftwareId if it's not null
      if (_tipoSoftwareId != null) {
        body['tipoSoftwareId'] = _tipoSoftwareId;
      }
      if (_licenciaVinculadaSoftwareId != null) {
        body['licenciaVinculadaSoftwareId'] = _licenciaVinculadaSoftwareId;
      }

      if (_contratoVinculadoSoftwareId != null) {
        body['contratoVinculadoSoftwareId'] = _contratoVinculadoSoftwareId;
      }

      final response = await http.put(
        Uri.parse(
            '${ApiService.inventoryBaseUrl}/api/software/${widget.software.idSoftware}'),
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
          const SnackBar(content: Text('Software actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error al actualizar el software. Código: ${response.statusCode}')),
        );
        print(
            'Error updating software: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el software: $e')),
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
        title: const Text('Editar Software'),
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
                  initialValue: _nombreSoftware,
                  decoration:
                  const InputDecoration(labelText: 'Nombre del Software'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del software';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreSoftware = value!,
                ),
                TextFormField(
                  initialValue: _versionSoftware,
                  decoration: const InputDecoration(labelText: 'Versión'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la versión del software';
                    }
                    return null;
                  },
                  onSaved: (value) => _versionSoftware = value!,
                ),
                DropdownButtonFormField<int>(
                  value: _tipoSoftwareId,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo.idTipoSoftware,
                      child: Text(tipo.nombreTipoSoftware),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _tipoSoftwareId = value),
                  onSaved: (value) => _tipoSoftwareId = value,
                  validator: (value) => value == null ? 'Por favor selecciona un tipo de software' : null,
                ),
                CheckboxListTile(
                  title: const Text('Requiere Actualización'),
                  value: _requiereActualizacion,
                  onChanged: (value) =>
                      setState(() => _requiereActualizacion = value!),
                ),
                CheckboxListTile(
                  title: const Text('Está en Lista Negra'),
                  value: _estaEnListaNegra,
                  onChanged: (value) =>
                      setState(() => _estaEnListaNegra = value!),
                ),
                TextFormField(
                  initialValue:
                  _licenciaVinculadaSoftwareId?.toString() ?? '',
                  decoration: const InputDecoration(
                      labelText: 'ID de Licencia (opcional)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _licenciaVinculadaSoftwareId =
                  value != null && value.isNotEmpty
                      ? int.tryParse(value)
                      : null,
                ),
                TextFormField(
                  initialValue:
                  _contratoVinculadoSoftwareId?.toString() ?? '',
                  decoration: const InputDecoration(
                      labelText: 'ID de Contrato (opcional)'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _contratoVinculadoSoftwareId =
                  value != null && value.isNotEmpty
                      ? int.tryParse(value)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _editSoftware();
                      }
                    },
                    child: const Text('Actualizar Software'),
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