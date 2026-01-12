import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/Task.dart';
import 'package:tekne_demirbas/routes/routes.dart';

part 'firestore_controller.g.dart';

@riverpod
class FirestoreController extends _$FirestoreController {
  @override
  FutureOr<void> build() {
    throw UnimplementedError();
  }

  Future<void> addTask({required Task task, required String userId}) async {
    state = const AsyncLoading();

    final fireStoreRepository = ref.read(firestoreRepositoryProvider);
    state = await AsyncValue.guard(
      () => fireStoreRepository.addTask(task: task, userId: userId),
    );
  }

  Future<void> updateTask({
    required Task task,
    required String userId,
    required String taskId,
  }) async {
    state = const AsyncLoading();
    final fireStoreRepository = ref.read(firestoreRepositoryProvider);

    state = await AsyncValue.guard(
      () => fireStoreRepository.updateTask(
        task: task,
        taskId: taskId,
        userId: userId,
      ),
    );
  }

  Future<void> deleteTask({required String taskId}) async {
    state = const AsyncLoading();
    final fireStoreRepository = ref.read(firestoreRepositoryProvider);

    state = await AsyncValue.guard(
      () => fireStoreRepository.deleteTask(taskId: taskId),
    );
  }
}
