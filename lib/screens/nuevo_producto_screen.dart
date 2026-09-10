import 'package:flutter/material.dart';
import '../services/producto_services.dart';

class NuevoProductoScreen extends StatefulWidget {
  const NuevoProductoScreen({super.key});

  @override
  State<NuevoProductoScreen> createState() => _NuevoProductoScreenState();
}

class _NuevoProductoScreenState extends State<NuevoProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ProductoService();

  final _nombreCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _stockCtrl = TextEditingController(text: '0');

  bool _guardando = false;

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final categoriaId = int.tryParse(_categoriaCtrl.text) ?? 1;
    final stock = int.tryParse(_stockCtrl.text) ?? 0;
    final creado = await _apiService.crearProducto(
      _nombreCtrl.text,
      double.parse(_precioCtrl.text),
      stock,
      categoriaId,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto guardado')),
    );

    Navigator.pop(context, creado); // devuelve el producto a CatalogoScreen
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _categoriaCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'El nombre es obligatorio';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoriaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID de categoría'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stockCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _precioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio *'),
                validator: (val) {
                  if (val == null || double.tryParse(val) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('GUARDAR PRODUCTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}