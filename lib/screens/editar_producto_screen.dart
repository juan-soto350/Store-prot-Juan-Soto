import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../services/catergoria_service.dart';
import '../services/producto_services.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ProductoService();
  final CategoriasService _categoriasService = CategoriasService();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;

  late Future<List<Categoria>> _futureCategorias;
  Categoria? _categoriaSeleccionada;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.producto.nombre);
    _precioCtrl = TextEditingController(text: widget.producto.precio.toString());
    _stockCtrl = TextEditingController(text: widget.producto.stock.toString());
    _futureCategorias = _categoriasService.getCategorias();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }

    setState(() => _guardando = true);

    final resultado = await _apiService.actualizarProducto(
      widget.producto.id,
      _nombreCtrl.text,
      double.parse(_precioCtrl.text),
      int.tryParse(_stockCtrl.text) ?? 0,
      _categoriaSeleccionada!.id,
    );

    if (!mounted) return;
    setState(() => _guardando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado ? 'Producto actualizado' : 'No se pudo actualizar el producto'),
        backgroundColor: resultado ? Colors.green : Colors.red,
      ),
    );

    if (resultado) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'El nombre es obligatorio';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Categoria>>(
                future: _futureCategorias,
                builder: (context, snapshot) {
                  final categorias = snapshot.data ?? [];
                  // Precarga la categoría actual del producto si existe en la lista
                  if (_categoriaSeleccionada == null && categorias.isNotEmpty) {
                    _categoriaSeleccionada = categorias.firstWhere(
                      (c) => c.id == widget.producto.categoriaId,
                      orElse: () => categorias.first,
                    );
                  }
                  return DropdownButtonFormField<Categoria>(
                    value: _categoriaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: 'Categoría *',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: categorias.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat.nombre),
                      );
                    }).toList(),
                    onChanged: (cat) => setState(() => _categoriaSeleccionada = cat),
                    validator: (val) =>
                        val == null ? 'Selecciona una categoría' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precioCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio *',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (val) {
                  if (val == null || double.tryParse(val) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: const Icon(Icons.update),
                  label: const Text('ACTUALIZAR PRODUCTO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
