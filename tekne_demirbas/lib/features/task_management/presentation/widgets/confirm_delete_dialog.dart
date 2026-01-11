import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String itemName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text("Emin misin?", style: TextStyle(color: Colors.white)),
        content: Text(
          "'$itemName' silinsin mi?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sil"),
          ),
        ],
      );
    },
  );

  return result == true;
}
