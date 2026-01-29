import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/domain/room.dart';
import 'package:tekne_demirbas/features/room_management/domain/room_request.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/permission_provider.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

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
        SnackBar(
          content: Text(
            'Oda kodu boş olamaz',
            style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
          ),
        ),
      );
      return;
    }
    
    if (roomCode.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Oda kodu 5 haneli olmalıdır',
            style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
          ),
        ),
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
            SnackBar(
              content: Text(
                'Bu kod ile oda bulunamadı',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
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
            content: Text(
              '${room.name} odasına katılım isteği gönderildi',
              style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
            ),
            backgroundColor: Appstyles.primaryBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
            ),
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

  void _showRoomActionDialog(BuildContext context, WidgetRef ref, Room room, User user) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: Appstyles.oceanGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.meeting_room, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        room.name,
                        style: Appstyles.headingTextStyle.copyWith(
                          color: Appstyles.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: Appstyles.oceanGradient,
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                          boxShadow: Appstyles.mediumShadow,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ref.read(selectedRoomProvider.notifier).setRoom(room.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Appstyles.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Odaya Gir',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await _leaveRoom(context, ref, room.id, user.uid);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                          side: BorderSide(color: Colors.red.shade300, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Odadan Ayrıl',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _leaveRoom(BuildContext context, WidgetRef ref, String roomId, String userId) async {
    try {
      await ref.read(roomRepositoryProvider).removeMemberFromRoom(userId, roomId);
      
      // Kullanıcının permission'larını da sil
      final permissionsSnapshot = await FirebaseFirestore.instance
          .collection('room_permissions')
          .where('userId', isEqualTo: userId)
          .where('roomId', isEqualTo: roomId)
          .get();
      
      for (var doc in permissionsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Pending request'leri de temizle
      final requestsSnapshot = await FirebaseFirestore.instance
          .collection('room_requests')
          .where('userId', isEqualTo: userId)
          .where('roomId', isEqualTo: roomId)
          .get();
      
      for (var doc in requestsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Odadan ayrıldınız',
              style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
            ),
            backgroundColor: Colors.green.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Hata: $e',
              style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
            ),
          ),
        );
      }
    }
  }

  void _editRoomName(BuildContext context, Room room) async {
    final controller = TextEditingController(text: room.name);
    
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: Appstyles.oceanGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Oda Adını Değiştir',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                      decoration: InputDecoration(
                        hintText: 'Yeni oda adı',
                        hintStyle: Appstyles.subtitleTextStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                        ),
                        filled: true,
                        fillColor: Appstyles.white,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: Appstyles.oceanGradient,
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.text.trim().isNotEmpty) {
                                  Navigator.pop(ctx, controller.text.trim());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Kaydet',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty && mounted) {
      try {
        await ref.read(roomRepositoryProvider).updateRoomName(room.id, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Oda adı güncellendi',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Hata: $e',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
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
          
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Appstyles.white,
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
                boxShadow: Appstyles.strongShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: Appstyles.oceanGradient,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                        topRight: Radius.circular(Appstyles.borderRadiusLarge),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: Appstyles.white, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Hesap Bilgileri',
                          style: Appstyles.headingTextStyle.copyWith(
                            color: Appstyles.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        displayNameAsync.when(
                          data: (displayName) => Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: Appstyles.oceanGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: Appstyles.mediumShadow,
                                  ),
                                  child: const Icon(Icons.account_circle, color: Appstyles.white, size: 60),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildEditableNameRow(context, ref, user.uid, displayName ?? ''),
                              const SizedBox(height: 20),
                              _buildInfoRow('Email', user.email ?? 'Email yok'),
                            ],
                          ),
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (_, __) => Text(
                            'Hata oluştu',
                            style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Appstyles.textLight,
                                  side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                  ),
                                ),
                                child: const Text('Kapat', style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.red.shade400, Colors.red.shade600],
                                  ),
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                  boxShadow: Appstyles.mediumShadow,
                                ),
                                child: ElevatedButton(
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
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Appstyles.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Çıkış Yap',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEditableNameRow(BuildContext context, WidgetRef ref, String userId, String currentName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İsim',
          style: Appstyles.subtitleTextStyle.copyWith(
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
                  style: Appstyles.normalTextStyle.copyWith(
                    color: currentName.isEmpty ? Appstyles.textLight : Appstyles.textDark,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                gradient: Appstyles.oceanGradient,
                shape: BoxShape.circle,
                boxShadow: Appstyles.softShadow,
              ),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Appstyles.white),
                onPressed: () => _editDisplayName(context, ref, userId, currentName),
              ),
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
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: Appstyles.oceanGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'İsmini Düzenle',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                      decoration: InputDecoration(
                        hintText: 'İsminizi girin',
                        hintStyle: Appstyles.subtitleTextStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                        ),
                        filled: true,
                        fillColor: Appstyles.white,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: Appstyles.oceanGradient,
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx, controller.text.trim());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Kaydet',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && mounted) {
      try {
        await ref.read(roomRepositoryProvider).updateUserDisplayName(userId, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'İsim güncellendi',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Hata: $e',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
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
          style: Appstyles.subtitleTextStyle.copyWith(
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
            style: Appstyles.normalTextStyle.copyWith(
              fontWeight: isCode ? FontWeight.bold : FontWeight.normal,
              color: isCode ? Appstyles.primaryBlue : Appstyles.textDark,
            ),
          ),
        ),
      ],
    );
  }

  void _showLeaveRoomConfirmation(BuildContext context, WidgetRef ref, Room room, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.exit_to_app, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Odadan Ayrıl',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${room.name} odasından ayrılmak istediğinize emin misiniz?\n\nBu odaya olan erişiminiz kesilecektir.',
                      style: Appstyles.normalTextStyle.copyWith(
                        color: Appstyles.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.orange.shade400, Colors.orange.shade600],
                              ),
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Evet, Ayrıl',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      await _leaveRoom(context, ref, room.id, userId);
    }
  }

  void _showDeleteRoomConfirmation(BuildContext context, Room room) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Odayı Sil',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${room.name} odasını silmek istediğinize emin misiniz?\n\nBu işlem geri alınamaz ve odadaki tüm görevler silinecektir.',
                      style: Appstyles.normalTextStyle.copyWith(
                        color: Appstyles.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade400, Colors.red.shade600],
                              ),
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Evet, Sil',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(roomRepositoryProvider).deleteRoom(room.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Oda silindi',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.green.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Hata: $e',
                style: Appstyles.normalTextStyle.copyWith(color: Appstyles.white),
              ),
              backgroundColor: Colors.red.shade400,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
              ),
            ),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
    final isAdminAsync = ref.watch(isAdminProvider);
    final isAdmin = isAdminAsync.when(
      data: (v) => v,
      loading: () => false,
      error: (_, __) => false,
    );

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

    // Admin olmayan + en az 1 odaya katılmış → oda seçimi atla, direkt main (Devam Eden)
    final rooms = userRooms.when<List<Room>?>(
      data: (r) => r,
      loading: () => null,
      error: (_, __) => null,
    );
    final isAdminValue = isAdminAsync.when<bool?>(
      data: (b) => b,
      loading: () => null,
      error: (_, __) => null,
    );
    if (rooms != null &&
        isAdminValue != null &&
        !isAdminValue &&
        rooms.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedRoomProvider.notifier).setRoom(rooms.first.id);
        context.go('/main');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Appstyles.lightGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Appstyles.white,
        title: Text(
          'Oda Seç',
          style: Appstyles.headingTextStyle.copyWith(
            color: Appstyles.primaryBlue,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Appstyles.lightBlue,
            shape: BoxShape.circle,
            boxShadow: Appstyles.softShadow,
          ),
          child: IconButton(
            icon: const Icon(Icons.person, color: Appstyles.primaryBlue),
            onPressed: () => _showProfilePopup(context, user),
          ),
        ),
        iconTheme: IconThemeData(color: Appstyles.primaryBlue),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: Appstyles.lightOceanGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Butonlar - Admin kontrolüne göre gösterilir
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Oda Oluştur butonu sadece admin için görünür
                  if (isAdmin) ...[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: Appstyles.oceanGradient,
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                          boxShadow: Appstyles.mediumShadow,
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _showCreateRoomDialog(context, user),
                          icon: const Icon(Icons.add_business, size: 22),
                          label: Text(
                            'Oda Oluştur',
                            style: Appstyles.titleTextStyle.copyWith(
                              color: Appstyles.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            foregroundColor: Appstyles.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  // Odaya Katıl butonu - admin değilse ortalanmış, admin ise yan yana
                  isAdmin
                      ? Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () => _showJoinRoomDialog(context, user),
                              icon: const Icon(Icons.login, size: 22),
                              label: Text(
                                'Odaya Katıl',
                                style: Appstyles.titleTextStyle.copyWith(
                                  color: Appstyles.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                                foregroundColor: Appstyles.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                            boxShadow: Appstyles.mediumShadow,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _showJoinRoomDialog(context, user),
                            icon: const Icon(Icons.login, size: 22),
                            label: Text(
                              'Odaya Katıl',
                              style: Appstyles.titleTextStyle.copyWith(
                                color: Appstyles.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                              foregroundColor: Appstyles.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                ],
              ),
            const SizedBox(height: 32),
            // Benim Odalarım
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Appstyles.lightBlue, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: Appstyles.oceanGradient,
                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                    ),
                    child: const Icon(Icons.meeting_room, color: Appstyles.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Benim Odalarım',
                    style: Appstyles.headingTextStyle.copyWith(
                      color: Appstyles.primaryBlue,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            userRooms.when(
              data: (rooms) {
                if (rooms.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Appstyles.white,
                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                      border: Border.all(color: Appstyles.lightBlue, width: 1.5),
                      boxShadow: Appstyles.softShadow,
                    ),
                    child: Center(
                      child: Text(
                        'Henüz bir odaya katılmadınız',
                        style: Appstyles.normalTextStyle.copyWith(
                          color: Appstyles.textLight,
                        ),
                      ),
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Appstyles.white,
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                        border: Border.all(
                          color: isOwner ? Appstyles.primaryBlue : Appstyles.lightBlue,
                          width: isOwner ? 2 : 1.5,
                        ),
                        boxShadow: Appstyles.softShadow,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: isOwner ? Appstyles.oceanGradient : LinearGradient(
                              colors: [Appstyles.lightBlue, Appstyles.white],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: Appstyles.softShadow,
                          ),
                          child: Center(
                            child: Text(
                              room.name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isOwner ? Appstyles.white : Appstyles.primaryBlue,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          room.name,
                          style: Appstyles.titleTextStyle.copyWith(
                            color: Appstyles.textDark,
                          ),
                        ),
                        subtitle: Text(
                          isOwner ? 'Sahip' : 'Üye • ${room.memberIds.length} üye',
                          style: Appstyles.subtitleTextStyle,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Appstyles.primaryBlue),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _editRoomName(context, room);
                                } else if (value == 'delete') {
                                  _showDeleteRoomConfirmation(context, room);
                                } else if (value == 'leave') {
                                  _showLeaveRoomConfirmation(context, ref, room, user.uid);
                                }
                              },
                              itemBuilder: (context) => [
                                if (isOwner) ...[
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Appstyles.primaryBlue),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Oda Adını Değiştir',
                                          style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.delete, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Odayı Sil',
                                          style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else ...[
                                  PopupMenuItem(
                                    value: 'leave',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.exit_to_app, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Odadan Ayrıl',
                                          style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                gradient: Appstyles.oceanGradient,
                                shape: BoxShape.circle,
                                boxShadow: Appstyles.softShadow,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward, color: Appstyles.white),
                                onPressed: () {
                                  // Mavi ok her zaman odaya girişi temsil eder
                                  ref.read(selectedRoomProvider.notifier).setRoom(room.id);
                                },
                              ),
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
            const SizedBox(height: 32),

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
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Appstyles.lightBlue, width: 2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                            ),
                            child: const Icon(Icons.pending, color: Colors.orange, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Bekleyen İsteklerim',
                            style: Appstyles.headingTextStyle.copyWith(
                              color: Appstyles.primaryBlue,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pendingRequests.map((request) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Appstyles.white,
                            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                            border: Border.all(color: Colors.orange.shade300, width: 1.5),
                            boxShadow: Appstyles.softShadow,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.pending, color: Colors.orange),
                            ),
                            title: Text(request.roomName, style: Appstyles.titleTextStyle),
                            subtitle: Text('Beklemede', style: Appstyles.subtitleTextStyle),
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
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context, user) {
    _roomNameController.clear();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: Appstyles.oceanGradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_business, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Yeni Oda Oluştur',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _roomNameController,
                      style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                      decoration: InputDecoration(
                        hintText: 'Oda adı',
                        hintStyle: Appstyles.subtitleTextStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.meeting_room, color: Appstyles.primaryBlue),
                        filled: true,
                        fillColor: Appstyles.white,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _roomNameController.clear();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: Appstyles.oceanGradient,
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: _isCreatingRoom ? null : () {
                                Navigator.pop(ctx);
                                _createRoom(user);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: _isCreatingRoom
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Appstyles.white,
                                      ),
                                    )
                                  : const Text(
                                      'Oluştur',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusLarge),
            boxShadow: Appstyles.strongShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Appstyles.borderRadiusLarge),
                    topRight: Radius.circular(Appstyles.borderRadiusLarge),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.login, color: Appstyles.white, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Odaya Katıl',
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _roomCodeController,
                      style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                      textCapitalization: TextCapitalization.characters,
                      maxLength: 5,
                      decoration: InputDecoration(
                        hintText: 'Oda kodu (örn: A1B2C)',
                        hintStyle: Appstyles.subtitleTextStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                          borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                        ),
                        prefixIcon: const Icon(Icons.vpn_key, color: Appstyles.primaryBlue),
                        filled: true,
                        fillColor: Appstyles.white,
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '5 haneli oda kodunu girin',
                      style: Appstyles.subtitleTextStyle,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              _roomCodeController.clear();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Appstyles.textLight,
                              side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              ),
                            ),
                            child: const Text('İptal', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                              boxShadow: Appstyles.mediumShadow,
                            ),
                            child: ElevatedButton(
                              onPressed: _isJoiningRoom ? null : () {
                                Navigator.pop(ctx);
                                _joinRoomByCode(user);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                foregroundColor: Appstyles.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                                ),
                                elevation: 0,
                              ),
                              child: _isJoiningRoom
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Appstyles.white,
                                      ),
                                    )
                                  : const Text(
                                      'Katıl',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
