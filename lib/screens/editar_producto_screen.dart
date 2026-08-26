import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/fake_api_service.dart';

class EditarProductoScreen extends StatefulWidget {
  final Producto producto;

  const EditarProductoScreen({super.key, required this.producto});

  @override
  State<EditarProductoScreen> createState() => _EditarProductoScreenState();
}

class _EditarProductoScreenState extends State<EditarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = FakeApiService();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _categoriaCtrl;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.producto.nombre);
    _precioCtrl = TextEditingController(text: widget.producto.precio.toString());
    _categoriaCtrl = TextEditingController(text: widget.producto.categoria);
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    final editado = Producto(
      id: widget.producto.id,
      nombre: _nombreCtrl.text,
      precio: double.parse(_precioCtrl.text),
      categoria: _categoriaCtrl.text.isEmpty ? 'General' : _categoriaCtrl.text,
    );

    final resultado = await _apiService.editarProducto(editado);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Producto actualizado')),
    );

    Navigator.pop(context, resultado);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _categoriaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Producto')),
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
                decoration: const InputDecoration(labelText: 'Categoría'),
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
                    : const Text('ACTUALIZAR PRODUCTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
