import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view2/flutter_fancy_tree_view2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:pi_block/blocs/interfaces/interfaces_bloc.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/network_gateway_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';

class InterfacesPage extends StatelessWidget {
  const InterfacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          InterfacesBloc(context.read<PiholeRepository>())
            ..add(InterfacesFetched()),
      child: _InterfacesView(),
    );
  }
}

class _InterfacesView extends StatefulWidget {
  const _InterfacesView();
  @override
  State<_InterfacesView> createState() => _InterfacesViewState();
}

class _InterfacesViewState extends State<_InterfacesView> {
  int animationDuration = 200;
  List<NetworkInterfaceElement> networkTree = [];
  TreeController<NetworkInterfaceElement>? treeController;

  String getPercentage(int first, int second) {
    if (second == 0) {
      return "0.0";
    }
    return (first / second * 100).toStringAsFixed(2);
  }

  List<NetworkInterfaceElement> buildStatistics(
    NetworkInterfaceModel interface,
  ) {
    return [
      NetworkInterfaceElement(
        child: Text(
          "RX Bytes: ${interface.stats.rxBytes.value.toStringAsFixed(2)} ${interface.stats.rxBytes.unit}",
        ),
        icon: FontAwesomeIcons.download,
      ),
      NetworkInterfaceElement(
        child: Text(
          "TX Bytes: ${interface.stats.txBytes.value.toStringAsFixed(2)} ${interface.stats.txBytes.unit}",
        ),
        icon: FontAwesomeIcons.upload,
      ),
      NetworkInterfaceElement(
        child: Text("RX Packets: ${interface.stats.rxPackets}"),
        icon: FontAwesomeIcons.download,
      ),
      NetworkInterfaceElement(
        child: Text(
          "RX Errors: ${interface.stats.rxErrors.toStringAsFixed(2)} (${getPercentage(interface.stats.rxErrors, interface.stats.rxPackets)})",
        ),
        icon: FontAwesomeIcons.download,
      ),
      NetworkInterfaceElement(
        child: Text(
          "RX Dropped: ${interface.stats.rxDropped.toStringAsFixed(2)} (${getPercentage(interface.stats.rxDropped, interface.stats.rxPackets)})",
        ),
        icon: FontAwesomeIcons.download,
      ),
      NetworkInterfaceElement(
        child: Text("TX Packets: ${interface.stats.txPackets}"),
        icon: FontAwesomeIcons.upload,
      ),
      NetworkInterfaceElement(
        child: Text(
          "TX Errors: ${interface.stats.txErrors.toStringAsFixed(2)} (${getPercentage(interface.stats.txErrors, interface.stats.txPackets)})",
        ),
        icon: FontAwesomeIcons.upload,
      ),
      NetworkInterfaceElement(
        child: Text(
          "TX Dropped: ${interface.stats.txDropped.toStringAsFixed(2)} (${getPercentage(interface.stats.txDropped, interface.stats.txPackets)})",
        ),
        icon: FontAwesomeIcons.upload,
      ),
      NetworkInterfaceElement(
        child: Text("Multicast: ${interface.stats.multicast}"),
        icon: FontAwesomeIcons.towerBroadcast,
      ),
      NetworkInterfaceElement(
        child: Text("Collisions: ${interface.stats.collisions}"),
        icon: FontAwesomeIcons.rightLeft,
      ),
    ];
  }

  List<NetworkInterfaceElement> buildFurtherDetails(
    NetworkInterfaceModel interface,
  ) {
    return [
      NetworkInterfaceElement(
        child: Row(
          children: [
            Text("Carrier: "),
            Text(
              interface.carrier ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: interface.carrier
                    ? KColors.interfaceConnected
                    : KColors.interfaceDisconnected,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        icon: FontAwesomeIcons.link,
      ),
      NetworkInterfaceElement(
        child: Text("State: ${interface.state.toUpperCase()}"),
        icon: FontAwesomeIcons.server,
      ),
      if (interface.parentDeviceName != null)
        NetworkInterfaceElement(
          child: Text(
            "Parent Device: ${interface.parentDeviceName} ${interface.parentDeviceBusName != null ? ' @${interface.parentDeviceBusName}' : ''}",
          ),
          icon: FontAwesomeIcons.networkWired,
        ),
      NetworkInterfaceElement(
        child: Text("Carrier Changes: ${interface.carrierChanges}"),
        icon: FontAwesomeIcons.arrowRightArrowLeft,
      ),
      NetworkInterfaceElement(
        child: Row(
          children: [
            Text("Broadcast: "),
            Text(
              interface.broadcast,
              style: TextStyle(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha(20),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        icon: FontAwesomeIcons.towerBroadcast,
      ),
      NetworkInterfaceElement(
        child: Text(
          "MTU: ${interface.mtu} (min: ${interface.minMtu} btyes, max: ${interface.maxMtu} bytes)",
        ),
        icon: FontAwesomeIcons.arrowRightArrowLeft,
      ),
      if (interface.txqlen > 0)
        NetworkInterfaceElement(
          child: Text("TX Queue Length: ${interface.txqlen}"),
          icon: FontAwesomeIcons.fileArrowUp,
        ),
      NetworkInterfaceElement(
        child: Text(
          "Promiscuity Mode: ${interface.promiscuity == 0 ? 'Yes' : 'No'}",
        ),
        icon: FontAwesomeIcons.fileArrowUp,
      ),
      NetworkInterfaceElement(
        child: Text("Scheduler: ${interface.qdisc}"),
        icon: FontAwesomeIcons.networkWired,
      ),
    ];
  }

  List<NetworkInterfaceElement> buildAddressDetails(
    NetworkInterfaceModel interface,
  ) {
    return [
      for (InterfaceAddressModel interfaceAddressModel in interface.addresses)
        NetworkInterfaceElement(
          child: Row(
            children: [
              Text("Address: "),
              Badge(interfaceAddressModel.family),
              Badge(interfaceAddressModel.address),
              Text("/ "),
              Badge(interfaceAddressModel.prefixlen.toString()),
              Text(
                "(${interfaceAddressModel.family == 'inet6' ? 'IPv6' : 'IPv4'} ${interfaceAddressModel.addressType})",
              ),
            ],
          ),
          icon: Icons.location_on,
          childrenBuilder: () => [
            if (interfaceAddressModel.local != null)
              NetworkInterfaceElement(
                child: Row(
                  children: [
                    Text("Local: "),
                    Badge('${interfaceAddressModel.local}'),
                  ],
                ),
                icon: Icons.location_on,
              ),
            if (interfaceAddressModel.broadcast != null)
              NetworkInterfaceElement(
                child: Row(
                  children: [
                    Text("Broadcast: "),
                    Badge('${interfaceAddressModel.broadcast}'),
                  ],
                ),
                icon: Icons.location_on,
              ),
            NetworkInterfaceElement(
              child: Text("Scope: ${interfaceAddressModel.scope}"),
              icon: Icons.location_on,
            ),
            if (interfaceAddressModel.flags.isNotEmpty)
              NetworkInterfaceElement(
                child: Text("Flags: ${interfaceAddressModel.flags.join(', ')}"),
                icon: Icons.location_on,
              ),
            NetworkInterfaceElement(
              child: Text(
                "Prefered: ${interfaceAddressModel.prefered == 4294967295 ? 'forever' : '${interfaceAddressModel.prefered} seconds'}",
              ),
              icon: FontAwesomeIcons.clock,
            ),
            NetworkInterfaceElement(
              child: Text(
                "Valid: ${interfaceAddressModel.valid == 4294967295 ? 'forever' : '${interfaceAddressModel.valid} seconds'}",
              ),
              icon: FontAwesomeIcons.clock,
            ),
            if (interfaceAddressModel.cstamp != 0)
              NetworkInterfaceElement(
                child: Text(
                  "Created: ${PiUtils.getDateFormatter(interfaceAddressModel.cstamp, format: 'yyyy-MM-dd H:m a')}",
                ),
                icon: FontAwesomeIcons.clock,
              ),
            if (interfaceAddressModel.tstamp != 0)
              NetworkInterfaceElement(
                child: Text(
                  "Last Updated: ${PiUtils.getDateFormatter(interfaceAddressModel.tstamp, format: 'yyyy-MM-dd H:m a')}",
                ),
                icon: FontAwesomeIcons.clock,
              ),
          ],
        ),
    ];
  }

  List<NetworkInterfaceElement> buildMainNodes(
    NetworkInterfaceModel interface,
  ) {
    return [
      if (interface.speed != null)
        NetworkInterfaceElement(
          child: Text("Speed: ${interface.speed} Mbit/s"),
          icon: FontAwesomeIcons.gaugeSimpleHigh,
        ),
      NetworkInterfaceElement(
        child: Text("Type: ${interface.type}"),
        icon: FontAwesomeIcons.networkWired,
      ),
      NetworkInterfaceElement(
        child: Text("Flags: ${interface.flags.join(', ')}"),
        icon: Icons.flag,
      ),
      NetworkInterfaceElement(
        child: Row(
          children: [Text("Hardware Address: "), Badge(interface.address)],
        ),
        icon: Icons.location_on,
      ),
      NetworkInterfaceElement(
        child: Text(
          "${interface.addresses.length} address connected to interface",
        ),
        icon: Icons.location_on,
        childrenBuilder: () => buildAddressDetails(interface),
      ),
      NetworkInterfaceElement(
        child: Text("Statistics"),
        icon: Icons.auto_graph,
        childrenBuilder: () => buildStatistics(interface),
      ),
      NetworkInterfaceElement(
        child: Text("Further details"),
        icon: Icons.info,
        childrenBuilder: () => buildFurtherDetails(interface),
      ),
    ];
  }

  List<NetworkInterfaceElement> getNodes(
    NetworkGatewayModel networkGatewayModel,
  ) {
    networkTree.clear();
    for (var interface in networkGatewayModel.interfaces) {
      networkTree.add(
        NetworkInterfaceElement(
          child: Text(interface.name),
          icon: FontAwesomeIcons.networkWired,
          childrenBuilder: () => buildMainNodes(interface),
        ),
      );
    }
    return networkTree;
  }

  @override
  void dispose() {
    treeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Network Interfaces",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => treeController?.expandAll(),
                      icon: const Icon(Icons.expand_rounded),
                      tooltip: "Expand All",
                    ),
                    IconButton(
                      onPressed: () => treeController?.collapseAll(),
                      icon: const Icon(Icons.compress),
                      tooltip: "Collapse All",
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        treeController?.collapseAll();
                        context.read<InterfacesBloc>().add(InterfacesFetched());
                      },
                      tooltip: "Refresh Data",
                    ),
                  ],
                ),
              ],
            ),
            BlocConsumer<InterfacesBloc, InterfacesState>(
              listener: (context, state) {
                if (state is InterfacesFailure) {
                  PiUtils.handleGeneralException(context, state.error);
                }
              },
              builder: (context, state) {
                if (state is InterfacesFailure) {
                  return const CustomErrorWidget(message: "Error loading data");
                }
                if (state is InterfacesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is InterfacesSuccess) {
                  NetworkGatewayModel networkGatewayModel =
                      state.networkGatewayModel;
                  List<NetworkInterfaceElement> networkTree = getNodes(
                    networkGatewayModel,
                  );

                  if (treeController == null) {
                    treeController = TreeController<NetworkInterfaceElement>(
                      roots: networkTree,
                      childrenProvider: (node) => node.children,
                    );
                  } else {
                    treeController!.roots = networkTree;
                  }

                  // Estimate width to avoid horizontal overflow
                  // Expected depth is max 6 levels deep
                  final estimatedWidth =
                      MediaQuery.sizeOf(context).width + 40.0 * 6;

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: estimatedWidth,
                        child: TreeView<NetworkInterfaceElement>(
                          treeController: treeController!,
                          // Provide a widget builder callback to map your tree nodes into widgets.
                          nodeBuilder:
                              (
                                BuildContext context,
                                TreeEntry<NetworkInterfaceElement> entry,
                              ) {
                                return MyTreeTile(
                                  // Add a key to your tiles to avoid syncing descendant animations.
                                  key: ValueKey(entry.node),
                                  entry: entry,
                                  // Add a callback to toggle the expansion state of this node.
                                  onTap: () => treeController?.toggleExpansion(
                                    entry.node,
                                  ),
                                );
                              },
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Create a widget to display the data held by your tree nodes.
class MyTreeTile extends StatelessWidget {
  const MyTreeTile({super.key, required this.entry, required this.onTap});

  final TreeEntry<NetworkInterfaceElement> entry;
  final VoidCallback onTap;

  // Customize the dash path for indent guides
  Path dottingModifier(Path path) {
    return dashPath(
      path,
      dashArray: CircularIntervalList(const <double>[3.0]),
      dashOffset: const DashOffset.absolute(2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TreeIndentation(
      entry: entry,
      // Provide an indent guide if desired. Indent guides can be used to
      // add decorations to the indentation of tree nodes.
      // This could also be provided through a DefaultTreeIndentGuide
      // inherited widget placed above the tree view.
      guide: IndentGuide.connectingLines(
        indent: 30,
        connectBranches: true,
        roundCorners: true,
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
        pathModifier: (path) => dottingModifier(path),
      ),
      // The widget to render next to the indentation. TreeIndentation
      // respects the text direction of `Directionality.maybeOf(context)`
      // and defaults to left-to-right.
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
        child: Row(
          children: [
            entry.hasChildren
                ? ExpandIcon(
                    key: ValueKey(entry.node),
                    isExpanded: entry.isExpanded,
                    onPressed: (_) =>
                        TreeViewScope.of<NetworkInterfaceElement>(context)
                          ..controller.toggleExpansion(entry.node),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(entry.node.icon, size: 20),
            ),
            Expanded(child: entry.node.child),
          ],
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  const Badge(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ui = context.ui;
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: ui.networkAddressBackgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: ui.networkAddressColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class NetworkInterfaceElement {
  NetworkInterfaceElement({
    required this.child,
    required this.icon,
    List<NetworkInterfaceElement> Function()? childrenBuilder,
  }) : _childrenBuilder = childrenBuilder;

  final Widget child;
  final IconData icon;

  /// Lazy children builder (called only when expanded)
  final List<NetworkInterfaceElement> Function()? _childrenBuilder;

  /// Cache to avoid rebuilding children on every expand
  List<NetworkInterfaceElement>? _cachedChildren;

  /// TreeView will call this
  List<NetworkInterfaceElement> get children {
    if (_childrenBuilder == null) return const [];
    return _cachedChildren ??= _childrenBuilder();
  }

  bool get hasChildren => _childrenBuilder != null;
}
