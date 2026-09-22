import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/catergoria_service.dart';
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
      body: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final lista = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12.0),
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
                  trailing: Switch(
                  value: cat.estado,
                  onChanged: (val) async {
                    await _service.cambiarEstado(cat.id);
                    _cargarCategorias();
                  },
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