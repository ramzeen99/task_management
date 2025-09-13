import 'package:test/test.dart';
import 'package:task_management/task_management.dart';

void main() {
  group('TaskManager', (){
    late TaskManager taskManager;

    setUp((){
      taskManager = TaskManager();
    });
    test('Ajouter une tâche',(){
      taskManager.addTask('Test Task', 'Test Description');
      expect(taskManager.allTasks.length, 1);
      expect(taskManager.allTasks[0].title, 'Test Task');
    });
    test('Ne peut pas ajouter une tâche avec un tittre vide', (){
      expect(() => taskManager.addTask('', 'Description'), throwsArgumentError);
    });

    test('Marquer une tâche comme complétée', (){
      taskManager.addTask('Test Task', 'Test Description');
      taskManager.markTaskAsCompleted(1);
      expect(taskManager.completedTasks.length, 1);
      expect(taskManager.allTasks[0].isCompleted, true);
    });

    test('Supprimer une tâche',(){
      taskManager.addTask('Test Task', 'Test Description');
      taskManager.deleteTask(1);
      expect(taskManager.allTasks.length, 0) ;
    });
     test('Rechercher des tâches', (){
      taskManager.addTask('Faire les courses', 'Acheter du lait');
      taskManager.addTask('Appeler jean', 'Discuter du projet');

      print("Tâches ajoutées: ${taskManager.allTasks.length}");
      print("Titres: ${taskManager.allTasks.map((t)=> t.title).toList()}");

      final results = taskManager.searchTasks('courses');
      print("Resultats de recherche: ${results.length}");
      print("Résultats: ${results.map((r) => r.title).toList()}");

      expect(results.length, 1);
      //expect(results[0].title, 'Faire les course');
     });

     test('Statistiques', (){
      taskManager.addTask('Tâche 1', 'Description 1');
      taskManager.addTask('Tâche 2', 'Description 2');
      taskManager.markTaskAsCompleted(1);

      expect(taskManager.totalTasks, 2);
      expect(taskManager.completedTasksCount, 1);
     });
  });
}