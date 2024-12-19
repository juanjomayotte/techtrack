import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/services/api_service.dart';
import '../../models/Usuario.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Usuario? _user;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      setState(() {
        _errorMessage = 'No se encontró el ID de usuario o el token';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/users/$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        setState(() {
          _user = Usuario.fromJson(userData);
          _nombreController.text = _user!.nombreUsuario;
          _emailController.text = _user!.correoElectronicoUsuario;
          _isLoading = false;
        });
        print('Datos recibidos del usuario: ${_user!.toJson()}');
      } else {
        throw Exception('Error al obtener datos del usuario: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
      print('Error al obtener datos del usuario: $e');
    }
  }

  Future<void> _editUser() async {
    if (_user == null) return;

    try {
      final response = await http.put(
        Uri.parse('${ApiService.authBaseUrl}/api/users/${_user!.idUsuario}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken', // Ajusta si usas un token dinámico
        },
        body: jsonEncode({
          'nombreUsuario': _nombreController.text,
          'correoElectronicoUsuario': _emailController.text,
          'rolId': _user!.rolId, // Reutiliza el rolId existente
        }),
      );

      if (response.statusCode == 200) {
        await _fetchUserData(); // Recarga los datos
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente.')),
        );
      } else {
        throw Exception('Error al actualizar el perfil: ${response.body}');
      }
    } catch (e) {
      print('Error al actualizar el perfil: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  if (_formKey.currentState?.validate() ?? false) {
                    _editUser();
                  }
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing)
                ...[
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: 'Correo Electrónico'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Por favor ingrese un correo válido';
                      }
                      return null;
                    },
                  ),
                ]
              else
                ...[
                  Text('Nombre: ${_user?.nombreUsuario ?? 'No disponible'}'),
                  const SizedBox(height: 10),
                  Text('Correo Electrónico: ${_user?.correoElectronicoUsuario ?? 'No disponible'}'),
                  const SizedBox(height: 10),
                  Text('Rol: ${_user?.rol?.nombreRol ?? 'No asignado'}'),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
