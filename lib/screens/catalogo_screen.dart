import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/fake_api_service.dart';
import 'nuevo_producto_screen.dart';
import 'editar_producto_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final FakeApiService _apiService = FakeApiService();
  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _futureProductos = _apiService.obtenerProductos();
  }

  void _recargar() {
    setState(() {
      _futureProductos = _apiService.obtenerProductos();
    });
  }

  Future<void> _agregarProducto() async {
    final nuevo = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(builder: (_) => const NuevoProductoScreen()),
    );
    if (nuevo != null) _recargar();
  }

  Future<void> _editarProducto(Producto producto) async {
    final editado = await Navigator.push<Producto>(
      context,
      MaterialPageRoute(builder: (_) => EditarProductoScreen(producto: producto)),
    );
    if (editado != null) _recargar();
  }

  Future<void> _confirmarEliminar(Producto producto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      await _apiService.eliminarProducto(producto.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${producto.nombre} eliminado')),
      );
      _recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StorePro Fake API'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProducto,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar productos: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final productos = snapshot.data!;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final prod = productos[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
                  title: Text(prod.nombre),
                  subtitle: Text(prod.categoria),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${prod.precio.toStringAsFixed(2)}'),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarProducto(prod),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmarEliminar(prod),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          
          return const SizedBox();
        },
      ),
    );
  }
}