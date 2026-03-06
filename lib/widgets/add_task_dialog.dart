import 'package:flutter/material.dart';

void showAddTaskDialog(
  BuildContext context, {
  required Function(String) onAdd,
}) {
  TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Add Task"),

        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter task"),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              onAdd(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
