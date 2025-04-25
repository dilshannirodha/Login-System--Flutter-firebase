import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'to_do_model.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  final _todoBox = Hive.box<Todo>('todos');
  final _controller = TextEditingController();

  void _addTodo(String title) {
    if (title.trim().isEmpty) return;
    _todoBox.add(Todo(title: title));
    _controller.clear();
  }

  void _toggleDone(Todo todo) {
    todo.isDone = !todo.isDone;
    todo.save();
  }

  void _deleteTodo(Todo todo) {
    todo.delete();
  }

  void _goToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To Do List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _goToSettings(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: _todoBox.listenable(),
                builder: (context, Box<Todo> box, _) {
                  if (box.values.isEmpty)
                    return Center(child: Text('No to-dos yet!'));

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final todo = box.getAt(index)!;
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration:
                                todo.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                          ),
                        ),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => _toggleDone(todo),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTodo(todo),
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Add a new to-do...',
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => _addTodo(_controller.text),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
