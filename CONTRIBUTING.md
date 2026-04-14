# Contribuir a BuzzCafe POS

¡Bienvenido! Este proyecto es desarrollado como parte de la materia de Ingeniería del Software. Si eres un compañero de clase, profesor, o simplemente quieres aportar a este repositorio, sigue estas directrices para mantener la base de código estable y limpia.

## 🚀 Cómo empezar

1. **Clona el repositorio**
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd BuzzCafe_Project
   ```

2. **Levantar el Backend (Java)**
   - Asegúrate de tener instalado Java JDK 21.
   - Entra a la carpeta del backend y usa el Maven Wrapper:
   ```bash
   cd BuzzCafe_Back
   ./mvnw spring-boot:run
   ```
   > El servidor estará disponible en `http://localhost:8080`.

3. **Levantar el Frontend (Flutter)**
   - Necesitas tener instalado Flutter y Dart (SDK compatible con ^3.10.4).
   - Abre un nuevo terminal y descarga las dependencias:
   ```bash
   cd buzzcafe_front
   flutter pub get
   flutter run
   ```

## 🌿 Flujo de Trabajo y Ramas (Branching)

Trataremos de mantener la rama `main` (o `master`) siempre limpia, funcional y libre de errores graves de compilación.

- **Para nuevas características:** Crea una rama desde `main` con el formato `feature/<nombre-de-tu-funcion>`. 
  *Ejemplo:* `feature/agregar-pantalla-cocina`
- **Para correcciones (Bugs):** Crea una rama con el formato `fix/<nombre-del-bug>`. 
  *Ejemplo:* `fix/error-login-nulo`

## 💬 Convención de Commits

Sé claro en tus mensajes de commit para que cualquier persona entienda qué cambiaste. Recomendamos usar prefijos ("Conventional Commits"):
- `feat:` (Para una nueva característica)
- `fix:` (Para solventar un bug)
- `docs:` (Si modificas documentación como el README o diagramas)
- `refactor:` (Reescritura de código que ni arregla un bug ni añade una característica, ej: Provider -> Riverpod)
- `chore:` (Actualización de dependencias, scripts, etc.)

*Ejemplo:* `feat: crear servicio de Autenticación con JWT`

## 🛠️ Reglas del Código Arquitectónico
- **Backend:** Mantén estricta la arquitectura: `Controlador` recibe petición -> Pasa al `Servicio` (lógica) -> El Servicio consulta al `Repositorio` (BD). **No** metas lógica de negocio en los Controladores.
- **Frontend:** Mantén las vistas limpias. Si algo necesita procesamiento asíncrono o reglas lógicas, extráelo a su Provider/Servicio correspondiente y lee de ahí. ¡Evita los "Fat Widgets"!


