import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/domain/room.dart';
import 'package:tekne_demirbas/features/room_management/domain/room_request.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class RoomSelectionScreen extends ConsumerStatefulWidget {
  const RoomSelectionScreen({super.key});

  @override
  ConsumerState<RoomSelectionScreen> createState() => _RoomSelectionScreenState();
}

class _RoomSelectionScreenState extends ConsumerState<RoomSelectionScreen> {
  final _roomNameController = TextEditingController();
  final _roomCodeController = TextEditingController();
  bool _isCreatingRoom = false;
  bool _isJoiningRoom = false;

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomCodeController.dispose();
    super.dispose();
  }
  
  void _joinRoomByCode(user) async {
    final roomCode = _roomCodeController.text.trim().toUpperCase();
    if (roomCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oda kodu boş olamaz')),
      );
      return;
    }
    
    if (roomCode.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oda kodu 5 haneli olmalıdır')),
      );
      return;
    }

    setState(() => _isJoiningRoom = true);

    try {
      final roomRepository = ref.read(roomRepositoryProvider);
      final room = await roomRepository.findRoomByCode(roomCode);
      
      if (room == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bu kod ile oda bulunamadı'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Zaten member mı kontrol et
      if (room.memberIds.contains(user.uid)) {
        ref.read(selectedRoomProvider.notifier).setRoom(room.id);
        _roomCodeController.clear();
        return;
      }

      await ref.read(roomRepositoryProvider).createRoomRequest(
        userId: user.uid,
        userEmail: user.email ?? '',
        roomId: room.id,
        roomName: room.name,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${room.name} odasına katılım isteği gönderildi'),
            backgroundColor: Colors.blue,
          ),
        );
        _roomCodeController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      setState(() => _isJoiningRoom = false);
    }
  }


  void _editRoomName(BuildContext context, Room room) async {
    final controller = TextEditingController(text: room.name);
    
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Oda Adını Değiştir'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Yeni oda adı',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      try {
        await ref.read(roomRepositoryProvider).updateRoomName(room.id, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Oda adı güncellendi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      }
    }
  }

  void _showProfilePopup(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final displayNameAsync = ref.watch(loadUserDisplayNameProvider(user.uid));
          
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 8),
                Text('Hesap Bilgileri'),
              ],
            ),
            content: displayNameAsync.when(
              data: (displayName) => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(Icons.account_circle, color: Colors.blueGrey, size: 80),
                  ),
                  const SizedBox(height: 16),
                  _buildEditableNameRow(context, ref, user.uid, displayName ?? ''),
                  const SizedBox(height: 16),
                  _buildInfoRow('Email', user.email ?? 'Email yok'),
                  const SizedBox(height: 12),
                  _buildInfoRow('UID', user.uid),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Hata oluştu'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Kapat'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  final userId = user.uid;
                  
                  // Oda seçimini temizle
                  ref.read(selectedRoomProvider.notifier).clear();
                  
                  // Tüm provider'ları invalidate et
                  ref.invalidate(selectedRoomProvider);
                  if (userId != null) {
                    ref.invalidate(loadUserRoomsProvider(userId));
                    ref.invalidate(loadUserRoomRequestsProvider(userId));
                  }
                  
                  // Çıkış yap
                  await ref.read(authRepositoryProvider).signOut();
                  
                  // Biraz bekle ki Firebase state güncellensin
                  await Future.delayed(const Duration(milliseconds: 500));
                  
                  // Sign in ekranına yönlendir
                  if (context.mounted) {
                    context.go('/signIn');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Çıkış Yap'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditableNameRow(BuildContext context, WidgetRef ref, String userId, String currentName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İsim',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  currentName.isEmpty ? 'İsim belirtilmemiş' : currentName,
                  style: TextStyle(
                    fontSize: 14,
                    color: currentName.isEmpty ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _editDisplayName(context, ref, userId, currentName),
            ),
          ],
        ),
      ],
    );
  }

  void _editDisplayName(BuildContext context, WidgetRef ref, String userId, String currentName) async {
    final controller = TextEditingController(text: currentName);
    
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('İsmini Düzenle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'İsminizi girin',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx, controller.text.trim());
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      try {
        await ref.read(roomRepositoryProvider).updateUserDisplayName(userId, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('İsim güncellendi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      }
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isCode = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCode ? Colors.blue[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isCode ? Colors.blue[300]! : Colors.grey[300]!,
            ),
          ),
          child: SelectableText(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isCode ? FontWeight.bold : FontWeight.normal,
              color: isCode ? Colors.blue[900] : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteRoomConfirmation(BuildContext context, Room room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Odayı Sil'),
        content: Text(
          '${room.name} odasını silmek istediğinize emin misiniz?\n\nBu işlem geri alınamaz ve odadaki tüm görevler silinecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(roomRepositoryProvider).deleteRoom(room.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Oda silindi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Kullanıcı bulunamadı')),
          );
        }
        
        return _buildRoomSelectionContent(context, user);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const Scaffold(
        body: Center(child: Text('Hata oluştu')),
      ),
    );
  }
  
  Widget _buildRoomSelectionContent(BuildContext context, user) {
    final userRooms = ref.watch(loadUserRoomsProvider(user.uid));
    final userRequests = ref.watch(loadUserRoomRequestsProvider(user.uid));

    final selectedRoomId = ref.watch(selectedRoomProvider);
    if (selectedRoomId != null) {
      // Room seçildi, ana ekrana yönlendir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/main');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oda Seç'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => _showProfilePopup(context, user),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Oda seçimini temizle
              ref.read(selectedRoomProvider.notifier).clear();
              
              // Tüm provider'ları invalidate et
              ref.invalidate(selectedRoomProvider);
              ref.invalidate(loadUserRoomsProvider(user.uid));
              ref.invalidate(loadUserRoomRequestsProvider(user.uid));
              
              // Çıkış yap
              await ref.read(authRepositoryProvider).signOut();
              
              // Biraz bekle ki Firebase state güncellensin
              await Future.delayed(const Duration(milliseconds: 500));
              
              // Sign in ekranına yönlendir
              if (context.mounted) {
                context.go('/signIn');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Butonlar - Üst kısımda ortalanmış
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showCreateRoomDialog(context, user),
                  icon: const Icon(Icons.add_business, size: 22),
                  label: const Text(
                    'Oda Oluştur',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _showJoinRoomDialog(context, user),
                  icon: const Icon(Icons.login, size: 22),
                  label: const Text(
                    'Odaya Katıl',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Benim Odalarım
            Text(
              'Benim Odalarım',
              style: Appstyles.titleTextStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 12),
            userRooms.when(
              data: (rooms) {
                if (rooms.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Henüz bir odaya katılmadınız'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];
                    final isOwner = room.ownerId == user.uid;
                    final isMember = room.memberIds.contains(user.uid);
                    // Sadece member olan odaları göster
                    if (!isMember && !isOwner) {
                      return const SizedBox.shrink();
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(room.name[0].toUpperCase()),
                        ),
                        title: Text(room.name),
                        subtitle: Text(
                          isOwner ? 'Sahip' : 'Üye • ${room.memberIds.length} üye',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isOwner)
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editRoomName(context, room);
                                  } else if (value == 'delete') {
                                    _showDeleteRoomConfirmation(context, room);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Oda Adını Değiştir'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Odayı Sil', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: () {
                                ref.read(selectedRoomProvider.notifier).setRoom(room.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Hata: $e'),
            ),
            const SizedBox(height: 24),

            // Bekleyen İsteklerim
            userRequests.when(
              data: (requests) {
                final pendingRequests = requests
                    .where((r) => r.status == RoomRequestStatus.pending)
                    .toList();
                if (pendingRequests.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bekleyen İsteklerim',
                      style: Appstyles.titleTextStyle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ...pendingRequests.map((request) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.pending, color: Colors.orange),
                            title: Text(request.roomName),
                            subtitle: const Text('Beklemede'),
                          ),
                        )),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context, user) {
    _roomNameController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_business, color: Colors.blue),
            SizedBox(width: 8),
            Text('Yeni Oda Oluştur'),
          ],
        ),
        content: TextField(
          controller: _roomNameController,
          decoration: InputDecoration(
            hintText: 'Oda adı',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.meeting_room),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _roomNameController.clear();
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: _isCreatingRoom ? null : () {
              Navigator.pop(ctx);
              _createRoom(user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: _isCreatingRoom
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

  void _createRoom(user) async {
    final roomName = _roomNameController.text.trim();
    if (roomName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oda adı boş olamaz')),
      );
      return;
    }

    setState(() => _isCreatingRoom = true);

    try {
      final roomId = await ref.read(roomRepositoryProvider).createRoom(
        name: roomName,
        ownerId: user.uid,
        ownerEmail: user.email ?? '',
      );

      if (mounted) {
        _roomNameController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$roomName odası oluşturuldu'),
            backgroundColor: Colors.green,
          ),
        );
        // Odayı seç ve ana ekrana git
        ref.read(selectedRoomProvider.notifier).setRoom(roomId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } finally {
      setState(() => _isCreatingRoom = false);
    }
  }

  void _showJoinRoomDialog(BuildContext context, user) {
    _roomCodeController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.login, color: Colors.green),
            SizedBox(width: 8),
            Text('Odaya Katıl'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _roomCodeController,
              decoration: InputDecoration(
                hintText: 'Oda kodu (örn: A1B2C)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.vpn_key),
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 5,
              autofocus: true,
            ),
            const SizedBox(height: 8),
            const Text(
              '5 haneli oda kodunu girin',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _roomCodeController.clear();
            },
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: _isJoiningRoom ? null : () {
              Navigator.pop(ctx);
              _joinRoomByCode(user);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: _isJoiningRoom
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Katıl'),
          ),
        ],
      ),
    );
  }

}
