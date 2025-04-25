import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'to_do_model.dart';
import 'package:newapp/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _selectedSort = 'By Date';

  final List<String> _sortOptions = ['By Date', 'By Title', 'By Completed'];

  void _clearAllTodos() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Confirm'),
            content: Text('Are you sure you want to delete all todos?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Yes, delete all'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final todoBox = Hive.box<Todo>('todos');
      await todoBox.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All todos cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: context.watch<ThemeProvider>().isDarkMode,
            onChanged: (val) => context.read<ThemeProvider>().toggleTheme(),
          ),
          ListTile(
            title: Text('Sort Todos'),
            trailing: DropdownButton<String>(
              value: _selectedSort,
              items:
                  _sortOptions
                      .map(
                        (option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ),
                      )
                      .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedSort = val;
                  });
                }
              },
            ),
          ),
          ListTile(
            title: Text('Clear All Todos'),
            trailing: Icon(Icons.delete_forever, color: Colors.red),
            onTap: _clearAllTodos,
          ),
          AboutListTile(
            icon: Icon(Icons.info),
            applicationName: 'To Do App',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2025 dilshan',
          ),
        ],
      ),
    );
  }
}
