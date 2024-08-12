import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import '../providers/task_provider.dart';
import 'user_profile_page.dart';
import 'settings_page.dart';
import 'add_task_page.dart';
import 'delete_task_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    int completedTasks = taskProvider.tasks.where((task) => task['completed']).length;
    double progress = completedTasks / taskProvider.tasks.length;
    final userName = Provider.of<UserProvider>(context).name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar Sesión'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Save tasks
                await taskProvider.saveTasks();

                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Hola $userName, ten un buen día!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/avatar.png'), // Ensure you have an avatar image in assets
            ),
            SizedBox(height: 16),
            Text(DateFormat('dd \'de\' MMMM').format(DateTime.now()), style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Tareas', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(taskProvider.tasks[index]['task']),
                              trailing: taskProvider.tasks[index]['completed']
                                  ? Icon(Icons.check, color: Colors.green)
                                  : ElevatedButton(
                                onPressed: () => taskProvider.completeTask(index),
                                child: Text('Completar'),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      LinearProgressIndicator(value: progress),
                      SizedBox(height: 8),
                      Text('${(progress * 100).toStringAsFixed(0)}% completado'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTaskPage()),
                    );
                  },
                  child: Text('Agregar Tarea'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DeleteTaskPage()),
                    );
                  },
                  child: Text('Eliminar Tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}