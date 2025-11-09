import 'package:flutter/material.dart';
import '../model/todo.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const ToDoItem({
    Key? key,
    required this.todo,
    this.onToggle,
    this.onDelete,
  }) : super(key: key);

  Widget _buildLeading() {
    // Circular mini avatar that shows a check icon when done
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: todo.isDone ? Colors.indigo : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Center(
        child: todo.isDone
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Icon(Icons.circle, color: Colors.grey.shade400, size: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildLeading(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  todo.todoText,
                  style: TextStyle(
                    fontSize: 16,
                    color: todo.isDone
                        ? Colors.grey.shade600
                        : Colors.grey.shade900,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
