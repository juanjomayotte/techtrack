// screens/roles_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart'; // Import your ApiService
import '../models/Rol.dart'; // Import your Rol model

class RolesScreen extends StatefulWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  _RolesScreenState createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  List<Rol> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoles();
  }

  Future<void> _fetchRoles() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/roles/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken', // Replace with how you get the token
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonBody = jsonDecode(response.body);
        setState(() {
          _roles = jsonBody.map((rol) => Rol.fromJson(rol)).toList();
          _isLoading = false;
        });
      } else {
        print('Error fetching roles: ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }


  Future<void> _deleteRol(int rolId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.authBaseUrl}/api/roles/$rolId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken', // Replace with your actual token retrieval method
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _roles.removeWhere((rol) => rol.idRol == rolId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol eliminado correctamente')),
        );
      } else {
        print('Error deleting rol: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el rol')),
        );
      }
    } catch (e) {
      print("Error deleting rol: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el rol: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _roles.isEmpty
          ? const Center(child: Text("No hay roles"))
          : ListView.builder(
        itemCount: _roles.length,
        itemBuilder: (context, index) {
          final rol = _roles[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 4.0,
            child: ListTile(
              title: Text(rol.nombreRol),
              subtitle: Text(rol.descripcionRol ?? ''), // Handle null
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      // Navegar a la pantalla de edición y esperar la respuesta
                      final updatedRol = await Navigator.pushNamed(
                        context,
                        '/edit_role', // Asegúrate de que esta ruta esté definida
                        arguments: rol, // Pasar el rol para editar
                      );
                      if (updatedRol != null) {
                        // Actualizar el rol en la lista después de la edición
                        setState(() {
                          _roles[index] = updatedRol as Rol;


                        });
                      }
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {

                      _deleteRol(rol.idRol);

                    },
                  ),
                ],
              ),


              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(rol.nombreRol),
                    content: Text(rol.descripcionRol ?? ''),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
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
          final result = await Navigator.pushNamed(context, '/add_role');

          if (result != null && result == true) {
            _fetchRoles();
          }

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}