import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [
    {'task': 'Hacer cama', 'completed': false},
    {'task': 'Lavar los platos', 'completed': false},
    {'task': 'Aseo en el living', 'completed': false},
    {'task': 'Limpiar el baño', 'completed': false},
    {'task': 'Limpiar ventanales', 'completed': false},
    {'task': 'Lavado de ropa', 'completed': false},
    {'task': 'Planchado', 'completed': false},
    {'task': 'Ordenado de ropa', 'completed': false},
    {'task': 'Hacer comida', 'completed': false},
    {'task': 'Desayuno, almuerzo y cena', 'completed': false},
  ];

  List<Map<String, dynamic>> get tasks => _tasks;

  void completeTask(int index) {
    _tasks[index]['completed'] = true;
    notifyListeners();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = _tasks.map((task) => jsonEncode(task)).toList();
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? tasks = prefs.getStringList('tasks');
    if (tasks != null) {
      _tasks = tasks.map((task) => jsonDecode(task) as Map<String, dynamic>).toList();
      notifyListeners();
    }
  }

  void addTask(String taskName) {
    _tasks.add({'task': taskName, 'completed': false});
    notifyListeners();
  }

  void deleteTasks(List<int> taskIndexes) {
    taskIndexes.sort((a, b) => b.compareTo(a));
    for (int index in taskIndexes) {
      _tasks.removeAt(index);
    }
    notifyListeners();
  }
}