import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/domain/permission.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';

// Seçili oda için kullanıcının permission'ını döndürür
final currentUserPermissionProvider = StreamProvider.autoDispose<RoomPermission?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  final userId = userAsync.value?.uid;
  final roomId = ref.watch(selectedRoomProvider);
  
  if (userId == null || roomId == null) {
    return Stream.value(null);
  }
  
  // Repository'den direkt stream'i al
  final repository = ref.watch(roomRepositoryProvider);
  return repository.loadUserPermission(userId, roomId);
});

// Permission kontrolü için helper provider'lar
final canAddTaskProvider = Provider.autoDispose<bool>((ref) {
  final permissionAsync = ref.watch(currentUserPermissionProvider);
  return permissionAsync.when(
    data: (permission) => permission?.canAddTask ?? false,
    loading: () => false,
    error: (_, __) => false,
  );
});

final canDeleteTaskProvider = Provider.autoDispose<bool>((ref) {
  final permissionAsync = ref.watch(currentUserPermissionProvider);
  return permissionAsync.when(
    data: (permission) {
      // Görev ekleme yetkisi olanlar da görevleri silebilir
      return (permission?.canDeleteTask ?? false) || (permission?.canAddTask ?? false);
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

final canEditTaskProvider = Provider.autoDispose<bool>((ref) {
  final permissionAsync = ref.watch(currentUserPermissionProvider);
  return permissionAsync.when(
    data: (permission) {
      // Görev ekleme yetkisi olanlar da görevleri düzenleyebilir
      return (permission?.canEditTask ?? false) || (permission?.canAddTask ?? false);
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

final canViewTasksProvider = Provider.autoDispose<bool>((ref) {
  final permissionAsync = ref.watch(currentUserPermissionProvider);
  return permissionAsync.when(
    data: (permission) => permission?.canViewTasks ?? true,
    loading: () => false,
    error: (_, __) => false,
  );
});
