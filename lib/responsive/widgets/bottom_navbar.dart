import 'package:flutter/material.dart';

final ValueNotifier<int> indexNotifier = ValueNotifier(0);

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: indexNotifier,
        builder: (BuildContext context, int newIndex, Widget? _) {
          return BottomNavigationBar(
              onTap: (index) {
                indexNotifier.value = index;
              },
              currentIndex: newIndex,
              iconSize: 26,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle_outline), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: ''),
              ]);
        });
  }
}
