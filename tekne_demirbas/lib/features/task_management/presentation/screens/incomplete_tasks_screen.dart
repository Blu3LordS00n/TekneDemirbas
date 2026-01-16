import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/common_widgets/async_value_ui.dart';
import 'package:tekne_demirbas/common_widgets/async_value_widget.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
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
    final roomId = ref.watch(selectedRoomProvider);
    
    if (roomId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.meeting_room, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Lütfen bir oda seçin'),
          ],
        ),
      );
    }

    final completeTaskAsyncValue = ref.watch(filteredIncompletedTasksProvider(roomId));

    ref.listen<AsyncValue>(loadTasksProvider(roomId), (_, state) {
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
