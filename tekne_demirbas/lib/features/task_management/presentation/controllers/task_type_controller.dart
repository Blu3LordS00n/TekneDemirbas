import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';

final taskTypeControllerProvider =
    AsyncNotifierProvider<TaskTypeController, void>(TaskTypeController.new);

class TaskTypeController extends AsyncNotifier<void> {
  late final FirestoreRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(firestoreRepositoryProvider);
  }

  Future<void> addTaskType(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.addTaskTypes(name));
  }

  Future<void> deleteTaskType(String taskId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteTaskType(taskId));
  }
}
