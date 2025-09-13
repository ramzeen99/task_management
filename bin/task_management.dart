#!/usr/bin/env dart 

import 'dart:io';
import 'package:task_management/task_management.dart';
import 'package:task_management/task_storage.dart';
import 'package:task_management/task.dart';

void main() async{
  print('GESTIONNAIRE DE TÄCHES');
  print('======================');

  //charger les tâches sauvegardées
  TaskManager taskManager = await TaskStorage.loadTasks();

  bool exit = false;
    
  while(!exit){
    _displayMainMenu();
    final choice = stdin.readLineSync()?.trim() ?? '';
    switch (choice) {
      case '1':
        await _addTaskUI(taskManager);
        break;
      case '2':
        _viewTasksUI(taskManager);
        break;
      case '3':
        await _updateTaskUI(taskManager);
        break;
      case '4':
        await _markTaskUI(taskManager);
        break;
      case '5':
       await _deleteTaskUI(taskManager);
       break;
      case '6':
      _searchTaskUI(taskManager);
      break;
      case '7':
        taskManager.displayStatistics();
        break;
      case '8':
        await TaskStorage.saveTasks(taskManager);
        break;
      case '9':
        await TaskStorage.deleteSaveFile();
        break;
      case '0':
        exit = true;
        print('Au revoit!');
        break;
      default:
        print('option invalide.Veuillez choisir une option valide.');                 
    }
    if(!exit){
      print('\nAppuyez sur Entrée pour continuer ...');
      stdin.readLineSync();
    }
  }  
}
void _displayMainMenu(){
  print('\n');
  print('  MENU PRINCIPAL');
  print('================');
  print('1. Ajouter une tâche');
  print('2. Voir les tâches');
  print('3. Modifier une tâche');
  print('4.Marque une tâche comme complétée/ en attente');
  print('5. Supprimer une tâche');
  print('6. Rechercher des tâches');
  print('7. Afficher les statistiques');
  print('8. Sauvegarder les tâches');
  print('9. Supprimer la sauvegarde');
  print('0. Quitter');
  print('\nChoisissez une option (0-9): ');
}
Future<void> _addTaskUI(TaskManager manager) async {
  print('\n + AJOUTER UNE TÄCHE');
  print('======================');

  try{
   print('Entrez le titre de le tâche:');
   final title = stdin.readLineSync()?.trim() ?? '';

   if (title.isEmpty) {
    print('X Le titre ne peut pas être vide.');
    return;
   }

   print('Entrez la description(optionnel):');
   final description = stdin.readLineSync()?.trim() ?? '';

   manager.addTask(title, description);
   print('Tâche ajoutée avec succès!');
  } catch (e) {
    print('X Erreur: $e');
  }
}
void _viewTasksUI(TaskManager manager) {
  if (manager.allTasks.isEmpty) {
    print('Aucune tâche à afficher.');
    return;
  }
  print('\n VOIR LES TÄCHES');
  print('==================');
  print('1. Toutes les tâches');
  print('2. tâches complétées');
  print('3. Tâches en attente');
  print('4. Détails d\'une tâche spécifique');
  print('\nChoisissez une option (1-4):');

  final choice = stdin.readLineSync()?.trim() ?? '';

  switch (choice) {
    case '1':
     _displayTasks('TOUTES LES TÄCHES', manager.allTasks);
     break;
    case '2':
     _displayTasks('TÄCHES COMPLETEES', manager.completedTasks);
     break;
    case '3':
      _displayTasks('TÄCHE EN ATTENTE', manager.pendingTasks);
     break;
    case '4':
      _viewTaskDetailsUI(manager);
      break;
    default:
      print('X Option invalide.');      
  }
}

void _displayTasks(String title, List<Task> tasks){
 if (tasks.isEmpty){
  print('Aucune tâche à afficher.');
  return;
 }
 print('\n$title');
 print('=' * title.length);
 for (final task in tasks){
  print(task);
 }
 print('\nTotal: ${tasks.length} tâche(s)');
}

void _viewTaskDetailsUI(TaskManager manager){
  print('Entrez l\'ID de la tâche à afficher:');
  final input = stdin.readLineSync()?.trim() ?? '';
  final id = int.tryParse(input);

  if (id == null) {
    print('X ID invalide.');
    return;
  }
  try {
    final task = manager.getTask(id);
    print(task.toDetailedString());
  } catch (e) {
    print('X $e');
  }
}

Future<void> _updateTaskUI(TaskManager manager) async{
  print('Entrez l\'ID de la tâche à modifier:');
  final input = stdin.readLineSync()?.trim() ?? '';
  final id = int.tryParse(input);

  if (id == null) {
    print('X ID invalide');
    return;
  }
  try {
    final task = manager.getTask(id);
    print('Tâche actuelle:');
    print(task.toDetailedString());

    print('Nouveau titre (laissez vide pour ne pas changer ):');
    final newTitle = stdin.readLineSync()?.trim();

    print('Nouvelle description (laissez vide pour ne pas changer):');
    final newDescription = stdin.readLineSync()?.trim();

    if (newTitle != null && newTitle.isNotEmpty || newDescription !=null){
      manager.updateTask(id, title: newTitle?.isNotEmpty == true? newTitle :null,
      description: newDescription?.isNotEmpty == true? newDescription:null,
      );
      print('Tâche modifiée avec succès!');
    } else {
      print('Aucune modification apportée.');
    }
  } catch (e){
    print('X $e');
  }
}

Future<void> _markTaskUI(TaskManager manager) async {
  print('Entrez l\'ID de la tâche à modifier:');
  final input = stdin.readLineSync()?.trim() ?? '';
  final id = int.tryParse(input);

  if (id == null) {
    print('X ID invalide.');
    return;
  }
  try {
    final task = manager.getTask(id);
    print('Tâche actuelle:');
    print(task);

    print('Changer le statut vers:');
    print('1. Complétée');
    print('2. En attente');
    print('Choisissez une option (1-2):');

    final choice = stdin.readLineSync()?.trim() ?? '';

    switch(choice){
      case '1':
        manager.markTaskAsCompleted(id);
        print('Tâche marquée comme complétée!');
        break;
      case'2':
         manager.markTaskAsPending(id);
         print('Tâche marquée comme en attente!');
         break;
      default:
        print('X Option invalide.');     
    }
  } catch (e){
    print('X $e');
  }
}

Future<void> _deleteTaskUI(TaskManager manager) async {
  print('Entrez l\'ID de la tâche à supprimer:');
  final input = stdin.readLineSync()?.trim() ?? '';
  final id = int.tryParse(input);

  if (id == null){
    print('X ID invalide');
    return;
  }
  try {
    final task = manager.getTask(id);
    print('Tâche à supprimer:');
    print(task.toDetailedString());

    print('Ëtes-vous sûr de vouloir supprimer cette tâche? (o/N)');
    final confirmation = stdin.readLineSync()?.trim().toLowerCase() ?? '';

    if (confirmation == 'o' || confirmation == 'oui'){
      manager.deleteTask(id);
      print('Tâche supprimée avec succès!');
    }else{
      print('Suppression annulée.');
    }
  }catch(e){
    print('X $e');
  }
}
 void _searchTaskUI(TaskManager manager){
  print('Entrez le terme de recherche:');
  final query =  stdin.readLineSync()?.trim() ?? '';

  if (query.isEmpty){
    print('X le terme de recherche ne peut pas être vide.');
    return;
  }

  final results = manager.searchTasks(query);
  _displayTasks('RESULTAS DE RECHERCHE POUR "$query"', results);
 }