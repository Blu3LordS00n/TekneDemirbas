import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/boat_type.dart';

final boatTypesProvider = StreamProvider<List<BoatType>>((ref) {
  final repo = ref.watch(firestoreRepositoryProvider);
  return repo.loadBoatTypes();
});
