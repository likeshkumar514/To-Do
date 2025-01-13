import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_bangl/Models/task.dart';
import 'package:http/http.dart' as http;

import 'package:to_do_bangl/Screens/Auth/auth_service.dart';
import 'package:to_do_bangl/Screens/Auth/login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final String baseUrl =
      "https://to-do-app-eee33-default-rtdb.asia-southeast1.firebasedatabase.app";

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final url = Uri.parse('$baseUrl/tasks.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          setState(() {
            _tasks = (data as Map<String, dynamic>).entries.map((entry) {
              final task = Task.fromJson(entry.value);
              task.id = entry.key; // Assigning Firebase ID for future updates
              return task;
            }).toList();
          });
        }
      } else {
        _showToast("Failed to fetch tasks. Try again later.", Colors.red);
      }
    } catch (error) {
      _showToast("An error occurred: $error", Colors.red);
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksJson = jsonEncode(_tasks);
    prefs.setString('tasks', tasksJson);
  }

  Future<void> _addTask() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showToast("Title and Description are required", Colors.red);
      return;
    }

    final url = Uri.parse('$baseUrl/tasks.json');
    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: false,
    );

    try {
      final response = await http.post(
        url,
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        _showToast("Task added successfully", Colors.green);
        _fetchTasks(); // Refresh tasks from database
        _titleController.clear();
        _descriptionController.clear();
      } else {
        _showToast("Failed to add task", Colors.red);
      }
    } catch (error) {
      _showToast("An error occurred: $error", Colors.red);
    }
  }

  Future<void> _updateTask(Task task) async {
    if (task.id == null) return;

    final url = Uri.parse('$baseUrl/tasks/${task.id}.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode(task.toJson()),
      );
      if (response.statusCode == 200) {
        _showToast("Task updated successfully", Colors.green);
        _fetchTasks(); // Refresh tasks from database
      } else {
        _showToast("Failed to update task", Colors.red);
      }
    } catch (error) {
      _showToast("An error occurred: $error", Colors.red);
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final url = Uri.parse('$baseUrl/tasks/$taskId.json');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        _showToast("Task deleted successfully", Colors.red);
        _fetchTasks(); // Refresh tasks from database
      } else {
        _showToast("Failed to delete task", Colors.red);
      }
    } catch (error) {
      _showToast("An error occurred: $error", Colors.red);
    }
  }

  void _toggleTaskCompletion(Task task) {
    task.isCompleted = !task.isCompleted;
    _updateTask(task);
  }

  void _showDeleteDialog(int index) {
    final taskId = _tasks[index].id; // Get the task ID
    if (taskId == null) {
      _showToast("Unable to delete. Task ID not found.", Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTask(taskId); // Pass the task ID to delete
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showTaskBottomSheet({Task? task}) {
    if (task != null) {
      _titleController.text = task.title;
      _descriptionController.text = task.description;
    } else {
      _titleController.clear();
      _descriptionController.clear();
    }

    showModalBottomSheet(
      backgroundColor: Colors.green[50],
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task == null ? 'Add Task' : 'Edit Task',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (task == null) {
                          _addTask();
                        } else {
                          task.title = _titleController.text;
                          task.description = _descriptionController.text;
                          _updateTask(task);
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(task == null ? 'Add' : 'Save'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginPage()));

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[100],
        actions: [
          TextButton(
              onPressed: () async {
                await _auth.signout();

                // Reset login state
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);

                goToLogin(context);
              },
              child: Text(
                "Signout",
                style: TextStyle(color: Colors.black),
              ))
        ],
        title: Text('To-Do List'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Dismissible(
            key: Key(task.hashCode.toString()),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.green[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Text(
                      "Are you sure you want to delete this task?",
                      style: TextStyle(color: Colors.deepPurple.shade800),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                        ),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              _deleteTask(task.id!);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: task.isCompleted ? Colors.green[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Please swipe left or right to delete task",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: (value) {
                            _toggleTaskCompletion(task);
                          },
                        ),
                      ),
                      // Title and Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              task.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Edit and Delete Icons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, size: 20),
                            onPressed: () {
                              _showTaskBottomSheet(task: task);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () {
                              _showDeleteDialog(index);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
