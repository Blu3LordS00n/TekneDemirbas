import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/domain/permission.dart';
import 'package:tekne_demirbas/features/room_management/domain/room.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/add_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/all_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/completed_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/incomplete_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/room_management_dialog.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/room_requests_dialog.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Görevlerim';
      case 1:
        return 'Tamamlanmamış Görevlerim';
      case 2:
        return 'Görev Oluştur';
      case 3:
        return 'Tamamlanmış Görevlerim';
      default:
        return 'Ana Ekran';
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ref.watch(selectedRoomProvider);
    final roomAsync = roomId != null ? ref.watch(loadRoomProvider(roomId)) : null;

    final currentUserAsync = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => _showAccountDialog(context, ref),
          tooltip: 'Hesabım',
        ),
        title: Text(_getPageTitle(currentIndex)),
        actions: [
          // Oda Seçimi
          roomAsync?.when(
            data: (room) {
              // Bekleyen istek sayısını kontrol et (sadece oda sahibi için)
              final isOwner = room != null && room.ownerId == ref.read(currentUserProvider).value?.uid;
              final pendingRequestsAsync = isOwner && roomId != null
                  ? ref.watch(pendingRoomRequestsCountProvider(roomId!))
                  : null;

              return PopupMenuButton<String>(
                tooltip: 'Oda Seç',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: pendingRequestsAsync?.when(
                        data: (count) => count > 0
                            ? Badge(
                                label: Text('$count'),
                                child: const Icon(Icons.meeting_room),
                              )
                            : const Icon(Icons.meeting_room),
                        loading: () => const Icon(Icons.meeting_room),
                        error: (_, __) => const Icon(Icons.meeting_room),
                      ) ??
                      const Icon(Icons.meeting_room),
                ),
                onSelected: (value) {
                  if (value == 'exit') {
                    // Odadan çık
                    ref.read(selectedRoomProvider.notifier).clear();
                    context.go('/roomSelection');
                  } else if (value == 'info' && room != null) {
                    // Oda bilgileri
                    _showRoomInfo(context, room);
                  } else if (value == 'requests' && room != null) {
                    // İstekler
                    _showRoomRequests(context, roomId!);
                  } else if (value == 'manage' && room != null) {
                    // Oda yönetimi (izinler)
                    _showRoomManagement(context, roomId!, room);
                  }
                },
                itemBuilder: (context) {
                  final pendingCountAsync = roomId != null && room != null && room.ownerId == ref.read(currentUserProvider).value?.uid
                      ? ref.watch(pendingRoomRequestsCountProvider(roomId!))
                      : null;
                  
                  return [
                    PopupMenuItem(
                      value: 'info',
                      child: const Row(
                        children: [
                          Icon(Icons.info),
                          SizedBox(width: 8),
                          Text('Oda Bilgileri'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'exit',
                      child: const Row(
                        children: [
                          Icon(Icons.exit_to_app),
                          SizedBox(width: 8),
                          Text('Odadan Çık'),
                        ],
                      ),
                    ),
                    if (room != null && room.ownerId == ref.read(currentUserProvider).value?.uid)
                      PopupMenuItem(
                        value: 'requests',
                        child: pendingCountAsync?.when(
                              data: (count) => Row(
                                    children: [
                                      count > 0
                                          ? Badge(
                                              label: Text('$count'),
                                              child: const Icon(Icons.notifications),
                                            )
                                          : const Icon(Icons.notifications),
                                      const SizedBox(width: 8),
                                      const Text('İstekler'),
                                    ],
                                  ),
                              loading: () => const Row(
                                    children: [
                                      Icon(Icons.notifications),
                                      SizedBox(width: 8),
                                      Text('İstekler'),
                                    ],
                                  ),
                              error: (_, __) => const Row(
                                    children: [
                                      Icon(Icons.notifications),
                                      SizedBox(width: 8),
                                      Text('İstekler'),
                                    ],
                                  ),
                            ) ??
                            const Row(
                              children: [
                                Icon(Icons.notifications),
                                SizedBox(width: 8),
                                Text('İstekler'),
                              ],
                            ),
                      ),
                    if (room != null)
                      PopupMenuItem(
                        value: 'manage',
                        child: const Row(
                          children: [
                            Icon(Icons.settings),
                            SizedBox(width: 8),
                            Text('Oda Yönetimi'),
                          ],
                        ),
                      ),
                  ];
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => IconButton(
              icon: const Icon(Icons.error),
              onPressed: () => context.go('/roomSelection'),
            ),
          ) ?? IconButton(
            icon: const Icon(Icons.meeting_room),
            tooltip: 'Oda Seç',
            onPressed: () => context.go('/roomSelection'),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllTasksScreen(),
          IncompleteTasksScreen(),
          AddTasksScreen(),
          CompletedTasksScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
          _tabController.animateTo(value);
        },
        iconSize: 20.0,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Ana Sayfa',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous_outlined),
            label: 'Tamamlanmamis',
            activeIcon: Icon(Icons.dangerous),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ekle',
            activeIcon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tamamlanmis',
            activeIcon: Icon(Icons.check_box),
          ),
        ],
      ),
    );
  }

  void _showRoomManagement(BuildContext context, String roomId, Room room) {
    showDialog(
      context: context,
      builder: (ctx) => RoomManagementDialog(roomId: roomId, room: room),
    );
  }

  void _showRoomRequests(BuildContext context, String roomId) {
    showDialog(
      context: context,
      builder: (ctx) => RoomRequestsDialog(roomId: roomId),
    );
  }

  void _showRoomInfo(BuildContext context, Room room) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.meeting_room, color: Colors.blue),
            SizedBox(width: 8),
            Text('Oda Bilgileri'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Oda Adı', room.name),
            const SizedBox(height: 12),
            _buildInfoRow('Oda Kodu', room.code, isCode: true),
            const SizedBox(height: 12),
            _buildInfoRow('Üye Sayısı', '${room.memberIds.length}'),
            const SizedBox(height: 12),
            _buildInfoRow('Oluşturulma', _formatDate(room.createdAt)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAccountDialog(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.read(currentUserProvider);
    
    currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kullanıcı bulunamadı')),
          );
          return;
        }
        
        showDialog(
          context: context,
          builder: (ctx) => Consumer(
            builder: (context, ref, _) {
              final displayNameAsync = ref.watch(loadUserDisplayNameProvider(currentUser.uid));
              
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
                      _buildEditableNameRow(context, ref, currentUser.uid, displayName ?? ''),
                      const SizedBox(height: 16),
                      _buildInfoRow('Email', currentUser.email ?? 'Email yok'),
                      const SizedBox(height: 12),
                      _buildInfoRow('UID', currentUser.uid),
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
                      final userId = currentUser.uid;
                      
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
      },
      loading: () {
        showDialog(
          context: context,
          builder: (ctx) => const AlertDialog(
            content: Center(child: CircularProgressIndicator()),
          ),
        );
      },
      error: (_, __) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hata oluştu')),
        );
      },
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

}
