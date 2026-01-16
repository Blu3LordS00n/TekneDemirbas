import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String taskType;
  final String boatType;
  final String createdBy;
  final String date;
  final bool isComplete;
  final List<String> imageUrls;
  final String? videoUrl;
  final String roomId; // Task hangi odaya ait

  const Task({
    this.id = '',
    required this.title,
    required this.description,
    required this.taskType,
    required this.boatType,
    required this.createdBy,
    required this.date,
    required this.roomId,
    this.isComplete = false,
    this.imageUrls = const [],
    this.videoUrl,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      taskType: map['taskType'] ?? '',
      boatType: map['boatType'] ?? '',
      createdBy: map['createdBy'] ?? '',
      date: map['date'] ?? '',
      roomId: map['roomId'] ?? '',
      isComplete: map['isComplete'] ?? false,
      imageUrls: map['imageUrls'] != null 
          ? List<String>.from(map['imageUrls']) 
          : [],
      videoUrl: map['videoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'taskType': taskType,
      'boatType': boatType,
      'createdBy': createdBy,
      'date': date,
      'roomId': roomId,
      'isComplete': isComplete,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? taskType,
    String? boatType,
    String? createdBy,
    String? date,
    String? roomId,
    bool? isComplete,
    List<String>? imageUrls,
    String? videoUrl,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      taskType: taskType ?? this.taskType,
      boatType: boatType ?? this.boatType,
      createdBy: createdBy ?? this.createdBy,
      date: date ?? this.date,
      roomId: roomId ?? this.roomId,
      isComplete: isComplete ?? this.isComplete,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
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
        other.createdBy == createdBy &&
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
        createdBy.hashCode ^
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
        'createdBy: $createdBy, '
        'date: $date, '
        'isComplete: $isComplete'
        ')';
  }

  DateTime? get dateTime {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  String get formattedDate {
    final dt = dateTime;
    if (dt == null) return '';

    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }

  String get createdByUsername {
    if (createdBy.isEmpty) return '';

    final atIndex = createdBy.indexOf('@');
    if (atIndex == -1) return createdBy;

    return createdBy.substring(0, atIndex);
  }
}
