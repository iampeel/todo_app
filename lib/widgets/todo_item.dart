import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../screens/edit_todo_screen.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final ValueChanged<String> onEdit;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          // ListTile을 InkWell로 감쌌습니다
          onTap: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (context) => EditTodoScreen(todo: todo),
              ),
            );
            if (result != null) {
              onEdit(result);
            }
          },
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
