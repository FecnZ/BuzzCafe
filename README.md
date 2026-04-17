#  BuzzCafe POS System

Un sistema integral de Punto de Venta (Point of Sale) Full-Stack diseñado para la gestión de una cafetería. El proyecto implementa control de acceso basado en roles (Administrador, Cajero y Cocina) con un diseño multiplataforma y una robusta arquitectura orientada a servicios.

---

##  Herramientas y Tecnologías Utilizadas

Este proyecto está dividido en dos partes principales y construido con tecnologías modernas y estándares de la industria de Ingeniería de Software.

###  Frontend (`buzzcafe_front`)
Desarrollado con **Flutter**, diseñado originalmente para soportar pantallas multipropósito (Cajas registradoras en Windows, Tablets en cocina):
- **Framework:** Flutter SDK (Dart)
- **Gestión de Estado:** `Provider` (A través de `ChangeNotifierProvider` y un enrutador basado en estado `MainWrapper`).
- **Autenticación:** Almacenamiento seguro y paso de JSON Web Tokens (JWT).
- **Arquitectura:** Diseño Modular por "Features" (Características) separando Lógica de Estado (`Providers`), UI (`Screens` / `Views`) y Modelos de Negocio.

###  Backend (`BuzzCafe_Back`)
Desarrollado con **Java**, funcionando como una API RESTful segura y orientada a servicios:
- **Framework Principal:** Spring Boot
- **Seguridad:** Spring Security con filtros persnalizados para JWT (JSON Web Tokens).
- **Persistencia de Datos:** Spring Data JPA + Hibernate.
- **Base de Datos:** Base de Datos en Memoria **H2** (Excelente para pruebas rápidas y entornos educativos).
- **Arquitectura:** Arquitectura en capas limpia (`Controllers` -> `Services` -> `Repositories`), con Mapeo de Entidades a Transferencia de Datos (`DTOs`) y manejo de excepciones centralizado (`@ControllerAdvice`).

---

##  Vista General de la Estructura del Proyecto

La estructura raíz de este proyecto de monorepositorio está distribuida de la siguiente manera:

```text
📦 BuzzCafe_Project
 ┣ 📂 buzzcafe_front        <-- Aplicación Cliente (Flutter)
 ┃ ┣ 📂 lib/core            <-- Controladores globales, temas de UI y providers de sesión.
 ┃ ┣ 📂 lib/features        <-- Módulos separados por rol (admin, cajero, cocina, auth).
 ┃ ┗ 📜 main.dart           <-- Punto de entrada e inyección de Providers de Flutter.
 ┃
 ┣ 📂 BuzzCafe_Back         <-- API y Lógica de Negocio (Spring Boot / Java)
 ┃ ┣ 📂 src/main/java       <-- Código fuente Java.
 ┃ ┃ ┗ 📂 com/buzzcafe/backend
 ┃ ┃   ┣ 📂 controllers     <-- Puntos de entrada HTTP (Endpoints) por roles.
 ┃ ┃   ┣ 📂 dto             <-- Objetos de Transferencia de Datos (Request/Response).
 ┃ ┃   ┣ 📂 entities        <-- Modelos de la Base de Datos (JPA).
 ┃ ┃   ┣ 📂 exceptions      <-- Manejadores globales de errores limpios de conexión.
 ┃ ┃   ┣ 📂 repositories    <-- Capa de consultas a Base de Datos H2.
 ┃ ┃   ┣ 📂 security        <-- Filtros y validación de tokens JWT.
 ┃ ┃   ┗ 📂 services        <-- Lógica de negocio dura, separada meticulosamente por roles.
 ┃ ┗ 📜 application.properties <-- Configuración de BD H2, puertos y secreto JWT.
 ┃
 ┣ 📂 database_scripts      <-- (Opcional) Scripts SQL de utilidades y esquemas de BD.
 ┗ 📜 .gitignore            <-- Ignora archivos basura de IDE y SO (Nivel de todo el repositorio).
```

###  Sistema de Roles y Navegación
- **`ROLE_ADMIN`**: Acceso al panel de administración para agregar, modificar y eliminar productos.
- **`ROLE_CAJERO`**: Pantalla diseñada para la toma rápida de órdenes y facturación (Integración posbile a futuro de RFID/Impresión).
- **`ROLE_COCINA`**: Pantalla de lectura activa para observar órdenes pendientes y actualizarlas de estado de preparación.

---

