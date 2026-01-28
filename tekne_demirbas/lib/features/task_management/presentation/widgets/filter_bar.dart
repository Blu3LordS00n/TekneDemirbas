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
      // Daha dar ve üst/alt boşluğu daha az
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                // Butonun iç yüksekliğini ve genişliğini azalt
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Appstyles.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Filtrele",
                      style: TextStyle(
                        color: Appstyles.white,
                        fontSize: 15,
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
