import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pager/pager.dart';
import 'package:pi_block/blocs/network_devices/network_devices_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/network_devices.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/simple_sheet.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'dart:io' show Platform;

import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class NetworkDevicesPage extends StatelessWidget {
  const NetworkDevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NetworkDevicesBloc(context.read<PiholeRepository>()),
      child: _NetworkDevicesView(),
    );
  }
}

class _NetworkDevicesView extends StatefulWidget {
  const _NetworkDevicesView();

  @override
  State<_NetworkDevicesView> createState() => _NetworkDevicesViewState();
}

class _NetworkDevicesViewState extends State<_NetworkDevicesView> {
  static const double _rowHeight = 85; // Calculated using DevTools
  static const double _reservedHeight = 80;
  static const double _reservedWidth = 30;
  static const int maxIpsToDisplay = 3;

  int _lastItemsPerPage = 0;
  int _lastPagesPerView = 0;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounce;
  bool layoutLocked = false;

  @override
  void initState() {
    searchFocusNode.addListener(() {
      if (layoutLocked != searchFocusNode.hasFocus) {
        setState(() {
          layoutLocked = searchFocusNode.hasFocus;
        });
      }
    });

    super.initState();
  }

  int calculatePagesPerView({
    required double availableWidth,
    required double reservedWidth,
  }) {
    double pagerButtonWidth = 40;
    switch (Platform.operatingSystem) {
      case "ios":
        pagerButtonWidth = 48;
        break;
      case "android":
        pagerButtonWidth = 40;
        break;
      default:
    }
    double pagerNumberButtonWidth = 56;
    switch (Platform.operatingSystem) {
      case "ios":
        pagerNumberButtonWidth = 64;
        break;
      case "android":
        pagerNumberButtonWidth = 56;
        break;
      default:
    }
    const int mandatoryButtonsCount = 4;
    const int maxPagesView = 5;

    final double mandatoryWidth = mandatoryButtonsCount * pagerButtonWidth;

    final double remainingWidth =
        availableWidth - mandatoryWidth - reservedWidth;

    if (remainingWidth <= pagerNumberButtonWidth) {
      return 1;
    }

    final int maxButtons = (remainingWidth / pagerNumberButtonWidth).floor();

    return maxButtons.clamp(1, maxPagesView);
  }

  int calculateItemsPerPage({
    required double availableHeight,
    required double reservedHeight,
    required double rowHeight,
    int minItems = 1,
    int maxItems = 100,
  }) {
    final double usableHeight = availableHeight - reservedHeight;

    if (usableHeight <= 0 || rowHeight <= 0) {
      return minItems;
    }

    return (usableHeight / rowHeight).floor().clamp(minItems, maxItems);
  }

  String getDeviceName(Device item) {
    if (item.ips.isNotEmpty) {
      return '${item.ips.first.ip} ${(item.ips.first.name != null) ? ' (${item.ips.first.name})' : ""}';
    } else {
      return item.hwaddr.toString();
    }
  }

  String buildIPs(Device item) {
    if (item.ips.isNotEmpty) {
      String ips = "";
      int ipCounter = 0;
      for (var ip in item.ips) {
        ips =
            '$ips${(ipCounter > 0 ? ', ' : "")}${ip.ip}${(ip.name != null) ? ' (${ip.name})' : ""}';
        if (ipCounter > maxIpsToDisplay) break;
        ipCounter++;
      }
      return ips;
    } else {
      return "";
    }
  }

  Duration getDifference(Device item) {
    DateTime lastQueryTimestamp = DateTime.fromMillisecondsSinceEpoch(
      item.lastQuery * 1000,
    );
    Duration difference = lastQueryTimestamp.difference(DateTime.now());
    return difference;
  }

  Color getDeviceColor(Device item) {
    Duration difference = getDifference(item);
    switch (difference.inHours) {
      case 0: // Current hour, ie minutes
        return context.ui.networkDeviceLessThanHour;
      case >= -24: // Less than a day
        return context.ui.networkDeviceLessThanDay;
      case >= -48: // Greater than 24 Hours
        return context.ui.networkDeviceGreaterThanDay;
      default:
        // Device does not use pi-hole
        return context.ui.networkDeviceDoesNotUsePihole;
    }
  }

  Widget _networkDeviceRow(Device item) {
    return CustomExpansionTileWidget(
      isHeaderARow: true,
      headerItems: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDeviceName(item),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: getDeviceColor(item),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    CustomTagWidget(title: item.interfaceName),
                  ],
                ),
                const SizedBox(height: 5),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 3,
                      children: [
                        CustomTagWidget(title: item.hwaddr),
                        CustomTagWidget(title: item.numQueries.toString()),
                      ],
                    ),
                    Icon(
                      getDifference(item).inDays < 0
                          ? Icons.question_mark
                          : Icons.check,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Query: ${PiUtils.getDateFormatter(item.lastQuery.toDouble())}',
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      contentTitleItems: [
        const Text('Hardware Address: ', style: KTextStyle.listExpandedTitle),
        const Text('Last Query: ', style: KTextStyle.listExpandedTitle),
        const Text('First Seen: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('IPs: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
        Text(
          item.hwaddr,
          style: KTextStyle.listExpandedValue,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        Text(
          PiUtils.getDateFormatter(item.lastQuery.toDouble()),
          style: KTextStyle.listExpandedValue,
        ),
        Text(
          PiUtils.getDateFormatter(item.firstSeen.toDouble()),
          style: KTextStyle.listExpandedValue,
        ),
        Text('${item.id}', style: KTextStyle.listExpandedValue),
        Text(buildIPs(item)),
      ],
    );
  }

  Widget _networkDeviceRowCard(Device item, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: KCardStyle.cardPadding,
        child: Column(
          children: [
            // header row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getDeviceName(item),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: getDeviceColor(item),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    CustomTagWidget(title: item.interfaceName),
                  ],
                ),
                const SizedBox(height: 5),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 3,
                      children: [
                        CustomTagWidget(title: item.hwaddr),
                        CustomTagWidget(title: item.numQueries.toString()),
                      ],
                    ),
                    Icon(
                      getDifference(item).inDays < 0
                          ? Icons.question_mark
                          : Icons.check,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Query: ${PiUtils.getDateFormatter(item.lastQuery.toDouble())}',
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // details
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hardware Address: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Last Query: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'First Seen: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Database ID: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'IPs: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.hwaddr,
                              style: KTextStyle.listExpandedValue,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            Text(
                              PiUtils.getDateFormatter(
                                item.lastQuery.toDouble(),
                              ),
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              PiUtils.getDateFormatter(
                                item.firstSeen.toDouble(),
                              ),
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              '${item.id}',
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(buildIPs(item)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // entity actions like edit and delete
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    deleteNetworkDeviceModal(context, item);
                  },
                  tooltip: "Delete",
                  icon: Icon(
                    Icons.delete,
                    color: context.ui.slideError.withAlpha(170),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void deleteNetworkDeviceModal(BuildContext context, Device item) {
    final networkDevicesBloc = context.read<NetworkDevicesBloc>();
    final pageIndexNotifier = ValueNotifier<int>(0);
    WoltModalSheet.show(
      context: context,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            pageTitle: Text(
              'Delete Device',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: BlocProvider.value(
              value: networkDevicesBloc,
              child: BlocListener<NetworkDevicesBloc, NetworkDevicesState>(
                listener: (context, state) {
                  if (state.itemStatus ==
                      NetworkDevicesItemStateStatus.success) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  } else if (state.itemStatus ==
                      NetworkDevicesItemStateStatus.failure) {
                    PiUtils.handleGeneralException(context, state.error);
                  }
                },
                child: SimpleBottomSheet(
                  primaryTitle: "Delete",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  cancelFunction: () => Navigator.pop(context),
                  primaryFunction: () => {
                    networkDevicesBloc.add(
                      DeleteNetworkDevice(networkDevice: item),
                    ),
                  },
                  confirmationText: 'Do you want to delete device?',
                ),
              ),
            ),
          ),
        ];
      },
      modalTypeBuilder: (context) => PiUtils.getModalTypeBuilder(context),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  Widget generateNetworkDevicesData(List<Device> devices) {
    ListView listView = ListView.separated(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        var selectedPageItem = devices[index];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteNetworkDeviceModal(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: context.ui.slideError,
                icon: Icons.delete,
              ),
            ],
          ),
          child: _networkDeviceRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KDivider.listDivider;
      },
    );
    return listView;
  }

  void onSearchChanged(
    BuildContext context,
    String query,
    int page,
    int itemsPerPage,
  ) {
    const int minSearchLength = 1;
    String trimmedQuery = query.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // waits 400 milliseconds before processing user input
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // Case 1: Search cleared
      if (trimmedQuery.isEmpty) {
        context.read<NetworkDevicesBloc>().add(UpdateCurrentPage(1));
        context.read<NetworkDevicesBloc>().add(ClearNetworkDevicesSearch());
        return;
      }

      // Case 2: Too short → do nothing
      if (trimmedQuery.length < minSearchLength) {
        return;
      }

      context.read<NetworkDevicesBloc>().add(UpdateCurrentPage(1));
      // Case 3: Valid search (going to page 1 because its new search)
      context.read<NetworkDevicesBloc>().add(
        SearchNetworkDevices(trimmedQuery, 1, itemsPerPage),
      );
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // log('sizes: constraints: ${constraints.maxHeight}');
                    final isSearching = searchController.text.trim().isNotEmpty;
                    // During searching keyboard appears and layout changes
                    // needs to disable that for smoother search
                    if (!layoutLocked && !isSearching) {
                      final itemsPerPage = calculateItemsPerPage(
                        availableHeight: constraints.maxHeight,
                        reservedHeight: _reservedHeight,
                        rowHeight: _rowHeight,
                      );
                      final pagesPerView = calculatePagesPerView(
                        availableWidth: constraints.maxWidth,
                        reservedWidth: _reservedWidth,
                      );
      
                      // Notify Bloc ONLY if sizes changes
                      if (_lastItemsPerPage != itemsPerPage) {
                        _lastItemsPerPage = itemsPerPage;
      
                        context.read<NetworkDevicesBloc>().add(
                          UpdateItemsPerPage(itemsPerPage),
                        );
                      }
      
                      if (_lastPagesPerView != pagesPerView) {
                        _lastPagesPerView = pagesPerView;
      
                        context.read<NetworkDevicesBloc>().add(
                          UpdatePagesPerView(pagesPerView),
                        );
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Network Devices",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    iconSize: 25,
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(
                                      minHeight: 25,
                                      minWidth: 25,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    tooltip: 'Refresh Devices',
                                    onPressed: () {
                                      if (searchController.text.isEmpty) {
                                        context.read<NetworkDevicesBloc>().add(
                                          RefreshNetworkDevices(),
                                        );
                                      }
                                    },
                                    icon: Icon(Icons.refresh),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    iconSize: 25,
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.center,
                                    constraints: BoxConstraints(
                                      minHeight: 25,
                                      minWidth: 25,
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      isNetworkDeviceSearchVisible.value =
                                          !isNetworkDeviceSearchVisible.value;
                                      searchFocusNode.requestFocus();
                                    },
                                    icon: Icon(Icons.search),
                                  ),
                                ],
                              ),
                              ValueListenableBuilder(
                                valueListenable: isNetworkDeviceSearchVisible,
                                builder: (context, searchVisible, child) {
                                  if (!searchVisible) {
                                    return const SizedBox(key: ValueKey('empty'));
                                  }
                                  return Padding(
                                    key: const ValueKey('search'),
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextFormField(
                                      focusNode: searchFocusNode,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      controller: searchController,
                                      onChanged: (value) => onSearchChanged(
                                        context,
                                        value,
                                        context
                                            .read<NetworkDevicesBloc>()
                                            .state
                                            .page,
                                        context
                                            .read<NetworkDevicesBloc>()
                                            .state
                                            .itemsPerPage,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Search Devices",
                                        helperStyle: TextStyle(fontSize: 9),
                                        isDense: true,
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            searchController.clear();
                                            onSearchChanged(
                                              context,
                                              '',
                                              context
                                                  .read<NetworkDevicesBloc>()
                                                  .state
                                                  .page,
                                              context
                                                  .read<NetworkDevicesBloc>()
                                                  .state
                                                  .itemsPerPage,
                                            );
                                          },
                                          icon: Icon(Icons.clear),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: BlocConsumer<NetworkDevicesBloc, NetworkDevicesState>(
                            listener: (context, state) {
                              if (state.status ==
                                  NetworkDevicesStateStatus.failure) {
                                PiUtils.handleGeneralException(
                                  context,
                                  "An Error Occured",
                                );
                              } else if (state.itemStatus ==
                                  NetworkDevicesItemStateStatus.success) {
                                GlobalBanner.info(context, state.message, "");
                              }
                            },
                            builder: (context, state) {
                              if (state.status ==
                                  NetworkDevicesStateStatus.loading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state.status ==
                                  NetworkDevicesStateStatus.failure) {
                                return const CustomErrorWidget(
                                  message: "Error loading data",
                                );
                                // Full-page empty ONLY if not searching
                              } else if (state.devices.isEmpty &&
                                  state.searchStatus ==
                                      NetworkDevicesSearchStatus.searching) {
                                return const Center(
                                  child: EmptyWidget(message: "No data"),
                                );
                              } else if (state.status ==
                                  NetworkDevicesStateStatus.success) {
                                List<Device> devices = state.devices;
                                final totalPages =
                                    (state.total / state.itemsPerPage).ceil();
                                return Column(
                                  children: [
                                    Expanded(
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final width = constraints.maxWidth;
      
                                          return width < 500
                                              ? RefreshIndicator(
                                                  onRefresh: () async {
                                                    if (state
                                                        .searchTerm
                                                        .isEmpty) {
                                                      context
                                                          .read<
                                                            NetworkDevicesBloc
                                                          >()
                                                          .add(
                                                            RefreshNetworkDevices(),
                                                          );
                                                    }
                                                  },
                                                  child:
                                                      generateNetworkDevicesData(
                                                        devices,
                                                      ),
                                                )
                                              : GridView.builder(
                                                  padding: const EdgeInsets.all(
                                                    10,
                                                  ),
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                        crossAxisSpacing: 8,
                                                        mainAxisSpacing: 8,
                                                        mainAxisExtent:
                                                            KGridCardSizes
                                                                .devices["height"]!
                                                                .toDouble(),
                                                        maxCrossAxisExtent:
                                                            KGridCardSizes
                                                                .devices["width"]!
                                                                .toDouble(),
                                                      ),
                                                  itemCount: devices.length,
                                                  itemBuilder: (context, index) {
                                                    return _networkDeviceRowCard(
                                                      devices[index],
                                                      context,
                                                    );
                                                  },
                                                );
                                        },
                                      ),
                                    ),
                                    // During search if no results come up then
                                    // pagination should be hidden otherwise error
                                    // occurs with pager with 0 pages
                                    if (totalPages > 0)
                                      Center(
                                        child: Pager(
                                          currentItemsPerPage: state.itemsPerPage,
                                          currentPage: state.page,
                                          totalPages:
                                              (state.total / state.itemsPerPage)
                                                  .ceil(),
                                          onPageChanged: (page) {
                                            if (searchController.text
                                                .trim()
                                                .isNotEmpty) {
                                              context
                                                  .read<NetworkDevicesBloc>()
                                                  .add(
                                                    SearchNetworkDevices(
                                                      searchController.text,
                                                      page,
                                                      state.itemsPerPage,
                                                    ),
                                                  );
                                            } else {
                                              context
                                                  .read<NetworkDevicesBloc>()
                                                  .add(
                                                    LoadNetworkDevices(
                                                      page,
                                                      state.itemsPerPage,
                                                    ),
                                                  );
                                            }
                                          },
                                          pagesView: state.pagesPerView,
                                          numberButtonSelectedColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          numberTextUnselectedColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
