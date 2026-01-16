class TaskType {
  final String id;
  final String name;

  TaskType({required this.id, required this.name});

  factory TaskType.fromMap(Map<String, dynamic> map, String id) {
    return TaskType(
      id: id,
      name: map['name'] as String? ?? '',
    );
  }
}
