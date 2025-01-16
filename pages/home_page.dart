import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'task_edit_screen.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  int _selectedIndex = 0; // Untuk melacak tab yang dipilih

  @override
  void initState() {
    super.initState();
    Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Tab Home
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome to DailyNotes!')),
      );
    } else if (index == 1) {
      // Tambah Task
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => TaskEditScreen()))
          .then((_) {
        Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      });
    } else if (index == 2) {
      // Lihat Task (Refresh)
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } else if (index == 3) {
      // Logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DailyNotes',
          style: GoogleFonts.poppins(
            fontSize: 23,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
      ),
      body: taskProvider.tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks available.',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            )
          : ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (ctx, index) {
                final task = taskProvider.tasks[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: task.isCompleted ? Colors.green[50] : Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted ? Colors.green : Colors.orange,
                      size: 30,
                    ),
                    title: Text(
                      task.title,
                      style: GoogleFonts.lora(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color:
                            task.isCompleted ? Colors.grey[600] : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      task.description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: task.isCompleted ? Colors.grey : Colors.black54,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await taskProvider.deleteTask(task.id!);
                      },
                    ),
                    onTap: () {
                      Navigator.of(ctx)
                          .push(MaterialPageRoute(
                        builder: (_) => TaskEditScreen(task: task),
                      ))
                          .then((_) {
                        taskProvider.fetchTasks();
                      });
                    },
                    onLongPress: () {
                      final updatedTask = Task(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        isCompleted: !task.isCompleted,
                      );
                      taskProvider.updateTask(updatedTask);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lihat Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Keluar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreenAccent[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
