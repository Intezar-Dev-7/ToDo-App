import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/db_functions.dart';
import 'package:to_do_app/provider/db_provider.dart';
import 'package:to_do_app/provider/theme_provider.dart';
import 'package:to_do_app/screens/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (context) => DBProvider(notesDatabase: NotesDatabase.getInstance),
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      themeMode:
          context.watch<ThemeProvider>().getThemeValue()
              ? ThemeMode.dark
              : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
