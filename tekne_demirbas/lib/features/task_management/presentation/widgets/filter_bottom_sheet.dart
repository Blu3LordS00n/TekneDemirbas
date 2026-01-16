import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/room_management/data/room_repository.dart';
import 'package:tekne_demirbas/features/room_management/presentation/providers/selected_room_provider.dart';
import 'package:tekne_demirbas/features/task_management/data/firestore_repository.dart' as firestore_repo;
import 'package:tekne_demirbas/features/task_management/domain/task_filter.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_filter_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/boat_type_provider.dart';
import 'package:tekne_demirbas/features/task_management/presentation/providers/task_type_provider.dart';

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

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filtreler",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            /// 🚢 TEKNE
            boatTypeAsync.when(
              data: (boats) {
                return DropdownButtonFormField<String>(
                  value: _selectedBoatType,
                  hint: const Text(
                    "Tüm tekneler",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  isExpanded: true,
                  menuMaxHeight: 200,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  dropdownColor: Colors.white,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "Tüm tekneler",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    ...boats
                        .map(
                          (b) => DropdownMenuItem(
                            value: b.name,
                            child: Text(
                              b.name,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                  hint: const Text(
                    "Tüm işler",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  isExpanded: true,
                  menuMaxHeight: 200,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade600),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  dropdownColor: Colors.white,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text(
                        "Tüm işler",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ),
                    ...tasks
                        .map(
                          (t) => DropdownMenuItem(
                            value: t.name,
                            child: Text(
                              t.name,
                              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                    hint: const Text(
                      "Tüm kullanıcılar",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    isExpanded: true,
                    menuMaxHeight: 200,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    dropdownColor: Colors.white,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          "Tüm kullanıcılar",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
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
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                loading: () => Text(
                                  userId,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                error: (_, __) => Text(
                                  userId,
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDateRange == null
                      ? "Tüm tarihler"
                      : "${_fmt(_selectedDateRange!.start)} - "
                            "${_fmt(_selectedDateRange!.end)}",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Row(
                  children: [
                    if (_selectedDateRange != null)
                      TextButton(
                        child: const Text("Temizle"),
                        onPressed: () {
                          setState(() {
                            _selectedDateRange = null;
                          });
                        },
                      ),
                    TextButton(
                      child: const Text("Tarih Seç"),
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
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔘 BUTONLAR
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    child: const Text("Temizle"),
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
                  child: ElevatedButton(
                    child: const Text("Uygula"),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/"
      "${d.month.toString().padLeft(2, '0')}/"
      "${d.year}";
}
