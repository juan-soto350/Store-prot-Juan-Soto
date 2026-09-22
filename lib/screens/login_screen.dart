import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_prot_js/screens/categorias_screen.dart';
import '../providers/auth_provider.dart';

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
    const Color primario = Color(0xFF02569B);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ENCABEZADO CON LOGO
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: primario,
                  child: Icon(Icons.storefront, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'StorePro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primario,
                  ),
                ),
                const Text(
                  'Gestión de tienda · Acceso',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 28),

                // TARJETA DE ACCESO
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 48,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton.icon(
                                  icon: const Icon(Icons.login),
                                  label: const Text('Ingresar a la App'),
                                  onPressed: _ejecutarLogin,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'v1.0.0 · Trimestre 5 ADSO',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
