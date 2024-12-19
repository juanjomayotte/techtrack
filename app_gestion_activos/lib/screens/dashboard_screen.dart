import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Elimina el token
    Navigator.pushReplacementNamed(context, '/'); // Redirige al login
  }
  Future<void> _navigateToProfile(BuildContext context) async {
    Navigator.pushNamed(context, '/profile');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () {
              _navigateToProfile(context); // Navegar a la sección de Perfil
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await _logout(context); // Cerrar sesión
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2, // Dos columnas
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          _dashboardCard(context, 'Usuarios', Icons.people, '/users'),
          _dashboardCard(context, 'Inventario', Icons.inventory, '/inventory'),
          _dashboardCard(context, 'Contratos', Icons.assignment, '/contracts'),
          _dashboardCard(context, 'Licencias', Icons.description, '/licenses'),
        ],
      ),
    );
  }
  Widget _dashboardCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}