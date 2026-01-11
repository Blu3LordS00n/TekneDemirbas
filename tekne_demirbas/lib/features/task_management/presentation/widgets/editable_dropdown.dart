import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:tekne_demirbas/utils/appstyles.dart';

class EditableDropdown extends StatelessWidget {
  const EditableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedIndex,
    required this.lockedCount,
    required this.onChanged,
    required this.onAddNew,
    required this.onDelete,
  });

  final String label;
  final List<String> items;
  final int selectedIndex;
  final int lockedCount;

  final void Function(int index) onChanged;
  final VoidCallback onAddNew;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Appstyles.headingTextStyle.copyWith(fontSize: 18)),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<int>(
              isExpanded: true,
              value: selectedIndex,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down),
              ),
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              items: [
                for (int i = 0; i < items.length; i++)
                  DropdownMenuItem(value: i, child: Text(items[i])),

                const DropdownMenuItem(
                  value: -1,
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Yeni ekle"),
                    ],
                  ),
                ),

                if (selectedIndex >= lockedCount)
                  const DropdownMenuItem(
                    value: -2,
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text("Seçili olanı sil"),
                      ],
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value == -1) {
                  onAddNew();
                } else if (value == -2) {
                  onDelete(selectedIndex);
                } else {
                  onChanged(value!);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
