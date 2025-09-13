import 'dart:convert';
import 'dart:io';
//import 'package:path/path.dart' as path;
import 'task.dart';
import 'task_management.dart';

class TaskStorage {
  static Future<String> get _localPath async {
    final directory = Directory.current;
    return directory.path;  
  }
  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('${path}/tasks.json');
  }
  static Future<void> saveTasks(TaskManager manager) async {
    try {
      final file = await _localFile;
      final tasksJson =  manager.allTasks.map((task) => task.toJson()).toList();
      final jsonString = jsonEncode(tasksJson);
      await file.writeAsString(jsonString);
      print('Tâches sauvegardées avec succès!');
    }catch (e){
      print('Erreur lors de la sauvegarde: $e');
    }
  }
  static Future<TaskManager> loadTasks() async {
    try {
      final file = await _localFile;

      if (!await file.exists()){
        return TaskManager();
      }
      final contents = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(contents);
      final manager = TaskManager();
      final tasks = jsonList.map((json) => Task.fromJson(json)).toList();

      //reinitialiser le gestionnaire et ajouter les tâches
      manager.clearAllTasks();
      for (final task in tasks) {
        manager.addTask(task.title, task.description);
        if(task.isCompleted){
          manager.markTaskAsCompleted(task.id);
        }
      }
      print('Tâches chargées avec succès!');
      return manager;
    } catch (e) {
      print('Erreur lors du chargement: $e');
      return TaskManager();
    }
  }
  static Future<void> deleteSaveFile() async {
    try {
      final file = await _localFile;
      if(await file.exists()){
        await file.delete();
        print('Fichier de sauvegarde supprimé!');
      }
    } catch (e){
      print('Erreur lors de la suppression: $e');
    }
  }
}
