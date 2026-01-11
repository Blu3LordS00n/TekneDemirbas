import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddJobTypeDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text(
            'Yeni İş Türü',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'İş türü adı',
              hintStyle: TextStyle(color: Colors.white54),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _taskType.add(controller.text.trim());
                    _selectedJobTypeIndex = _taskType.length - 1;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDeleteJobType(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text(
            "Emin misin?",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "'${_taskType[index]}' iş türü silinsin mi?",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sil"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        _taskType.removeAt(index);
        if (_selectedJobTypeIndex >= _taskType.length) {
          _selectedJobTypeIndex = _taskType.length - 1;
        }
      });

      // Dropdown’u force refresh etmek için kapat
      Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: [
            TitleDescription(
              title: 'Görev Adı',
              prefixIcon: Icons.notes,
              hintText: 'Görev adı gir',
              maxLines: 1,
              controller: _titleController,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(10)),
            TitleDescription(
              title: 'Görev Tanımı',
              prefixIcon: Icons.notes,
              hintText: 'Görev tanımı gir',
              maxLines: 3,
              controller: _descriptionController,
            ),
            SizedBox(height: SizeConfig.getProportionateHeight(20)),
            Row(
              children: [
                Text(
                  'İş Türü',
                  style: Appstyles.headingTextStyle.copyWith(
                    fontSize: SizeConfig.getProportionateHeight(18),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedJobTypeIndex,
                        dropdownColor: Colors.grey.shade900,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: [
                          for (int i = 0; i < _taskType.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_taskType[i]),
                                  if (i >= _lockedJobTypeCount)
                                    GestureDetector(
                                      onTap: () => _confirmDeleteJobType(i),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          const DropdownMenuItem(
                            value: -1,
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.green),
                                SizedBox(width: 8),
                                Text("Yeni iş türü ekle"),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == -1) {
                            _showAddJobTypeDialog();
                          } else {
                            setState(() {
                              _selectedJobTypeIndex = value!;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
