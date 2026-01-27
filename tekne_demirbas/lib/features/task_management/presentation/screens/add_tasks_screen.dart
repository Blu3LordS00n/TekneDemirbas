import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tekne_demirbas/common_widgets/async_value_ui.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/permission_provider.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/storage_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/controllers/boat_type_controller.dart';
import 'package:tekne_demirbas/features/task_management/presentation/controllers/task_type_controller.dart';
import 'package:tekne_demirbas/features/task_management/presentation/firestore_controller.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/boat_type_provider.dart' as boat_provider;
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_type_provider.dart' as task_provider;
import 'package:tekne_demirbas/features/task_management/presentation/screens/main_screen.dart';

import 'package:video_player/video_player.dart';

import 'package:tekne_demirbas/features/task_management/presentation/widgets/confirm_delete_dialog.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/editable_dropdown.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/editable_item_dialog.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/title_description.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class AddTasksScreen extends ConsumerStatefulWidget {
  const AddTasksScreen({super.key});

  @override
  ConsumerState<AddTasksScreen> createState() => _AddTasksScreenState();
}

class _AddTasksScreenState extends ConsumerState<AddTasksScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final int _lockedTaskTypeCount = 4;
  int _selectedTaskTypeIndex = 0;

  final int _lockedBoatTypeCount = 0;
  int _selectedBoatTypeIndex = 0;

  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];
  File? _video;
  VideoPlayerController? _videoController;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (picked != null) {
      setState(() {
        _images.add(File(picked.path));
      });
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? picked = await _picker.pickVideo(source: source);
    if (picked != null) {
      _videoController?.dispose();
      final file = File(picked.path);
      final controller = VideoPlayerController.file(file);
      await controller.initialize();

      setState(() {
        _video = file;
        _videoController = controller;
      });
    }
  }

  Future<void> _showMediaTypePicker({required bool fromCamera}) async {
    final type = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Appstyles.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Appstyles.borderRadiusLarge),
              topRight: Radius.circular(Appstyles.borderRadiusLarge),
            ),
            boxShadow: Appstyles.strongShadow,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
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
                        child: const Icon(Icons.perm_media, color: Appstyles.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Medya Türü Seç",
                        style: Appstyles.headingTextStyle.copyWith(
                          color: Appstyles.primaryBlue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: Appstyles.oceanGradient,
                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                    ),
                    child: const Icon(Icons.photo, color: Appstyles.white),
                  ),
                  title: Text("Fotoğraf", style: Appstyles.titleTextStyle),
                  onTap: () => Navigator.pop(context, "image"),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                      ),
                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                    ),
                    child: const Icon(Icons.videocam, color: Appstyles.white),
                  ),
                  title: Text("Video", style: Appstyles.titleTextStyle),
                  onTap: () => Navigator.pop(context, "video"),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (type == null) return;

    if (type == "image") {
      _pickImage(fromCamera ? ImageSource.camera : ImageSource.gallery);
    } else {
      _pickVideo(fromCamera ? ImageSource.camera : ImageSource.gallery);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    if (user == null) {
      return Center(
        child: Text(
          'Kullanıcı bulunamadı',
          style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
        ),
      );
    }
    final userId = user.uid;
    final state = ref.watch(firestoreControllerProvider);
    final email = user.email;
    
    // Görev ekleme yetkisi kontrolü
    final canAddTask = ref.watch(canAddTaskProvider);

    final boatTypeAsync = ref.watch(boat_provider.boatTypesProvider);
    final boatController = ref.read(boatTypeControllerProvider.notifier);

    final taskTypeAsync = ref.watch(task_provider.taskTypesProvider);
    final taskTypeController = ref.read(taskTypeControllerProvider.notifier);

    ref.listen<AsyncValue>(firestoreControllerProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });
    
    // Yetki yoksa mesaj göster
    if (!canAddTask) {
      return Container(
        decoration: const BoxDecoration(
          gradient: Appstyles.lightOceanGradient,
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
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
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                    boxShadow: Appstyles.softShadow,
                  ),
                  child: const Icon(Icons.block, size: 64, color: Colors.red),
                ),
                const SizedBox(height: 24),
                Text(
                  'Görev Ekleme Yetkiniz Yok',
                  style: Appstyles.headingTextStyle.copyWith(
                    color: Appstyles.textDark,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Lütfen oda yöneticisinden yetki isteyin',
                  style: Appstyles.normalTextStyle.copyWith(
                    color: Appstyles.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: Appstyles.lightOceanGradient,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleDescription(
              title: 'Görev Adı',
              prefixIcon: Icons.notes,
              hintText: 'Görev adı gir',
              maxLines: 1,
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            TitleDescription(
              title: 'Görev Tanımı',
              prefixIcon: Icons.notes,
              hintText: 'Görev tanımı gir',
              maxLines: 3,
              controller: _descriptionController,
            ),
            const SizedBox(height: 20),

            taskTypeAsync.when(
              data: (taskTypes) {
                if (taskTypes.isEmpty) {
                  return Text(
                    "Henüz iş türü yok",
                    style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textLight),
                  );
                }
                final names = taskTypes.map((t) => t.name).toList();

                return EditableDropdown(
                  label: "İş Türü",
                  items: names,
                  selectedIndex: _selectedTaskTypeIndex,
                  lockedCount: _lockedTaskTypeCount,

                  onChanged: (i) {
                    setState(() => _selectedTaskTypeIndex = i);
                  },

                  // ➕ EKLE
                  onAddNew: () async {
                    final name = await showAddItemDialog(
                      context: context,
                      title: "Yeni İş Türü",
                      hint: "İş Türü Adı",
                    );

                    if (name != null && name.trim().isNotEmpty) {
                      await taskTypeController.addTaskType(name.trim());
                      setState(() {
                        _selectedTaskTypeIndex = names.length;
                      });
                    }
                  },

                  // 🗑 SİL (soft delete)
                  onDelete: (i) async {
                    final confirmed = await showConfirmDeleteDialog(
                      context: context,
                      itemName: names[i],
                    );

                    if (confirmed) {
                      await taskTypeController.deleteTaskType(taskTypes[i].id);

                      if (_selectedTaskTypeIndex >= i &&
                          _selectedTaskTypeIndex > 0) {
                        setState(() => _selectedTaskTypeIndex--);
                      }
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, stackTrace) => Text(
                "Hata: $e\n\nStack: $stackTrace",
                style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
              ),
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            boatTypeAsync.when(
              data: (boats) {
                final names = boats.map((b) => b.name).toList();

                return EditableDropdown(
                  label: "Tekne",
                  items: names,
                  selectedIndex: _selectedBoatTypeIndex,
                  lockedCount: 0,

                  onChanged: (i) {
                    setState(() => _selectedBoatTypeIndex = i);
                  },

                  // ➕ EKLE
                  onAddNew: () async {
                    final name = await showAddItemDialog(
                      context: context,
                      title: "Yeni Tekne",
                      hint: "Tekne Adı",
                    );

                    if (name != null && name.trim().isNotEmpty) {
                      await boatController.addBoat(name.trim());
                      setState(() {
                        _selectedBoatTypeIndex = names.length;
                      });
                    }
                  },

                  // 🗑 SİL (soft delete)
                  onDelete: (i) async {
                    final confirmed = await showConfirmDeleteDialog(
                      context: context,
                      itemName: names[i],
                    );

                    if (confirmed) {
                      await boatController.deleteBoat(boats[i].id);

                      if (_selectedBoatTypeIndex >= i &&
                          _selectedBoatTypeIndex > 0) {
                        setState(() => _selectedBoatTypeIndex--);
                      }
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(
                "Hata: $e",
                style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
              ),
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(20)),

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
                    child: const Icon(Icons.perm_media, color: Appstyles.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Medya",
                    style: Appstyles.headingTextStyle.copyWith(
                      color: Appstyles.primaryBlue,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: Appstyles.oceanGradient,
                    shape: BoxShape.circle,
                    boxShadow: Appstyles.mediumShadow,
                  ),
                  child: IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.camera_alt, color: Appstyles.white),
                    onPressed: () => _showMediaTypePicker(fromCamera: true),
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Appstyles.secondaryBlue, Appstyles.primaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: Appstyles.mediumShadow,
                  ),
                  child: IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.photo_library, color: Appstyles.white),
                    onPressed: () => _showMediaTypePicker(fromCamera: false),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            if (_images.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                              border: Border.all(color: Appstyles.lightBlue, width: 2),
                              boxShadow: Appstyles.softShadow,
                              image: DecorationImage(
                                image: FileImage(_images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: Appstyles.softShadow,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            if (_videoController != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                  border: Border.all(color: Appstyles.lightBlue, width: 2),
                  boxShadow: Appstyles.softShadow,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Appstyles.borderRadiusSmall - 2),
                        topRight: Radius.circular(Appstyles.borderRadiusSmall - 2),
                      ),
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _videoController?.dispose();
                                setState(() {
                                  _videoController = null;
                                  _video = null;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: SizeConfig.getProportionateHeight(32)),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: Appstyles.oceanGradient,
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                boxShadow: Appstyles.mediumShadow,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading ? null : () async {
                // Yetki kontrolü
                final canAdd = ref.read(canAddTaskProvider);
                if (!canAdd) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Görev ekleme yetkiniz yok',
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
                
                final title = _titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Görev adı boş olamaz',
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

                final roomId = ref.read(selectedRoomProvider);
                if (roomId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Lütfen bir oda seçin',
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
                
                // Loading başlat
                setState(() {
                  _isLoading = true;
                });

                try {
                final description = _descriptionController.text.trim();
                final taskTypes = ref.read(task_provider.taskTypesProvider).value!;
                String taskType = taskTypes[_selectedTaskTypeIndex].name;
                final boatTypes = ref.read(boat_provider.boatTypesProvider).value!;
                String boatType = boatTypes[_selectedBoatTypeIndex].name;
                String date = DateTime.now().toString();

                final myTask = Task(
                  title: title,
                  description: description,
                  taskType: taskType,
                  boatType: boatType,
                  createdBy: userId, // UID olarak sakla
                  date: date,
                  roomId: roomId,
                );

                // Önce task'ı oluştur
                final taskId = await ref
                    .read(firestoreRepositoryProvider)
                    .addTask(task: myTask, userId: userId, roomId: roomId);

                // Medya varsa yükle
                List<String>? imageUrls;
                String? videoUrl;

                if (_images.isNotEmpty || _video != null) {
                  final storageRepo = ref.read(storageRepositoryProvider);
                  
                  // Resimleri yükle
                  if (_images.isNotEmpty) {
                    try {
                      imageUrls = await storageRepo.uploadImages(_images, taskId);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Resimler yüklenirken hata: $e',
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

                  // Videoyu yükle
                  if (_video != null) {
                    try {
                      videoUrl = await storageRepo.uploadVideo(_video!, taskId);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Video yüklenirken hata: $e',
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

                  // Task'ı medya URL'leri ile güncelle
                  if (imageUrls != null || videoUrl != null) {
                    final updatedTask = myTask.copyWith(
                      id: taskId,
                      imageUrls: imageUrls ?? [],
                      videoUrl: videoUrl,
                    );
                    await ref.read(firestoreRepositoryProvider).updateTask(
                      task: updatedTask,
                      taskId: taskId,
                      userId: userId,
                    );
                  }
                }

                // Başarılı mesajı göster ve formu temizle
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Appstyles.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Görev başarıyla eklendi!',
                              style: Appstyles.normalTextStyle.copyWith(
                                color: Appstyles.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green.shade400,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _images.clear();
                    _video = null;
                    _videoController?.dispose();
                    _videoController = null;
                  });
                  
                  // Görevlerim ekranına (index 0) yönlendir
                  final tabController = ref.read(tabControllerStateProvider);
                  if (tabController != null) {
                    tabController.animateTo(0);
                  }
                }
                } catch (e) {
                  // Hata durumunda loading'i kapat
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Görev eklenirken hata oluştu: $e',
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
                  },
                  borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Appstyles.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_task, color: Appstyles.white, size: 28),
                              const SizedBox(width: 12),
                              Text(
                                'Görev Ekle',
                                style: Appstyles.titleTextStyle.copyWith(
                                  fontSize: 20,
                                  color: Appstyles.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      );
  }
}
