# StorePro

Aplicación Flutter integradora del trimestre 5: cliente móvil de una tienda
**StorePro** que consume una API REST con autenticación JWT, más una suite de
ejercicios (calculadora, cotizador de envíos, encuesta de satisfacción y
directorio médico).

El backend es un servidor Express con datos simulados en memoria (`server.js`).

---

## Requisitos

| Herramienta | Versión | Notas |
|---|---|---|
| Flutter | 3.47+ | `flutter --version` |
| Node.js | 18+ | Para el backend |
| Android SDK | API 35+ | Solo si vas a compilar para Android |

Verifica tu entorno con:

```bash
flutter doctor          # el toolchain de Android debe estar en ✓
```

---

## 1. Levantar el backend

```bash
npm install
node server.js
```

Debe imprimir `Servidor StorePro corriendo en http://localhost:3000`.
Comprueba que responde:

```bash
curl http://localhost:3000/api/categorias
```

### Usuarios de prueba

| Email | Contraseña | Rol |
|---|---|---|
| `admin@storepro.com` | `123456` | admin |
| `vendedor@storepro.com` | `123456` | vendedor |

> ⚠️ Los datos viven en memoria: al reiniciar el servidor se pierden los cambios.

---

## 2. Configurar el `.env`

El proyecto **requiere** un archivo `.env` en la raíz: está declarado como asset
en `pubspec.yaml`, así que si no existe el build falla. Cópialo desde la plantilla:

```bash
cp .env.example .env
```

Luego ajusta `API_URL` según dónde se ejecute la app:

| Plataforma | Valor de `API_URL` |
|---|---|
| Web / Chrome | `http://localhost:3000/api` |
| Linux desktop | `http://localhost:3000/api` |
| Emulador Android | `http://10.0.2.2:3000/api` |
| **Celular físico** | `http://<IP_LAN_DEL_PC>:3000/api` |

Para un celular físico, obtén la IP de tu PC con:

```bash
hostname -I        # Linux
ipconfig           # Windows
```

Ejemplo: `API_URL=http://192.168.0.7:3000/api`

> 📌 `localhost` **no funciona** desde un celular: en el teléfono apunta al
> propio teléfono, no a tu PC.
>
> 📌 La URL se compila dentro del APK. Si la IP del PC cambia, hay que
> recompilar.

---

## 3. Ejecutar en un celular Android (por USB)

### 3.1 Preparar el celular

1. Ajustes → *Acerca del teléfono* → toca **Número de compilación** 7 veces.
2. Ajustes → *Opciones de desarrollador* → activa **Depuración USB**.
3. Conéctalo por cable y acepta el diálogo *"¿Permitir depuración USB?"*.

Verifica que Flutter lo detecta:

```bash
flutter devices
```

### 3.2 Abrir el puerto del backend

El celular y el PC deben estar **en la misma red Wi-Fi**. Permite el puerto en
el firewall del PC:

```bash
sudo ufw allow 3000/tcp        # Linux (ufw)
```

**Pruébalo desde el navegador del celular** antes de seguir: abre
`http://<IP_LAN_DEL_PC>:3000/api/categorias`. Si ves el JSON, la red está lista.
Si no, el problema es de red o firewall, no de la app.

### 3.3 Compilar y ejecutar

```bash
flutter run -d <id-del-dispositivo>
```

Con la app corriendo: `r` = hot reload, `R` = reinicio completo, `q` = salir.

Para generar el APK y probarlo sin cable:

```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

---

## 4. Ejecutar en otras plataformas

```bash
flutter run -d chrome     # Web
flutter run -d linux      # Linux desktop
```

---

## Notas de seguridad en Android

El archivo `android/app/src/main/AndroidManifest.xml` incluye dos ajustes
necesarios porque la API se sirve por **HTTP sin TLS** en desarrollo:

- `<uses-permission android:name="android.permission.INTERNET"/>` — sin esto el
  APK **release** se queda sin red (Flutter solo lo añade en debug/profile).
- `android:usesCleartextTraffic="true"` — Android 9+ bloquea el tráfico HTTP en
  claro. Sin esto, toda petición falla con `CLEARTEXT communication not permitted`.

> En producción habría que servir la API por **HTTPS** y quitar
> `usesCleartextTraffic`.

---

## Endpoints de la API

| Método | Ruta | Auth | Descripción |
|---|---|---|---|
| POST | `/api/auth/login` | No | Devuelve el JWT |
| GET | `/api/auth/perfil` | Sí | Datos del usuario del token |
| GET | `/api/categorias` | No | Lista categorías |
| GET | `/api/categorias/:id` | No | Detalle de categoría |
| POST | `/api/categorias` | Sí | Crea categoría |
| PUT | `/api/categorias/:id` | Sí | Actualiza categoría |
| PATCH | `/api/categorias/:id/estado` | Sí | Activa/desactiva categoría |
| DELETE | `/api/categorias/:id` | Sí | Elimina categoría |
| GET | `/api/productos` | No | Lista productos (con su categoría) |
| GET | `/api/productos/:id` | No | Detalle de producto |
| POST | `/api/productos` | Sí | Crea producto |
| PUT | `/api/productos/:id` | Sí | Actualiza producto |
| DELETE | `/api/productos/:id` | Sí | Elimina producto |
| PATCH | `/api/productos/:id/estado` | Sí | Activa/desactiva producto |

`Auth: Sí` significa que requiere cabecera `Authorization: Bearer <token>`.

---

## Solución de problemas

| Síntoma | Causa probable |
|---|---|
| El spinner de *Ingresar* gira sin parar | Antes pasaba siempre por falta de manejo de errores. Ahora muestra un mensaje rojo indicando si el problema es la red o las credenciales. |
| "No se pudo conectar con el servidor (…/api)" | El `server.js` está apagado, la `API_URL` no apunta a la IP del PC, o el firewall bloquea el 3000. |
| `CLEARTEXT communication not permitted` | Falta `usesCleartextTraffic` en el manifest. |
| El build falla al compilar assets | No existe el `.env`. Ejecuta `cp .env.example .env`. |
| Los listados no cargan y no hay error visible | El `FutureBuilder` de esas pantallas aún no distingue estado de error. |

---

## Estructura del proyecto

```
lib/
├── config/       # Lectura del .env
├── models/       # Producto, Categoria, Usuario, Medico
├── providers/    # AuthProvider (estado de sesión)
├── services/     # Cliente HTTP: auth, productos, categorías
├── screens/      # Login, categorías, productos, perfil
│   └── extras/   # Calculadora, cotizador, encuesta, directorio
└── widgets/      # Drawer y widgets reutilizables
server.js         # API REST con JWT (datos en memoria)
```

---

## Pruebas

```bash
flutter analyze
flutter test
```
