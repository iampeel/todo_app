import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';
import 'add_todo_screen.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;

  const HomeScreen({super.key, required this.storageService});

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
    final todo = Todo(id: DateTime.now().toString(), title: title);

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
      appBar: AppBar(title: const Text('Todo App')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _todos.isEmpty
              ? const Center(child: Text('할 일을 추가해주세요'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return TodoItem(
                    todo: todo,
                    onToggle: () => _toggleTodo(todo.id),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<String>(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoScreen()),
          );

          if (result != null) {
            try {
              await _addTodo(result);
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('할 일이 추가되었습니다')));
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('할 일 추가에 실패했습니다')));
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
