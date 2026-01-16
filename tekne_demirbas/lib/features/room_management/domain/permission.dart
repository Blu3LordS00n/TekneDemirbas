class RoomPermission {
  final String id;
  final String userId;
  final String userEmail;
  final String roomId;
  final bool canAddTask;
  final bool canDeleteTask;
  final bool canEditTask;
  final bool canViewTasks;

  const RoomPermission({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.roomId,
    this.canAddTask = false,
    this.canDeleteTask = false,
    this.canEditTask = false,
    this.canViewTasks = true, // Default: sadece görüntüleme
  });

  factory RoomPermission.fromMap(Map<String, dynamic> map, String id) {
    return RoomPermission(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      roomId: map['roomId'] ?? '',
      canAddTask: map['canAddTask'] ?? false,
      canDeleteTask: map['canDeleteTask'] ?? false,
      canEditTask: map['canEditTask'] ?? false,
      canViewTasks: map['canViewTasks'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'roomId': roomId,
      'canAddTask': canAddTask,
      'canDeleteTask': canDeleteTask,
      'canEditTask': canEditTask,
      'canViewTasks': canViewTasks,
    };
  }

  RoomPermission copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? roomId,
    bool? canAddTask,
    bool? canDeleteTask,
    bool? canEditTask,
    bool? canViewTasks,
  }) {
    return RoomPermission(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      roomId: roomId ?? this.roomId,
      canAddTask: canAddTask ?? this.canAddTask,
      canDeleteTask: canDeleteTask ?? this.canDeleteTask,
      canEditTask: canEditTask ?? this.canEditTask,
      canViewTasks: canViewTasks ?? this.canViewTasks,
    );
  }
}
