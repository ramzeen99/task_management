//import 'dart:io';
import 'task.dart';

class TaskManager {
  final List<Task> _tasks = [];
  int _nextId = 1;

  List<Task> get allTasks => List.unmodifiable(_tasks);
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();
  List<Task> get pendingTasks => _tasks.where((task) => !task.isCompleted).toList();
  int get totalTasks => _tasks.length;
  int get completedTasksCount =>completedTasks.length;

  void addTask(String title, String description) {
    if (title.isEmpty) {
      throw ArgumentError('The title does not empty');
    }
    final task = Task(
      id: _nextId++, 
      title: title.trim(), 
      description: description.trim(), 
      createdAt: DateTime.now(),
      );
    _tasks.add(task);
  }
 Task getTask(int id) {
  final task = _tasks.firstWhere(
    (task) => task.id == id,
    orElse: () => throw Exception('Task with ID $id not found')
  );
  return task; 
 }
 void updateTask(int id, {String? title, String? description}) {
   final task = getTask(id);
   if (title != null) task.title = title;
   if(description != null) task.description = description;
  
 }
 void markTaskAsCompleted(int id){
  final task = getTask(id);
  task.markAsCompleted();
 }
 void markTaskAsPending(int id){
  final task= getTask(id);
  task.markAsPending();
 }
 void deleteTask(int id) {
  final initialLenght = _tasks.length;
  _tasks.removeWhere((task) => task.id == id);
  if(_tasks.length == initialLenght){
    throw Exception('Tâche avec ID $id non trouvée');
  }
}
void clearAllTasks(){
  _tasks.clear();
  _nextId = 1;
}
void clearCompletedTasks(){
  _tasks.removeWhere((task)=> task.isCompleted);
}
List<Task> searchTasks(String query) {
  if (query.isEmpty) return [];

  final lowerQuery = query.toLowerCase();
  return _tasks.where((task){
    return task.title.toLowerCase().contains(lowerQuery)||
     task.description.toLowerCase().contains(lowerQuery);
  }).toList();
}

void displayStatistics(){
  print('\n STATISTIQUES');
  print('=================');
  print('Total des tâches: $totalTasks');
  print('tâches complétées: $completedTasksCount');
  print('Tâches en attente: ${pendingTasks.length}');

  if(totalTasks > 0) {
    final completionPercentage = (completedTasksCount / totalTasks * 100).toStringAsFixed(1);
    print('Pourcentage de completion: $completionPercentage%');
  }
}
 }
 