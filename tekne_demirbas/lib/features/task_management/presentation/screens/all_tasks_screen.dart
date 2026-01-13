import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/common_widgets/async_value_ui.dart';
import 'package:tekne_demirbas/common_widgets/async_value_widget.dart';
import 'package:tekne_demirbas/features/authentication/data/auth_repository.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart';
import 'package:tekne_demirbas/features/task_management/domain/Task.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/task_item.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class AllTasksScreen extends ConsumerStatefulWidget {
  const AllTasksScreen({super.key});

  @override
  ConsumerState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends ConsumerState<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserProvider)!.uid;
    final taskAsyncValue = ref.watch(loadTasksProvider);

    ref.listen<AsyncValue>(loadTasksProvider, (_, state) {
      state.showAlertDialogOnError(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gorevlerim',
          style: Appstyles.headingTextStyle.copyWith(color: Colors.white),
        ),
      ),
      body: AsyncValueWidget<List<Task>>(
        value: taskAsyncValue,
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
    );
  }
}
