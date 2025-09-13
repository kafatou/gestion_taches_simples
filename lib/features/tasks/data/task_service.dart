import 'package:gestion_taches/features/tasks/models/task_model.dart';
import 'package:hive_ce/hive.dart';

class TaskService {
  initializeBox() async {
    return await Hive.openBox('Tasks');
  }

  Future<List<Task>> getAllTasks() async {
    final box = await initializeBox();
    final List<Task> tasks = await box.values.toList().cast<Task>();
    return tasks;
  }

  addTask(Task task) async {
    var box = await initializeBox();
    await box.add(task);
  }

  editTask(final Task task, int index) async {
    var box = await initializeBox();
    await box.putAt(index, task);
  }

  deleteTask(int index) async {
    var box = await initializeBox();
    await box.deleteAt(index);
  }
}
