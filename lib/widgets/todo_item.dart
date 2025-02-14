import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete; // 추가

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete, // 추가
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todo.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('할 일 삭제'),
                content: const Text('이 할 일을 삭제하시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      '삭제',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );
      },
      onDismissed: (direction) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors:
                  todo.isCompleted
                      ? [Colors.grey.shade200, Colors.grey.shade100]
                      : [Colors.blue.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => onToggle(),
            ),
            title: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 16,
                decoration:
                    todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                color: todo.isCompleted ? Colors.grey : Colors.black,
              ),
              child: Text(todo.title),
            ),
          ),
        ),
      ),
    );
  }
}
