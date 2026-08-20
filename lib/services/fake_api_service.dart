import 'dart:convert';
import '../models/producto.dart';

class FakeApiService {
  // SIMULACIÓN DE RESPUESTA JSON DESDE SERVIDOR
  final String _jsonResponse = '''
  [
    {"id": "1", "nombre": "Teclado Mecánico RGB", "precio": 89.99, "categoria": "Accesorios"},
    {"id": "2", "nombre": "Audífonos Noise Cancelling", "precio": 120.00, "categoria": "Audio"},
    {"id": "3", "nombre": "Smartphone Pro X", "precio": 899.00, "categoria": "Móviles"},
    {"id": "4", "nombre": "Mouse Inalámbrico Ergonómico", "precio": 45.50, "categoria": "Accesorios"},
    {"id": "5", "nombre": "Monitor Curvo 27 pulgadas", "precio": 349.99, "categoria": "Pantallas"},
    {"id": "6", "nombre": "Parlante Bluetooth Portátil", "precio": 65.00, "categoria": "Audio"},
    {"id": "7", "nombre": "Tablet 10 pulgadas", "precio": 299.00, "categoria": "Móviles"},
    {"id": "8", "nombre": "Cargador Rápido USB-C 65W", "precio": 25.99, "categoria": "Accesorios"},
    {"id": "9", "nombre": "Webcam Full HD", "precio": 55.00, "categoria": "Accesorios"},
    {"id": "10", "nombre": "Smartwatch Fitness", "precio": 149.99, "categoria": "Móviles"}
  ]
  ''';

  // MÉTODO ASÍNCRONO CON RETARDO DE RED
  Future<List<Producto>> obtenerProductos() async {
    // Simular latencia de red de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    // Decodificar String JSON a List<dynamic>
    final List<dynamic> listJson = jsonDecode(_jsonResponse);

    // Mapear cada elemento a un objeto Producto
    return listJson.map((item) => Producto.fromJson(item)).toList();
  }
}