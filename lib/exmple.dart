import 'package:flutter/material.dart';

class ExamplePage extends StatefulWidget {
  const ExamplePage({Key? key}) : super(key: key);

  @override
  State<ExamplePage> createState() => _HomePageState();
}

class _HomePageState extends State<ExamplePage> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Task 1', 'description': 'This is task 1', 'isCompleted': false},
    {'title': 'Task 2', 'description': 'This is task 2', 'isCompleted': false},
  ];

  void _editTask(int index) {
    // Add edit logic
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Edit Task ${index + 1}')));
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index]['isCompleted'] = !_tasks[index]['isCompleted'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do App'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: _tasks[index]['isCompleted']
                  ? Colors.green.shade100
                  : Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: const Offset(3, 3),
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                // Left Column: Checkbox
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: _tasks[index]['isCompleted'],
                      onChanged: (value) {
                        _toggleComplete(index);
                      },
                    ),
                  ),
                ),
                // Middle Column: Title and Description
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tasks[index]['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _tasks[index]['isCompleted']
                                ? Colors.green
                                : Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _tasks[index]['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Column: Edit and Delete Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.orange,
                        onPressed: () {
                          _editTask(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _deleteTask(index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
