import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get apiUrl {
    // Retorna la URL configurada en assets/.env o una fallback por defecto
    return dotenv.env['API_URL'] ?? 'http://localhost:3000/api';
  }
}