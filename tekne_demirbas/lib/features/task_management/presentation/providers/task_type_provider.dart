import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task_type.dart';

final taskTypesProvider = StreamProvider<List<TaskType>>((ref) {
  final repo = ref.watch(firestoreRepositoryProvider);
  return repo.loadTaskTypes();
});
