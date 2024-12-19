import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import '../models/Usuario.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Usuario> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _users = jsonBody.map((user) => Usuario.fromJson(user)).toList();
          _isLoading = false;
        });
      } else {
        print('Error fetching users: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.authBaseUrl}/api/users/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _users.removeWhere((user) => user.idUsuario == userId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario eliminado exitosamente')),
        );
      } else {
        print('Error deleting user: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el usuario')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/roles');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.groups_2),
                  SizedBox(width: 4),
                  Text('Roles'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
          ? const Center(child: Text("No hay usuarios"))
          : ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(user.nombreUsuario),
              subtitle: Text(user.correoElectronicoUsuario),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final updatedUser = await Navigator.pushNamed(
                        context,
                        '/edit_user',
                        arguments: user,
                      );
                      if (updatedUser != null) {
                        setState(() {
                          _users[index] = updatedUser as Usuario;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteUser(user.idUsuario);
                    },
                  ),
                ],
              ),
              onTap: () {
                // Show details dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    final userToShow = Usuario.fromJson(user.toJson());
                    return AlertDialog(
                      title: Text(userToShow.nombreUsuario),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              'Correo: ${userToShow.correoElectronicoUsuario}'),
                          Text(
                              'Rol: ${userToShow.rol?.nombreRol ?? 'N/A'}'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add_user');
          if (result != null && result == true) {
            _fetchUsers();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}