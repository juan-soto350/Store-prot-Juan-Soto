import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/environment.dart';
import '../models/usuario.dart';

/// Se lanza cuando la app no puede comunicarse con la API: servidor apagado,
/// IP mal configurada, firewall bloqueando el puerto o el dispositivo sin red.
class ApiConnectionException implements Exception {
  final String message;

  const ApiConnectionException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final String baseUrl = Environment.apiUrl;
  final _storage = const FlutterSecureStorage();

  // Tiempo máximo de espera para que la UI no se quede colgada para siempre
  static const Duration _timeout = Duration(seconds: 10);

  // POST: Autenticar e ingresar
  Future login(String email, String password) async {
    final http.Response response;

    // Solo se capturan fallos de red; los de parseo o almacenamiento se propagan
    try {
      response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const ApiConnectionException(
        'El servidor tardó demasiado en responder. Inténtalo de nuevo.',
      );
    } catch (_) {
      throw ApiConnectionException(
        'No se pudo conectar con el servidor ($baseUrl). Verifica que la API '
        'esté encendida, que la IP sea correcta y que estés en la misma red.',
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Persistir el Token de manera cifrada en Hardware
      await _storage.write(key: 'jwt_token', value: data['token']);
      return true;
    }
    return false;
  }

  // GET: Obtener Perfil del Usuario Logueado inyectando JWT
  Future getPerfil() async {
    final token = await getToken();
    if (token == null) return null;

    final http.Response response;
    try {
      response = await http
          .get(
            Uri.parse('$baseUrl/auth/perfil'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(_timeout);
    } catch (_) {
      // Sin conexión se trata como sesión no válida, no como fallo fatal
      return null;
    }

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future getToken() async => await _storage.read(key: 'jwt_token');
  Future logout() async => await _storage.delete(key: 'jwt_token');
}
                