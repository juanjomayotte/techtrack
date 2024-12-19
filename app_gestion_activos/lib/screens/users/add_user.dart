//screens/users/add_user.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _correo;
  late int _rolId = 1; // Valor inicial para _rolId
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Para controlar el estado de carga
  List<Map<String, dynamic>> _roles = [];

  @override
  void initState() {
    super.initState();
    _fetchRoles(); // Llama a la función para obtener los roles al iniciar
  }
  Future<void> _fetchRoles() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/roles/'), // Ajusta la ruta según tu API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 'Authorization': 'Bearer your_token', // Si necesitas autenticación
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _roles = jsonBody.cast<Map<String, dynamic>>();

          // Asignar el primer rol como valor inicial si la lista no está vacía
          if (_roles.isNotEmpty) {
            _rolId = _roles[0]['idRol']; // Asumiendo que 'idRol' es la clave para el ID del rol
          }
        });

      } else {
        print('Error fetching roles: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose(); // Liberar recursos
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiService.authBaseUrl}/api/users/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nombreUsuario': _nombre,
          'correoElectronicoUsuario': _correo,
          'passwordUsuario': _passwordController.text,
          'confirmPassword': _confirmPasswordController.text, // Añadir este campo
          'rolId': _rolId,
        }),
      );
      setState(() {
        _isLoading = false; // Ocultar indicador de carga
      });
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final token = jsonBody['token'];
        final userId = jsonBody['userId'];

        // Guardar el token y userId en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user_id', userId.toString());

        // Mostrar Snackbar de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario guardado con éxito')),
        );
        Navigator.pop(context, true);
      } else {
        print('Error adding user: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar usuario. Código: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Ocultar indicador de carga en caso de error
      });
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor ingrese un correo válido';
                  }
                  return null;
                },
                onSaved: (value) => _correo = value!,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirmar Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty || value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Rol'),
                value: _rolId,
                items: _roles.map((rol) {
                  return DropdownMenuItem<int>(
                    value: rol['idRol'], //  Asumiendo que 'idRol' es la clave
                    child: Text(rol['nombreRol']), // Asumiendo que 'nombreRol' es la clave
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
                  onPressed: _isLoading ? null : () { // Deshabilitar el botón mientras se carga
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      _addUser();
                    }
                  },
                  child: _isLoading  // Mostrar indicador de carga en el botón
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Agregar Usuario'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
