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
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final todos = await widget.storageService.loadTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '할 일을 불러오는데 실패했습니다.';
        _isLoading = false;
      });
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

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('할 일을 불러오는 중...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadTodos, child: const Text('다시 시도')),
          ],
        ),
      );
    }

    if (_todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('할 일이 없습니다.'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return TodoItem(
          todo: todo,
          onToggle: () => _toggleTodo(todo.id),
          onDelete: () => _deleteTodo(todo.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          if (_error != null)
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTodos),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _error != null
                ? null
                : () async {
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTodoScreen(),
                    ),
                  );

                  if (result != null) {
                    try {
                      await _addTodo(result);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('할 일이 추가되었습니다')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('할 일 추가에 실패했습니다'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
        child: const Icon(Icons.add),
      ),
    );
  }
}
