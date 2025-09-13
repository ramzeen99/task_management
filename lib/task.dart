class Task {
  final int id;
   String title;
   String description;
  bool isCompleted;
  final DateTime createdAt;
  DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
  });
  void markAsCompleted(){
    if (!isCompleted){
      isCompleted =  true;
      completedAt = DateTime.now();
    }
  }
  void markAsPending(){
    if(isCompleted) {
      isCompleted = false;
      completedAt =null;
    }
  }
  Map<String,dynamic> toJson() {
    return{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted' : isCompleted,
      'createdAt' : createdAt.toIso8601String(),
      'completedAt' : completedAt?.toIso8601String(),
    };
  }
  factory Task.fromJson(Map<String, dynamic> json){
    return Task(
      id:  json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,

    );
  }
  @override
  String toString() {
    final status =  isCompleted ? '👌' : '🤖';
    final completedInfo = isCompleted ? ' | finished the: ${completedAt!.toString()}' : '';
    return '$status ID: $id | Titre: $title | Créé le: ${createdAt.toString()}$completedInfo';

  }
  String toDetailedString(){
    return '''
ID: $id
Titre: $title
Description: $description
Statut: ${isCompleted ? 'completed' : 'In progress'}
Created the : ${createdAt.toString()}
${isCompleted ? 'completed the: ${completedAt!.toString()}':''}
--------------------------------------------
''';
  }
}