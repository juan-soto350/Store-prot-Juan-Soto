import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart'; // Asegúrate de importar tu provider

class RoleGuardWidget extends StatelessWidget {
  final List allowedRoles; // Recomendado tipar también la lista como 
  final Widget child;
  final Widget fallback;

  const RoleGuardWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    
    final authProvider = Provider.of(context);
    
    // O alternativamente usando context.watch (es exactamente lo mismo):
    // final authProvider = context.watch();

    final userRole = authProvider.usuario?.role ?? '';

    if (allowedRoles.contains(userRole)) {
      return child;
    }
    
    return fallback;
  }
}