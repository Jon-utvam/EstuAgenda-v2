import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/materias_tareas_screen.dart'; 

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EsTuAgenda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MateriasTareasScreen(), 
    );
  }
}