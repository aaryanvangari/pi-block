import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/router/app_routes.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/logo.dart';

class DrawerWidget extends StatelessWidget {
  VoidCallback? onLogout;
  final StatefulNavigationShell navigationShell;
  final bool isDesktop;
  DrawerWidget({
    super.key,
    required this.onLogout,
    required this.navigationShell,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.toString();
    return Drawer(
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
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
                if (isDesktop) ...[
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    selected: currentLocation == AppRoutes.homePath,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // closes drawer
                      }
                      navigationShell.goBranch(
                        AppDestination.dashboard.branchIndex,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.auto_graph),
                    title: const Text('Stats'),
                    selected: currentLocation == AppRoutes.statsPath,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // closes drawer
                      }
                      navigationShell.goBranch(
                        AppDestination.stats.branchIndex,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Query Log'),
                    selected: currentLocation == AppRoutes.queryLogPath,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // closes drawer
                      }
                      navigationShell.goBranch(
                        AppDestination.querylog.branchIndex,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('Domains'),
                    selected: currentLocation == AppRoutes.domainsPath,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // closes drawer
                      }
                      navigationShell.goBranch(
                        AppDestination.domains.branchIndex,
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shield),
                    title: const Text('Lists'),
                    selected: currentLocation == AppRoutes.listsPath,
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(); // closes drawer
                      }
                      navigationShell.goBranch(
                        AppDestination.lists.branchIndex,
                      );
                    },
                  ),
                ],
                ListTile(
                  title: Text("Groups", style: KTextStyle.drawerEntryItemTitle),
                  leading: Icon(FontAwesomeIcons.userGroup),
                  selected: currentLocation == AppRoutes.groupsPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.groups.branchIndex,
                    ); // Groups branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Clients",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(FontAwesomeIcons.laptop),
                  selected: currentLocation == AppRoutes.clientsPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.clients.branchIndex,
                    ); // Clients branch index
                  },
                ),
                ListTile(
                  title: Text("Logs", style: KTextStyle.drawerEntryItemTitle),
                  leading: Icon(Icons.list),
                  selected: currentLocation == AppRoutes.logsPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.logs.branchIndex,
                    ); // Logs branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Actions",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(Icons.pending_actions),
                  selected: currentLocation == AppRoutes.actionsPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.actions.branchIndex,
                    ); // Actions branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Configuration",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(Icons.code),
                  selected:
                      currentLocation == AppRoutes.piholeConfigurationPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.piholeConfiguration.branchIndex,
                    ); // Pi-Hole Configuration branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Interfaces",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(Icons.wifi),
                  selected: currentLocation == AppRoutes.interfacesPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.interfaces.branchIndex,
                    ); // Interfaces branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Devices",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(FontAwesomeIcons.networkWired),
                  selected: currentLocation == AppRoutes.devicesPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.devices.branchIndex,
                    ); // Devices branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Teleporter",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(FontAwesomeIcons.fileExport),
                  selected: currentLocation == AppRoutes.teleporterPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.teleporter.branchIndex,
                    ); // Teleporter branch index
                  },
                ),
                ListTile(
                  title: Text(
                    "Settings",
                    style: KTextStyle.drawerEntryItemTitle,
                  ),
                  leading: Icon(Icons.settings),
                  selected: currentLocation == AppRoutes.settingsPath,
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop(); // closes drawer
                    }
                    navigationShell.goBranch(
                      AppDestination.settings.branchIndex,
                    ); // Settings branch index
                  },
                ),
              ],
            ),
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
