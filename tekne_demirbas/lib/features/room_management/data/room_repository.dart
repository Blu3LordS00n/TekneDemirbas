import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tekne_demirbas/features/room_management/domain/room.dart';
import 'package:tekne_demirbas/features/room_management/domain/room_request.dart';
import 'package:tekne_demirbas/features/room_management/domain/permission.dart';

part 'room_repository.g.dart';

@riverpod
FirebaseFirestore roomFirestore(Ref ref) {
  return FirebaseFirestore.instance;
}

@riverpod
RoomRepository roomRepository(Ref ref) {
  return RoomRepository(ref.watch(roomFirestoreProvider));
}

class RoomRepository {
  RoomRepository(this._firestore);

  final FirebaseFirestore _firestore;
  
  // 5 haneli rastgele kod oluştur (harf ve rakam)
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      5,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  // ROOM OPERATIONS
  Future<String> createRoom({
    required String name,
    required String ownerId,
    required String ownerEmail,
  }) async {
    // 5 haneli rastgele kod oluştur (harf ve rakam)
    final code = _generateRoomCode();
    
    final roomData = {
      'name': name,
      'ownerId': ownerId,
      'ownerEmail': ownerEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'memberIds': [ownerId], // Owner otomatik member
      'isPublic': true,
      'code': code,
    };

    final docRef = await _firestore.collection('rooms').add(roomData);
    await docRef.update({'id': docRef.id});

    // Owner için default permission oluştur (tüm yetkiler)
    await _firestore.collection('room_permissions').add({
      'userId': ownerId,
      'userEmail': ownerEmail,
      'roomId': docRef.id,
      'canAddTask': true,
      'canDeleteTask': true,
      'canEditTask': true,
      'canViewTasks': true,
    });

    return docRef.id;
  }

  // Oda koduna göre oda bul
  Future<Room?> findRoomByCode(String code) async {
    final query = await _firestore
        .collection('rooms')
        .where('code', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();
    
    if (query.docs.isEmpty) {
      return null;
    }
    
    return Room.fromMap(query.docs.first.data(), query.docs.first.id);
  }

  Stream<Room?> loadRoom(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return Room.fromMap(doc.data()!, doc.id);
    });
  }

  Stream<List<Room>> loadUserRooms(String userId) {
    return _firestore
        .collection('rooms')
        .where('memberIds', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Room.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> updateRoomName(String roomId, String newName) async {
    if (newName.trim().isEmpty) {
      throw Exception('Oda adı boş olamaz');
    }
    await _firestore.collection('rooms').doc(roomId).update({
      'name': newName.trim(),
    });
  }

  // USER OPERATIONS
  Future<String?> getUserDisplayName(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return doc.data()?['displayName'] as String?;
  }

  Future<void> updateUserDisplayName(String userId, String displayName) async {
    // Önce mevcut kullanıcı bilgilerini al
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final existingData = userDoc.data() ?? {};
    
    await _firestore.collection('users').doc(userId).set({
      'displayName': displayName.trim(),
      'email': existingData['email'], // Email'i koru (varsa)
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<String?> loadUserDisplayName(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return doc.data()?['displayName'] as String?;
    });
  }

  // Email'den display name'i al
  Stream<String?> loadUserDisplayNameByEmail(String email) {
    // Email ile kullanıcıyı bul (users collection'ında email field'ı ile)
    return _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first.data()['displayName'] as String?;
    });
  }

  Future<void> deleteRoom(String roomId) async {
    // Odaya ait tüm task'ları sil
    final taskDocs = await _firestore
        .collection('tasks')
        .where('roomId', isEqualTo: roomId)
        .get();
    
    for (var doc in taskDocs.docs) {
      await doc.reference.delete();
    }
    
    // Odaya ait tüm permission'ları sil
    final permissionDocs = await _firestore
        .collection('room_permissions')
        .where('roomId', isEqualTo: roomId)
        .get();
    
    for (var doc in permissionDocs.docs) {
      await doc.reference.delete();
    }
    
    // Odaya ait tüm room request'leri sil
    final requestDocs = await _firestore
        .collection('room_requests')
        .where('roomId', isEqualTo: roomId)
        .get();
    
    for (var doc in requestDocs.docs) {
      await doc.reference.delete();
    }
    
    // Odayı sil
    await _firestore.collection('rooms').doc(roomId).delete();
  }

  // ROOM REQUEST OPERATIONS
  Future<String> createRoomRequest({
    required String userId,
    required String userEmail,
    required String roomId,
    required String roomName,
  }) async {
    // Daha önce istek atılmış mı kontrol et
    final existingRequest = await _firestore
        .collection('room_requests')
        .where('userId', isEqualTo: userId)
        .where('roomId', isEqualTo: roomId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (existingRequest.docs.isNotEmpty) {
      throw Exception('Bu odaya zaten istek gönderdiniz');
    }

    final requestData = {
      'userId': userId,
      'userEmail': userEmail,
      'roomId': roomId,
      'roomName': roomName,
      'status': 'pending',
      'requestedAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _firestore.collection('room_requests').add(requestData);
    await docRef.update({'id': docRef.id});
    return docRef.id;
  }

  Stream<List<RoomRequest>> loadRoomRequestsForRoom(String roomId) {
    return _firestore
        .collection('room_requests')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RoomRequest.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<List<RoomRequest>> loadUserRoomRequests(String userId) {
    return _firestore
        .collection('room_requests')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RoomRequest.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> approveRoomRequest(String requestId, String roomId) async {
    final requestDoc = await _firestore
        .collection('room_requests')
        .doc(requestId)
        .get();

    if (!requestDoc.exists) return;

    final requestData = requestDoc.data()!;
    final userId = requestData['userId'] as String;
    final userEmail = requestData['userEmail'] as String;

    // Request'i approved yap
    await _firestore.collection('room_requests').doc(requestId).update({
      'status': 'approved',
    });

    // Kullanıcıyı room'a ekle
    await _firestore.collection('rooms').doc(roomId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
    });

    // Default permission oluştur (sadece görüntüleme)
    await _firestore.collection('room_permissions').add({
      'userId': userId,
      'userEmail': userEmail,
      'roomId': roomId,
      'canAddTask': false,
      'canDeleteTask': false,
      'canEditTask': false,
      'canViewTasks': true,
    });
  }

  Future<void> rejectRoomRequest(String requestId) async {
    await _firestore.collection('room_requests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  // PERMISSION OPERATIONS
  Stream<RoomPermission?> loadUserPermission(String userId, String roomId) {
    return _firestore
        .collection('room_permissions')
        .where('userId', isEqualTo: userId)
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return RoomPermission.fromMap(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    });
  }

  Future<void> updatePermission({
    required String permissionId,
    required bool canAddTask,
    required bool canDeleteTask,
    required bool canEditTask,
    required bool canViewTasks,
  }) async {
    await _firestore.collection('room_permissions').doc(permissionId).update({
      'canAddTask': canAddTask,
      'canDeleteTask': canDeleteTask,
      'canEditTask': canEditTask,
      'canViewTasks': canViewTasks,
    });
  }

  Future<void> removeMemberFromRoom(String userId, String roomId) async {
    // Member'ı room'dan çıkar
    await _firestore.collection('rooms').doc(roomId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
    });

    // Permission'ı sil
    final permissionDocs = await _firestore
        .collection('room_permissions')
        .where('userId', isEqualTo: userId)
        .where('roomId', isEqualTo: roomId)
        .get();

    for (var doc in permissionDocs.docs) {
      await doc.reference.delete();
    }
  }

  // Oda içindeki tüm kullanıcıların permission'larını getir
  Stream<List<RoomPermission>> loadRoomPermissions(String roomId) {
    return _firestore
        .collection('room_permissions')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RoomPermission.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}

// PROVIDERS

@riverpod
Stream<List<Room>> loadUserRooms(Ref ref, String userId) {
  return ref.watch(roomRepositoryProvider).loadUserRooms(userId);
}

@riverpod
Stream<List<RoomRequest>> loadUserRoomRequests(Ref ref, String userId) {
  return ref.watch(roomRepositoryProvider).loadUserRoomRequests(userId);
}

@riverpod
Stream<List<RoomRequest>> loadRoomRequestsForRoom(Ref ref, String roomId) {
  return ref.watch(roomRepositoryProvider).loadRoomRequestsForRoom(roomId);
}

@riverpod
Stream<Room?> loadRoom(Ref ref, String roomId) {
  return ref.watch(roomRepositoryProvider).loadRoom(roomId);
}

@riverpod
Stream<RoomPermission?> loadUserPermission(Ref ref, String userId, String roomId) {
  return ref.watch(roomRepositoryProvider).loadUserPermission(userId, roomId);
}

@riverpod
Stream<List<RoomPermission>> loadRoomPermissions(Ref ref, String roomId) {
  return ref.watch(roomRepositoryProvider).loadRoomPermissions(roomId);
}

@riverpod
Stream<int> pendingRoomRequestsCount(Ref ref, String roomId) {
  return ref.watch(roomRepositoryProvider).loadRoomRequestsForRoom(roomId).map((requests) {
    return requests.where((request) => request.status == 'pending').length;
  });
}

@riverpod
Stream<String?> loadUserDisplayNameByEmail(Ref ref, String email) {
  return ref.watch(roomRepositoryProvider).loadUserDisplayNameByEmail(email);
}

@riverpod
Stream<String?> loadUserDisplayName(Ref ref, String userId) {
  return ref.watch(roomRepositoryProvider).loadUserDisplayName(userId);
}
