import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/Task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/firestore_controller.dart';
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
    TextEditingController titleController = TextEditingController(
      text: widget.task.title,
    );

    TextEditingController descriptionController = TextEditingController(
      text: widget.task.description,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.edit, color: Colors.green, size: 40),
        title: Text('Gorevi Guncelle', style: Appstyles.normalTextStyle),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Gorev adi'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Gorev tanimi'),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text('Iptal', style: Appstyles.normalTextStyle),
              ),

              SizedBox(width: SizeConfig.getProportionateWidth(20)),

              ElevatedButton(
                onPressed: () {
                  String newTitle = titleController.text;
                  String newDescription = descriptionController.text;

                  final newTask = Task(
                    id: widget.task.id,
                    title: newTitle,
                    description: newDescription,
                    taskType: widget.task.taskType,
                    boatType: widget.task.boatType,
                    createdBy: widget.task.createdBy,
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
                child: Text('Guncelle', style: Appstyles.normalTextStyle),
              ),
            ],
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
                    Row(
                      children: [
                        _Tag(text: widget.task.boatType, color: Colors.green),
                        SizedBox(width: 15),
                        _Tag(text: widget.task.taskType, color: Colors.blue),
                        SizedBox(width: 15),
                        _Tag(
                          text: widget.task.createdByUsername,
                          color: Colors.purple,
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: _editTask,
                      child: Container(
                        height: SizeConfig.getProportionateHeight(40),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30.0,
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
