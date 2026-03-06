import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/colors.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,

        decoration: BoxDecoration(
          color: task.isDone ? AppColors.done : AppColors.card,

          borderRadius: BorderRadius.circular(15),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ), child: ListTile(
          leading: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              onToggle();
            },
          ),

          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
            ),
          ),

          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
