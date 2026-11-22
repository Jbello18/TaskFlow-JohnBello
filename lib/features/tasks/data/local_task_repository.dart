import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Entregar laboratorio de Flutter',
      description: 'Subir el modelo Task y la arquitectura MVVM al repositorio',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Estudiar para examen de Base de Datos',
      description: 'Repasar consultas SQL, índices y normalización de tablas',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Configurar rutas con go_router',
      description: 'Verificar navegación entre lista y detalle de la sesión 4',
      priority: 'Baja',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Diseñar bocetos de pantalla',
      description: 'Definir estructura de lista, detalle y futuro formulario',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Documentar contrato de API REST',
      description: 'Listar endpoints GET, POST, PATCH y DELETE en el README',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
