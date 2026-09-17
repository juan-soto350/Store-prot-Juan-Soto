import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_prot_js/screens/categorias_screen.dart';
import '../providers/auth_provider.dart';
import 'productos_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;

  void _ejecutarLogin() async {
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    bool exito = await authProvider.login(_emailCtrl.text, _passCtrl.text);

    setState(() => _isLoading = false);

    if (exito && mounted) {
      // 4. Redirigir a la pantalla de productos (donde opera el RBAC)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CategoriasScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales o servidor incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StorePro - Acceso')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person, size: 70, color: Colors.indigo),
            const SizedBox(height: 16),
            TextField(
              controller: _emailCtrl, 
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl, 
              obscureText: true, 
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 24),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text('Ingresar a la App'),
                  onPressed: _ejecutarLogin,
                ),
          ],
        ),
      ),
    );
  }
}