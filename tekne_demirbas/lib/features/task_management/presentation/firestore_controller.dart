import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/storage_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/routes/routes.dart';

part 'firestore_controller.g.dart';

@riverpod
class FirestoreController extends _$FirestoreController {
  @override
  FutureOr<void> build() {
    throw UnimplementedError();
  }

  Future<void> addTask({
    required Task task,
    required String userId,
    required String roomId,
    List<String>? imageUrls,
    String? videoUrl,
  }) async {
    state = const AsyncLoading();
    final fireStoreRepository = ref.read(firestoreRepositoryProvider);
    
    try {
      // Önce task'ı oluştur ve ID'yi al
      final taskId = await fireStoreRepository.addTask(
        task: task, 
        userId: userId,
        roomId: roomId,
      );
      
      // Medya varsa task'ı güncelle
      if (imageUrls != null || videoUrl != null) {
        final updatedTask = task.copyWith(
          id: taskId,
          imageUrls: imageUrls ?? task.imageUrls,
          videoUrl: videoUrl ?? task.videoUrl,
        );
        await fireStoreRepository.updateTask(
          task: updatedTask,
          taskId: taskId,
          userId: userId,
        );
      }
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
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
    if (!ref.mounted) return;
    
    state = const AsyncLoading();
    final fireStoreRepository = ref.read(firestoreRepositoryProvider);
    final storageRepository = ref.read(storageRepositoryProvider);

    state = await AsyncValue.guard(
      () async {
        // Önce Firestore'dan görevi sil
        await fireStoreRepository.deleteTask(taskId: taskId);
        
        // Sonra Storage'dan medya dosyalarını sil
        try {
          await storageRepository.deleteTaskFiles(taskId);
        } catch (e) {
          // Storage silme hatası görev silme işlemini durdurmaz
          // Çünkü Firestore'dan görev zaten silindi
          // Loglama yapılabilir ama kullanıcıya gösterilmeyebilir
          print('Storage dosyaları silinirken hata: $e');
        }
      },
    );
  }
}
