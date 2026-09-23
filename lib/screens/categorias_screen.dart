import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/catergoria_service.dart';
import '../services/producto_services.dart';
import '../widgets/app_drawer.dart';
import 'perfil_screen.dart';
import 'productos_screen.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriasService _service = CategoriasService();
  final ProductoService _productoService = ProductoService();
  late Future<List<Categoria>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  void _cargarCategorias() {
    setState(() {
      _futureCategorias = _service.getCategorias();
    });
  }

  Future<void> _crearCategoria() async {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final datos = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva categoría'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa un nombre'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Ingresa una descripción'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, [
                  nombreController.text.trim(),
                  descripcionController.text.trim(),
                ]);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );

    nombreController.dispose();
    descripcionController.dispose();
    if (datos == null || !mounted) return;

    final creada = await _service.crearCategoria(datos[0], datos[1]);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(creada ? 'Categoría creada con éxito' : 'No se pudo crear la categoría'),
        backgroundColor: creada ? Colors.green : Colors.red,
      ),
    );
    if (creada) _cargarCategorias();
  }

  // Cuenta cuántos productos están asociados a una categoría
  Future<int> _contarProductosDeCategoria(int categoriaId) async {
    final productos = await _productoService.getProductos();
    return productos.where((p) => p.categoriaId == categoriaId).length;
  }

  // Pide confirmación y elimina la categoría en el backend
  Future<void> _eliminarCategoria(Categoria cat) async {
    // Se crea antes del diálogo para no repetir la petición en cada rebuild
    final futureConteo = _contarProductosDeCategoria(cat.id);

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Seguro que deseas eliminar "${cat.nombre}"? Esta acción no se puede deshacer.'),
            const SizedBox(height: 16),
            FutureBuilder<int>(
              future: futureConteo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    'Verificando productos asociados...',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  );
                }
                if (snapshot.hasError) {
                  return const Text(
                    'No se pudo verificar cuántos productos usan esta categoría.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  );
                }

                final total = snapshot.data ?? 0;
                if (total == 0) {
                  return const Text(
                    'Ningún producto usa esta categoría.',
                    style: TextStyle(fontSize: 13, color: Colors.green),
                  );
                }
                return Text(
                  '$total producto${total == 1 ? '' : 's'} '
                  'usa${total == 1 ? '' : 'n'} esta categoría. Si la eliminas, '
                  'quedarán sin categoría asignada.',
                  style: const TextStyle(fontSize: 13, color: Colors.red),
                );
              },
            ),
          ],
        ),
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

    final ok = await _service.eliminarCategoria(cat.id);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Categoría eliminada' : 'No se pudo eliminar la categoría'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (ok) _cargarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.inventory_2),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductosScreen())),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _crearCategoria,
        icon: const Icon(Icons.add),
        label: const Text('Categoría'),
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final lista = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
            itemCount: lista.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (ctx, i) {
              final cat = lista[i];
              return Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: cat.estado ? Colors.blue.shade50 : Colors.grey.shade200,
                    child: Icon(
                      Icons.category,
                      color: cat.estado ? const Color(0xFF02569B) : Colors.grey,
                    ),
                  ),
                  title: Text(cat.nombre, style: TextStyle(fontWeight: FontWeight.w600, decoration: cat.estado ? TextDecoration.none : TextDecoration.lineThrough)),
                  subtitle: Text(cat.descripcion),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Switch para activar/desactivar la categoría (borrado lógico)
                      Switch(
                        value: cat.estado,
                        onChanged: (val) async {
                          await _service.cambiarEstado(cat.id);
                          _cargarCategorias();
                        },
                      ),
                      // Botón para eliminar definitivamente la categoría
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                        tooltip: 'Eliminar categoría',
                        onPressed: () => _eliminarCategoria(cat),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}