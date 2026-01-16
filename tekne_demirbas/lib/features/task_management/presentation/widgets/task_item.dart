import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/permission_provider.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/firestore_controller.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/boat_type_provider.dart' as boat_provider;
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_type_provider.dart' as task_provider;
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  void _editTask() {
    final titleController = TextEditingController(text: widget.task.title);
    final descriptionController = TextEditingController(text: widget.task.description);
    String? selectedBoatType = widget.task.boatType;
    String? selectedTaskType = widget.task.taskType;

    showDialog(
      context: context,
      builder: (ctx) => Consumer(
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
                          onPressed: () {
                            if (titleController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Görev adı boş olamaz')),
                              );
                              return;
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
                            );

                            ref
                                .read(firestoreControllerProvider.notifier)
                                .updateTask(
                                  task: newTask,
                                  userId: widget.task.createdBy,
                                  taskId: widget.task.id,
                                );
                            context.pop();
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Container(
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

                    Transform.scale(
                      scale: 1.8,
                      child: Checkbox(
                        value: widget.task.isComplete,
                        onChanged: (bool? value) {
                          if (value == null) return;
                          
                          // Görev ekleme yetkisi kontrolü (görev ekleme yetkisi olmayan sadece görüntüleyebilir)
                          final canAddTask = ref.read(canAddTaskProvider);
                          if (!canAddTask) {
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
                            _Tag(
                              text: widget.task.createdByUsername,
                              color: Colors.purple,
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
