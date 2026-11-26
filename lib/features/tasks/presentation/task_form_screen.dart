import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  String _priority = 'Media';
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Selecciona una fecha límite (opcional)',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority,
      dueDate: _dueDate,
    );
    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
                hintText: 'Ej. Entregar laboratorio de Flutter',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) {
                  return 'El título es obligatorio. Escribe una actividad.';
                }
                if (title.length < 3) {
                  return 'El título es muy corto (mínimo 3 caracteres).';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                hintText: 'Agrega detalles o instrucciones...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Prioridad',
                border: OutlineInputBorder(),
              ),
              items: ['Alta', 'Media', 'Baja']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) =>
                  setState(() => _priority = value ?? 'Media'),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Theme.of(context).dividerColor),
              ),
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate == null
                    ? 'Fecha límite: Sin fecha (opcional)'
                    : 'Fecha límite: ${_formatDate(_dueDate!)}',
              ),
              trailing: _dueDate != null
                  ? IconButton(
                      tooltip: 'Quitar fecha',
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _dueDate = null),
                    )
                  : const Icon(Icons.edit_calendar),
              onTap: _pickDate,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Guardar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
