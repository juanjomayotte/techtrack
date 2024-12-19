import 'package:flutter/material.dart';
import 'package:app_gestion_activos/services/inventory_service.dart';
import 'package:app_gestion_activos/models/Mantenimiento.dart';
import 'package:app_gestion_activos/screens/inventory/add_mantenimiento_screen.dart';
import 'package:app_gestion_activos/screens/inventory/edit_mantenimiento_screen.dart';
import 'package:app_gestion_activos/widgets/confirmation_dialog.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/EstadoDispositivo.dart';
import 'package:app_gestion_activos/models/Usuario.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/Rol.dart';
import 'package:app_gestion_activos/services/auth_service.dart';


class MantenimientoScreen extends StatefulWidget {
  const MantenimientoScreen({super.key});

  @override
  _MantenimientoScreenState createState() => _MantenimientoScreenState();
}

class _MantenimientoScreenState extends State<MantenimientoScreen> {
  bool _isLoading = false;
  List<Mantenimiento> _mantenimientos = [];
  List<Dispositivo> _dispositivosPendientes = [];
  List<Software> _softwaresPendientes = [];

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
      final mantenimientos = await InventoryService.fetchMantenimientos();
      final dispositivos = await InventoryService.fetchDispositivos();
      final softwares = await InventoryService.fetchSoftwares();

      List<Mantenimiento> modelMantenimientos = [];

      for (var serviceMantenimiento in mantenimientos) {
        Dispositivo? dispositivo;
        Software? software;

        if (serviceMantenimiento.dispositivoAsociadoMantenimientoId != null) {
          dispositivo = await InventoryService.fetchDispositivoById(serviceMantenimiento.dispositivoAsociadoMantenimientoId!)
              .catchError((e) => null);
        }

        if (serviceMantenimiento.softwareAsociadoMantenimientoId != null) {
          software = await InventoryService.fetchSoftwareById(serviceMantenimiento.softwareAsociadoMantenimientoId!)
              .catchError((e) => null);
        }

        final modelMantenimiento = Mantenimiento(
            idMantenimiento: serviceMantenimiento.idMantenimiento,
            descripcionMantenimiento: serviceMantenimiento.descripcionMantenimiento,
            situacionMantenimiento: serviceMantenimiento.situacionMantenimiento,
            prioridadMantenimiento: serviceMantenimiento.prioridadMantenimiento,
            observacionesMantenimiento: serviceMantenimiento.observacionesMantenimiento,
            softwareAsociadoMantenimientoId: serviceMantenimiento.softwareAsociadoMantenimientoId,
            dispositivoAsociadoMantenimientoId: serviceMantenimiento.dispositivoAsociadoMantenimientoId,
            mantenimientoCreadoPorId: serviceMantenimiento.mantenimientoCreadoPorId,
            dispositivoAsociado: dispositivo,
            softwareAsociado: software
        );
        modelMantenimientos.add(modelMantenimiento);
      }
      List<Dispositivo> dispositivosPendientes = [];

      for (var serviceDevice in dispositivos) {
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


        if(estadoDispositivo?.nombreEstadoDispositivo == 'Pendiente de reparación'){
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
          dispositivosPendientes.add(modelDevice);
        }
      }
      final softwaresPendientes = softwares.where((software) => (software.estaEnListaNegra == true || software.requiereActualizacion == true)).toList();


      setState(() {
        _mantenimientos = modelMantenimientos;
        _dispositivosPendientes = dispositivosPendientes;
        _softwaresPendientes = softwaresPendientes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching mantenimientos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener mantenimientos: $e')),
      );
    }
  }
  Future<void> _deleteMantenimiento(int id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: 'Confirmar Eliminación',
        message: '¿Está seguro de que desea eliminar este mantenimiento?',
      ),
    );

    if(confirmDelete == true){
      try {
        await InventoryService.deleteMantenimiento(id);
        _fetchData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mantenimiento eliminado con éxito')),
        );
      } catch (e) {
        print('Error deleting mantenimiento: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar el mantenimiento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimientos'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            if (_dispositivosPendientes.isEmpty && _softwaresPendientes.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.thumb_up,
                      size: 80.0,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      '¡Todo está muy bien por aquí! ¡Felicitaciones!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ...[
                if(_dispositivosPendientes.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.all(16.0),
                    child: ExpansionTile(
                      title: Text('Dispositivos Pendientes de Reparación (${_dispositivosPendientes.length})', style: TextStyle(fontWeight: FontWeight.bold)),
                      children: _dispositivosPendientes.map((dispositivo) {
                        return ListTile(
                          title: Text(dispositivo.numeroSerieDispositivo),
                          subtitle: Text('Modelo: ${dispositivo.modeloDispositivo?.nombreModeloDispositivo ?? "N/A"}'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    'Dispositivo: ${dispositivo.numeroSerieDispositivo}'
                                ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Ubicación: ${dispositivo.ubicacionDispositivo ?? "N/A"}'),
                                    Text(
                                        'Modelo: ${dispositivo.modeloDispositivo?.nombreModeloDispositivo ?? "N/A"}'
                                    ),
                                    Text(
                                        'Tipo Disp.: ${dispositivo.tipoDispositivo?.nombreTipoDispositivo ?? "N/A"}'
                                    ),
                                    Text(
                                        'Estado: ${dispositivo.estadoDispositivo?.nombreEstadoDispositivo ?? "N/A"}'
                                    ),
                                    Text(
                                        'Software: ${dispositivo.softwareInstalado?.nombreSoftware ?? "N/A"}'
                                    ),
                                    Text(
                                        'Usuario Asignado: ${dispositivo.usuarioAsignado?.nombreUsuario ?? "N/A"}'
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cerrar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Cerramos el diálogo
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddMantenimientoScreen(dispositivo: dispositivo),
                                        ),
                                      ).then((_) => _fetchData());
                                    },
                                    child: const Text('Crear Mantenimiento'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                if(_softwaresPendientes.isNotEmpty)
                  Card(
                    margin: const EdgeInsets.all(16.0),
                    child: ExpansionTile(
                      title: Text('Softwares que requieren atención (${_softwaresPendientes.length})', style: TextStyle(fontWeight: FontWeight.bold)),
                      children: _softwaresPendientes.map((software) {
                        return ListTile(
                            title: Text(software.nombreSoftware),
                            subtitle: Text('Versión: ${software.versionSoftware}'),
                            onTap: (){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(software.nombreSoftware),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Versión: ${software.versionSoftware}'),
                                      Text('Tipo: ${software.tipoSoftware?.nombreTipoSoftware ?? "N/A"}'), // Corrected line
                                      Text('Requiere Actualización: ${software.requiereActualizacion ? "Sí" : "No"}'),
                                      Text('En Lista Negra: ${software.estaEnListaNegra ? "Sí" : "No"}'),
                                      Text('ID de Licencia: ${software.licenciaVinculadaSoftwareId ?? "N/A"}'),
                                      Text('ID de Contrato: ${software.contratoVinculadoSoftwareId ?? "N/A"}'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text('Cerrar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddMantenimientoScreen(software: software)
                                          ),
                                        ).then((_) => _fetchData());
                                      },
                                      child: const Text('Crear Mantenimiento'),
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      }).toList(),
                    ),
                  ),

                if(_mantenimientos.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _mantenimientos.length,
                    itemBuilder: (context, index) {
                      final mantenimiento = _mantenimientos[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        elevation: 4.0,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text('Mantenimiento ID: ${mantenimiento.idMantenimiento}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (mantenimiento.dispositivoAsociado?.numeroSerieDispositivo != null)
                                Text('Dispositivo: ${mantenimiento.dispositivoAsociado!.numeroSerieDispositivo}'),
                              if (mantenimiento.softwareAsociado?.nombreSoftware != null)
                                Text('Software: ${mantenimiento.softwareAsociado!.nombreSoftware}'),
                              Text('Situación: ${mantenimiento.situacionMantenimiento}'),
                              Text('Prioridad: ${mantenimiento.prioridadMantenimiento}'),

                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditMantenimientoScreen(mantenimiento: mantenimiento),
                                    ),
                                  ).then((_) => _fetchData());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteMantenimiento(mantenimiento.idMantenimiento),
                              ),
                            ],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Mantenimiento ID: ${mantenimiento.idMantenimiento}'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (mantenimiento.dispositivoAsociado?.numeroSerieDispositivo != null)
                                      Text('Dispositivo: ${mantenimiento.dispositivoAsociado!.numeroSerieDispositivo}'),
                                    if (mantenimiento.softwareAsociado?.nombreSoftware != null)
                                      Text('Software: ${mantenimiento.softwareAsociado!.nombreSoftware}'),
                                    Text('Descripción: ${mantenimiento.descripcionMantenimiento ?? "N/A"}'),
                                    Text('Situación: ${mantenimiento.situacionMantenimiento}'),
                                    Text('Prioridad: ${mantenimiento.prioridadMantenimiento}'),
                                    Text('Observaciones: ${mantenimiento.observacionesMantenimiento ?? "N/A"}'),

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
              ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMantenimientoScreen()),
          ).then((_) => _fetchData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}