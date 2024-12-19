// screens/contracts/add_contract_type_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/contract_service.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContractTypeScreen extends StatefulWidget {
  const AddContractTypeScreen({Key? key}) : super(key: key);

  @override
  _AddContractTypeScreenState createState() => _AddContractTypeScreenState();
}

class _AddContractTypeScreenState extends State<AddContractTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreTipoContrato;
  late String _descripcionTipoContrato;
  bool _isLoading = false;

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo that the ID de usuario es int
  }

  Future<void> _addContractType() async {
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

      final newContractType = TipoContrato(
          idTipoContrato: 0,
          nombreTipoContrato: _nombreTipoContrato,
          descripcionTipoContrato: _descripcionTipoContrato,
          tipoContratoCreadoPor: userId
      );
      await ContractService.createTipoContrato(newContractType);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de contrato creado con éxito')),
      );
      Navigator.pop(context, true); // Retorna true al cerrar esta pantalla
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar tipo de contrato: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tipo de Contrato'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          :  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre del Tipo de Contrato'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre del tipo de contrato';
                    }
                    return null;
                  },
                  onSaved: (value) => _nombreTipoContrato = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese una descripción';
                    }
                    return null;
                  },
                  onSaved: (value) => _descripcionTipoContrato = value!,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addContractType();
                      }
                    },
                    child: const Text('Agregar Tipo de Contrato'),
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