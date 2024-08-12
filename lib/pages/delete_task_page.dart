import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class DeleteTaskPage extends StatefulWidget {
  @override
  _DeleteTaskPageState createState() => _DeleteTaskPageState();
}

class _DeleteTaskPageState extends State<DeleteTaskPage> {
  final List<int> _selectedTasks = [];

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Eliminar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(taskProvider.tasks[index]['task']),
                    value: _selectedTasks.contains(index),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedTasks.add(index);
                        } else {
                          _selectedTasks.remove(index);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                taskProvider.deleteTasks(_selectedTasks);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}