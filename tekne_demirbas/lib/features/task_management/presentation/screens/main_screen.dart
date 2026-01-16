import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tekne_demirbas/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:tekne_demirbas/features/authentication/presentation/screens/account_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/add_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/all_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/completed_tasks_screen.dart';
import 'package:tekne_demirbas/features/task_management/presentation/screens/incomplete_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Görevlerim';
      case 1:
        return 'Tamamlanmamış Görevlerim';
      case 2:
        return 'Görev Oluştur';
      case 3:
        return 'Tamamlanmış Görevlerim';
      case 4:
        return 'Hesabım';
      default:
        return 'Ana Ekran';
    }
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle(currentIndex)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllTasksScreen(),
          IncompleteTasksScreen(),
          AddTasksScreen(),
          CompletedTasksScreen(),
          AccountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        iconSize: 20.0,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Ana Sayfa',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous_outlined),
            label: 'Tamamlanmamis',
            activeIcon: Icon(Icons.dangerous),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ekle',
            activeIcon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tamamlanmis',
            activeIcon: Icon(Icons.check_box),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Hesabim',
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
