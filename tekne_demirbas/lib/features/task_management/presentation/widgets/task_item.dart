import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/permission_provider.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/storage_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/firestore_controller.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/boat_type_provider.dart' as boat_provider;
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_type_provider.dart' as task_provider;
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';
import 'package:video_player/video_player.dart';

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  final ImagePicker _picker = ImagePicker();
  
  void _editTask() {
    final titleController = TextEditingController(text: widget.task.title);
    final descriptionController = TextEditingController(text: widget.task.description);
    String? selectedBoatType = widget.task.boatType;
    String? selectedTaskType = widget.task.taskType;
    
    // Medya için state değişkenleri
    final List<File> newImages = [];
    File? newVideo;
    VideoPlayerController? newVideoController;

    showDialog(
      context: context,
      builder: (ctx) {
        // Dialog kapatıldığında video controller'ı temizle
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (didPop) {
              newVideoController?.dispose();
            }
          },
          child: Consumer(
            builder: (context, ref, _) {
          final boatTypeAsync = ref.watch(boat_provider.boatTypesProvider);
          final taskTypeAsync = ref.watch(task_provider.taskTypesProvider);

          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Icon(Icons.edit, color: Colors.green, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'Görevi Düzenle',
                    style: Appstyles.titleTextStyle.copyWith(fontSize: 22),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Görev Adı
                      Text(
                        'Görev Adı',
                        style: Appstyles.normalTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Görev adını girin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.title),
                        ),
                        style: Appstyles.normalTextStyle,
                      ),
                      const SizedBox(height: 20),

                      // Görev Tanımı
                      Text(
                        'Görev Tanımı',
                        style: Appstyles.normalTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Görev tanımını girin',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.description),
                        ),
                        style: Appstyles.normalTextStyle,
                      ),
                      const SizedBox(height: 20),

                      // Tekne Türü
                      Text(
                        'Tekne Türü',
                        style: Appstyles.normalTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      boatTypeAsync.when(
                        data: (boats) {
                          final boatNames = boats.map((b) => b.name).toList();
                          return DropdownButtonFormField<String>(
                            value: selectedBoatType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: const Icon(Icons.directions_boat),
                            ),
                            items: boatNames.map((name) {
                              return DropdownMenuItem(
                                value: name,
                                child: Text(name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedBoatType = value;
                              });
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Text('Tekne türleri yüklenemedi'),
                      ),
                      const SizedBox(height: 20),

                      // İş Türü
                      Text(
                        'İş Türü',
                        style: Appstyles.normalTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      taskTypeAsync.when(
                        data: (taskTypes) {
                          final taskTypeNames = taskTypes.map((t) => t.name).toList();
                          return DropdownButtonFormField<String>(
                            value: selectedTaskType,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              prefixIcon: const Icon(Icons.work),
                            ),
                            items: taskTypeNames.map((name) {
                              return DropdownMenuItem(
                                value: name,
                                child: Text(name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setDialogState(() {
                                selectedTaskType = value;
                              });
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Text('İş türleri yüklenemedi'),
                      ),
                      const SizedBox(height: 20),
                      
                      // Medya Ekleme Bölümü
                      Text(
                        'Medya',
                        style: Appstyles.normalTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 40,
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
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
                              
                              if (type == "image") {
                                final XFile? picked = await _picker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 70,
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    newImages.add(File(picked.path));
                                  });
                                }
                              } else if (type == "video") {
                                final XFile? picked = await _picker.pickVideo(source: ImageSource.camera);
                                if (picked != null) {
                                  newVideoController?.dispose();
                                  final file = File(picked.path);
                                  final controller = VideoPlayerController.file(file);
                                  await controller.initialize();
                                  setDialogState(() {
                                    newVideo = file;
                                    newVideoController = controller;
                                  });
                                }
                              }
                            },
                          ),
                          IconButton(
                            iconSize: 40,
                            icon: const Icon(Icons.photo_library),
                            onPressed: () async {
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
                              
                              if (type == "image") {
                                final XFile? picked = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 70,
                                );
                                if (picked != null) {
                                  setDialogState(() {
                                    newImages.add(File(picked.path));
                                  });
                                }
                              } else if (type == "video") {
                                final XFile? picked = await _picker.pickVideo(source: ImageSource.gallery);
                                if (picked != null) {
                                  newVideoController?.dispose();
                                  final file = File(picked.path);
                                  final controller = VideoPlayerController.file(file);
                                  await controller.initialize();
                                  setDialogState(() {
                                    newVideo = file;
                                    newVideoController = controller;
                                  });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      
                      // Yeni eklenen resimler
                      if (newImages.isNotEmpty)
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: newImages.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(8),
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: FileImage(newImages[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setDialogState(() {
                                          newImages.removeAt(index);
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
                      
                      // Yeni eklenen video
                      if (newVideoController != null)
                        Column(
                          children: [
                            AspectRatio(
                              aspectRatio: newVideoController!.value.aspectRatio,
                              child: VideoPlayer(newVideoController!),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                newVideoController?.dispose();
                                setDialogState(() {
                                  newVideoController = null;
                                  newVideo = null;
                                });
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                Consumer(
                  builder: (context, ref, _) {
                    final canEdit = ref.watch(canEditTaskProvider);
                    final canDelete = ref.watch(canDeleteTaskProvider);
                    
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sil Butonu - sadece canDelete varsa göster
                        if (canDelete)
                          TextButton.icon(
                            onPressed: () {
                              context.pop();
                              _showDeleteConfirmation();
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: Text(
                              'Sil',
                              style: Appstyles.normalTextStyle.copyWith(color: Colors.red),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        // İptal ve Güncelle Butonları
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () => context.pop(),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('İptal', style: Appstyles.normalTextStyle),
                            ),
                            const SizedBox(width: 10),
                            // Güncelle Butonu - sadece canEdit varsa göster
                            if (canEdit)
                              ElevatedButton(
                          onPressed: () async {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Görev adı boş olamaz')),
                              );
                              return;
                            }

                            // Medya varsa yükle
                            List<String>? newImageUrls;
                            String? newVideoUrl;
                            
                            if (newImages.isNotEmpty || newVideo != null) {
                              final storageRepo = ref.read(storageRepositoryProvider);
                              final taskId = widget.task.id;
                              
                              // Yeni resimleri yükle
                              if (newImages.isNotEmpty) {
                                try {
                                  newImageUrls = await storageRepo.uploadImages(newImages, taskId);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Resimler yüklenirken hata: $e')),
                                    );
                                  }
                                  return;
                                }
                              }
                              
                              // Yeni videoyu yükle
                              if (newVideo != null) {
                                try {
                                  newVideoUrl = await storageRepo.uploadVideo(newVideo!, taskId);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Video yüklenirken hata: $e')),
                                    );
                                  }
                                  return;
                                }
                              }
                            }
                            
                            // Mevcut medya URL'lerini al ve yeni medyalarla birleştir
                            List<String> finalImageUrls = List<String>.from(widget.task.imageUrls ?? []);
                            if (newImageUrls != null) {
                              finalImageUrls.addAll(newImageUrls);
                            }
                            
                            String? finalVideoUrl = widget.task.videoUrl;
                            if (newVideoUrl != null) {
                              finalVideoUrl = newVideoUrl;
                            }

                            final newTask = Task(
                              id: widget.task.id,
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              taskType: selectedTaskType ?? widget.task.taskType,
                              boatType: selectedBoatType ?? widget.task.boatType,
                              createdBy: widget.task.createdBy,
                              roomId: widget.task.roomId,
                              isComplete: widget.task.isComplete,
                              date: DateTime.now().toString(),
                              imageUrls: finalImageUrls,
                              videoUrl: finalVideoUrl,
                            );

                            await ref
                                .read(firestoreControllerProvider.notifier)
                                .updateTask(
                                  task: newTask,
                                  userId: widget.task.createdBy,
                                  taskId: widget.task.id,
                                );
                            
                            // Video controller'ı temizle
                            newVideoController?.dispose();
                            
                            if (context.mounted) {
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Görev başarıyla güncellendi!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                                child: Text(
                                  'Güncelle',
                                  style: Appstyles.normalTextStyle.copyWith(color: Colors.white),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(Icons.warning, color: Colors.red, size: 50),
        title: Text(
          'Görevi Sil',
          style: Appstyles.titleTextStyle.copyWith(fontSize: 22),
        ),
        content: Text(
          'Bu görevi silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: Appstyles.normalTextStyle,
          textAlign: TextAlign.center,
        ),
        actions: [
          OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('İptal', style: Appstyles.normalTextStyle),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(firestoreControllerProvider.notifier)
                  .deleteTask(taskId: widget.task.id);
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Sil',
              style: Appstyles.normalTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetail() {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.task.title,
                          style: Appstyles.headingTextStyle.copyWith(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                ),
                
                // İçerik
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Açıklama
                        Text(
                          'Açıklama',
                          style: Appstyles.normalTextStyle.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.task.description,
                          style: Appstyles.normalTextStyle.copyWith(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Etiketler
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _Tag(
                              text: widget.task.boatType,
                              color: Colors.green,
                            ),
                            _Tag(
                              text: widget.task.taskType,
                              color: Colors.blue,
                            ),
                            Consumer(
                              builder: (context, ref, _) {
                                final isEmail = widget.task.createdBy.contains('@');
                                final displayNameAsync = isEmail
                                    ? ref.watch(loadUserDisplayNameByEmailProvider(widget.task.createdBy))
                                    : ref.watch(loadUserDisplayNameProvider(widget.task.createdBy));
                                return displayNameAsync.when(
                                  data: (displayName) => _Tag(
                                    text: displayName ?? (isEmail ? widget.task.createdByUsername : widget.task.createdBy),
                                    color: Colors.purple,
                                  ),
                                  loading: () => _Tag(
                                    text: 'Yükleniyor...',
                                    color: Colors.purple,
                                  ),
                                  error: (_, __) => _Tag(
                                    text: isEmail ? widget.task.createdByUsername : widget.task.createdBy,
                                    color: Colors.purple,
                                  ),
                                );
                              },
                            ),
                            _Tag(
                              text: widget.task.formattedDate,
                              color: Colors.orange,
                            ),
                            _Tag(
                              text: widget.task.isComplete ? 'Tamamlandı' : 'Devam Ediyor',
                              color: widget.task.isComplete ? Colors.green : Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Resimler
                        if (widget.task.imageUrls.isNotEmpty) ...[
                          Text(
                            'Resimler',
                            style: Appstyles.normalTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.task.imageUrls.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Stack(
                                          children: [
                                            InteractiveViewer(
                                              child: Image.network(
                                                widget.task.imageUrls[index],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                icon: const Icon(Icons.close, color: Colors.white),
                                                onPressed: () => Navigator.of(ctx).pop(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        widget.task.imageUrls[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        
                        // Video
                        if (widget.task.videoUrl != null) ...[
                          Text(
                            'Video',
                            style: Appstyles.normalTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: VideoPlayerWidget(
                                  videoUrl: widget.task.videoUrl!,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return GestureDetector(
      onTap: _showTaskDetail,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.task.title,
                        style: Appstyles.headingTextStyle.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _Tag(text: widget.task.formattedDate, color: Colors.orange),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateHeight(10)),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.task.description,
                        style: Appstyles.normalTextStyle.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {}, // Checkbox tıklamasını durdur
                      child:                     GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {}, // Parent GestureDetector'ın event'ini durdur
                      child: Transform.scale(
                        scale: 1.8,
                        child: Checkbox(
                          value: widget.task.isComplete,
                          onChanged: (bool? value) {
                            if (value == null) return;
                            
                            // Görev düzenleme yetkisi kontrolü (görev ekleme veya düzenleme yetkisi olmayan sadece görüntüleyebilir)
                            final canEdit = ref.read(canEditTaskProvider);
                            if (!canEdit) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Görev durumunu değiştirme yetkiniz yok. Sadece görüntüleme yetkiniz var.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            ref
                                .read(firestoreRepositoryProvider)
                                .updateTaskCompletion(
                                  taskId: widget.task.id,
                                  isComplete: value,
                                );
                          },
                        ),
                      ),
                    ),
                    ),
                  ],
                ),

                SizedBox(height: SizeConfig.getProportionateHeight(20)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _Tag(
                              text: widget.task.boatType,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 15),
                            _Tag(
                              text: widget.task.taskType,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 15),
                            Consumer(
                              builder: (context, ref, _) {
                                // createdBy artık UID olarak saklanıyor (yeni tasklar için)
                                // Eski tasklar için email olabilir, o yüzden kontrol et
                                final isEmail = widget.task.createdBy.contains('@');
                                final displayNameAsync = isEmail
                                    ? ref.watch(loadUserDisplayNameByEmailProvider(widget.task.createdBy))
                                    : ref.watch(loadUserDisplayNameProvider(widget.task.createdBy));
                                return displayNameAsync.when(
                                  data: (displayName) => _Tag(
                                    text: displayName ?? (isEmail ? widget.task.createdByUsername : widget.task.createdBy),
                                    color: Colors.purple,
                                  ),
                                  loading: () => _Tag(
                                    text: 'Yükleniyor...',
                                    color: Colors.purple,
                                  ),
                                  error: (_, __) => _Tag(
                                    text: isEmail ? widget.task.createdByUsername : widget.task.createdBy,
                                    color: Colors.purple,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Permission kontrolü: Edit veya Delete yetkisi varsa göster
                    Consumer(
                      builder: (context, ref, _) {
                        final canEdit = ref.watch(canEditTaskProvider);
                        final canDelete = ref.watch(canDeleteTaskProvider);
                        
                        if (!canEdit && !canDelete) {
                          return const SizedBox.shrink();
                        }
                        
                        return GestureDetector(
                          onTap: canEdit ? _editTask : null,
                          child: Container(
                            height: SizeConfig.getProportionateHeight(40),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: canEdit ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        );
                      },
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
  }
}

class _Tag extends StatelessWidget {
  const _Tag({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text.toUpperCase(),
        style: Appstyles.normalTextStyle.copyWith(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.addListener(() {
          if (mounted) {
            setState(() {
              _isPlaying = _controller!.value.isPlaying;
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller!.value.isPlaying) {
            _controller!.pause();
          } else {
            _controller!.play();
          }
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          VideoPlayer(_controller!),
          if (!_isPlaying)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 50,
              ),
            ),
        ],
      ),
    );
  }
}
