import 'package:flutter/material.dart';
import '../screens/categorias_screen.dart';
import '../screens/productos_screen.dart';
import '../screens/perfil_screen.dart';
import '../screens/extras/calculadora_screen.dart';
import '../screens/extras/cotizador_screen.dart';
import '../screens/extras/encuesta_screen.dart';
import '../screens/extras/directorio_screen.dart';

/// Menú de navegación lateral (Drawer) de StorePro.
/// Integra el Store (categorías, productos, perfil) con las demás
/// aplicaciones del trimestre: calculadora, cotizador, encuesta y
/// directorio médico.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // Cierra el Drawer, vuelve a la raíz (Categorías) y abre la pantalla destino
  void _irA(BuildContext context, Widget pantalla) {
    Navigator.pop(context); // Cierra el Drawer
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  // Restablece el stack dejando Categorías como raíz
  void _irACategorias(BuildContext context) {
    Navigator.pop(context); // Cierra el Drawer
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CategoriasScreen()),
      (route) => false,
    );
  }

  void _acercaDe(BuildContext context) {
    Navigator.pop(context); // Cierra el Drawer antes de abrir el diálogo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de StorePro'),
        content: const Text(
          'Aplicación integradora del trimestre 5: StorePro (API REST con JWT) '
          'más la suite de ejercicios móviles: calculadora, cotizador de envíos, '
          'encuesta de satisfacción y directorio médico. Construida en Flutter.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.storefront, color: Colors.indigo, size: 28),
                ),
                SizedBox(height: 10),
                Text('StorePro App', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Store + Suite de Ejercicios Móviles', style: TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () => _irACategorias(context),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('Productos'),
            onTap: () => _irA(context, const ProductosScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi Perfil'),
            onTap: () => _irA(context, const PerfilScreen()),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text(
              'Suite de Ejercicios',
              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.indigo),
            title: const Text('Calculadora'),
            subtitle: const Text('Operaciones básicas interactivas'),
            onTap: () => _irA(context, const PantallaCalculadora()),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.green),
            title: const Text('Cotizador de Envíos'),
            subtitle: const Text('Calcula fletes según peso y destino'),
            onTap: () => _irA(context, const CotizadorScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.rate_review, color: Colors.teal),
            title: const Text('Encuesta de Feedback'),
            subtitle: const Text('Valora el servicio de atención'),
            onTap: () => _irA(context, const PantallaEncuesta()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.indigo),
            title: const Text('Directorio Médico'),
            subtitle: const Text('Busca médicos y solicita citas'),
            onTap: () => _irA(context, const DirectorioScreen()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de la App'),
            onTap: () => _acercaDe(context),
          ),
        ],
      ),
    );
  }
}
