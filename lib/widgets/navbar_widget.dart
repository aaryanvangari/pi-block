import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedpage, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedpage,
          onTap: (int index) {
            selectedPageNotifier.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_graph),
              label: "Stats",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Query Log",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.list),
              label: "Domains",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shieldHalved),
              label: "Lists",
            ),
          ],
        );
      },
    );
  }
}
