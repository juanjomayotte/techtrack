import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_gestion_activos/screens/inventory/add_device_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_device_screen.dart';
import 'package:app_gestion_activos/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/users_screen.dart';
import 'screens/users/add_user.dart';
import 'screens/users/edit_user.dart';
import 'screens/roles_screen.dart';
import 'package:app_gestion_activos/screens/roles/add_role_screen.dart';
import 'package:app_gestion_activos/screens/roles/edit_role_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_gestion_activos/models/Usuario.dart';
import 'package:app_gestion_activos/models/Rol.dart';
import 'package:app_gestion_activos/screens/inventory_screen.dart';
import 'package:app_gestion_activos/screens/devices_screen.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart';
import 'package:app_gestion_activos/screens/device_settings_screen.dart';
import 'package:app_gestion_activos/screens/device_models_screen.dart';
import 'package:app_gestion_activos/screens/device_types_screen.dart';
import 'package:app_gestion_activos/screens/inventory/add_device_model_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_device_model_screen.dart';
import 'package:app_gestion_activos/screens/inventory/add_device_type_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_device_type_screen.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:app_gestion_activos/screens/software_screen.dart';
import 'package:app_gestion_activos/screens/software_settings_screen.dart';
import 'package:app_gestion_activos/screens/inventory/add_software_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_software_screen.dart';
import 'package:app_gestion_activos/screens/inventory/add_software_type_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_software_type_screen.dart';
import 'package:app_gestion_activos/models/Mantenimiento.dart';
import 'package:app_gestion_activos/screens/mantenimiento_screen.dart';
import 'package:app_gestion_activos/screens/inventory/add_mantenimiento_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_mantenimiento_screen.dart';
import 'package:app_gestion_activos/screens/contracts_screen.dart';
import 'package:app_gestion_activos/screens/contract_types_screen.dart';
import 'package:app_gestion_activos/screens/contracts/add_contract_screen.dart';
import 'package:app_gestion_activos/screens/contracts/edit_contract_screen.dart';
import 'package:app_gestion_activos/screens/contracts/add_contract_type_screen.dart';
import 'package:app_gestion_activos/screens/contracts/edit_contract_type_screen.dart';
import 'package:app_gestion_activos/screens/contract_settings_screen.dart';
import 'package:app_gestion_activos/models/Contrato.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';
import 'package:app_gestion_activos/screens/license_screen.dart';
import 'package:app_gestion_activos/screens/license_settings_screen.dart';
import 'package:app_gestion_activos/screens/license/add_license_screen.dart';
import 'package:app_gestion_activos/screens/license/edit_license_screen.dart';
import 'package:app_gestion_activos/screens/license/add_license_type_screen.dart';
import 'package:app_gestion_activos/screens/license/edit_license_type_screen.dart';
import 'package:app_gestion_activos/models/Licencia.dart'; // Import Licencia
import 'package:app_gestion_activos/models/TipoLicencia.dart'; // Import TipoLicencia

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  final authToken = prefs.getString('auth_token');
  runApp(MyApp(authToken: authToken));
}

class MyApp extends StatelessWidget {
  final String? authToken;
  MyApp({super.key, this.authToken});

  final Map<String, WidgetBuilder> routes = {
    '/': (context) => const LoginScreen(), // Ruta inicial
    '/dashboard': (context) => const DashboardScreen(),
    '/profile': (context) => const ProfileScreen(), // Ruta de perfil
    '/users': (context) => const UsersScreen(),
    '/add_user': (context) => const AddUserScreen(),
    '/edit_user': (context) => EditUserScreen(
      user: ModalRoute.of(context)!.settings.arguments as Usuario,
    ),
    '/roles': (context) => const RolesScreen(),
    '/add_role': (context) => const AddRoleScreen(),
    '/edit_role': (context) => EditRoleScreen(
      rol: ModalRoute.of(context)!.settings.arguments as Rol,
    ),
    '/inventory': (context) => const InventoryScreen(),
    '/devices': (context) => const DevicesScreen(),
    '/add_device': (context) => const AddDeviceScreen(),
    '/edit_device': (context) => EditDeviceScreen(
        device: ModalRoute.of(context)!.settings.arguments as Dispositivo
    ),
    '/device_settings': (context) => const DeviceSettingsScreen(),
    '/device_models': (context) => const DeviceModelsScreen(),
    '/device_types': (context) => const DeviceTypesScreen(),
    '/add_device_model': (context) => const AddDeviceModelScreen(),
    '/edit_device_model': (context) => EditDeviceModelScreen(model: ModalRoute.of(context)!.settings.arguments as ModeloDispositivo),
    '/add_device_type': (context) => const AddDeviceTypeScreen(),
    '/edit_device_type': (context) => EditDeviceTypeScreen(type: ModalRoute.of(context)!.settings.arguments as TipoDispositivo),
    '/software': (context) => const SoftwareScreen(),
    '/add_software': (context) => const AddSoftwareScreen(),
    '/edit_software': (context) => EditSoftwareScreen(
        software: ModalRoute.of(context)!.settings.arguments as Software
    ),
    '/software_settings': (context) => const SoftwareSettingsScreen(),
    '/add_software_type': (context) => const AddSoftwareTypeScreen(),
    '/edit_software_type': (context) => EditSoftwareTypeScreen(type: ModalRoute.of(context)!.settings.arguments as TipoSoftware),
    '/mantenimiento': (context) => const MantenimientoScreen(),
    '/add_mantenimiento': (context) => const AddMantenimientoScreen(),
    '/edit_mantenimiento': (context) => EditMantenimientoScreen(mantenimiento: ModalRoute.of(context)!.settings.arguments as Mantenimiento),
    '/contracts': (context) => const ContractsScreen(),
    '/contract_settings': (context) => const ContractSettingsScreen(),
    '/add_contract': (context) => const AddContractScreen(),
    '/edit_contract': (context) => EditContractScreen(contrato: ModalRoute.of(context)!.settings.arguments as Contrato),
    '/contract_types': (context) => const ContractTypesScreen(),
    '/add_contract_type': (context) => const AddContractTypeScreen(),
    '/edit_contract_type': (context) => EditContractTypeScreen(contractType: ModalRoute.of(context)!.settings.arguments as TipoContrato),
    '/licenses': (context) => LicenseScreen(),
    '/license_settings': (context) => LicenseSettingsScreen(),
    '/add_license': (context) => AddLicenseScreen(),
    '/edit_license': (context) => EditLicenseScreen(license: ModalRoute.of(context)!.settings.arguments as Licencia),
    '/add_license_type': (context) => AddLicenseTypeScreen(),
    '/edit_license_type': (context) => EditLicenseTypeScreen(licenseType: ModalRoute.of(context)!.settings.arguments as TipoLicencia),

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: authToken == null ? '/' : '/dashboard',
      routes: routes,
    );
  }
}