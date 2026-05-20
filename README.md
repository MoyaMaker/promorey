# PromoRey

![Flutter](https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-✓-FFCA28?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)

**PromoRey** es una aplicación multiplataforma (Android, iOS, Web, macOS, Windows) para gestionar promociones y ofertas. Permite a los usuarios autenticarse, crear, editar, eliminar, explorar y compartir promociones de forma sencilla.

Desarrollada con **Flutter** y **Firebase**.

---

## Funcionalidades

- [x] Autenticación por email y contraseña (Firebase Auth)
- [x] Registro e inicio de sesión con validación de formularios
- [x] Creación de promociones (título, descripción, fecha, activo/inactivo)
- [x] Edición y eliminación de promociones propias
- [x] Feed público con todas las promociones activas
- [x] Vista de detalle de cada promoción
- [x] Compartir promociones vía share nativo (share_plus)
- [x] Pull-to-refresh en listas
- [x] Navegación con tabs (feed, mis promociones, perfil)
- [x] Diseño Material 3 con tema personalizado
- [x] Interfaz completamente en español

> **Nota:** Se dejo fuera la subida de imágenes de promociones por costo del servicio de Firebase Storage (requiere el plan Blaze).

---

## Tecnologías

| Tecnología | Versión | Propósito |
|---|---|---|
| [Flutter](https://flutter.dev) | SDK | Framework multiplataforma |
| [Dart](https://dart.dev) | ^3.11.5 | Lenguaje de programación |
| [Firebase Auth](https://firebase.google.com/docs/auth) | ^5.5.2 | Autenticación de usuarios |
| [Cloud Firestore](https://firebase.google.com/docs/firestore) | ^5.6.6 | Base de datos NoSQL en tiempo real |
| [Provider](https://pub.dev/packages/provider) | ^6.1.5 | Manejo de estado |
| [GoRouter](https://pub.dev/packages/go_router) | ^14.8.1 | Enrutamiento declarativo con guards de autenticación |
| [share_plus](https://pub.dev/packages/share_plus) | ^10.1.4 | Compartir contenido nativo |
| [intl](https://pub.dev/packages/intl) | ^0.20.2 | Formateo de fechas |

---

## Arquitectura

PromoRey sigue el patrón **Provider + Service Layer** (MVVM simplificado):

```
UI (Screens / Widgets)
    ↕  Provider (watch/read)
Providers (ChangeNotifier)
    ↕  llaman a servicios
Services (wrappers de Firebase)
    ↕  Firebase SDK
Firebase Auth + Firestore
```

- **Screens / Widgets** — Capa de presentación. Consumen los providers.
- **Providers** — Contenedores de estado (ChangeNotifier). Manejan loading, error y datos.
- **Services** — Capa de datos. Llamadas directas a Firebase Auth y Cloud Firestore.
- **Models** — Clases Dart con serialización (`toMap` / `fromMap`).

---

## Estructura del proyecto

```
lib/
├── config/
│   ├── theme.dart              # Tema Material 3
│   └── routes.dart             # Rutas con GoRouter
├── models/
│   └── promotion.dart          # Modelo de datos de promoción
├── providers/
│   ├── auth_provider.dart      # Estado de autenticación
│   └── promotion_provider.dart # Estado de promociones
├── screens/
│   ├── login_screen.dart       # Inicio de sesión
│   ├── register_screen.dart    # Registro
│   ├── main_shell.dart         # Navegación inferior con tabs
│   ├── promotions_tab.dart     # Feed de promociones
│   ├── my_promotions_tab.dart  # Mis promociones
│   ├── profile_tab.dart        # Perfil de usuario
│   ├── promotion_form_screen.dart  # Crear / editar promoción
│   └── promotion_detail_screen.dart # Detalle de promoción
├── services/
│   ├── auth_service.dart       # Servicio de autenticación
│   └── firestore_service.dart  # CRUD en Firestore
├── utils/
│   ├── validators.dart         # Validadores de formularios
│   ├── auth_errors.dart        # Traducción de errores de auth
│   └── firestore_errors.dart   # Traducción de errores de Firestore
├── widgets/
│   ├── promotion_card.dart     # Tarjeta de promoción reutilizable
│   ├── error_text.dart         # Texto de error en rojo
│   └── loading_overlay.dart    # Overlay de carga
├── firebase_options.dart       # Configuración de Firebase (generado)
└── main.dart                   # Punto de entrada
```

---

## Requisitos previos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.11.5)
- [Dart SDK](https://dart.dev/get-dart) (viene incluido con Flutter)
- Una cuenta de [Firebase](https://firebase.google.com)
- Un proyecto de Firebase creado en [Firebase Console](https://console.firebase.google.com)

---

## Configuración de Firebase

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com).
2. Habilita los siguientes servicios:
   - **Authentication** → Método de inicio de sesión → **Correo electrónico/contraseña**
   - **Cloud Firestore** → Crear base de datos (modo de prueba para desarrollo)
3. Agrega tu aplicación en Firebase Console:
   - **Android**: Descarga `google-services.json` y colócalo en `android/app/`
   - **iOS**: Descarga `GoogleService-Info.plist` y colócalo en `ios/Runner/`
   - **Web**: Copia la configuración de Firebase en `web/index.html`
   - **macOS**: Coloca `GoogleService-Info.plist` en `macos/Runner/`
   - **Windows**: Coloca `google-services.json` en `windows/flutter/`
4. Regenera el archivo `firebase_options.dart` (opcional, si usas FlutterFire CLI):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

> **Nota:** Si tu proyecto Firebase está en el plan Spark (gratuito), ten en cuenta que Cloud Firestore tiene límites de uso. Firebase Storage (para imágenes) **no está incluido** en esta app porque requiere el plan Blaze (pago).

---

## Instalación y ejecución

```bash
# 1. Clonar el repositorio
git clone https://github.com/tuusuario/promorey.git
cd promorey

# 2. Instalar dependencias
flutter pub get

# 3. Configurar Firebase (ver sección anterior)

# 4. Ejecutar en modo desarrollo
flutter run

# 5. Generar un APK de release (Android)
flutter build apk

# 6. Generar para Web
flutter build web
```

---

## Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.
