import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import '../../models/Usuario.dart';

class EditUserScreen extends StatefulWidget {
  final Usuario user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _correo;
  int _rolId = -1;
  List<Map<String, dynamic>> _roles = [];
  bool _rolesLoading = true;


  Future<void> _editUser() async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.authBaseUrl}/api/users/${widget.user.idUsuario}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken',
        },
        body: jsonEncode({
          'nombreUsuario': _nombre,
          'correoElectronicoUsuario': _correo,
          'rolId': _rolId,
        }),
      );
      if (response.statusCode == 200) {
        final updatedUserResponse = await http.get(
          Uri.parse('${ApiService.authBaseUrl}/api/users/${widget.user.idUsuario}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer authToken',
          },
        );
        if (updatedUserResponse.statusCode == 200) {
          final updatedUserJson = jsonDecode(updatedUserResponse.body);
          final updatedUser = Usuario.fromJson(updatedUserJson);
          Navigator.pop(context, updatedUser);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario actualizado exitosamente')),
          );

        } else {
          print('Error fetching updated user: ${updatedUserResponse.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al actualizar el usuario')),
          );
        }
      } else {
        print('Error editing user: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el usuario')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nombre = widget.user.nombreUsuario;
    _correo = widget.user.correoElectronicoUsuario;
    _fetchRoles();

  }

  Future<void> _fetchRoles() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/roles/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _roles = jsonBody.cast<Map<String, dynamic>>();
          _rolId = widget.user.rolId;
          _rolesLoading = false;
        });
      } else {
        print('Error fetching roles: ${response.statusCode}');
        setState(() {
          _rolesLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching roles: $e');
      setState(() {
        _rolesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) => _nombre = value!,
              ),
              TextFormField(
                initialValue: _correo,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor ingrese un correo válido';
                  }
                  return null;
                },
                onSaved: (value) => _correo = value!,
              ),
              _rolesLoading
                  ? const CircularProgressIndicator()
                  :  DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Rol'),
                value: _rolId == -1 ? null : _rolId,
                items: _roles.map((rol) {
                  return DropdownMenuItem<int>(
                    value: rol['idRol'],
                    child: Text(rol['nombreRol']),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _rolId = value!;
                }),
                onSaved: (value) => _rolId = value!,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      _editUser();
                    }
                  },
                  child: const Text('Actualizar Usuario'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}