import 'package:flutter/material.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:provider/provider.dart';

class TaskEditScreen extends StatefulWidget {
  final Task? task;
  TaskEditScreen({this.task});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  void _saveTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) return;

    final task = Task(
      id: widget.task?.id,
      title: title,
      description: description,
      isCompleted: _isCompleted,
    );

    if (widget.task == null) {
      // Menambahkan task baru
      Provider.of<TaskProvider>(context, listen: false).addTask(task);
    } else {
      // Memperbarui task
      Provider.of<TaskProvider>(context, listen: false).updateTask(task);
    }

    Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Judul Task
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul Task',
                    labelStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Input Deskripsi Task
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Task',
                    labelStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            // Switch untuk Completed
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.all(10),
                title: Text(
                  'Sudah Selesai',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                value: _isCompleted,
                onChanged: (value) {
                  setState(() {
                    _isCompleted = value;
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            // Tombol Add / Save Changes
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                widget.task == null ? 'Tambah Task' : 'Simpan Perubahan',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
