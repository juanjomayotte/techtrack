//screens/roles/add_role_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRoleScreen extends StatefulWidget {
  const AddRoleScreen({Key? key}) : super(key: key);

  @override
  _AddRoleScreenState createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  Future<int> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    print("Shared Preferences Keys: ${prefs.getKeys()}");
    final userId = prefs.getInt('userId'); // Replace 'userId' with your actual key

    if (userId == null) {
      throw Exception("User ID not found. Please log in.");
    }
    return userId;
  }

  final _formKey = GlobalKey<FormState>();
  late String _nombreRol;
  late String _descripcionRol;
  bool _isLoading = false;

  Map<String, dynamic> _formValues = {};

  @override
  void initState() {
    super.initState();
    _formValues = {
      // Permisos para Contratos
      'permisoContratoCreacion': false,
      'permisoContratoEdicion': false,
      'permisoContratoVisualizacion': false,
      'permisoContratoEliminacion': false,

      // Permisos para Tipos de Contratos
      'permisoTipoContratoCreacion': false,
      'permisoTipoContratoEdicion': false,
      'permisoTipoContratoVisualizacion': false,
      'permisoTipoContratoEliminacion': false,

      // Permisos para Licencias
      'permisoLicenciaCreacion': false,
      'permisoLicenciaEdicion': false,
      'permisoLicenciaVisualizacion': false,
      'permisoLicenciaEliminacion': false,

      // Permisos para Tipos de Licencias
      'permisoTipoLicenciaCreacion': false,
      'permisoTipoLicenciaEdicion': false,
      'permisoTipoLicenciaVisualizacion': false,
      'permisoTipoLicenciaEliminacion': false,

      // Permisos para Modelos de Dispositivo
      'permisoModeloDispositivoCreacion': false,
      'permisoModeloDispositivoEdicion': false,
      'permisoModeloDispositivoVisualizacion': false,
      'permisoModeloDispositivoEliminacion': false,

      // Permisos para Dispositivos
      'permisoDispositivoCreacion': false,
      'permisoDispositivoEdicion': false,
      'permisoDispositivoVisualizacion': false,
      'permisoDispositivoEliminacion': false,

      // Permisos para Tipos de Dispositivos
      'permisoTipoDispositivoCreacion': false,
      'permisoTipoDispositivoEdicion': false,
      'permisoTipoDispositivoVisualizacion': false,
      'permisoTipoDispositivoEliminacion': false,

      // Permisos para Software
      'permisoSoftwareCreacion': false,
      'permisoSoftwareEdicion': false,
      'permisoSoftwareVisualizacion': false,
      'permisoSoftwareEliminacion': false,

      // Permisos para Tipos de Software
      'permisoTipoSoftwareCreacion': false,
      'permisoTipoSoftwareEdicion': false,
      'permisoTipoSoftwareVisualizacion': false,
      'permisoTipoSoftwareEliminacion': false,

      // Permisos para Mantenimiento
      'permisoMantenimientoCreacion': false,
      'permisoMantenimientoEdicion': false,
      'permisoMantenimientoVisualizacion': false,
      'permisoMantenimientoEliminacion': false,

      // Permisos para Usuarios
      'permisoUsuarioCreacion': false,
      'permisoUsuarioEdicion': false,
      'permisoUsuarioVisualizacion': false,
      'permisoUsuarioEliminacion': false,

      // Permisos para Roles
      'permisoRolCreacion': false,
      'permisoRolEdicion': false,
      'permisoRolVisualizacion': false,
      'permisoRolEliminacion': false,

      // Permisos para Plataformas
      'permisoPlataformaCreacion': false,
      'permisoPlataformaEdicion': false,
      'permisoPlataformaVisualizacion': false,
      'permisoPlataformaEliminacion': false,

      // Permisos para Estado de Dispositivos
      'permisoEstadoDispositivoCreacion': false,
      'permisoEstadoDispositivoEdicion': false,
      'permisoEstadoDispositivoVisualizacion': false,
      'permisoEstadoDispositivoEliminacion': false,

      // Permisos para Alertas
      'permisoAlertaCreacion': false,
      'permisoAlertaEdicion': false,
      'permisoAlertaVisualizacion': false,
      'permisoAlertaEliminacion': false,
    };
  }

  Future<void> _addRole() async {
    setState(() => _isLoading = true);
    try {
      final int userId = await getCurrentUserId();
      final response = await http.post(
        Uri.parse('${ApiService.authBaseUrl}/api/roles/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer authToken', // Replace with actual token
        },
        body: jsonEncode({
          'nombreRol': _nombreRol,
          'descripcionRol': _descripcionRol,
          'RolCreadoPor': userId,
          ..._formValues,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rol agregado correctamente')),
        );
        Navigator.pop(context, true); // Success
      } else {
        print('Error adding role: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al agregar el rol')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error adding role: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Rol'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre del Rol'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => _nombreRol = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción del Rol'),
                onSaved: (value) => _descripcionRol = value!,
              ),
              // ListView de permisos
              ListView(
                shrinkWrap: true,
                children: [
                  const Padding(
                    padding:  EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child:  Text(
                      'Permisos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.0,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPermissionCard('Contratos', [
                        'permisoContratoCreacion',
                        'permisoContratoEdicion',
                        'permisoContratoVisualizacion',
                        'permisoContratoEliminacion'
                      ]),
                      _buildPermissionCard('Tipos de Contratos', [
                        'permisoTipoContratoCreacion',
                        'permisoTipoContratoEdicion',
                        'permisoTipoContratoVisualizacion',
                        'permisoTipoContratoEliminacion'
                      ]),
                      _buildPermissionCard('Licencias', [
                        'permisoLicenciaCreacion',
                        'permisoLicenciaEdicion',
                        'permisoLicenciaVisualizacion',
                        'permisoLicenciaEliminacion'
                      ]),
                      _buildPermissionCard('Tipos de Licencias', [
                        'permisoTipoLicenciaCreacion',
                        'permisoTipoLicenciaEdicion',
                        'permisoTipoLicenciaVisualizacion',
                        'permisoTipoLicenciaEliminacion'
                      ]),
                      _buildPermissionCard('Modelos de Disp.', [
                        'permisoModeloDispositivoCreacion',
                        'permisoModeloDispositivoEdicion',
                        'permisoModeloDispositivoVisualizacion',
                        'permisoModeloDispositivoEliminacion'
                      ]),
                      _buildPermissionCard('Dispositivos', [
                        'permisoDispositivoCreacion',
                        'permisoDispositivoEdicion',
                        'permisoDispositivoVisualizacion',
                        'permisoDispositivoEliminacion'
                      ]),
                      _buildPermissionCard('Tipos de Dispositivos', [
                        'permisoTipoDispositivoCreacion',
                        'permisoTipoDispositivoEdicion',
                        'permisoTipoDispositivoVisualizacion',
                        'permisoTipoDispositivoEliminacion'
                      ]),
                      _buildPermissionCard('Software', [
                        'permisoSoftwareCreacion',
                        'permisoSoftwareEdicion',
                        'permisoSoftwareVisualizacion',
                        'permisoSoftwareEliminacion'
                      ]),
                      _buildPermissionCard('Tipos de Software', [
                        'permisoTipoSoftwareCreacion',
                        'permisoTipoSoftwareEdicion',
                        'permisoTipoSoftwareVisualizacion',
                        'permisoTipoSoftwareEliminacion'
                      ]),
                      _buildPermissionCard('Mantenimiento', [
                        'permisoMantenimientoCreacion',
                        'permisoMantenimientoEdicion',
                        'permisoMantenimientoVisualizacion',
                        'permisoMantenimientoEliminacion'
                      ]),
                      _buildPermissionCard('Usuarios', [
                        'permisoUsuarioCreacion',
                        'permisoUsuarioEdicion',
                        'permisoUsuarioVisualizacion',
                        'permisoUsuarioEliminacion'
                      ]),
                      _buildPermissionCard('Roles', [
                        'permisoRolCreacion',
                        'permisoRolEdicion',
                        'permisoRolVisualizacion',
                        'permisoRolEliminacion'
                      ]),
                      _buildPermissionCard('Plataformas', [
                        'permisoPlataformaCreacion',
                        'permisoPlataformaEdicion',
                        'permisoPlataformaVisualizacion',
                        'permisoPlataformaEliminacion'
                      ]),
                      _buildPermissionCard('Estado de Dispositivos', [
                        'permisoEstadoDispositivoCreacion',
                        'permisoEstadoDispositivoEdicion',
                        'permisoEstadoDispositivoVisualizacion',
                        'permisoEstadoDispositivoEliminacion'
                      ]),
                      _buildPermissionCard('Alertas', [
                        'permisoAlertaCreacion',
                        'permisoAlertaEdicion',
                        'permisoAlertaVisualizacion',
                        'permisoAlertaEliminacion'
                      ]),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      _addRole();
                    }
                  },
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const SizedBox.shrink(),
                  label: const Text('Guardar Rol'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPermissionCard(String title, List<String> permissions) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: permissions.map((permission) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add horizontal padding
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _formValues[permission] = !_formValues[permission];
                          });
                        },
                        child: _buildPermissionIcon(permission),
                      )
                  );
                }).toList()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionIcon(String permission) {
    final bool isEnabled = _formValues[permission] ?? false;
    Color iconColor;

    switch (permission) {
      case 'permisoContratoCreacion':
      case 'permisoTipoContratoCreacion':
      case 'permisoLicenciaCreacion':
      case 'permisoTipoLicenciaCreacion':
      case 'permisoModeloDispositivoCreacion':
      case 'permisoDispositivoCreacion':
      case 'permisoTipoDispositivoCreacion':
      case 'permisoSoftwareCreacion':
      case 'permisoTipoSoftwareCreacion':
      case 'permisoMantenimientoCreacion':
      case 'permisoUsuarioCreacion':
      case 'permisoRolCreacion':
      case 'permisoPlataformaCreacion':
      case 'permisoEstadoDispositivoCreacion':
      case 'permisoAlertaCreacion':

        iconColor = isEnabled ? Colors.green : Colors.red;
        return Icon(Icons.add, color: iconColor);

      case 'permisoContratoEdicion':
      case 'permisoTipoContratoEdicion':
      case 'permisoLicenciaEdicion':
      case 'permisoTipoLicenciaEdicion':
      case 'permisoModeloDispositivoEdicion':
      case 'permisoDispositivoEdicion':
      case 'permisoTipoDispositivoEdicion':
      case 'permisoSoftwareEdicion':
      case 'permisoTipoSoftwareEdicion':
      case 'permisoMantenimientoEdicion':
      case 'permisoUsuarioEdicion':
      case 'permisoRolEdicion':
      case 'permisoPlataformaEdicion':
      case 'permisoEstadoDispositivoEdicion':
      case 'permisoAlertaEdicion':
        iconColor = isEnabled ? Colors.green : Colors.red;
        return Icon(Icons.edit, color: iconColor);
      case 'permisoContratoVisualizacion':
      case 'permisoTipoContratoVisualizacion':
      case 'permisoLicenciaVisualizacion':
      case 'permisoTipoLicenciaVisualizacion':
      case 'permisoModeloDispositivoVisualizacion':
      case 'permisoDispositivoVisualizacion':
      case 'permisoTipoDispositivoVisualizacion':
      case 'permisoSoftwareVisualizacion':
      case 'permisoTipoSoftwareVisualizacion':
      case 'permisoMantenimientoVisualizacion':
      case 'permisoUsuarioVisualizacion':
      case 'permisoRolVisualizacion':
      case 'permisoPlataformaVisualizacion':
      case 'permisoEstadoDispositivoVisualizacion':
      case 'permisoAlertaVisualizacion':
        iconColor = isEnabled ? Colors.green : Colors.red;
        return Icon(Icons.visibility, color: iconColor);
      case 'permisoContratoEliminacion':
      case 'permisoTipoContratoEliminacion':
      case 'permisoLicenciaEliminacion':
      case 'permisoTipoLicenciaEliminacion':
      case 'permisoModeloDispositivoEliminacion':
      case 'permisoDispositivoEliminacion':
      case 'permisoTipoDispositivoEliminacion':
      case 'permisoSoftwareEliminacion':
      case 'permisoTipoSoftwareEliminacion':
      case 'permisoMantenimientoEliminacion':
      case 'permisoUsuarioEliminacion':
      case 'permisoRolEliminacion':
      case 'permisoPlataformaEliminacion':
      case 'permisoEstadoDispositivoEliminacion':
      case 'permisoAlertaEliminacion':
        iconColor = isEnabled ? Colors.green : Colors.red;
        return Icon(Icons.delete, color: iconColor);
      default:
        iconColor = isEnabled ? Colors.green : Colors.red;
        return Icon(Icons.help_outline, color: iconColor);
    }
  }
}