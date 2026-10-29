import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Datos del usuario y curso
  final String studentName = 'John'; // Reemplaza con tu nombre
  final String courseName = 'Desarrollo de Aplicaciones Móviles';
  final String motivationalMessage = '¡Paso a paso construimos grandes ideas!';

  // Estado de tareas
  int pendingTasks = 5;
  int completedTasks = 0;
  static const int dailyGoal = 5;

  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  void _completeTask() {
    if (pendingTasks == 0) return;

    setState(() {
      pendingTasks--;
      completedTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.task_alt,
                size: 56,
                color: Colors.indigo,
              ), // Ícono de la app
              const SizedBox(height: 16),
              Text(
                '¡Hola, $studentName!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                motivationalMessage, // Mensaje motivacional mostrado debajo del saludo
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                statusMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.pending_actions,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Tareas pendientes: $pendingTasks',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 12),
                          Text(
                            'Completadas hoy: $completedTasks de $dailyGoal',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tarea'),
                  ),
                  OutlinedButton.icon(
                    onPressed: pendingTasks == 0 ? null : _completeTask,
                    icon: const Icon(Icons.done),
                    label: const Text('Completar una tarea'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
