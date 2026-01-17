import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/task_management/domain/task_filter.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/widgets/filter_bottom_sheet.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

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
      padding: const EdgeInsets.all(12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: Appstyles.oceanGradient,
            borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
            boxShadow: Appstyles.mediumShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => FilterBottomSheet(
                    filterControllerProvider: filterControllerProvider,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Appstyles.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Filtrele",
                      style: TextStyle(
                        color: Appstyles.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
