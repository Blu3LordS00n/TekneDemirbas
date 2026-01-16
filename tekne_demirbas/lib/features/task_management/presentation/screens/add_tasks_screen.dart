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
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Fotoğraf"),
                onTap: () => Navigator.pop(context, "image"),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text("Video"),
                onTap: () => Navigator.pop(context, "video"),
              ),
            ],
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
      return const Center(child: Text('Kullanıcı bulunamadı'));
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Görev ekleme yetkiniz yok',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Lütfen oda yöneticisinden yetki isteyin',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                  return const Text("Henüz iş türü yok");
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
              error: (e, stackTrace) => Text("Hata: $e\n\nStack: $stackTrace"),
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
              error: (e, _) => Text("Hata: $e"),
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            Text(
              "Medya",
              style: Appstyles.headingTextStyle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () => _showMediaTypePicker(fromCamera: true),
                ),
                IconButton(
                  iconSize: 50,
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _showMediaTypePicker(fromCamera: false),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            if (_images.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            if (_videoController != null)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _videoController?.dispose();
                      setState(() {
                        _videoController = null;
                        _video = null;
                      });
                    },
                  ),
                ],
              ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            InkWell(
              onTap: () async {
                // Yetki kontrolü
                final canAdd = ref.read(canAddTaskProvider);
                if (!canAdd) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Görev ekleme yetkiniz yok'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                final title = _titleController.text.trim();
                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Görev adı boş olamaz')),
                  );
                  return;
                }

                final description = _descriptionController.text.trim();
                final taskTypes = ref.read(task_provider.taskTypesProvider).value!;
                String taskType = taskTypes[_selectedTaskTypeIndex].name;
                final boatTypes = ref.read(boat_provider.boatTypesProvider).value!;
                String boatType = boatTypes[_selectedBoatTypeIndex].name;
                String date = DateTime.now().toString();

                final roomId = ref.read(selectedRoomProvider);
                if (roomId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lütfen bir oda seçin')),
                  );
                  return;
                }

                final myTask = Task(
                  title: title,
                  description: description,
                  taskType: taskType,
                  boatType: boatType,
                  createdBy: email.toString(),
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
                        SnackBar(content: Text('Resimler yüklenirken hata: $e')),
                      );
                    }
                  }

                  // Videoyu yükle
                  if (_video != null) {
                    try {
                      videoUrl = await storageRepo.uploadVideo(_video!, taskId);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Video yüklenirken hata: $e')),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Görev başarıyla eklendi!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
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
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.getProportionateHeight(50),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: state.isLoading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Gorev Ekle',
                            style: Appstyles.normalTextStyle.copyWith(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
  }
}
