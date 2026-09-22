import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/categoria.dart';
import 'auth_service.dart';

class CategoriasService {
	final String baseUrl = Environment.apiUrl;
	final AuthService _authService = AuthService();

	Future<List<Categoria>> getCategorias() async {
		final response = await http.get(Uri.parse('$baseUrl/categorias'));
		if (response.statusCode == 200) {
			final data = jsonDecode(response.body) as List;
			return data.map((item) => Categoria.fromJson(item)).toList();
		}
		throw Exception('Error al cargar categorías');
	}

	Future<bool> cambiarEstado(int id) async {
		final token = await _authService.getToken();
		final response = await http.patch(
			Uri.parse('$baseUrl/categorias/$id/estado'),
			headers: {
				'Content-Type': 'application/json',
				if (token != null) 'Authorization': 'Bearer $token',
			},
		);
		return response.statusCode == 200;
	}

	Future<bool> eliminarCategoria(int id) async {
		final token = await _authService.getToken();
		final response = await http.delete(
			Uri.parse('$baseUrl/categorias/$id'),
			headers: {
				'Content-Type': 'application/json',
				if (token != null) 'Authorization': 'Bearer $token',
			},
		);
		return response.statusCode == 200;
	}
}
