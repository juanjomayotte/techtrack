// lib/services/contract_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:app_gestion_activos/models/Contrato.dart';
import 'package:app_gestion_activos/models/TipoContrato.dart';


class ContractService {

  // Helper function for making API requests
  static Future<T> _makeApiRequest<T>(
      String url,
      String method, {
        Map<String, String>? headers,
        dynamic body,
        T Function(Map<String, dynamic>)? fromJson,
        T Function(List<dynamic>)? fromJsonList,
      }) async {
    final uri = Uri.parse(url);

    final requestHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      ...?headers,
    };

    http.Response response;
    try{
      if (method == 'GET') {
        response = await http.get(uri, headers: requestHeaders);
      }
      else if(method == 'POST'){
        response = await http.post(uri, headers: requestHeaders, body: body != null ? jsonEncode(body) : null);
      }
      else if(method == 'PUT'){
        response = await http.put(uri, headers: requestHeaders, body: body != null ? jsonEncode(body) : null);
      }
      else if(method == 'DELETE'){
        response = await http.delete(uri, headers: requestHeaders);
      }
      else{
        throw Exception('Invalid HTTP method: $method');
      }
      print('--- API Request: $method $url ---');
      print('Request Headers: $requestHeaders');
      if(body != null){
        print('Request Body: ${jsonEncode(body)}');
      }


      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');


      if(response.statusCode >= 200 && response.statusCode < 300){
        if (response.body.isNotEmpty) {
          if (fromJson != null) {
            return fromJson(json.decode(response.body));
          }
          if (fromJsonList != null) {
            return fromJsonList(json.decode(response.body));
          }

        }
        return  {} as T; // Return an empty object if no body or json to decode
      }
      else {
        print('Error with Status Code: ${response.statusCode}, ${response.body}');
        throw Exception('Request failed with status code ${response.statusCode}, ${response.body}');
      }

    }  catch (error) {
      print('Error during API Request: $error');
      rethrow;
    }
  }

  // ---------------------------------------------
  // Métodos para Contratos
  // ---------------------------------------------
  static Future<List<Contrato>> fetchContratos() async {
    final response = await http.get(Uri.parse('${ApiService.contractBaseUrl}/api/contratos'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      List<Contrato> contratos = [];
      for (var contratoJson in jsonList) {
        Contrato contrato = Contrato.fromJson(contratoJson);
        if (contrato.tipoContratoId != null) {
          final tipoContrato = await fetchTipoContratoById(contrato.tipoContratoId!);
          contrato = contrato.copyWith(tipoContrato: tipoContrato);
        }
        contratos.add(contrato);
      }
      return contratos;
    } else {
      throw Exception('Failed to load contracts');
    }
  }



  static Future<Contrato> fetchContratoById(int id) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/contratos/$id',
      'GET',
      fromJson: (json) => Contrato.fromJson(json),
    );
  }


  static Future<Contrato> createContrato(Contrato contrato) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/contratos',
      'POST',
      body: contrato.toJson(),
      fromJson: (json) => Contrato.fromJson(json),
    );
  }


  static Future<Contrato> updateContrato(Contrato contrato) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/contratos/${contrato.idContrato}',
      'PUT',
      body: contrato.toJson(),
      fromJson: (json) => Contrato.fromJson(json),
    );

  }
  static Future<void> deleteContrato(int id) async {
    await _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/contratos/$id',
      'DELETE',
    );

  }

  // ---------------------------------------------
  // Métodos para Tipos de Contratos
  // ---------------------------------------------
  static Future<List<TipoContrato>> fetchTiposContrato() async {
    return _makeApiRequest(
        '${ApiService.contractBaseUrl}/api/tipos-contrato',
        'GET',
        fromJsonList: (jsonList) => jsonList.map((json) => TipoContrato.fromJson(json)).toList()
    );
  }


  static Future<TipoContrato> fetchTipoContratoById(int id) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/tipos-contrato/$id',
      'GET',
      fromJson: (json) => TipoContrato.fromJson(json),
    );
  }


  static Future<TipoContrato> createTipoContrato(TipoContrato tipoContrato) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/tipos-contrato',
      'POST',
      body: tipoContrato.toJson(),
      fromJson: (json) => TipoContrato.fromJson(json),
    );
  }


  static Future<TipoContrato> updateTipoContrato(TipoContrato tipoContrato) async {
    return _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/tipos-contrato/${tipoContrato.idTipoContrato}',
      'PUT',
      body: tipoContrato.toJson(),
      fromJson: (json) => TipoContrato.fromJson(json),
    );
  }
  static Future<void> deleteTipoContrato(int id) async {
    await _makeApiRequest(
      '${ApiService.contractBaseUrl}/api/tipos-contrato/$id',
      'DELETE',
    );
  }
}