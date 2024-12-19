//services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_gestion_activos/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =============================================
// Clase que modela la respuesta del login
// =============================================
class LoginResponse {
  final String token;
  final int userId;

  LoginResponse({required this.token, required this.userId});

  // Método para convertir un JSON en un objeto LoginResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userId: json['userId'],   //  <-- Map userId from JSON
    );
  }
}

// =============================================
// Clase que modela la respuesta de un usuario
// =============================================
// services/auth_service.dart
class UserResponse {
  final int idUsuario; // Added idUsuario
  final String nombreUsuario;
  final String correoElectronicoUsuario;
  final int? rolId;
  final Map<String, dynamic>? rol;

  UserResponse({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoElectronicoUsuario,
    this.rolId,
    required this.rol,
  });

  // Método para convertir un JSON en un objeto UserResponse
  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      idUsuario: json['idUsuario'],
      nombreUsuario: json['nombreUsuario'],
      correoElectronicoUsuario: json['correoElectronicoUsuario'],
      rolId: json['rol']?['idRol'], // Extract idRol from the 'rol' Map
      rol: json['rol'] != null ? Map<String, dynamic>.from(json['rol']) : null,
    );
  }

  // Método para convertir un objeto UserResponse en un JSON
  Map<String, dynamic> toJson() => {
    'idUsuario': idUsuario,
    'nombreUsuario': nombreUsuario,
    'correoElectronicoUsuario': correoElectronicoUsuario,
    'rolId': rolId,
    'rol': rol,
  };
}

// =============================================
// Servicio de Autenticación (AuthService)
// =============================================
class AuthService {
  // ---------------------------------------------
  // Método para realizar el login de un usuario
  // ---------------------------------------------
  static Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.authBaseUrl}/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'correoElectronicoUsuario': email,
          'passwordUsuario': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);

        if (jsonBody.containsKey('token') && jsonBody['token'] is String) {
          // Parse token
          final loginResponse = LoginResponse.fromJson(jsonBody);

          // Guardar el token y otros datos en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginResponse.token);

          // Si el ID del usuario está en la respuesta (puedes modificar según tu API)
          if (jsonBody.containsKey('userId')) {
            await prefs.setString('user_id', jsonBody['userId'].toString());
          }

          return loginResponse;
        } else {
          print('Error: Invalid token format in login response');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Error: Incorrect credentials');
        return null;
      } else {
        print('Error during login: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Exception during login: $e');
      throw Exception('Failed to login: $e');
    }
  }
  // ---------------------------------------------
  // Método para obtener datos de un usuario por ID
  // ---------------------------------------------
  static Future<UserResponse?> getUserDataById(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      if (authToken == null) {
        print('Error: Token not found');
        return null;
      }

      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/users/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return UserResponse.fromJson(jsonBody);
      } else {
        print('Error fetching user data: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception fetching user data: $e');
      return null;
    }
  }

  // ---------------------------------------------
  // Método para obtener datos de un usuario
  // ---------------------------------------------
  static Future<UserResponse?> getUserData(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.authBaseUrl}/api/users/$userId'), // Or your correct endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Include the token in the header
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return UserResponse.fromJson(jsonBody);
      } else {
        print('Error fetching user data: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception fetching user data: $e');
      return null;
    }
  }
  // ---------------------------------------------
  // Método para actualizar datos de un usuario
  // ---------------------------------------------
  static Future<UserResponse?> updateProfile(UserResponse updatedUser) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');
      final userId = prefs.getString('user_id');

      if (authToken == null || userId == null) {
        print('Error: Token or User ID not found');
        return null;
      }

      final response = await http.put(
        Uri.parse('${ApiService.authBaseUrl}/api/users/$userId'), // Your update endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final Map<String, dynamic> jsonBody = response.statusCode == 204 ? {} : jsonDecode(response.body);
        if (jsonBody.isNotEmpty) {
          final updatedUserData = UserResponse.fromJson(jsonBody);
        }
        return UserResponse.fromJson(jsonBody);

      } else {
        print('Error updating profile: ${response.statusCode} - ${response.body}');
        return null;

      }
    } catch (e) {
      print('Exception updating profile: $e');
      return null; // Or rethrow the exception:  rethrow;
    }
  }

  // ---------------------------------------------
  // Método para obtener datos de usuario almacenados en SharedPreferences
  // ---------------------------------------------
  static Future<UserResponse?> fetchUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');
      final userId = prefs.getString('user_id');

      if (authToken == null || userId == null) {
        print('Error: Token or User ID not found in SharedPreferences');
        return null;
      }

      return await getUserData(userId, authToken);
    } catch (e) {
      print('Exception fetching user data: $e');
      rethrow; // Re-throw the exception to be handled higher up
    }
  }

  // ---------------------------------------------
  // Método para realizar logout del usuario
  // ---------------------------------------------
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos almacenados
  }
}