import 'package:flutter/material.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/widgets/add_task_dialog.dart';
import 'package:todo_app/widgets/task_item.dart';
import '../services/task_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TaskService taskService = TaskService();
  String filter = "all";
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List filteredTasks = taskService.tasks.where((task) {
      if (filter == "done") {
        return task.isDone;
      }

      if (filter == "pending") {
        return !task.isDone;
      }

      return true;
    }).toList();
    int completedTasks = taskService.tasks.where((task) => task.isDone).length;

    double progress = taskService.tasks.isEmpty
        ? 0
        : completedTasks / taskService.tasks.length;
        Color progressColor;

    if (progress < 0.4) {
      progressColor = Colors.red;
    } else if (progress < 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Column(
          children: [
            const Text("My Tasks"),
            Text(
              "${taskService.tasks.length} Tasks",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilterChip(
                label: const Text("All"),
                selected: filter == "all",
                onSelected: (value) {
                  setState(() {
                    filter = "all";
                  });
                },
              ),

              FilterChip(
                label: const Text("Done"),
                selected: filter == "done",
                onSelected: (value) {
                  setState(() {
                    filter = "done";
                  });
                },
              ),

              FilterChip(
                label: const Text("Pending"),
                selected: filter == "pending",
                onSelected: (value) {
                  setState(() {
                    filter = "pending";
                  });
                },
              ),
              
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$completedTasks / ${taskService.tasks.length} completed",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 0.0, end: progress),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: value,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(progressColor),
                        ),
                      );
                    },
                  )
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text(
                      "No Tasks Found",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final realIndex = taskService.tasks.indexOf(task);

                      return Dismissible(
                        key: Key(task.title + index.toString()),

                        direction: DismissDirection.horizontal,

                        onDismissed: (direction) {
                          final deletedTask = taskService.tasks[realIndex];
                          final deletedIndex = realIndex;

                          taskService.deleteTask(realIndex);
                          refresh();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${deletedTask.title} deleted"),

                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: () {
                                  setState(() {
                                    taskService.tasks.insert(
                                      deletedIndex,
                                      deletedTask,
                                    );
                                  });
                                },
                              ),

                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },

                        background: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        secondaryBackground: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        child: TaskItem(
                          task: task,
                          onToggle: () {
                            taskService.toggleTask(realIndex);
                            refresh();
                          },
                          onDelete: () {
                            taskService.deleteTask(realIndex);
                            ;
                            refresh();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          showAddTaskDialog(
            context,
            onAdd: (task) {
              taskService.addTask(task);
              refresh();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
