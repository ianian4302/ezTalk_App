import 'package:flutter/material.dart';

// import 'package:pops/utilities/design.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.g_translate),
          label: 'DataCollection',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mic),
          label: 'Record',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.addchart),
          label: 'Translate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color.fromARGB(82, 0, 0, 0),
      onTap: onTap,
    );
  }
}
