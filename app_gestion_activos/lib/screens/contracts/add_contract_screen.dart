// screens/contracts/add_contract_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_gestion_activos/services/contract_service.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/Contrato.dart';



class AddContractScreen extends StatefulWidget {
  const AddContractScreen({Key? key}) : super(key: key);

  @override
  _AddContractScreenState createState() => _AddContractScreenState();
}

class _AddContractScreenState extends State<AddContractScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombreContrato;
  String? _descripcionContrato;
  String? _fechaInicio;
  String? _fechaExpiracion;
  int? _tipoContratoId;
  String? _proveedor;
  String? _terminosGenerales;
  String _estadoContrato = 'Vigente';
  bool _isLoading = false;


  List<TipoContrato> _tipos = [];

  Future<int?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Asumiendo that the ID de usuario es int
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
      final tipos = await ContractService.fetchTiposContrato();
      setState(() {
        _tipos = tipos;
        if(_tipos.isNotEmpty) _tipoContratoId = _tipos.first.idTipoContrato;
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


  Future<void> _addContract() async {
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

      final formattedFechaInicio = _fechaInicio != null && _fechaInicio!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_fechaInicio!))
          : null;
      final formattedFechaExpiracion = _fechaExpiracion != null && _fechaExpiracion!.isNotEmpty
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(_fechaExpiracion!))
          : null;


      final newContract = Contrato(
        idContrato: 0,
        nombreContrato: _nombreContrato,
        descripcionContrato: _descripcionContrato,
        tipoContratoId: _tipoContratoId!,
        fechaInicio: formattedFechaInicio != null ? DateTime.parse(formattedFechaInicio) : DateTime.now(),
        fechaExpiracion: formattedFechaExpiracion != null ?  DateTime.parse(formattedFechaExpiracion) : DateTime.now(),
        proveedor: _proveedor ?? "",
        terminosGenerales: _terminosGenerales ?? "",
        estadoContrato: _estadoContrato,
        ContratoCreadoPor: userId,
      );


      await ContractService.createContrato(newContract);
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrato creado con éxito')),
      );
      Navigator.pop(context, true); // Retorna true al cerrar esta pantalla
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar contrato: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Contrato'),
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
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  onSaved: (value) => _descripcionContrato = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Proveedor'),
                  onSaved: (value) => _proveedor = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Fecha de inicio (YYYY-MM-DD)'),
                  onSaved: (value) => _fechaInicio = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Fecha de Expiración (YYYY-MM-DD)'),
                  onSaved: (value) => _fechaExpiracion = value,
                ),

                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Tipo de Contrato'),
                  value: _tipoContratoId,
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem<int>(
                      value: tipo.idTipoContrato,
                      child: Text(tipo.nombreTipoContrato),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Términos Generales'),
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                  onSaved: (value) => _terminosGenerales = value,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        _addContract();
                      }
                    },
                    child: const Text('Agregar Contrato'),
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