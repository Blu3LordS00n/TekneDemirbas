import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';

final boatTypeControllerProvider =
    AsyncNotifierProvider<BoatTypeController, void>(BoatTypeController.new);

class BoatTypeController extends AsyncNotifier<void> {
  late final FirestoreRepository _repo;

  @override
  Future<void> build() async {
    _repo = ref.read(firestoreRepositoryProvider);
  }

  Future<void> addBoat(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.addBoatTypes(name));
  }

  Future<void> deleteBoat(String boatId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.deleteBoatType(boatId));
  }
}
