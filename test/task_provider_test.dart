import 'package:flutter_test/flutter_test.dart';
import 'package:gestion_taches/features/tasks/providers/task_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:gestion_taches/features/tasks/data/task_service.dart';
import 'package:gestion_taches/features/tasks/models/task_model.dart';

// Générez les mocks avec: flutter packages pub run build_runner build
@GenerateMocks([TaskService])
import 'task_provider_test.mocks.dart';

void main() {
  group('TaskProvider Tests', () {
    late TaskProvider taskProvider;
    late MockTaskService mockTaskService;

    setUp(() {
      taskProvider = TaskProvider();
      mockTaskService = MockTaskService();
      taskProvider.taskService = mockTaskService;
    });

    tearDown(() {
      taskProvider.dispose();
    });

    group('Initialization', () {
      test('should initialize with correct default values', () {
        expect(taskProvider.alltasks, isEmpty);
        expect(taskProvider.fromEdit, false);
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.getTasksFromData, true);
        expect(taskProvider.researchOn, false);
        expect(taskProvider.index, 0);
        expect(taskProvider.listStatus, ["Complète", "Incomplète"]);
        expect(taskProvider.tasks, isEmpty);
      });

      test('should initialize controllers with empty text', () {
        expect(taskProvider.nameTaskController.text, isEmpty);
        expect(taskProvider.dateBeginTaskController.text, isEmpty);
        expect(taskProvider.dateEndTaskController.text, isEmpty);
        expect(taskProvider.researchTaskController.text, isEmpty);
      });
    });

    group('getTasks', () {
      test('should get all tasks from service and update state', () async {
        // Arrange
        final mockTasks = [
          Task('Task 1', 'Complète', '2024-01-01', '2024-01-02'),
          Task('Task 2', 'Incomplète', '2024-01-03', '2024-01-04'),
        ];
        when(mockTaskService.getAllTasks()).thenAnswer((_) async => mockTasks);

        // Act
        await taskProvider.getTasks();

        // Assert
        expect(taskProvider.alltasks, mockTasks);
        expect(taskProvider.getTasksFromData, false);
        verify(mockTaskService.getAllTasks()).called(1);
      });
    });

    group('Research functionality', () {
      setUp(() {
        taskProvider.alltasks = [
          Task('Flutter Task', 'Complète', '2024-01-01', '2024-01-02'),
          Task('Android Task', 'Incomplète', '2024-01-03', '2024-01-04'),
          Task('Flutter Development', 'Complète', '2024-01-05', '2024-01-06'),
        ];
      });

      test('should filter tasks based on search term', () {
        // Arrange
        taskProvider.researchTaskController.text = 'Flutter';

        // Act
        taskProvider.researchTask();

        // Assert
        expect(taskProvider.researchOn, true);
        expect(taskProvider.alltasks.length, 2);
        expect(taskProvider.alltasks[0].name, 'Flutter Task');
        expect(taskProvider.alltasks[1].name, 'Flutter Development');
      });

      test('should return empty list when no tasks match search', () {
        // Arrange
        taskProvider.researchTaskController.text = 'iOS';

        // Act
        taskProvider.researchTask();

        // Assert
        expect(taskProvider.researchOn, true);
        expect(taskProvider.alltasks, isEmpty);
      });

      test('should reset research and restore original task list', () {
        // Arrange
        taskProvider.researchTaskController.text = 'Flutter';
        taskProvider.researchTask();
        final originalTasksCount = taskProvider.tasks.length;

        // Act
        taskProvider.resetResearch();

        // Assert
        expect(taskProvider.researchOn, false);
        expect(taskProvider.alltasks.length, originalTasksCount);
        expect(taskProvider.researchTaskController.text, isEmpty);
      });
    });

    group('editIndexStatus', () {
      test('should update index and notify listeners', () {
        // Arrange
        bool notified = false;
        taskProvider.addListener(() => notified = true);

        // Act
        taskProvider.editIndexStatus(1);

        // Assert
        expect(taskProvider.index, 1);
        expect(notified, true);
      });
    });

    group('resetVariables', () {
      test('should reset all form variables to default state', () {
        // Arrange
        taskProvider.nameTaskController.text = 'Test Task';
        taskProvider.dateBeginTaskController.text = '2024-01-01';
        taskProvider.dateEndTaskController.text = '2024-01-02';
        taskProvider.fromEdit = true;
        taskProvider.index = 1;

        // Act
        taskProvider.resetVariables();

        // Assert
        expect(taskProvider.nameTaskController.text, isEmpty);
        expect(taskProvider.dateBeginTaskController.text, isEmpty);
        expect(taskProvider.dateEndTaskController.text, isEmpty);
        expect(taskProvider.fromEdit, false);
        expect(taskProvider.index, 0);
      });
    });

    group('addTask', () {
      test('should add new task when not in edit mode', () async {
        // Arrange
        when(mockTaskService.addTask(any)).thenAnswer((_) async => {});

        taskProvider.nameTaskController.text = 'New Task';
        taskProvider.dateBeginTaskController.text = '2024-01-01';
        taskProvider.dateEndTaskController.text = '2024-01-02';
        taskProvider.index = 0;
        taskProvider.fromEdit = false; // Mode ajout

        bool notified = false;
        taskProvider.addListener(() => notified = true);

        // Act
        await taskProvider.addTask();

        // Assert
        expect(taskProvider.alltasks.length, 1);
        expect(taskProvider.alltasks[0].name, 'New Task');
        expect(taskProvider.alltasks[0].status, 'Complète'); // listStatus[0]
        expect(taskProvider.alltasks[0].dateBegin, '2024-01-01');
        expect(taskProvider.alltasks[0].dateEnd, '2024-01-02');
        expect(taskProvider.fromEdit, false); // Reset par resetVariables()
        expect(taskProvider.index, 0); // Reset par resetVariables()
        expect(notified, true); // notifyListeners() appelé
        verify(mockTaskService.addTask(any)).called(1);
      });

      test('should edit existing task when in edit mode', () async {
        // Arrange
        when(mockTaskService.editTask(any, any)).thenAnswer((_) async => {});

        // Setup initial task
        taskProvider.alltasks = [
          Task('Original Task', 'Complète', '2024-01-01', '2024-01-02'),
        ];

        // Setup edit mode
        taskProvider.fromEdit = true;
        taskProvider.indexTask = 0;
        taskProvider.nameTaskController.text = 'Updated Task';
        taskProvider.dateBeginTaskController.text = '2024-01-03';
        taskProvider.dateEndTaskController.text = '2024-01-04';
        taskProvider.index = 1; // 'Incomplète'

        bool notified = false;
        taskProvider.addListener(() => notified = true);

        // Act
        await taskProvider.addTask();

        // Assert
        expect(
          taskProvider.alltasks.length,
          1,
        ); // Pas d'ajout, juste modification
        expect(taskProvider.alltasks[0].name, 'Updated Task');
        expect(taskProvider.alltasks[0].status, 'Incomplète'); // listStatus[1]
        expect(taskProvider.alltasks[0].dateBegin, '2024-01-03');
        expect(taskProvider.alltasks[0].dateEnd, '2024-01-04');
        expect(taskProvider.fromEdit, false); // Reset par resetVariables()
        expect(taskProvider.index, 0); // Reset par resetVariables()
        expect(notified, true); // notifyListeners() appelé
        verify(mockTaskService.editTask(any, 0)).called(1);
      });

      test('should create task with correct status based on index', () async {
        // Arrange
        when(mockTaskService.addTask(any)).thenAnswer((_) async => {});

        taskProvider.nameTaskController.text = 'Status Test Task';
        taskProvider.dateBeginTaskController.text = '2024-01-01';
        taskProvider.dateEndTaskController.text = '2024-01-02';
        taskProvider.index = 1; // 'Incomplète'
        taskProvider.fromEdit = false;

        // Act
        await taskProvider.addTask();

        // Assert
        expect(taskProvider.alltasks.length, 1);
        expect(taskProvider.alltasks[0].status, 'Incomplète'); // listStatus[1]
        verify(mockTaskService.addTask(any)).called(1);
      });

      test('should handle empty text fields', () async {
        // Arrange
        when(mockTaskService.addTask(any)).thenAnswer((_) async => {});

        taskProvider.nameTaskController.text = '';
        taskProvider.dateBeginTaskController.text = '';
        taskProvider.dateEndTaskController.text = '';
        taskProvider.index = 0;
        taskProvider.fromEdit = false;

        // Act
        await taskProvider.addTask();

        // Assert
        expect(taskProvider.alltasks.length, 1);
        expect(taskProvider.alltasks[0].name, ''); // Chaîne vide
        expect(taskProvider.alltasks[0].dateBegin, '');
        expect(taskProvider.alltasks[0].dateEnd, '');
        expect(taskProvider.alltasks[0].status, 'Complète');
        verify(mockTaskService.addTask(any)).called(1);
      });

      test('should reset variables after adding task', () async {
        // Arrange
        when(mockTaskService.addTask(any)).thenAnswer((_) async => {});

        taskProvider.nameTaskController.text = 'Test Task';
        taskProvider.dateBeginTaskController.text = '2024-01-01';
        taskProvider.dateEndTaskController.text = '2024-01-02';
        taskProvider.index = 1;
        taskProvider.fromEdit = false;

        // Act
        await taskProvider.addTask();

        // Assert - Variables should be reset
        expect(taskProvider.nameTaskController.text, '');
        expect(taskProvider.dateBeginTaskController.text, '');
        expect(taskProvider.dateEndTaskController.text, '');
        expect(taskProvider.fromEdit, false);
        expect(taskProvider.index, 0);
      });

      test('should reset variables after editing task', () async {
        // Arrange
        when(mockTaskService.editTask(any, any)).thenAnswer((_) async => {});

        taskProvider.alltasks = [
          Task('Original Task', 'Complète', '2024-01-01', '2024-01-02'),
        ];

        taskProvider.fromEdit = true;
        taskProvider.indexTask = 0;
        taskProvider.nameTaskController.text = 'Updated Task';
        taskProvider.dateBeginTaskController.text = '2024-01-03';
        taskProvider.dateEndTaskController.text = '2024-01-04';
        taskProvider.index = 1;

        // Act
        await taskProvider.addTask();

        // Assert - Variables should be reset
        expect(taskProvider.nameTaskController.text, '');
        expect(taskProvider.dateBeginTaskController.text, '');
        expect(taskProvider.dateEndTaskController.text, '');
        expect(taskProvider.fromEdit, false);
        expect(taskProvider.index, 0);
      });

      test('should update task at correct index during edit', () async {
        // Arrange
        when(mockTaskService.editTask(any, any)).thenAnswer((_) async => {});

        taskProvider.alltasks = [
          Task('Task 1', 'Complète', '2024-01-01', '2024-01-02'),
          Task('Task 2', 'Incomplète', '2024-01-03', '2024-01-04'),
          Task('Task 3', 'Complète', '2024-01-05', '2024-01-06'),
        ];

        // Edit middle task (index 1)
        taskProvider.fromEdit = true;
        taskProvider.indexTask = 1;
        taskProvider.nameTaskController.text = 'Modified Task 2';
        taskProvider.dateBeginTaskController.text = '2024-01-10';
        taskProvider.dateEndTaskController.text = '2024-01-11';
        taskProvider.index = 0; // Change status to 'Complète'

        // Act
        await taskProvider.addTask();

        // Assert
        expect(taskProvider.alltasks.length, 3); // No new task added
        expect(taskProvider.alltasks[0].name, 'Task 1'); // Unchanged
        expect(taskProvider.alltasks[1].name, 'Modified Task 2'); // Changed
        expect(taskProvider.alltasks[1].status, 'Complète'); // Status changed
        expect(
          taskProvider.alltasks[1].dateBegin,
          '2024-01-10',
        ); // Date changed
        expect(taskProvider.alltasks[2].name, 'Task 3'); // Unchanged
        verify(mockTaskService.editTask(any, 1)).called(1);
      });

      test('should notify listeners exactly once', () async {
        // Arrange
        when(mockTaskService.addTask(any)).thenAnswer((_) async => {});

        taskProvider.nameTaskController.text = 'Test Task';
        taskProvider.fromEdit = false;

        int notificationCount = 0;
        taskProvider.addListener(() => notificationCount++);

        // Act
        await taskProvider.addTask();

        // Assert
        expect(notificationCount, 1); // notifyListeners() called once
      });

      test('should handle service errors gracefully', () async {
        // Arrange
        when(
          mockTaskService.addTask(any),
        ).thenThrow(Exception('Service error'));

        taskProvider.nameTaskController.text = 'Test Task';
        taskProvider.fromEdit = false;

        // Act & Assert
        expect(() async => await taskProvider.addTask(), throwsException);

        // Variables should still be reset even if service fails
        // (This depends on your error handling implementation)
        verify(mockTaskService.addTask(any)).called(1);
      });
    });

    group('deleteTask', () {
      test('should delete task at specified index', () async {
        // Arrange
        when(mockTaskService.deleteTask(any)).thenAnswer((_) async => {});

        taskProvider.alltasks = [
          Task('Task 1', 'Complète', '2024-01-01', '2024-01-02'),
          Task('Task 2', 'Incomplète', '2024-01-03', '2024-01-04'),
        ];

        // Act
        await taskProvider.deleteTask(0);

        // Assert
        expect(taskProvider.alltasks.length, 1);
        expect(taskProvider.alltasks[0].name, 'Task 2');
        verify(mockTaskService.deleteTask(0)).called(1);
      });
    });

    group('editTask', () {
      test('should populate form fields with task data for editing', () {
        // Arrange
        final task = Task(
          'Edit Task',
          'Incomplète',
          '2024-01-01',
          '2024-01-02',
        );
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.nameTaskController.text, 'Edit Task');
        expect(taskProvider.dateBeginTaskController.text, '2024-01-01');
        expect(taskProvider.dateEndTaskController.text, '2024-01-02');
        expect(taskProvider.index, 1); // 'Incomplète' is at index 1
        expect(taskProvider.fromEdit, true);
      });

      test('should handle task with null name', () {
        // Arrange
        final task = Task(null, 'Complète', '2024-01-01', '2024-01-02');
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(
          taskProvider.nameTaskController.text,
          '',
        ); // null devient chaîne vide
        expect(taskProvider.dateBeginTaskController.text, '2024-01-01');
        expect(taskProvider.dateEndTaskController.text, '2024-01-02');
        expect(taskProvider.index, 0); // 'Complète' is at index 0
        expect(taskProvider.fromEdit, true);
      });

      test('should handle task with null dates', () {
        // Arrange
        final task = Task('Test Task', 'Incomplète', null, null);
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.nameTaskController.text, 'Test Task');
        expect(
          taskProvider.dateBeginTaskController.text,
          '',
        ); // null devient chaîne vide
        expect(
          taskProvider.dateEndTaskController.text,
          '',
        ); // null devient chaîne vide
        expect(taskProvider.index, 1); // 'Incomplète' is at index 1
        expect(taskProvider.fromEdit, true);
      });

      test('should handle task with null status', () {
        // Arrange
        final task = Task('Test Task', null, '2024-01-01', '2024-01-02');
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.nameTaskController.text, 'Test Task');
        expect(taskProvider.dateBeginTaskController.text, '2024-01-01');
        expect(taskProvider.dateEndTaskController.text, '2024-01-02');
        expect(
          taskProvider.index,
          0,
        ); // Valeur par défaut quand status est null
        expect(taskProvider.fromEdit, true);
      });

      test('should handle task with empty string values', () {
        // Arrange
        final task = Task('', '', '', '');
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.nameTaskController.text, '');
        expect(taskProvider.dateBeginTaskController.text, '');
        expect(taskProvider.dateEndTaskController.text, '');
        expect(
          taskProvider.index,
          0,
        ); // Valeur par défaut car '' n'est pas dans listStatus
        expect(taskProvider.fromEdit, true);
      });

      test('should handle task with invalid status', () {
        // Arrange
        final task = Task(
          'Test Task',
          'Status Invalide',
          '2024-01-01',
          '2024-01-02',
        );
        taskProvider.alltasks = [task];

        // Act
        taskProvider.editTask(0);

        // Assert
        expect(taskProvider.indexTask, 0);
        expect(taskProvider.nameTaskController.text, 'Test Task');
        expect(taskProvider.dateBeginTaskController.text, '2024-01-01');
        expect(taskProvider.dateEndTaskController.text, '2024-01-02');
        expect(
          taskProvider.index,
          0,
        ); // Valeur par défaut car status n'est pas trouvé
        expect(taskProvider.fromEdit, true);
      });

      test('should handle valid position at end of list', () {
        // Arrange
        final tasks = [
          Task('Task 1', 'Complète', '2024-01-01', '2024-01-02'),
          Task('Task 2', 'Incomplète', '2024-01-03', '2024-01-04'),
          Task('Last Task', 'Complète', '2024-01-05', '2024-01-06'),
        ];
        taskProvider.alltasks = tasks;

        // Act
        taskProvider.editTask(2); // Dernière position

        // Assert
        expect(taskProvider.indexTask, 2);
        expect(taskProvider.nameTaskController.text, 'Last Task');
        expect(taskProvider.dateBeginTaskController.text, '2024-01-05');
        expect(taskProvider.dateEndTaskController.text, '2024-01-06');
        expect(taskProvider.index, 0); // 'Complète' is at index 0
        expect(taskProvider.fromEdit, true);
      });

      test('should preserve previous form state when called multiple times', () {
        // Arrange
        final task1 = Task(
          'First Task',
          'Complète',
          '2024-01-01',
          '2024-01-02',
        );
        final task2 = Task(
          'Second Task',
          'Incomplète',
          '2024-01-03',
          '2024-01-04',
        );
        taskProvider.alltasks = [task1, task2];

        // Act - Premier appel
        taskProvider.editTask(0);
        expect(taskProvider.nameTaskController.text, 'First Task');

        // Act - Deuxième appel avec une autre tâche
        taskProvider.editTask(1);

        // Assert - Vérifier que les nouvelles valeurs remplacent les anciennes
        expect(taskProvider.indexTask, 1);
        expect(taskProvider.nameTaskController.text, 'Second Task');
        expect(taskProvider.dateBeginTaskController.text, '2024-01-03');
        expect(taskProvider.dateEndTaskController.text, '2024-01-04');
        expect(taskProvider.index, 1); // 'Incomplète' is at index 1
        expect(taskProvider.fromEdit, true);
      });
      
    });

    group('ChangeNotifier', () {
      test('should notify listeners when tasks are updated', () async {
        // Arrange
        bool notified = false;
        taskProvider.addListener(() => notified = true);
        when(mockTaskService.getAllTasks()).thenAnswer((_) async => []);

        // Act
        await taskProvider.getTasks();

        // Assert
        expect(notified, true);
      });

      test('should notify listeners when research is performed', () {
        // Arrange
        bool notified = false;
        taskProvider.addListener(() => notified = true);

        // Act
        taskProvider.researchTask();

        // Assert
        expect(notified, true);
      });

      test('should notify listeners when research is reset', () {
        // Arrange
        bool notified = false;
        taskProvider.addListener(() => notified = true);

        // Act
        taskProvider.resetResearch();

        // Assert
        expect(notified, true);
      });
    });
  });
}
