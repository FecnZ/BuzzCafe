# Especificaciones Técnicas y Conexión de Dispositivos

Este documento describe cómo se comunican las distintas partes del sistema en un entorno de producción (o pruebas) y detalla las versiones exactas de las herramientas utilizadas para garantizar la compatibilidad estructural.

## 🌐 Arquitectura de Red y Conectividad

El sistema BuzzCafe POS opera en una arquitectura **Cliente-Servidor** dentro de una Red de Área Local (LAN) o a través de la nube, dependiendo de su despliegue.

### 1. El Servidor (Java / Spring Boot)
El Backend (`BuzzCafe_Back`) actúa como la única fuente de la verdad (*Single Source of Truth*). 
- Por defecto, levanta un servidor Apache Tomcat en el puerto **8080**.
- **Conexión:** La computadora que ejecute el Backend debe tener una IP Estática dentro de la red local (por ejemplo `192.168.1.100`).

### 2. Los Clientes (Flutter)
La aplicación cliente (`buzzcafe_front`) está diseñada para instalarse en múltiples dispositivos que apuntarán a la IP del Servidor.
- **Caja Registradora (Windows):** Ejecuta el cliente de escritorio. Las solicitudes HTTP (`GET`, `POST`, etc.) se envían a `http://[IP_SERVIDOR]:8080/api/...`.
- **Tablets de Cocina (Android/Web/iOS):** Visualizan el sistema. Dado que el Backend incluye dependencias de `spring-boot-starter-websocket`, la cocina puede establecer una conexión bidireccional (WebSockets) para escuchar nuevas órdenes en tiempo real sin necesidad de recargar la página HTTP constantemente.

### 3. Autenticación Continua (JWT)
Cada vez que un cliente (Cajero o Cocina) se loguea exitosamente, recibe un **JSON Web Token (JWT)**.
- El Front-end almacena el JWT localmente.
- Todas las peticiones subsecuentes adjuntan un header HTTP para asegurar la autenticidad de la información transmitida:
  `Authorization: Bearer <TOKEN_AQUI>`

---

## 🛠️ Versiones de SDK y Dependencias Core

Para que cualquier desarrollador pueda compilar el sistema de manera idéntica, es obligatorio contar con las siguientes versiones del entorno de desarrollo:

### Backend (Java)
- **Java Development Kit (JDK):** Versión **21** (Soporte LTS y características modernas de Java).
- **Spring Boot:** Versión **4.0.4**
- **Gestor de Paquetes:** Maven (`mvnw` Wrapper incluido)
- **Seguridad y Tokens:** JJWT API e Implementación **0.11.5**
- **Lombok:** Habilitado como generador de anotaciones (`@Data`, `@Getter`, etc.)

### Frontend (Flutter)
- **Dart SDK:** `^3.10.4`
- **Gestor de Estados:** Provider `^6.1.5+1`
- **Protocolo de Red:** HTTP `^1.1.0`

### Base de Datos
- **Motor:** H2 Database (En Memoria durante entorno de Desarrollo). No se requiere instalación local de gestores SQL para probar el software.
