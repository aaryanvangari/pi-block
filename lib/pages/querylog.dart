import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pager/pager.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/querylog/querylog_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/constants/features/querylog.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/simple_sheet.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'dart:io' show Platform;

class QueryLogPage extends StatelessWidget {
  const QueryLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuerylogBloc(context.read<PiholeRepository>()),
      child: _QueryLogView(),
    );
  }
}

class _QueryLogView extends StatefulWidget {
  const _QueryLogView();

  @override
  State<_QueryLogView> createState() => _QueryLogViewState();
}

class _QueryLogViewState extends State<_QueryLogView> {
  static const double _rowHeight = 71;
  static const double _reservedHeight = 80;
  static const double _reservedWidth = 30;

  int _lastItemsPerPage = 0;
  int _lastPagesPerView = 0;
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounce;
  bool layoutLocked = false;

  @override
  void initState() {
    // searchFocusNode.addListener(() {
    //   layoutLocked = searchFocusNode.hasFocus;
    // });
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

  String getDomainName(query) {
    String domainName = "";
    var queryStatusConstant = QuerylogConstants.queryStatus[query.status];
    if (queryStatusConstant?.containsKey("isCNAME")) {
      var isCNAME = queryStatusConstant["isCNAME"];
      domainName = isCNAME
          ? '${query.domain} (blocked ${query.cname})'
          : query.domain;
      return domainName;
    }
    domainName = query.domain;
    return domainName;
  }

  Widget getStatusHumanReadableText(
    QueryModel query,
    Color queryStatusColorWithAlpha,
  ) {
    String status = "";
    var queryStatusConstant = QuerylogConstants.queryStatus[query.status];
    var isCNAME =
        (queryStatusConstant?.containsKey("isCNAME") &&
        queryStatusConstant["isCNAME"]);
    var customStatusTypes = ["FORWARDED", "SPECIAL_DOMAIN", "default"];
    if (customStatusTypes.contains(query.status)) {
      switch (query.status) {
        case "FORWARDED":
          status =
              (query.reply.type != "UNKNOWN"
                  ? "Forwarded, reply from "
                  : "Forwarded to ") +
              query.upstream;
          break;
        case "SPECIAL_DOMAIN":
          status = query.status;
          break;
        default:
          status = query.status;
      }
    } else {
      status = QuerylogConstants.queryStatus[query.status]["fieldtext"];
      status = isCNAME
          ? '$status Query was blocked during CNAME inspection of ${query.cname}'
          : status;
    }
    Widget statusWidget = Text(
      status,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: queryStatusColorWithAlpha,
      ),
    );

    return statusWidget;
  }

  Widget buildStatusCell(String status) {
    var queryStatusConstant = QuerylogConstants.queryStatus[status];
    return Icon(
      queryStatusConstant["icon"],
      size: 12,
      color: queryStatusConstant["color"],
    );
  }

  Widget _queryLogRow(QueryModel item) {
    var queryStatusConstant = QuerylogConstants.queryStatus[item.status];
    bool isDarkMode = PiUtils.getDarkMode(context);
    String queryStatusColor = queryStatusConstant["colorName"];
    Color queryStatusColorWithAlpha = isDarkMode
        ? KQueryLogColors.queryLogColors[queryStatusColor]["dark"]
        : KQueryLogColors.queryLogColors[queryStatusColor]["light"];
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
                            item.domain,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: queryStatusColorWithAlpha,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    CustomTagWidget(title: item.type),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.client.name,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 2,
                      ),
                      child: buildStatusCell(item.status),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PiUtils.getDateFormatter(item.time),
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        // vertical: 2,
                      ),
                      child: Text(PiUtils.calculateTime(item.reply.time)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      contentTitleItems: [
        const Text('Domain: ', style: KTextStyle.listExpandedTitle),
        const Text('Received on: ', style: KTextStyle.listExpandedTitle),
        const Text('Client: ', style: KTextStyle.listExpandedTitle),
        const Text('Reply: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Query Status: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
        Text(
          getDomainName(item),
          style: KTextStyle.listExpandedValue,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        Text(
          PiUtils.getDateFormatter(item.time),
          style: KTextStyle.listExpandedValue,
        ),
        Text(
          '${item.client.name} (${item.client.ip})',
          style: KTextStyle.listExpandedValue,
        ),
        Text(item.reply.type, style: KTextStyle.listExpandedValue),
        Text('${item.id}', style: KTextStyle.listExpandedValue),
        getStatusHumanReadableText(item, queryStatusColorWithAlpha),
      ],
    );
  }

  Widget _querylogRowCard(QueryModel item, BuildContext context) {
    bool isBlocked = false;
    isBlocked =
        QuerylogConstants.queryStatus[item.status].containsKey("blocked") &&
        QuerylogConstants.queryStatus[item.status]["blocked"];
    var queryStatusConstant = QuerylogConstants.queryStatus[item.status];
    bool isDarkMode = PiUtils.getDarkMode(context);
    String queryStatusColor = queryStatusConstant["colorName"];
    Color queryStatusColorWithAlpha = isDarkMode
        ? KQueryLogColors.queryLogColors[queryStatusColor]["dark"]
        : KQueryLogColors.queryLogColors[queryStatusColor]["light"];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                            item.domain,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: queryStatusColorWithAlpha,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    CustomTagWidget(title: item.type),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.client.name,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 2,
                      ),
                      child: buildStatusCell(item.status),
                    ),
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            PiUtils.getDateFormatter(item.time),
                            style: KTextStyle.listHeaderSubTitle,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        // vertical: 2,
                      ),
                      child: Text(PiUtils.calculateTime(item.reply.time)),
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
                              'Domain: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Received on: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Client: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Reply: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Database ID: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Query Status: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getDomainName(item),
                              style: KTextStyle.listExpandedValue,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            Text(
                              PiUtils.getDateFormatter(item.time),
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              '${item.client.name} (${item.client.ip})',
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              item.reply.type,
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              '${item.id}',
                              style: KTextStyle.listExpandedValue,
                            ),
                            getStatusHumanReadableText(
                              item,
                              queryStatusColorWithAlpha,
                            ),
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
                    allowDenyQuerylogModal(context, item, isBlocked);
                  },
                  tooltip: isBlocked ? "Allow" : "Deny",
                  icon: Icon(
                    isBlocked ? Icons.check : Icons.block,
                    color: isBlocked
                        ? context.ui.slidePrimary.withAlpha(170)
                        : context.ui.slideError.withAlpha(170),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void allowDenyQuerylogModal(
    BuildContext context,
    QueryModel item,
    bool isBlocked,
  ) {
    final querylogBloc = context.read<QuerylogBloc>();
    final pageIndexNotifier = ValueNotifier<int>(0);
    WoltModalSheet.show(
      context: context,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            pageTitle: Text(
              '${isBlocked ? 'Allow' : 'Deny'} Domain',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: BlocProvider.value(
              value: querylogBloc,
              child: BlocListener<QuerylogBloc, QuerylogState>(
                listener: (context, state) {
                  if (state.itemStatus == QuerylogItemStateStatus.success) {
                    // automatically updating domains whenever allow/deny happens
                    // this gets reflected in domains page without page reload
                    context.read<DomainsBloc>().add(LoadDomains());
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  } else if (state.itemStatus ==
                      QuerylogItemStateStatus.failure) {
                    PiUtils.handleGeneralException(context, state.error);
                  }
                },
                child: SimpleBottomSheet(
                  primaryTitle: isBlocked ? "Allow" : "Deny",
                  backgroundColor: isBlocked
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  cancelFunction: () => Navigator.pop(context),
                  primaryFunction: () => {
                    querylogBloc.add(
                      AllowDenyQuerylogDomain(
                        queryModel: item,
                        type: isBlocked ? "allow" : "deny",
                      ),
                    ),
                  },
                  confirmationText:
                      'Do you want to ${isBlocked ? 'allow' : 'deny'} domain?',
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

  Widget generateQueryLogData(List<QueryModel> queryModels) {
    ListView listView = ListView.separated(
      itemCount: queryModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = queryModels[index];
        bool isBlocked = false;
        isBlocked =
            QuerylogConstants.queryStatus[selectedPageItem.status].containsKey(
              "blocked",
            ) &&
            QuerylogConstants.queryStatus[selectedPageItem.status]["blocked"];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  allowDenyQuerylogModal(context, selectedPageItem, isBlocked);
                },
                autoClose: true,
                backgroundColor: isBlocked
                    ? context.ui.slidePrimary
                    : context.ui.slideError,
                icon: isBlocked ? Icons.check : Icons.block,
              ),
            ],
          ),
          child: _queryLogRow(selectedPageItem),
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
    const int minSearchLength = 3;
    String trimmedQuery = query.trim();
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // waits 400 milliseconds before processing user input
    _debounce = Timer(const Duration(milliseconds: 400), () {
      // Case 1: Search cleared
      if (trimmedQuery.isEmpty) {
        context.read<QuerylogBloc>().add(UpdateCurrentPage(1));
        context.read<QuerylogBloc>().add(ClearQuerylogSearch());
        return;
      }

      // Case 2: Too short → do nothing
      if (trimmedQuery.length < minSearchLength) {
        return;
      }

      context.read<QuerylogBloc>().add(UpdateCurrentPage(1));
      // Case 3: Valid search (going to page 1 because its new search)
      context.read<QuerylogBloc>().add(
        SearchQuerylog(trimmedQuery, 1, itemsPerPage),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // log('sizes: constraints: ${constraints.maxHeight}');
                  final isSearching = searchController.text.trim().length >= 3;
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

                      context.read<QuerylogBloc>().add(
                        UpdateItemsPerPage(itemsPerPage),
                      );
                    }

                    if (_lastPagesPerView != pagesPerView) {
                      _lastPagesPerView = pagesPerView;

                      context.read<QuerylogBloc>().add(
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
                                  "Query Log",
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
                                  tooltip: 'Refresh Querylog',
                                  onPressed: () {
                                    if (searchController.text.isEmpty) {
                                      context.read<QuerylogBloc>().add(
                                        LoadQuerylog(
                                          context
                                              .read<QuerylogBloc>()
                                              .state
                                              .page,
                                          context
                                              .read<QuerylogBloc>()
                                              .state
                                              .itemsPerPage,
                                        ),
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
                                    isQuerylogSearchVisible.value =
                                        !isQuerylogSearchVisible.value;
                                    searchFocusNode.requestFocus();
                                  },
                                  icon: Icon(Icons.search),
                                ),
                              ],
                            ),
                            ValueListenableBuilder(
                              valueListenable: isQuerylogSearchVisible,
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
                                      context.read<QuerylogBloc>().state.page,
                                      context
                                          .read<QuerylogBloc>()
                                          .state
                                          .itemsPerPage,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Search Domains",
                                      helperText: "Type at least 3 characters",
                                      helperStyle: TextStyle(fontSize: 9),
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          searchController.clear();
                                          onSearchChanged(
                                            context,
                                            '',
                                            context
                                                .read<QuerylogBloc>()
                                                .state
                                                .page,
                                            context
                                                .read<QuerylogBloc>()
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
                        child: BlocConsumer<QuerylogBloc, QuerylogState>(
                          listener: (context, state) {
                            if (state.status == QuerylogStateStatus.failure) {
                              PiUtils.handleGeneralException(
                                context,
                                "An Error Occured",
                              );
                            } else if (state.itemStatus ==
                                QuerylogItemStateStatus.success) {
                              GlobalBanner.info(context, state.message, "");
                            }
                          },
                          builder: (context, state) {
                            if (state.status == QuerylogStateStatus.loading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state.status ==
                                QuerylogStateStatus.failure) {
                              return const CustomErrorWidget(
                                message: "Error loading data",
                              );
                              // Full-page empty ONLY if not searching
                            } else if (state.queries.isEmpty &&
                                state.searchStatus ==
                                    QuerylogSearchStatus.searching) {
                              return const Center(
                                child: EmptyWidget(message: "No data"),
                              );
                            } else if (state.status ==
                                QuerylogStateStatus.success) {
                              List<QueryModel> queryModels = state.queries;
                              final totalPages =
                                  (state.recordsFiltered / state.itemsPerPage)
                                      .ceil();
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
                                                        .read<QuerylogBloc>()
                                                        .add(
                                                          LoadQuerylog(
                                                            state.page,
                                                            state.itemsPerPage,
                                                          ),
                                                        );
                                                  }
                                                },
                                                child: generateQueryLogData(
                                                  queryModels,
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
                                                              .querylog["height"]!
                                                              .toDouble(),
                                                      maxCrossAxisExtent:
                                                          KGridCardSizes
                                                              .querylog["width"]!
                                                              .toDouble(),
                                                    ),
                                                itemCount: queryModels.length,
                                                itemBuilder: (context, index) {
                                                  return _querylogRowCard(
                                                    queryModels[index],
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
                                            (state.recordsFiltered /
                                                    state.itemsPerPage)
                                                .ceil(),
                                        onPageChanged: (page) {
                                          if (searchController.text
                                              .trim()
                                              .isNotEmpty) {
                                            context.read<QuerylogBloc>().add(
                                              SearchQuerylog(
                                                searchController.text,
                                                page,
                                                state.itemsPerPage,
                                              ),
                                            );
                                          } else {
                                            context.read<QuerylogBloc>().add(
                                              LoadQuerylog(
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
    );
  }
}
