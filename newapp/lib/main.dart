import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'to_do_model.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:newapp/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');
  
      runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        final isDarkMode = context.watch<ThemeProvider>().isDarkMode;


    return MaterialApp(
      title: 'Local To-Do App',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: HomePage(),
    );
  }
}
