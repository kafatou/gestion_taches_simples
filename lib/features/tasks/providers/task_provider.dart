import 'package:flutter/cupertino.dart';
import 'package:gestion_taches/features/tasks/data/task_service.dart';
import 'package:gestion_taches/utils/constants.dart';
import 'package:gestion_taches/utils/functions.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> alltasks = [];
  bool fromEdit = false;
  int indexTask = 0;
  bool getTasksFromData = true;

  bool researchOn = false;

  final TextEditingController nameTaskController = TextEditingController();
  final TextEditingController dateBeginTaskController = TextEditingController();
  final TextEditingController dateEndTaskController = TextEditingController();
  int index = 0;
  final listStatus = ["Complète", "Incomplète"];

  TaskService taskService = TaskService();

  final TextEditingController researchTaskController = TextEditingController();
  List tasks = []; // Sauvegarde des tâches originales

  // fonction permettant de rechercher une tâche sur la liste
  researchTask() {
    researchOn = true;
    tasks = List.from(alltasks); // Copie de sauvegarde
    alltasks.clear();
    for (Task task in tasks) {
      if (task.name!.contains(researchTaskController.text)) {
        alltasks.add(task);
      }
    }
    notifyListeners();
  }

  // fonction permettant de réinitialiser la liste de tâches après recherche
  resetResearch() {
    researchOn = false;
    alltasks = List.from(tasks); // Restauration
    researchTaskController.clear();
    notifyListeners();
  }

  // fonction permettant de récupérer la liste de toutes les tâches
  getTasks() {
    taskService.getAllTasks().then((value) {
      alltasks = value;
      getTasksFromData = false;
      notifyListeners();
    });
  }

  // fonction permettant d'ajouter/modifier une tâche
  addTask() async {
    Task task = Task(
      nameTaskController.text,
      listStatus[index],
      dateBeginTaskController.text,
      dateEndTaskController.text,
    );
    if (fromEdit) {
      await taskService.editTask(task, indexTask);
      alltasks[indexTask] = task;
    } else {
      await taskService.addTask(task);
      alltasks.add(task);
    }
    notifyListeners();
    resetVariables();
  }

  // fonction permettant de mettre à jour l'index du statut
  editIndexStatus(int newIndex) {
    index = newIndex;
    notifyListeners();
  }

  setFromEdit(bool val) {
    fromEdit = val;
    notifyListeners();
  }

  // fonction permettant de réinitialiser les variables
  resetVariables() {
    nameTaskController.clear();
    dateBeginTaskController.clear();
    dateEndTaskController.clear();
    index = 0;
  }

  // fonction permettant de supprimer une tâche
  deleteTask(int index) async {
    await taskService.deleteTask(index);
    alltasks.removeAt(index);
    showToastValide(Constants.deleteMsg);
    notifyListeners();
  }

  // fonction permettant de modifier une tâche
  editTask(int position) {
    Task task = alltasks[position];
    indexTask = position;
    nameTaskController.text =
        task.name ?? ''; // Utilisation d'opérateurs null-safe
    dateBeginTaskController.text = task.dateBegin ?? '';
    dateEndTaskController.text = task.dateEnd ?? '';
    if (task.status != null &&
        task.status!.isNotEmpty &&
        listStatus.contains(task.status)) {
      index = listStatus.indexOf(task.status!);
    } else {
      index = 0; // Valeur par défaut si le statut est null
    }
    fromEdit = true;
  }
}
