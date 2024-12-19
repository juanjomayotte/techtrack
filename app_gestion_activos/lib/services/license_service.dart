import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Licencia.dart';
import '../models/TipoLicencia.dart';
import '../models/Software.dart';
import 'api_service.dart'; // Import ApiService

class LicenseService {
  final String _baseUrl = '${ApiService.licenseBaseUrl}/api/licencias';
  final String _baseUrlTipoLicencia =
      '${ApiService.licenseBaseUrl}/api/tipos-licencia';

  // Define the software URL using inventoryBaseUrl
  final String _baseUrlSoftware = '${ApiService.inventoryBaseUrl}/api/software';

  // services/license_service.dart

  Future<List<Licencia>> fetchLicencias() async {
    final url = Uri.parse(_baseUrl);
    print('Fetching Licencias from: $url');  // Log de la URL de la solicitud

    try {
      final response = await http.get(url);
      print('Response Status: ${response.statusCode}');  // Log del código de estado de la respuesta

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('Response Body (Licencias): ${response.body}');  // Log del cuerpo de la respuesta

        List<Licencia> licencias =
        jsonList.map((json) => Licencia.fromJson(json)).toList();
        print('Licencias fetched: $licencias');  // Log de las licencias obtenidas

        for (var licencia in licencias) {
          print('Processing Licencia: ${licencia.idLicencia}');  // Log de cada licencia procesada
          if (licencia.tipoLicenciaId != null) {
            print('Fetching TipoLicencia for ID: ${licencia.tipoLicenciaId}');
            final tipoLicencia =
            await fetchTipoLicenciaById(licencia.tipoLicenciaId);
            licencia.tipoLicencia = tipoLicencia;
            print('Fetched TipoLicencia: $tipoLicencia');
          }
          if (licencia.softwareId != null) {
            print('Fetching Software for ID: ${licencia.softwareId}');
            final software = await fetchSoftwareById(licencia.softwareId);
            licencia.software = software;
            print('Fetched Software: $software');
          }
        }

        return licencias;
      } else {
        print('Failed to load Licencias. Status Code: ${response.statusCode}');
        throw Exception('Failed to load licenses');
      }
    } catch (e) {
      print('Error in fetchLicencias: $e');  // Log de cualquier error
      rethrow;
    }
  }

  Future<Licencia> updateLicencia(int idLicencia, Licencia licencia) async {
    final url = Uri.parse('$_baseUrl/$idLicencia');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(licencia.toJson());

    print("--- API Request: PUT $url ---");
    print("Request Headers: $headers");
    print("Request Body: $body");

    try {
      final response = await http.put(url, headers: headers, body: body);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        if (decodedData != null && decodedData['licencia'] != null) {
          return Licencia.fromJson(decodedData['licencia']);
        } else {
          throw Exception(
              'Respuesta del servidor no tiene la estructura esperada.');
        }
      } else {
        throw Exception('Failed to update license: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en updateLicencia $e');
      rethrow;
    }
  }

  Future<void> deleteLicencia(int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete license');
    }
  }

  Future<TipoLicencia?> fetchTipoLicenciaById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrlTipoLicencia/$id'));
      if (response.statusCode == 200) {
        print('Response body tipo licencia: ${response.body}');
        return TipoLicencia.fromJson(json.decode(response.body));
      } else {
        print('Error en fetchTipoLicenciaById: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return null;
    }
  }

  Future<Software?> fetchSoftwareById(int id) async {
    return fetchSoftwareInstanceById(id);
  }

  Future<Software?> fetchSoftwareInstanceById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrlSoftware/$id'));
      if (response.statusCode == 200) {
        print('Response body software: ${response.body}');
        return Software.fromJson(json.decode(response.body));
      } else {
        print('Error in fetchSoftwareById: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al hacer la solicitud: $e');
      return null;
    }
  }

  Future<List<TipoLicencia>> fetchTiposLicencia() async {
    final url = Uri.parse(_baseUrlTipoLicencia);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => TipoLicencia.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load license types');
    }
  }

  Future<void> deleteTipoLicencia(int id) async {
    final url = Uri.parse('$_baseUrlTipoLicencia/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete license type');
    }
  }

  Future<Licencia> createLicencia(Licencia newLicense) async {
    final url = Uri.parse(_baseUrl);
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(newLicense.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);
      if (decodedData != null && decodedData['licencia'] != null) {
        return Licencia.fromJson(decodedData['licencia']);
      } else {
        throw Exception(
            'Respuesta del servidor no tiene la estructura esperada.');
      }
    } else {
      throw Exception('Failed to create license');
    }
  }

  Future<TipoLicencia> createTipoLicencia(TipoLicencia newLicenseType) async {
    final url = Uri.parse(_baseUrlTipoLicencia);
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(newLicenseType.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);
      if (decodedData != null && decodedData['tipoLicencia'] != null) {
        return TipoLicencia.fromJson(decodedData['tipoLicencia']);
      } else {
        throw Exception(
            'Respuesta del servidor no tiene la estructura esperada.');
      }
    } else {
      throw Exception('Failed to create license type');
    }
  }

  Future<TipoLicencia> updateTipoLicencia(
      int idTipoLicencia, TipoLicencia editedLicenseType) async {
    final url = Uri.parse('$_baseUrlTipoLicencia/$idTipoLicencia');
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    final body = jsonEncode(editedLicenseType.toJson());

    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData != null && decodedData['tipoLicencia'] != null) {
        return TipoLicencia.fromJson(decodedData['tipoLicencia']);
      } else {
        throw Exception(
            'Respuesta del servidor no tiene la estructura esperada.');
      }
    } else {
      throw Exception('Failed to update license type');
    }
  }
  // New method to fetch all softwares
  Future<List<Software>> fetchSoftwares() async {
    final url = Uri.parse(_baseUrlSoftware);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Software.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load softwares');
    }
  }
}