import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_services.dart';
import '../widgets/app_drawer.dart';
import 'editar_producto_screen.dart';
import 'nuevo_producto_screen.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final ProductoService _service = ProductoService();
  late Future<List<Producto>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    setState(() {
      _futureProductos = _service.getProductos();
    });
  }

  // Abre el formulario en modo creación y refresca al volver
  Future<void> _crearProducto() async {
    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NuevoProductoScreen()),
    );
    if (creado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto creado con éxito')),
      );
      _cargarProductos();
    }
  }

  // Abre el formulario en modo edición y refresca al volver
  Future<void> _editarProducto(Producto prod) async {
    final actualizado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditarProductoScreen(producto: prod)),
    );
    if (actualizado == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto actualizado con éxito')),
      );
      _cargarProductos();
    }
  }

  // Pide confirmación y elimina el producto en el backend
  Future<void> _eliminarProducto(Producto prod) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${prod.nombre}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final ok = await _service.eliminarProducto(prod.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Producto eliminado' : 'No se pudo eliminar el producto'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (ok) _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Inventario de Productos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearProducto,
        icon: const Icon(Icons.add),
        label: const Text('Producto'),
        backgroundColor: const Color(0xFF02569B),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Producto>>(
        future: _futureProductos,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('No hay productos registrados'));
          }
          return RefreshIndicator(
            onRefresh: () async => _cargarProductos(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
              itemCount: lista.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (ctx, i) {
                final prod = lista[i];
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: prod.estado ? Colors.green.shade50 : Colors.grey.shade200,
                      child: Icon(
                        prod.estado ? Icons.check_circle : Icons.cancel,
                        color: prod.estado ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(
                      prod.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: prod.estado ? TextDecoration.none : TextDecoration.lineThrough,
                      ),
                    ),
                    subtitle: Text('Precio: \$${prod.precio} | Stock: ${prod.stock}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Switch para activar/desactivar el producto (borrado lógico)
                        Switch(
                          value: prod.estado,
                          onChanged: (val) async {
                            await _service.cambiarEstado(prod.id);
                            _cargarProductos();
                          },
                        ),
                        // Botón para eliminar definitivamente el producto
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          tooltip: 'Eliminar producto',
                          onPressed: () => _eliminarProducto(prod),
                        ),
                      ],
                    ),
                    onTap: () => _editarProducto(prod),
                    onLongPress: () => _eliminarProducto(prod),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
