# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas semanales y saber cuáles faltan por entregar.
Usuario objetivo: estudiante universitario que planifica entregas y evaluaciones.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

- Endpoint consultado:** `https://jsonplaceholder.typicode.com/todos`
- Parámetro de filtro:** `userId=2` (obtiene únicamente las tareas correspondientes al usuario 2).
- Campos recibidos desde la API:** `id` (`int`), `userId` (`int`), `title` (`String`) y `completed` (`bool`, asignado a `isCompleted`).
- Valores completados por defecto en TaskFlow:** como la API de práctica no incluye descripción ni prioridad, `Task.fromJson` asigna `'Sin descripción (API)'` a `description` y `'Sin prioridad (API)'` a `priority`.
- Alcance de actualización:** marcar una tarea como completada o pendiente modifica únicamente la copia en memoria dentro de `RemoteTaskRepository`; al reiniciar la aplicación, las tareas vuelven a su estado original en el servidor.

## Estados de la lista remota

TaskFlow maneja cuatro estados explícitos en `TasksViewModel` y `TaskListScreen`:

1. Carga (`isLoading`): se activa al iniciar `loadTasks()` o al pulsar el botón/gesto de actualización. Muestra un `CircularProgressIndicator` y bloquea peticiones simultáneas.
2. Éxito (`tasks` con elementos): muestra las tarjetas dentro de un `RefreshIndicator` que permite recargar deslizando hacia abajo y navegar al detalle por `id`.
3. Vacío (`isEmpty`): ocurre cuando la petición responde `HTTP 200` con una lista `[]`. Se comprobó cambiando temporalmente `userId = 9999` en `TaskApiService`; muestra el mensaje de ausencia de tareas y el botón **Actualizar**.
4. Error (`errorMessage`): ocurre ante fallos de red o servidor. Se comprobó desactivando la conexión a Internet del dispositivo y pulsando actualizar; muestra el mensaje de error y el botón **Reintentar**, que recupera los datos al restablecer la red sin reiniciar la aplicación.

## Formulario de tareas

- Ruta: `/new` (`TaskFormScreen`), accesible desde el botón flotante **Nueva tarea** en la lista principal.
- Validaciones: exige un título no vacío de al menos 3 caracteres mediante `GlobalKey<FormState>` antes de construir el borrador (`TaskDraft`).
- Campos disponibles: título obligatorio, descripción opcional, selector de prioridad (`Alta`, `Media`, `Baja`) y selector opcional de fecha límite mediante `showDatePicker`.
- Retorno de datos: al validar correctamente, `context.pop(draft)` devuelve el borrador a la pantalla anterior y muestra un `SnackBar` de confirmación sin enviar aún peticiones `POST` a la API.