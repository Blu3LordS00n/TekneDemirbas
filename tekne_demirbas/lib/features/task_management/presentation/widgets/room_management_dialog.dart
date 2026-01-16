import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/domain/permission.dart';
import 'package:tekne_demirbas/features/room_management/domain/room.dart';

class RoomManagementDialog extends ConsumerWidget {
  final String roomId;
  final Room room;

  const RoomManagementDialog({
    super.key,
    required this.roomId,
    required this.room,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    final isOwner = currentUser?.uid == room.ownerId;
    final permissionsAsync = ref.watch(loadRoomPermissionsProvider(roomId));

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başlık
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Oda Yönetimi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Kullanıcı listesi
            Flexible(
              child: permissionsAsync.when(
                data: (permissions) {
                  if (permissions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Henüz kullanıcı yok'),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: permissions.length,
                    itemBuilder: (context, index) {
                      final permission = permissions[index];
                      final isCurrentUser = permission.userId == currentUser?.uid;
                      final isRoomOwner = permission.userId == room.ownerId;

                      return ListTile(
                        title: Text(
                          permission.userId == room.ownerId
                              ? '${permission.userEmail.isNotEmpty ? permission.userEmail : permission.userId} (Oda Sahibi)'
                              : (permission.userEmail.isNotEmpty ? permission.userEmail : permission.userId),
                          style: TextStyle(
                            fontWeight: isRoomOwner ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          isRoomOwner
                              ? 'Tüm yetkilere sahip'
                              : 'Görev ekleme: ${permission.canAddTask ? "Var" : "Yok"}',
                        ),
                        trailing: isOwner && !isRoomOwner && !isCurrentUser
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: permission.canAddTask,
                                    onChanged: (value) async {
                                      // Permission güncelle
                                      await ref
                                          .read(roomRepositoryProvider)
                                          .updatePermission(
                                            permissionId: permission.id,
                                            canAddTask: value,
                                            canDeleteTask: permission.canDeleteTask,
                                            canEditTask: permission.canEditTask,
                                            canViewTasks: permission.canViewTasks,
                                          );
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.person_remove, color: Colors.red),
                                    tooltip: 'Odadan Çıkar',
                                    onPressed: () => _showRemoveMemberConfirmation(
                                      context,
                                      ref,
                                      permission.userId,
                                      permission.userEmail.isNotEmpty ? permission.userEmail : permission.userId,
                                    ),
                                  ),
                                ],
                              )
                            : isRoomOwner
                                ? const Icon(Icons.star, color: Colors.amber)
                                : null,
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Hata: $error'),
                  ),
                ),
              ),
            ),
            const Divider(),
            // Kapat butonu
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kapat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveMemberConfirmation(
    BuildContext context,
    WidgetRef ref,
    String userId,
    String userEmail,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kullanıcıyı Odadan Çıkar'),
        content: Text(
          '$userEmail kullanıcısını odadan çıkarmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(roomRepositoryProvider)
                    .removeMemberFromRoom(userId, roomId);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$userEmail odadan çıkarıldı'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Hata: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkar'),
          ),
        ],
      ),
    );
  }
}
