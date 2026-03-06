import '../models/task_model.dart';

class TaskService {
  final List<Task> tasks = [];

  void addTask(String title) {
    tasks.add(Task(title: title));
  }

  void toggleTask(int index) {
    tasks[index].isDone = !tasks[index].isDone;
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
  }
}
