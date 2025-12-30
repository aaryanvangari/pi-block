import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/router/app_routes.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/logo.dart';

class DrawerWidget extends StatelessWidget {
  VoidCallback? onLogout;
  DrawerWidget({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: LogoWidget(type: "drawer")),
              // ExpansionTile(
              //   showTrailingIcon: true,
              //   childrenPadding: EdgeInsets.symmetric(horizontal: 10),
              //   tilePadding: EdgeInsets.zero,
              //   dense: true,
              //   visualDensity: VisualDensity.compact,
              //   expandedAlignment: Alignment.topLeft,
              //   collapsedShape: RoundedRectangleBorder(),
              //   shape: RoundedRectangleBorder(),
              //   title: ListTile(
              //     title: Text("Pi-Hole Settings", style: KTextStyle.drawerEntryItemTitle),
              //     leading: Icon(Icons.settings),
              //   ),
              //   children: [
              //     ListTile(
              //       title: Text(
              //         "Local DNS",
              //         style: KTextStyle.drawerEntryItemTitle,
              //       ),
              //       leading: Icon(Icons.dns),
              //       onTap: () {
              //         context.go("/localDns");
              //       },
              //     ),
              //   ],
              // ),
              ListTile(
                title: Text(
                  "Groups",
                  style: KTextStyle.drawerEntryItemTitle,
                ),
                leading: Icon(FontAwesomeIcons.userGroup),
                onTap: () {
                  Navigator.of(context).pop(); // closes drawer
                  context.pushNamed(AppRoutes.groups);
                },
              ),
              ListTile(
                title: Text(
                  "Pi-Hole Configuration",
                  style: KTextStyle.drawerEntryItemTitle,
                ),
                leading: Icon(Icons.code),
                onTap: () {
                  Navigator.of(context).pop(); // closes drawer
                  context.pushNamed(AppRoutes.piholeConfiguration);
                },
              ),
              ListTile(
                title: Text("Settings", style: KTextStyle.drawerEntryItemTitle),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop(); // closes drawer
                  context.pushNamed(AppRoutes.settings);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text("Logout", style: KTextStyle.drawerEntryItemTitle),
              leading: Icon(Icons.logout),
              onTap: onLogout,
            ),
          ),
        ],
      ),
    );
  }
}
