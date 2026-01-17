import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart' as firestore_repo;
import 'package:tekne_demirbas/features/task_management/domain/task_filter.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/boat_type_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_type_provider.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  final dynamic filterControllerProvider;
  
  const FilterBottomSheet({
    super.key,
    required this.filterControllerProvider,
  });

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String? _selectedBoatType;
  String? _selectedTaskType;
  String? _selectedCreatedBy;
  DateTimeRange? _selectedDateRange;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    // İlk yüklemede mevcut filtreleri al
    if (!_initialized) {
      final currentFilter = ref.read(widget.filterControllerProvider);
      _selectedBoatType = currentFilter.boatType;
      _selectedTaskType = currentFilter.taskType;
      _selectedCreatedBy = currentFilter.createdBy;
      _selectedDateRange = currentFilter.dateRange;
      _initialized = true;
    }

    final roomId = ref.watch(selectedRoomProvider);
    final boatTypeAsync = ref.watch(boatTypesProvider);
    final taskTypeAsync = ref.watch(taskTypesProvider);
    
    // Odadaki görevlerden kullanıcıları al (odaya ait kullanıcılar değil, görevi olan kullanıcılar)
    final roomTasksAsync = roomId != null 
        ? ref.watch(firestore_repo.loadTasksProvider(roomId))
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Appstyles.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Appstyles.borderRadiusLarge),
          topRight: Radius.circular(Appstyles.borderRadiusLarge),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Başlık
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: const BoxDecoration(
                  border: Border(
                        bottom: const BorderSide(color: Color(0xFFE6F3FF), width: 2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: Appstyles.oceanGradient,
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                      ),
                          child: const Icon(Icons.tune, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Filtreler",
                      style: Appstyles.headingTextStyle.copyWith(
                        color: Appstyles.primaryBlue,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

            /// 🚢 TEKNE
            boatTypeAsync.when(
              data: (boats) {
                return DropdownButtonFormField<String>(
                  value: _selectedBoatType,
                    hint: Text(
                      "Tüm tekneler",
                      style: Appstyles.subtitleTextStyle,
                    ),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: Appstyles.white,
                      isDense: true,
                    ),
                    style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                    dropdownColor: Appstyles.white,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0066CC)),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "Tüm tekneler",
                        style: Appstyles.normalTextStyle,
                      ),
                    ),
                    ...boats
                        .map(
                          (b) => DropdownMenuItem(
                            value: b.name,
                            child: Text(
                              b.name,
                              style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBoatType = value;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text("Tekneler yüklenemedi"),
            ),

            const SizedBox(height: 10),

            /// 🧰 İŞ TÜRÜ
            taskTypeAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const Text("Henüz iş türü yok");
                }
                return DropdownButtonFormField<String>(
                  value: _selectedTaskType,
                    hint: Text(
                      "Tüm işler",
                      style: Appstyles.subtitleTextStyle,
                    ),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: Appstyles.white,
                      isDense: true,
                    ),
                    style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                    dropdownColor: Appstyles.white,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0066CC)),
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "Tüm işler",
                        style: Appstyles.normalTextStyle,
                      ),
                    ),
                    ...tasks
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.name,
                            child: Text(
                              t.name,
                              style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTaskType = value;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text("İş türleri yüklenemedi: $error"),
            ),

            const SizedBox(height: 10),

            /// 👤 KULLANICI
            if (roomId != null && roomTasksAsync != null)
              roomTasksAsync.when(
                data: (tasks) {
                  // Görevlerden unique createdBy (UID) değerlerini al
                  final uniqueUserIds = tasks.map((task) => task.createdBy).toSet().toList();
                  
                  if (uniqueUserIds.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  return DropdownButtonFormField<String>(
                    value: _selectedCreatedBy,
                    hint: Text(
                      "Tüm kullanıcılar",
                      style: Appstyles.subtitleTextStyle,
                    ),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        borderSide: BorderSide(color: Appstyles.primaryBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: Appstyles.white,
                      isDense: true,
                    ),
                    style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                    dropdownColor: Appstyles.white,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF0066CC)),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          "Tüm kullanıcılar",
                          style: Appstyles.normalTextStyle,
                        ),
                      ),
                    ...uniqueUserIds.map(
                        (userId) => DropdownMenuItem<String>(
                          value: userId,
                          child: Consumer(
                            builder: (context, ref, _) {
                              final displayNameAsync = ref.watch(loadUserDisplayNameProvider(userId));
                              return displayNameAsync.when(
                                data: (displayName) => Text(
                                  displayName ?? userId,
                                  style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                                ),
                                loading: () => Text(
                                  userId,
                                  style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                                ),
                                error: (_, __) => Text(
                                  userId,
                                  style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCreatedBy = value;
                      });
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              )
            else
              const SizedBox.shrink(),

            const SizedBox(height: 10),

            /// 📅 TARİH
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Appstyles.lightGray,
                borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                border: Border.all(color: Appstyles.lightBlue, width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Color(0xFF0066CC), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDateRange == null
                          ? "Tüm tarihler"
                          : "${_fmt(_selectedDateRange!.start)} - "
                                "${_fmt(_selectedDateRange!.end)}",
                      style: Appstyles.normalTextStyle.copyWith(color: Appstyles.textDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (_selectedDateRange != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.clear, size: 18),
                      label: const Text("Temizle"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Appstyles.textLight,
                        side: BorderSide(color: Appstyles.lightBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedDateRange = null;
                        });
                      },
                    ),
                  ),
                if (_selectedDateRange != null) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text("Tarih Seç"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Appstyles.primaryBlue,
                      foregroundColor: Appstyles.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusSmall),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );

                      if (range != null) {
                        setState(() {
                          _selectedDateRange = range;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔘 BUTONLAR
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Appstyles.textLight,
                      side: BorderSide(color: Appstyles.lightBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                      ),
                    ),
                    child: const Text("Temizle", style: TextStyle(fontWeight: FontWeight.w600)),
                    onPressed: () {
                      // Provider'dan notifier'ı al - tüm filter controller'lar aynı metodları kullanır
                      final provider = widget.filterControllerProvider;
                      final notifierProvider = provider as dynamic;
                      final controller = ref.read(notifierProvider.notifier);
                      (controller as dynamic).clear();
                      setState(() {
                        _selectedBoatType = null;
                        _selectedTaskType = null;
                        _selectedCreatedBy = null;
                        _selectedDateRange = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: Appstyles.oceanGradient,
                      borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                      boxShadow: Appstyles.mediumShadow,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Appstyles.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Appstyles.borderRadiusMedium),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Uygula",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      onPressed: () {
                        // Provider'dan notifier'ı al - tüm filter controller'lar aynı metodları kullanır
                        final provider = widget.filterControllerProvider;
                        final notifierProvider = provider as dynamic;
                        final controller = ref.read(notifierProvider.notifier);
                        (controller as dynamic).setBoat(_selectedBoatType);
                        (controller as dynamic).setTaskType(_selectedTaskType);
                        (controller as dynamic).setCreatedBy(_selectedCreatedBy);
                        (controller as dynamic).setDateRange(_selectedDateRange);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/"
      "${d.month.toString().padLeft(2, '0')}/"
      "${d.year}";
}
