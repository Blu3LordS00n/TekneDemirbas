import 'package:cloud_firestore/cloud_firestore.dart';

enum RoomRequestStatus {
  pending,
  approved,
  rejected;

  static RoomRequestStatus fromString(String status) {
    switch (status) {
      case 'pending':
        return RoomRequestStatus.pending;
      case 'approved':
        return RoomRequestStatus.approved;
      case 'rejected':
        return RoomRequestStatus.rejected;
      default:
        return RoomRequestStatus.pending;
    }
  }

  String get value {
    switch (this) {
      case RoomRequestStatus.pending:
        return 'pending';
      case RoomRequestStatus.approved:
        return 'approved';
      case RoomRequestStatus.rejected:
        return 'rejected';
    }
  }
}

class RoomRequest {
  final String id;
  final String userId;
  final String userEmail;
  final String roomId;
  final String roomName;
  final RoomRequestStatus status;
  final DateTime requestedAt;

  const RoomRequest({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.roomId,
    required this.roomName,
    required this.status,
    required this.requestedAt,
  });

  factory RoomRequest.fromMap(Map<String, dynamic> map, String id) {
    return RoomRequest(
      id: id,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      roomId: map['roomId'] ?? '',
      roomName: map['roomName'] ?? '',
      status: RoomRequestStatus.fromString(map['status'] ?? 'pending'),
      requestedAt: map['requestedAt'] != null
          ? (map['requestedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'roomId': roomId,
      'roomName': roomName,
      'status': status.value,
      'requestedAt': Timestamp.fromDate(requestedAt),
    };
  }

  RoomRequest copyWith({
    String? id,
    String? userId,
    String? userEmail,
    String? roomId,
    String? roomName,
    RoomRequestStatus? status,
    DateTime? requestedAt,
  }) {
    return RoomRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }
}
