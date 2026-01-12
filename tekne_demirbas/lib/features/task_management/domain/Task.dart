class Task {
  final String id;
  final String title;
  final String description;
  final String taskType;
  final String boatType;
  final String date;
  final bool isComplete;

  const Task({
    this.id = '',
    required this.title,
    required this.description,
    required this.taskType,
    required this.boatType,
    required this.date,
    this.isComplete = false,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      taskType: map['taskType'] ?? '',
      boatType: map['boatType'] ?? '',
      date: map['date'] ?? '',
      isComplete: map['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'taskType': taskType,
      'boatType': boatType,
      'date': date, // 🔹 direkt string
      'isComplete': isComplete,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? taskType,
    String? boatType,
    String? date,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      taskType: taskType ?? this.taskType,
      boatType: boatType ?? this.boatType,
      date: date ?? this.date,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.taskType == taskType &&
        other.boatType == boatType &&
        other.date == date &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        taskType.hashCode ^
        boatType.hashCode ^
        date.hashCode ^
        isComplete.hashCode;
  }

  @override
  String toString() {
    return 'Task('
        'id: $id, '
        'title: $title, '
        'description: $description, '
        'taskType: $taskType, '
        'boatType: $boatType, '
        'date: $date, '
        'isComplete: $isComplete'
        ')';
  }
}
