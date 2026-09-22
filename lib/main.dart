import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'StorePro App',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const LoginScreen(),
      ),
    );
  }

  /// Tema global unificado de StorePro:
  /// indigo principal, tarjetas blancas redondeadas, campos suaves
  /// y botones con esquinas pronunciadas.
  ThemeData _buildTheme() {
    const Color primario = Color(0xFF02569B);
    const Color fondo = Color(0xFFF4F6FA);

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: primario),
      useMaterial3: true,
      scaffoldBackgroundColor: fondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: primario,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1.5,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E8EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primario, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primario,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? Colors.white : null),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? primario : null),
      ),
      dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 0.8),
      listTileTheme: const ListTileThemeData(
        iconColor: primario,
      ),
    );
  }
}
