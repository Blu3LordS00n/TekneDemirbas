import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/features/task_management/domain/boat_type.dart';
import 'package:tekne_demirbas/features/task_management/domain/task_type.dart';
import 'package:tekne_demirbas/features/task_management/domain/task_filter.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';

part 'firestore_repository.g.dart';

/// ===============================
/// REPOSITORY
/// ===============================
class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  /// ---------- TASKS ----------
  Future<String> addTask({
    required Task task,
    required String userId,
    required String roomId,
  }) async {
    final taskMap = task.toMap();
    taskMap['roomId'] = roomId; // Room ID'yi ekle
    final docRef = await _firestore.collection('tasks').add(taskMap);
    await docRef.update({'id': docRef.id});
    return docRef.id; // Task ID'yi döndür
  }

  Future<void> updateTask({
    required Task task,
    required String taskId,
    required String userId,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update(task.toMap());
  }

  Future<void> deleteTask({required String taskId}) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Future<void> updateTaskCompletion({
    required String taskId,
    required bool isComplete,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isComplete': isComplete,
    });
  }

  Stream<List<Task>> loadTasks(String roomId) {
    return _firestore
        .collection('tasks')
        .where('roomId', isEqualTo: roomId)
        .snapshots()
        .map((s) {
          final tasks = s.docs.map((d) => Task.fromMap(d.data(), d.id)).toList();
          // Client-side'da tarihe göre sırala (en yeni önce)
          tasks.sort((a, b) {
            final dateA = a.dateTime ?? DateTime(1970);
            final dateB = b.dateTime ?? DateTime(1970);
            return dateB.compareTo(dateA); // Descending order
          });
          return tasks;
        });
  }

  Stream<List<Task>> loadCompletedTasks(String roomId) {
    return _firestore
        .collection('tasks')
        .where('roomId', isEqualTo: roomId)
        .where('isComplete', isEqualTo: true)
        .snapshots()
        .map((s) {
          final tasks = s.docs.map((d) => Task.fromMap(d.data(), d.id)).toList();
          // Client-side'da tarihe göre sırala (en yeni önce)
          tasks.sort((a, b) {
            final dateA = a.dateTime ?? DateTime(1970);
            final dateB = b.dateTime ?? DateTime(1970);
            return dateB.compareTo(dateA); // Descending order
          });
          return tasks;
        });
  }

  Stream<List<Task>> loadIncompletedTasks(String roomId) {
    return _firestore
        .collection('tasks')
        .where('roomId', isEqualTo: roomId)
        .where('isComplete', isEqualTo: false)
        .snapshots()
        .map((s) {
          final tasks = s.docs.map((d) => Task.fromMap(d.data(), d.id)).toList();
          // Client-side'da tarihe göre sırala (en yeni önce)
          tasks.sort((a, b) {
            final dateA = a.dateTime ?? DateTime(1970);
            final dateB = b.dateTime ?? DateTime(1970);
            return dateB.compareTo(dateA); // Descending order
          });
          return tasks;
        });
  }

  /// ---------- TASK TYPES ----------
  Stream<List<TaskType>> loadTaskTypes() {
    return _firestore
        .collection('task_types')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => TaskType.fromMap(d.data(), d.id))
              .where((t) => t.name.isNotEmpty)
              .toList(),
        );
  }

  Future<void> addTaskTypes(String name) async {
    await _firestore.collection('task_types').add({
      'name': name,
      'isActive': true,
    });
  }

  Future<void> deleteTaskType(String taskTypeId) async {
    await _firestore.collection('task_types').doc(taskTypeId).update({
      'isActive': false,
    });
  }

  /// ---------- BOAT TYPES ----------
  Stream<List<BoatType>> loadBoatTypes() {
    return _firestore
        .collection('boat_types')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => BoatType.fromMap(d.data(), d.id))
              .where((b) => b.name.isNotEmpty)
              .toList(),
        );
  }

  Future<void> addBoatTypes(String name) async {
    await _firestore.collection('boat_types').add({
      'name': name,
      'isActive': true,
    });
  }

  Future<void> deleteBoatType(String boatId) async {
    await _firestore.collection('boat_types').doc(boatId).update({
      'isActive': false,
    });
  }
}

/// ===============================
/// PROVIDERS (READ ONLY)
/// ===============================

@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(Ref ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Task>> loadTasks(Ref ref, String roomId) {
  return ref.watch(firestoreRepositoryProvider).loadTasks(roomId);
}

@riverpod
Stream<List<Task>> loadCompletedTasks(Ref ref, String roomId) {
  return ref.watch(firestoreRepositoryProvider).loadCompletedTasks(roomId);
}

@riverpod
Stream<List<Task>> loadIncompletedTasks(Ref ref, String roomId) {
  return ref.watch(firestoreRepositoryProvider).loadIncompletedTasks(roomId);
}

@riverpod
Stream<List<TaskType>> taskTypes(Ref ref) {
  return ref.watch(firestoreRepositoryProvider).loadTaskTypes();
}

@riverpod
Stream<List<BoatType>> boatTypes(Ref ref) {
  return ref.watch(firestoreRepositoryProvider).loadBoatTypes();
}

/// ===============================
/// FILTERED TASKS (CLIENT SIDE)
/// ===============================
@riverpod
Stream<List<Task>> filteredTasks(Ref ref, String roomId) {
  final filter = ref.watch(allTasksFilterControllerProvider);
  final repository = ref.watch(firestoreRepositoryProvider);
  
  return repository.loadTasks(roomId).map((tasks) {
    return _applyFilters(tasks, filter);
  });
}

@riverpod
Stream<List<Task>> filteredCompletedTasks(Ref ref, String roomId) {
  final filter = ref.watch(completedTasksFilterControllerProvider);
  final repository = ref.watch(firestoreRepositoryProvider);
  
  return repository.loadCompletedTasks(roomId).map((tasks) {
    return _applyFilters(tasks, filter);
  });
}

@riverpod
Stream<List<Task>> filteredIncompletedTasks(Ref ref, String roomId) {
  final filter = ref.watch(incompletedTasksFilterControllerProvider);
  final repository = ref.watch(firestoreRepositoryProvider);
  
  return repository.loadIncompletedTasks(roomId).map((tasks) {
    return _applyFilters(tasks, filter);
  });
}

List<Task> _applyFilters(List<Task> tasks, TaskFilter filter) {
  var result = [...tasks];

  // Tekne filtresi - null veya boş değilse filtrele
  if (filter.boatType != null && filter.boatType!.isNotEmpty) {
    result = result.where((t) => t.boatType == filter.boatType).toList();
  }

  // İş türü filtresi - null veya boş değilse filtrele
  if (filter.taskType != null && filter.taskType!.isNotEmpty) {
    result = result.where((t) => t.taskType == filter.taskType).toList();
  }

  // Tarih filtresi
  if (filter.dateRange != null) {
    result = result.where((t) {
      final taskDate = t.dateTime;
      if (taskDate == null) return false;
      final start = filter.dateRange!.start;
      final end = filter.dateRange!.end;
      // Sadece tarih kısmını karşılaştır (saat bilgisi olmadan)
      final taskDateOnly = DateTime(taskDate.year, taskDate.month, taskDate.day);
      final startOnly = DateTime(start.year, start.month, start.day);
      final endOnly = DateTime(end.year, end.month, end.day);
      // Tarih aralığına dahil olup olmadığını kontrol et (start ve end dahil)
      return taskDateOnly.isAtSameMomentAs(startOnly) ||
             taskDateOnly.isAtSameMomentAs(endOnly) ||
             (taskDateOnly.isAfter(startOnly) && taskDateOnly.isBefore(endOnly));
    }).toList();
  }

  return result;
}
