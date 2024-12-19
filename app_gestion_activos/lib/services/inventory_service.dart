//services/inventory_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/EstadoDispositivo.dart';
import 'package:app_gestion_activos/models/Mantenimiento.dart';
import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart';

// =============================================
// Servicio de Inventario (InventoryService)
// =============================================
class InventoryService {
  // ---------------------------------------------
  // Métodos para Dispositivos
  // ---------------------------------------------
  static Future<List<Dispositivo>> fetchDispositivos() async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/dispositivos'));
    if (response.statusCode == 200) {
      print('API Response Body: ${response.body}');
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Dispositivo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load dispositivos');
    }
  }

  static Future<Dispositivo> fetchDispositivoById(int id) async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/dispositivos/$id'));
    if (response.statusCode == 200) {
      return Dispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dispositivo');
    }
  }

  static Future<Dispositivo> createDispositivo(Dispositivo dispositivo) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/dispositivos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dispositivo.toJson()),
    );
    if (response.statusCode == 201) {
      return Dispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create dispositivo');
    }
  }

  static Future<Dispositivo> updateDispositivo(Dispositivo dispositivo) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/dispositivos/${dispositivo.idDispositivo}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dispositivo.toJson()),
    );
    if (response.statusCode == 200) {
      return Dispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update dispositivo');
    }
  }

  static Future<void> deleteDispositivo(int id) async {
    try {
      // Get the device to obtain the model id before deleting
      final dispositivo = await fetchDispositivoById(id);

      final response = await http.delete(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/dispositivos/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        //Actualizar la cantidad en inventario del modelo
        if (dispositivo.modeloDispositivoId != null) {
          final modelo = await fetchModeloDispositivoById(
              dispositivo.modeloDispositivoId!);
          await updateModeloDispositivo(modelo.copyWith(
              cantidadEnInventario: modelo.cantidadEnInventario - 1));
        }
      } else {
        throw Exception('Failed to delete dispositivo');
      }
    } catch (e) {
      print('Error deleting dispositivo: $e');
      throw Exception('Failed to delete dispositivo');
    }
  }

  // ---------------------------------------------
  // Métodos para Estados de Dispositivos
  // ---------------------------------------------
  static Future<List<EstadoDispositivo>> fetchEstadosDispositivo() async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/estadosdispositivos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => EstadoDispositivo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load estados de dispositivos');
    }
  }

  static Future<EstadoDispositivo> fetchEstadoDispositivoById(int id) async {
    final response = await http.get(Uri.parse(
        '${ApiService.inventoryBaseUrl}/api/estadosdispositivos/$id'));
    if (response.statusCode == 200) {
      return EstadoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load estado de dispositivo');
    }
  }

  static Future<EstadoDispositivo> createEstadoDispositivo(
      EstadoDispositivo estadoDispositivo) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/estadosdispositivos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(estadoDispositivo.toJson()),
    );
    if (response.statusCode == 201) {
      return EstadoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create estado de dispositivo');
    }
  }

  static Future<EstadoDispositivo> updateEstadoDispositivo(
      EstadoDispositivo estadoDispositivo) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/estadosdispositivos/${estadoDispositivo.idEstadoDispositivo}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(estadoDispositivo.toJson()),
    );
    if (response.statusCode == 200) {
      return EstadoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update estado de dispositivo');
    }
  }

  static Future<void> deleteEstadoDispositivo(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/estadosdispositivos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete estado de dispositivo');
    }
  }

  // ---------------------------------------------
  // Métodos para Modelos de Dispositivos
  // ---------------------------------------------
  static Future<List<ModeloDispositivo>> fetchModelosDispositivo() async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/modelosdispositivos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ModeloDispositivo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load modelos de dispositivos');
    }
  }

  static Future<ModeloDispositivo> fetchModeloDispositivoById(int id) async {
    final response = await http.get(Uri.parse(
        '${ApiService.inventoryBaseUrl}/api/modelosdispositivos/$id'));
    if (response.statusCode == 200) {
      return ModeloDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load modelo de dispositivo');
    }
  }

  static Future<ModeloDispositivo> createModeloDispositivo(
      ModeloDispositivo modeloDispositivo) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/modelosdispositivos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(modeloDispositivo.toJson()),
    );
    if (response.statusCode == 201) {
      return ModeloDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create modelo de dispositivo');
    }
  }

  static Future<ModeloDispositivo> updateModeloDispositivo(
      ModeloDispositivo modeloDispositivo) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/modelosdispositivos/${modeloDispositivo.idModeloDispositivo}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(modeloDispositivo.toJson()),
    );

    if (response.statusCode == 200) {
      try {
        return ModeloDispositivo.fromJson(json.decode(response.body));
      } catch (e) {
        return modeloDispositivo; // Retornamos el modelo sin cambios si falla el parseo
      }
    } else {
      throw Exception('Failed to update modelo de dispositivo');
    }
  }

  static Future<void> deleteModeloDispositivo(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/modelosdispositivos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete modelo de dispositivo');
    }
  }

  // ---------------------------------------------
  // Métodos para Mantenimiento
  // ---------------------------------------------
  static Future<List<Mantenimiento>> fetchMantenimientos() async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Mantenimiento.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load mantenimientos');
    }
  }

  static Future<Mantenimiento> fetchMantenimientoById(int id) async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos/$id'));
    if (response.statusCode == 200) {
      return Mantenimiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load mantenimiento');
    }
  }

  static Future<Mantenimiento> createMantenimiento(
      Mantenimiento mantenimiento) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(mantenimiento.toJson()),
    );
    if (response.statusCode == 201) {
      return Mantenimiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create mantenimiento');
    }
  }

  static Future<Mantenimiento> updateMantenimiento(
      Mantenimiento mantenimiento) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/mantenimientos/${mantenimiento.idMantenimiento}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(mantenimiento.toJson()),
    );
    if (response.statusCode == 200) {
      return Mantenimiento.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update mantenimiento');
    }
  }

  static Future<void> deleteMantenimiento(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/mantenimientos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete mantenimiento');
    }
  }

  // ---------------------------------------------
  // Métodos para Tipos de Dispositivos
  // ---------------------------------------------
  static Future<List<TipoDispositivo>> fetchTiposDispositivos() async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposdispositivos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TipoDispositivo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tipos de dispositivos');
    }
  }

  static Future<TipoDispositivo> fetchTipoDispositivoById(int id) async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposdispositivos/$id'));
    if (response.statusCode == 200) {
      return TipoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tipo de dispositivo');
    }
  }

  static Future<TipoDispositivo> createTipoDispositivo(
      TipoDispositivo tipoDispositivo) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposdispositivos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tipoDispositivo.toJson()),
    );
    if (response.statusCode == 201) {
      return TipoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create tipo de dispositivo');
    }
  }

  static Future<TipoDispositivo> updateTipoDispositivo(
      TipoDispositivo tipoDispositivo) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/tiposdispositivos/${tipoDispositivo.idTipoDispositivo}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tipoDispositivo.toJson()),
    );
    if (response.statusCode == 200) {
      return TipoDispositivo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tipo de dispositivo');
    }
  }

  static Future<void> deleteTipoDispositivo(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/tiposdispositivos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tipo de dispositivo');
    }
  }

  // ---------------------------------------------
  // Métodos para Tipos de Software
  // ---------------------------------------------
  static Future<List<TipoSoftware>> fetchTiposSoftware() async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tipossoftware'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TipoSoftware.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tipos de software');
    }
  }


  static Future<TipoSoftware> fetchTipoSoftwareById(int id) async {
    final response = await http.get(
        Uri.parse('${ApiService.inventoryBaseUrl}/api/tipossoftware/$id'));
    if (response.statusCode == 200) {
      return TipoSoftware.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tipo de software');
    }
  }

  static Future<TipoSoftware> createTipoSoftware(
      TipoSoftware tipoSoftware) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/tipossoftware'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tipoSoftware.toJson()),
    );
    if (response.statusCode == 201) {
      return TipoSoftware.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create tipo de software');
    }
  }

  static Future<TipoSoftware> updateTipoSoftware(
      TipoSoftware tipoSoftware) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/tipossoftware/${tipoSoftware.idTipoSoftware}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tipoSoftware.toJson()),
    );
    if (response.statusCode == 200) {
      return TipoSoftware.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update tipo de software');
    }
  }

  static Future<void> deleteTipoSoftware(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/tipossoftware/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete tipo de software');
    }
  }

  // ---------------------------------------------
  // Métodos para Software
  // ---------------------------------------------
  static Future<List<Software>> fetchSoftwares() async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/software'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Software.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load softwares');
    }
  }

  static Future<Software> fetchSoftwareById(int id) async {
    final response = await http
        .get(Uri.parse('${ApiService.inventoryBaseUrl}/api/software/$id'));
    if (response.statusCode == 200) {
      final software = Software.fromJson(json.decode(response.body));
      if (software.tipoSoftwareId != null) {
        final tipoSoftware =
        await fetchTipoSoftwareById(software.tipoSoftwareId!);
        return software.copyWith(tipoSoftware: tipoSoftware);
      }
      return software;
    } else {
      throw Exception('Failed to load software');
    }
  }

  static Future<Software> createSoftware(Software software) async {
    final response = await http.post(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/software'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(software.toJson()),
    );
    if (response.statusCode == 201) {
      return Software.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create software');
    }
  }


  static Future<Software> updateSoftware(Software software) async {
    final response = await http.put(
      Uri.parse(
          '${ApiService.inventoryBaseUrl}/api/software/${software.idSoftware}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(software.toJson()),
    );

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        try {
          return Software.fromJson(json.decode(response.body));
        } catch (e) {
          print('Error decoding response: $e');
          return software; // Return original software object in case of decoding error
        }
      }
      return software; // Return the software object if content type is not application/json
    } else {
      print(
          'Error updating software: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to update software');
    }
  }

  static Future<void> deleteSoftware(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiService.inventoryBaseUrl}/api/software/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete software');
    }
  }
}
