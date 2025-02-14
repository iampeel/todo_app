import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;

  const HomeScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await widget.storageService.loadTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // 에러 처리는 다음 단계에서 구현
    }
  }

  Future<void> _addTodo(String title) async {
    final todo = Todo(
      id: DateTime.now().toString(),
      title: title,
    );

    setState(() {
      _todos.add(todo);
    });

    await widget.storageService.saveTodos(_todos);
  }

  Future<void> _toggleTodo(String id) async {
    setState(() {
      final todoIndex = _todos.indexWhere((todo) => todo.id == id);
      if (todoIndex != -1) {
        _todos[todoIndex].isCompleted = !_todos[todoIndex].isCompleted;
      }
    });

    await widget.storageService.saveTodos(_todos);
  }

  Future<void> _deleteTodo(String id) async {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
    });

    await widget.storageService.saveTodos(_todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Text('${_todos.length} todos loaded'),
      ),
    );
  }
}