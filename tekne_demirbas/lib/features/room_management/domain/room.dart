import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String id;
  final String name;
  final String ownerId;
  final String ownerEmail;
  final DateTime createdAt;
  final List<String> memberIds;
  final bool isPublic;
  final String code; // 5 haneli oda kodu

  const Room({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerEmail,
    required this.createdAt,
    this.memberIds = const [],
    this.isPublic = true,
    required this.code,
  });

  factory Room.fromMap(Map<String, dynamic> map, String id) {
    return Room(
      id: id,
      name: map['name'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerEmail: map['ownerEmail'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      memberIds: map['memberIds'] != null
          ? List<String>.from(map['memberIds'])
          : [],
      isPublic: map['isPublic'] ?? true,
      code: map['code'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'createdAt': Timestamp.fromDate(createdAt),
      'memberIds': memberIds,
      'isPublic': isPublic,
      'code': code,
    };
  }

  Room copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? ownerEmail,
    DateTime? createdAt,
    List<String>? memberIds,
    bool? isPublic,
    String? code,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      createdAt: createdAt ?? this.createdAt,
      memberIds: memberIds ?? this.memberIds,
      isPublic: isPublic ?? this.isPublic,
      code: code ?? this.code,
    );
  }
}
