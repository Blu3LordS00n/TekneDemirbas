import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/common_widgets/async_value_ui.dart';
import 'package:tekne_demirbas/common_widgets/async_value_widget.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/task_item.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/filter_bar.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class IncompleteTasksScreen extends ConsumerWidget {
  const IncompleteTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserProvider)!.uid;
    final completeTaskAsyncValue = ref.watch(filteredIncompletedTasksProvider);

    ref.listen<AsyncValue>(loadTasksProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    return Column(
        children: [
          FilterBar(filterControllerProvider: incompletedTasksFilterControllerProvider),
          Expanded(
            child: AsyncValueWidget<List<Task>>(
              value: completeTaskAsyncValue,
              data: (tasks) {
                return tasks.isEmpty
                    ? const Center(child: Text('Henuz gorev yok'))
                    : ListView.separated(
                        itemBuilder: (ctx, index) {
                          final task = tasks[index];

                          return TaskItem(task: task);
                        },
                        separatorBuilder: (ctx, height) =>
                            const Divider(height: 2, color: Colors.blue),
                        itemCount: tasks.length,
                      );
              },
            ),
          ),
        ],
      );
  }
}
