import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class NavbarWidget extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const NavbarWidget({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: "Dashboard",
          tooltip: "Dashboard",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label: "Stats",
          tooltip: "Statistics",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: "Query Log",
          tooltip: "Query Log",
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.list),
          label: "Domains",
          tooltip: "Domains"
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.shieldHalved),
          label: "Lists",
          tooltip: "Block/Allow Lists",
        ),
      ],
    );
  }
}
