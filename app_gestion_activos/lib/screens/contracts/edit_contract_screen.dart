//screens/contracts/edit_contract_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/models/Contrato.dart';
import 'package:app_gestion_activos/services/contract_service.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package

class EditContractScreen extends StatefulWidget {
  final Contrato contrato;

  const EditContractScreen({Key? key, required this.contrato}) : super(key: key);

  @override
  _EditContractScreenState createState() => _EditContractScreenState();
}

class _EditContractScreenState extends State<EditContractScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late String _nombreContrato;
  late String _descripcionContrato;
  String? _fechaInicio; // Changed to String?
  String? _fechaExpiracion; // Changed to String?
  int? _tipoContratoId;
  late String _estadoContrato;

  List<TipoContrato> _tipos = [];

  @override
  void initState() {
    super.initState();
    _nombreContrato = widget.contrato.nombreContrato ?? '';
    _descripcionContrato = widget.contrato.descripcionContrato ?? '';
    _fechaInicio = widget.contrato.fechaInicio != null ? DateFormat('yyyy-MM-dd').format(widget.contrato.fechaInicio!) : null;
    _fechaExpiracion =  widget.contrato.fechaExpiracion != null ? DateFormat('yyyy-MM-dd').format(widget.contrato.fechaExpiracion!) : null;
    _tipoContratoId = widget.contrato.tipoContratoId;
    _estadoContrato = widget.contrato.estadoContrato ?? 'Vigente';
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tipos = await ContractService.fetchTiposContrato();

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

  Future<void> _editContract() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final formattedFechaInicio = _fechaInicio != null && _fechaInicio!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_fechaInicio!))
          : null;
      final formattedFechaExpiracion = _fechaExpiracion != null && _fechaExpiracion!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_fechaExpiracion!))
          : null;
      Map<String, dynamic> body = {
        'nombreContrato': _nombreContrato,
        'descripcionContrato': _descripcionContrato,
        'fechaInicio': formattedFechaInicio,  // Send formatted string
        'fechaExpiracion': formattedFechaExpiracion, // Send formatted string
        'tipoContratoId': _tipoContratoId,
        'estadoContrato': _estadoContrato,
        'ContratoCreadoPor': widget.contrato.ContratoCreadoPor,
      };

      final response = await http.put(
        Uri.parse('${ApiService.contractBaseUrl}/api/contratos/${widget.contrato.idContrato}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await _getToken()}'
        },
        body: jsonEncode(body),
      );
      setState(() {
        _isLoading = false;
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contrato actualizado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el contrato. Código: ${response.statusCode}')),
        );
        print('Error updating contract: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el contrato: $e')),
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
        title: const Text('Editar Contrato'),
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
                  initialValue: _nombreContrato,
                  decoration: const InputDecoration(labelText: 'Nombre del Contrato'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del contrato';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreContrato = value!,
                ),
                TextFormField(
                  initialValue: _descripcionContrato,
                  decoration: const InputDecoration(labelText: 'Descripción del Contrato'),
                  onSaved: (value) => _descripcionContrato = value!,
                ),
                TextFormField(
                  initialValue: _fechaInicio,
                  decoration: const InputDecoration(labelText: 'Fecha de Inicio (YYYY-MM-DD)'),
                  onSaved: (value) => _fechaInicio = value,
                ),
                TextFormField(
                  initialValue: _fechaExpiracion,
                  decoration: const InputDecoration(labelText: 'Fecha de Expiración (YYYY-MM-DD)'),
                  onSaved: (value) => _fechaExpiracion = value,
                ),
                DropdownButtonFormField<int>(
                  value: _tipoContratoId,
                  decoration: const InputDecoration(labelText: 'Tipo de Contrato'),
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo.idTipoContrato,
                      child: Text(tipo.nombreTipoContrato ?? 'Desconocido'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _tipoContratoId = value),
                  onSaved: (value) => _tipoContratoId = value,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Estado'),
                  value: _estadoContrato,
                  items: <String>['Vigente', 'Expirado', 'Cancelado']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _estadoContrato = value!),
                  onSaved: (value) => _estadoContrato = value!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _editContract();
                      }
                    },
                    child: const Text('Actualizar Contrato'),
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