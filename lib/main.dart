import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  runApp(MyApp(storageService: storageService));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;

  const MyApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: HomeScreen(storageService: storageService),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final StorageService storageService;

  const MyHomePage({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Todo App')));
  }
}
