import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/domain/Task.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';
import 'package:tekne_demirbas/utils/size_config.dart';

class TaskItem extends ConsumerStatefulWidget {
  const TaskItem({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
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
                Text(
                  widget.task.title,
                  style: Appstyles.headingTextStyle.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(10)),
                Text(
                  widget.task.description,
                  style: Appstyles.normalTextStyle.copyWith(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.getProportionateHeight(20)),
                Row(
                  children: [
                    _Tag(widget.task.taskType),
                    SizedBox(width: 10),
                    _Tag(widget.task.boatType),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepOrange,
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
