// Prueba de widget de la pantalla de inicio de sesión.
//
// La app arranca con AuthProvider, que consulta el token guardado mediante
// flutter_secure_storage. En el entorno de pruebas no existen los plugins de
// plataforma, así que se simulan dos cosas para que la prueba sea determinista:
//   1. El .env, con dotenv.testLoad (evita depender del asset .env).
//   2. El canal de flutter_secure_storage, que devuelve null (sin sesión).

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:store_prot_js/main.dart';

void main() {
  const storageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUpAll(() {
    dotenv.testLoad(fileInput: 'API_URL=http://localhost:3000/api');
  });

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, (call) async => null);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(storageChannel, null);
  });

  testWidgets('Muestra la pantalla de inicio de sesión', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Encabezado y campos del formulario
    expect(find.text('StorePro'), findsOneWidget);
    expect(find.text('Gestión de tienda · Acceso'), findsOneWidget);
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar a la App'), findsOneWidget);
  });
}
