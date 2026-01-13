import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tekne_demirbas/features/task_management/domain/Task.dart';

part 'firestore_repository.g.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> addTask({required Task task, required String userId}) async {
    final docRef = await _firestore.collection('tasks').add(task.toMap());

    await docRef.update({'id': docRef.id});
  }

  Future<void> updateTask({
    required Task task,
    required String taskId,
    required String userId,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update(task.toMap());
  }

  Stream<List<Task>> loadTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Task>> loadCompletedTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('isComplete', isEqualTo: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<Task>> loadIncompletedTasks() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('isComplete', isEqualTo: false)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
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
}

@Riverpod(keepAlive: true)
FirestoreRepository firestoreRepository(Ref ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<List<Task>> loadTasks(Ref ref) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadTasks();
}

@riverpod
Stream<List<Task>> loadCompletedTasks(Ref ref) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadCompletedTasks();
}

@riverpod
Stream<List<Task>> loadIncompletedTasks(Ref ref) {
  final firestoreRepository = ref.watch(firestoreRepositoryProvider);
  return firestoreRepository.loadIncompletedTasks();
}
