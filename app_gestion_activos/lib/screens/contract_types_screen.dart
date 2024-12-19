// screens/contracts/contract_types_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/contract_service.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';
import 'package:app_gestion_activos/screens/contracts/add_contract_type_screen.dart';
import 'package:app_gestion_activos/screens/contracts/edit_contract_type_screen.dart';


class ContractTypesScreen extends StatefulWidget {
  const ContractTypesScreen({Key? key}) : super(key: key);

  @override
  _ContractTypesScreenState createState() => _ContractTypesScreenState();
}

class _ContractTypesScreenState extends State<ContractTypesScreen> {
  List<TipoContrato> _contractTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContractTypes();
  }

  Future<void> _fetchContractTypes() async {
    try {
      final contractTypes = await ContractService.fetchTiposContrato();
      setState(() {
        _contractTypes = contractTypes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching contract types: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener datos: $e')),
      );
    }
  }
  Future<void> _deleteContractType(int contractTypeId) async {
    try {
      await ContractService.deleteTipoContrato(contractTypeId);
      setState(() {
        _contractTypes.removeWhere((contractType) => contractType.idTipoContrato == contractTypeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de contrato eliminado con éxito')),
      );
    } catch (e) {
      print('Error deleting contract type: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el tipo de contrato: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de Contrato'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contractTypes.isEmpty
          ? const Center(child: Text("No hay tipos de contrato"))
          : ListView.builder(
        itemCount: _contractTypes.length,
        itemBuilder: (context, index) {
          final contractType = _contractTypes[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(contractType.nombreTipoContrato),
              subtitle: Text(contractType.descripcionTipoContrato),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit_contract_type',
                        arguments: contractType,
                      );
                      // Actualizar si hubo cambios
                      if (result == true) {
                        _fetchContractTypes();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteContractType(contractType.idTipoContrato),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(contractType.nombreTipoContrato),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Descripción: ${contractType.descripcionTipoContrato}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_contract_type');
          // Actualizar si hubo cambios
          if (result == true) {
            _fetchContractTypes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}