import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/app_drawer.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State {
  final AuthService _authService = AuthService();
  late Future _futureUsuario;

  @override
  void initState() {
    super.initState();
    _futureUsuario = _authService.getPerfil();
  }

  void _cerrarSesion() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primario = Color(0xFF02569B);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Mi Perfil de Usuario')),
      body: FutureBuilder(
        future: _futureUsuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Error al cargar datos del usuario'));
          }

          final usuario = snapshot.data!;
          final inicial = usuario.nombre.isNotEmpty ? usuario.nombre[0].toUpperCase() : 'U';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 8),

                // TARJETA DE IDENTIDAD
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: primario,
                          child: Text(
                            inicial,
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          usuario.nombre,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(usuario.email,
                            style: const TextStyle(color: Colors.black54)),
                        const SizedBox(height: 14),
                        Chip(
                          label: Text('Rol: ${usuario.role.toUpperCase()}'),
                          backgroundColor: usuario.role == 'admin'
                              ? Colors.amber.shade100
                              : Colors.blue.shade100,
                          labelStyle: TextStyle(
                            color: usuario.role == 'admin'
                                ? Colors.brown.shade800
                                : primario,
                            fontWeight: FontWeight.bold,
                          ),
                          side: BorderSide.none,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // DETALLE DE LA CUENTA
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.badge_outlined),
                        title: const Text('ID de usuario'),
                        subtitle: Text('${usuario.id}'),
                      ),
                      Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                          indent: 16,
                          endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Correo'),
                        subtitle: Text(usuario.email),
                      ),
                      Divider(
                          color: Colors.grey.shade200,
                          height: 1,
                          indent: 16,
                          endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.shield_outlined),
                        title: const Text('Permisos'),
                        subtitle: Text(usuario.role == 'admin'
                            ? 'Acceso total: gestión de categorías y productos'
                            : 'Acceso de vendedor: consulta del catálogo'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // CERRAR SESIÓN
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    onPressed: _cerrarSesion,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
