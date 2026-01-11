class Task {
  final String id;
  final String title;
  final String description;
  final String jobType;
  final String boatType;
  final DateTime date;
  final bool isComplete;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.jobType,
    required this.boatType,
    required this.date,
    required this.isComplete,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      jobType: map['jobType'] ?? '',
      boatType: map['boatType'] ?? '',
      date: DateTime.parse(map['date']),
      isComplete: map['isComplete'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'jobType': jobType,
      'boatType': boatType,
      'date': date.toIso8601String(),
      'isComplete': isComplete,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? jobType,
    String? boatType,
    DateTime? date,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
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
        other.jobType == jobType &&
        other.boatType == boatType &&
        other.date == date &&
        other.isComplete == isComplete;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        jobType.hashCode ^
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
        'jobType: $jobType, '
        'boatType: $boatType, '
        'date: $date, '
        'isComplete: $isComplete'
        ')';
  }
}
