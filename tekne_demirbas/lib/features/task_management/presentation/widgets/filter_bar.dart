import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/domain/task_filter.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/filter_bottom_sheet.dart';

class FilterBar extends ConsumerWidget {
  final dynamic filterControllerProvider;
  
  const FilterBar({
    super.key,
    required this.filterControllerProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterControllerProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.filter_list),
            label: const Text("Filtrele"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => FilterBottomSheet(
                  filterControllerProvider: filterControllerProvider,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
