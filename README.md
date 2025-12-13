# Campus Commerce

Una aplicación de comercio electrónico desarrollada en Flutter para facilitar la compra y venta de productos dentro del campus universitario.

## 📱 Descripción del Proyecto

Campus Commerce es una plataforma de e-commerce diseñada específicamente para comunidades universitarias. Permite a los usuarios navegar por un catálogo de productos, agregar artículos a su carrito de compras, gestionar su perfil y contactar directamente con los proveedores a través de WhatsApp.

### Características Principales

- 🛍️ **Catálogo de Productos**: Explora productos organizados por categorías (Electrónica, Ropa, Alimentos, etc.)
- 🛒 **Carrito de Compras**: Gestiona productos con funcionalidad tanto online (Firebase) como offline (Hive)
- 👤 **Autenticación de Usuarios**: Registro e inicio de sesión con Firebase Authentication
- 📱 **Contacto Directo**: Comunicación con proveedores vía WhatsApp
- 🔍 **Búsqueda de Productos**: Encuentra rápidamente lo que necesitas
- 📝 **Gestión de Productos**: Los usuarios pueden agregar y gestionar sus propios productos
- 👥 **Perfiles de Usuario**: Gestión completa de información personal

## 🏗️ Arquitectura del Proyecto

El proyecto sigue los principios de **Clean Architecture**, organizando el código en capas bien definidas:

```
lib/
├── core/                    # Lógica de negocio central
│   ├── entity/             # Entidades del dominio (Product, User)
│   ├── repository/         # Interfaces de repositorios
│   └── usecase/            # Casos de uso de la aplicación
├── data/                   # Capa de datos
│   └── datasource/         # Fuentes de datos (Firebase, Hive)
├── presentation/           # Capa de presentación
│   ├── pages/              # Pantallas de la aplicación
│   └── widgets/            # Componentes reutilizables
└── service/                # Servicios (Auth, Adapters)
```

### Entidades Principales

#### Product (Producto)
```dart
- id: String
- name: String
- imageUrl: String
- price: double
- brand: String
- category: String
- supplierPhoneNumber: String
- quantity: int
```

#### Usuario
```dart
- id: String
- nombre: String
- correo: String
- telefono: String
```

## 🛠️ Stack Tecnológico

### Framework y Lenguaje
- **Flutter** SDK 3.4.3 o superior
- **Dart** SDK >= 3.4.3 < 4.0.0

### Backend y Base de Datos
- **Firebase Core** (^3.6.0) - Plataforma de desarrollo
- **Firebase Authentication** (^5.3.1) - Autenticación de usuarios
- **Cloud Firestore** (^5.4.4) - Base de datos NoSQL en la nube
- **Firebase Database** (^11.1.4) - Base de datos en tiempo real

### Almacenamiento Local
- **Hive** (^2.2.3) - Base de datos NoSQL local
- **Hive Flutter** (^1.1.0) - Integración de Hive con Flutter
- **SQFlite** (^2.0.0) - Base de datos SQL local para Flutter

### Utilidades
- **url_launcher** (^6.3.1) - Apertura de URLs (WhatsApp)
- **intl** (^0.19.0) - Internacionalización y formato de fechas
- **path** (^1.8.0) - Manipulación de rutas de archivos

## 📋 Páginas de la Aplicación

1. **home_pages.dart** - Página principal con navegación inferior
2. **login_pages.dart** - Inicio de sesión
3. **register_pages.dart** - Registro de nuevos usuarios
4. **market_pages.dart** - Catálogo de productos
5. **cart_pages.dart** - Carrito de compras
6. **profile_pages.dart** - Perfil del usuario
7. **product_details_pages.dart** - Detalles de un producto
8. **product_add_pages.dart** - Agregar nuevos productos
9. **category_pages.dart** - Productos por categoría
10. **search_results_page.dart** - Resultados de búsqueda
11. **whatsapp_page.dart** - Integración con WhatsApp

## 🚀 Configuración e Instalación

### Prerrequisitos

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión 3.4.3 o superior)
2. [Dart SDK](https://dart.dev/get-dart) (incluido con Flutter)
3. Un IDE: [Android Studio](https://developer.android.com/studio), [VS Code](https://code.visualstudio.com/), o [IntelliJ IDEA](https://www.jetbrains.com/idea/)
4. Cuenta de [Firebase](https://firebase.google.com/)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd myapp
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - El proyecto ya incluye la configuración de Firebase en `main.dart`
   - Si necesitas usar tu propia instancia de Firebase, actualiza las credenciales en `lib/main.dart`

4. **Generar archivos de Hive**
   ```bash
   flutter pub run build_runner build
   ```

5. **Ejecutar la aplicación**
   
   Para desarrollo:
   ```bash
   flutter run
   ```
   
   Para web:
   ```bash
   flutter run -d chrome
   ```
   
   Para Android:
   ```bash
   flutter run -d android
   ```

## 🌐 Despliegue

### Firebase Hosting

El proyecto está configurado para desplegarse en Firebase Hosting:

```bash
# Construir la aplicación web
flutter build web

# Desplegar en Firebase
firebase deploy
```

La configuración de hosting se encuentra en `firebase.json`.

## 📱 Funcionalidades Detalladas

### Sistema de Autenticación
- Los usuarios pueden registrarse con correo electrónico y contraseña
- Inicio de sesión persistente
- Gestión de sesiones con Firebase Authentication

### Carrito de Compras Híbrido
- **Usuarios autenticados**: Los datos del carrito se sincronizan con Firebase
- **Usuarios no autenticados**: Los datos se almacenan localmente con Hive
- Transición automática de datos al iniciar sesión

### Gestión de Productos
- Los usuarios pueden agregar productos con información completa
- Cada producto incluye información del proveedor
- Soporte para imágenes de productos
- Organización por categorías

### Contacto con Proveedores
- Integración directa con WhatsApp
- Los usuarios pueden contactar a los proveedores con un solo clic

## 🔧 Desarrollo

### Ejecutar Tests
```bash
flutter test
```

### Análisis de Código
```bash
flutter analyze
```

### Formatear Código
```bash
flutter format lib/
```

## 📝 Configuración de Linting

El proyecto utiliza `flutter_lints` (^3.0.0) para mantener la calidad del código. Las reglas se encuentran en `analysis_options.yaml`.

## 🤝 Contribuir

Si deseas contribuir a este proyecto:

1. Haz un Fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este es un proyecto privado y no está publicado en pub.dev.

## 📞 Contacto

Para más información sobre el proyecto, contacta al equipo de desarrollo.

## 🔗 Enlaces Útiles

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de Firebase](https://firebase.google.com/docs)
- [Documentación de Hive](https://docs.hivedb.dev/)
- [Guía de Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
