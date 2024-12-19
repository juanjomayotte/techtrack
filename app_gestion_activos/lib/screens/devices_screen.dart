import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/services/auth_service.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/EstadoDispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/Usuario.dart';
import 'package:app_gestion_activos/models/Rol.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:intl/intl.dart'; // Import the intl package

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  _DevicesScreenState createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  List<Dispositivo> _devices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
  }

  Future<void> _fetchDevices() async {
    try {
      final serviceDevices = await InventoryService.fetchDispositivos();

      List<Dispositivo> modelDevices = [];

      for (var serviceDevice in serviceDevices) {
        ModeloDispositivo? modeloDispositivo;
        EstadoDispositivo? estadoDispositivo;
        Software? software;
        Usuario? usuario;
        TipoDispositivo? tipoDispositivo;

        if (serviceDevice.modeloDispositivoId != null) {
          modeloDispositivo = await InventoryService.fetchModeloDispositivoById(serviceDevice.modeloDispositivoId!)
              .catchError((e) => null);
        }

        if (serviceDevice.estadoDispositivoId != null) {
          estadoDispositivo = await InventoryService.fetchEstadoDispositivoById(serviceDevice.estadoDispositivoId!)
              .catchError((e) => null);
        }

        if (serviceDevice.softwareInstaladoId != null) {
          software = await InventoryService.fetchSoftwareById(serviceDevice.softwareInstaladoId!)
              .catchError((e) => null);
        }

        if (serviceDevice.usuarioAsignadoId != null) {
          final userResponse = await AuthService.getUserDataById(serviceDevice.usuarioAsignadoId!)
              .catchError((e) => null);

          if (userResponse != null) {
            usuario = Usuario(
              idUsuario: userResponse.idUsuario,
              nombreUsuario: userResponse.nombreUsuario,
              correoElectronicoUsuario: userResponse.correoElectronicoUsuario,
              rolId: userResponse.rolId ?? 0,
              rol: userResponse.rol != null ? Rol.fromJson(userResponse.rol!) : null,
            );
          }
        }

        if (modeloDispositivo?.tipoDispositivoId != null) {
          tipoDispositivo = await InventoryService.fetchTipoDispositivoById(modeloDispositivo!.tipoDispositivoId!)
              .catchError((e) => null);
        }

        final modelDevice = Dispositivo(
          idDispositivo: serviceDevice.idDispositivo,
          numeroSerieDispositivo: serviceDevice.numeroSerieDispositivo,
          ubicacionDispositivo: serviceDevice.ubicacionDispositivo,
          fechaAdquisicionDispositivo: serviceDevice.fechaAdquisicionDispositivo,
          modeloDispositivoId: serviceDevice.modeloDispositivoId,
          modeloDispositivo: modeloDispositivo,
          estadoDispositivoId: serviceDevice.estadoDispositivoId,
          estadoDispositivo: estadoDispositivo,
          softwareInstaladoId: serviceDevice.softwareInstaladoId,
          softwareInstalado: software,
          usuarioAsignadoId: serviceDevice.usuarioAsignadoId,
          usuarioAsignado: usuario,
          dispositivoCreadoPorId: serviceDevice.dispositivoCreadoPorId,
          tipoDispositivo: tipoDispositivo,
        );
        modelDevices.add(modelDevice);
      }

      setState(() {
        _devices = modelDevices;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching devices: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDevice(int deviceId) async {
    try {
      await InventoryService.deleteDispositivo(deviceId);
      setState(() {
        _devices.removeWhere((device) => device.idDispositivo == deviceId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dispositivo eliminado con éxito')),
      );
    } catch (e) {
      print('Error deleting device: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar dispositivo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configuración de Dispositivos',
            onPressed: () {
              Navigator.pushNamed(context, '/device_settings');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _devices.isEmpty
          ? const Center(child: Text("No hay dispositivos"))
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (context, index) {
          final device = _devices[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(device.numeroSerieDispositivo),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modelo: ${device.modeloDispositivo?.nombreModeloDispositivo ?? "N/A"}'),
                  Text('Tipo Disp.: ${device.tipoDispositivo?.nombreTipoDispositivo ?? "N/A"}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/edit_device',
                        arguments: device,
                      );
                      // Actualizar si hubo cambios
                      if (result == true) {
                        _fetchDevices();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteDevice(device.idDispositivo);
                    },
                  ),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(device.numeroSerieDispositivo),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ubicación: ${device.ubicacionDispositivo ?? "N/A"}'),
                        Text('Fecha de adquisición: ${device.fechaAdquisicionDispositivo != null ? DateFormat('yyyy-MM-dd').format(device.fechaAdquisicionDispositivo!) : "N/A"}'),
                        Text('Modelo: ${device.modeloDispositivo?.nombreModeloDispositivo ?? "N/A"}'),
                        Text('Tipo Disp.: ${device.tipoDispositivo?.nombreTipoDispositivo ?? "N/A"}'),
                        Text('Estado: ${device.estadoDispositivo?.nombreEstadoDispositivo ?? "N/A"}'),
                        Text('Software: ${device.softwareInstalado?.nombreSoftware ?? "N/A"}'),
                        Text('Usuario Asignado: ${device.usuarioAsignado?.nombreUsuario ?? "N/A"}'),
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
          final result = await Navigator.pushNamed(context, '/add_device');

          // Actualizar si hubo cambios
          if (result == true) {
            _fetchDevices();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}