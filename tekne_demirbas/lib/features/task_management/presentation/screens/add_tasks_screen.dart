import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  final List<String> _taskType = [
    'Ic Bakim',
    'Dis Bakim',
    'Elektrik Sistemleri',
    'Motor',
  ];
  final int _lockedJobTypeCount = 4;
  int _selectedJobTypeIndex = 0;

  final List<String> _boatType = [
    'LALUNA',
    'SC1',
    'SC2',
    'SC3',
    'SC4',
    'SC5',
    'SC6',
    'HERA',
    'AMARIS',
    'AZIZA',
    'SUHA BEY',
    'TIAN',
    'KUMMSAL',
    'ENKI',
    'SWEET',
  ];
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Görev Oluştur',
          style: Appstyles.titleTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
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

            EditableDropdown(
              label: "İş Türü",
              items: _taskType,
              selectedIndex: _selectedJobTypeIndex,
              lockedCount: _lockedJobTypeCount,
              onChanged: (i) => setState(() => _selectedJobTypeIndex = i),
              onAddNew: () async {
                final name = await showAddItemDialog(
                  context: context,
                  title: "Yeni İş Türü",
                  hint: "İş türü adı",
                );
                if (name != null) {
                  setState(() {
                    _taskType.add(name);
                    _selectedJobTypeIndex = _taskType.length - 1;
                  });
                }
              },
              onDelete: (i) async {
                final confirmed = await showConfirmDeleteDialog(
                  context: context,
                  itemName: _taskType[i],
                );
                if (confirmed) {
                  setState(() {
                    _taskType.removeAt(i);
                    if (_selectedJobTypeIndex == i) {
                      _selectedJobTypeIndex = 0;
                    } else if (_selectedJobTypeIndex > i) {
                      _selectedJobTypeIndex--;
                    }
                  });
                }
              },
            ),

            SizedBox(height: SizeConfig.getProportionateHeight(5)),

            EditableDropdown(
              label: "Tekne",
              items: _boatType,
              selectedIndex: _selectedBoatTypeIndex,
              lockedCount: _lockedBoatTypeCount,
              onChanged: (i) => setState(() => _selectedBoatTypeIndex = i),
              onAddNew: () async {
                final name = await showAddItemDialog(
                  context: context,
                  title: "Yeni Tekne",
                  hint: "Tekne Adı",
                );
                if (name != null) {
                  setState(() {
                    _boatType.add(name);
                    _selectedBoatTypeIndex = _boatType.length - 1;
                  });
                }
              },
              onDelete: (i) async {
                final confirmed = await showConfirmDeleteDialog(
                  context: context,
                  itemName: _boatType[i],
                );
                if (confirmed) {
                  setState(() {
                    _boatType.removeAt(i);
                    if (_selectedBoatTypeIndex == i) {
                      _selectedBoatTypeIndex = 0;
                    } else if (_selectedBoatTypeIndex > i) {
                      _selectedBoatTypeIndex--;
                    }
                  });
                }
              },
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
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: SizeConfig.getProportionateHeight(50),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gorev Ekle',
                      style: Appstyles.titleTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
