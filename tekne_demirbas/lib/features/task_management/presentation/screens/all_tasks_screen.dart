import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllTasksScreen extends ConsumerStatefulWidget {
  const AllTasksScreen({super.key});

  @override
  ConsumerState createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends ConsumerState<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Tum Yapilacaklar')));
  }
}
