//screens/contracts_screen.dart

import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/contract_service.dart';
import 'package:app_gestion_activos/models/Contrato.dart';
import 'package:intl/intl.dart';
import 'package:app_gestion_activos/screens/contracts/edit_contract_screen.dart'; // Asegúrate de importar esta línea

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({Key? key}) : super(key: key);

  @override
  _ContractsScreenState createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  List<Contrato>? _contracts; // Cambiado a nullable
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContracts();
  }

  Future<void> _fetchContracts() async {
    try {
      final contracts = await ContractService.fetchContratos();
      setState(() {
        _contracts = contracts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching contracts: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener datos: $e')),
      );
    }
  }

  Future<void> _deleteContract(int contractId) async {
    try {
      await ContractService.deleteContrato(contractId);
      if (_contracts != null) {
        setState(() {
          _contracts!.removeWhere((contract) => contract.idContrato == contractId);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrato eliminado con éxito')),
      );
    } catch (e) {
      print('Error deleting contract: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el contrato: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración de Contratos',
            onPressed: () {
              Navigator.pushNamed(context, '/contract_settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contracts == null || _contracts!.isEmpty
          ? const Center(child: Text("No hay contratos"))
          : ListView.builder(
        itemCount: _contracts!.length,
        itemBuilder: (context, index) {
          final contract = _contracts![index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(contract.nombreContrato),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo: ${contract.tipoContrato?.nombreTipoContrato ?? "N/A"}'),
                  Text('Proveedor: ${contract.proveedor}'),
                  Text('Inicio: ${DateFormat('yyyy-MM-dd').format(contract.fechaInicio)}'),
                  Text('Fin: ${DateFormat('yyyy-MM-dd').format(contract.fechaExpiracion)}'),
                  Text('Estado: ${contract.estadoContrato}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditContractScreen(contrato: contract), // Pasar el objeto completo
                        ),
                      );
                      if (result == true) {
                        _fetchContracts();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteContract(contract.idContrato),
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(contract.nombreContrato),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Tipo: ${contract.tipoContrato?.nombreTipoContrato ?? "N/A"}'),
                        Text('Proveedor: ${contract.proveedor}'),
                        Text('Inicio: ${DateFormat('yyyy-MM-dd').format(contract.fechaInicio)}'),
                        Text('Fin: ${DateFormat('yyyy-MM-dd').format(contract.fechaExpiracion)}'),
                        Text('Estado: ${contract.estadoContrato}'),
                        Text('Descripción: ${contract.descripcionContrato ?? "N/A"}'),
                        Text('Términos: ${contract.terminosGenerales ?? "N/A"}'),
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
          final result = await Navigator.pushNamed(context, '/add_contract');
          if (result == true) {
            _fetchContracts();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
