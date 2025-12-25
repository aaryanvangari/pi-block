import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pager/pager.dart';
import 'package:pi_block/blocs/querylog/querylog_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/constants/features/querylog.dart';
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

  int calculatePagesPerView({
    required double availableWidth,
    required double reservedWidth,
  }) {
    const double pagerButtonWidth = 40;
    const double pagerNumberButtonWidth = 56;
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

  ActionPane allowActionPane(item, isBlocked) {
    return ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.2,
      children: [
        SlidableAction(
          onPressed: (context) {
            final querylogBloc = BlocProvider.of<QuerylogBloc>(context);
            showModalBottomSheet(
              isScrollControlled: true,
              elevation: 5,
              context: context,
              isDismissible: true,
              showDragHandle: true,
              shape: KBottomSheetStyle.shape,
              builder: (ctx) => SimpleBottomSheet(
                primaryTitle: "Allow",
                backgroundColor: Theme.of(ctx).colorScheme.primary,
                cancelFunction: () => Navigator.pop(ctx),
                primaryFunction: () {
                  querylogBloc.add(
                    AllowDenyQuerylogDomain(queryModel: item, type: "allow"),
                  );
                  Navigator.pop(ctx);
                },
                confirmationText: "Do you want to allow domain?",
              ),
            );
          },
          autoClose: true,
          backgroundColor: isBlocked
              ? context.ui.slidePrimary
              : context.ui.slideError,
          icon: isBlocked ? Icons.check : Icons.block,
        ),
      ],
    );
  }

  ActionPane denyActionPane(item, isBlocked) {
    return ActionPane(
      motion: const BehindMotion(),
      extentRatio: 0.2,
      children: [
        SlidableAction(
          onPressed: (context) {
            final querylogBloc = BlocProvider.of<QuerylogBloc>(context);
            showModalBottomSheet(
              isScrollControlled: true,
              elevation: 5,
              context: context,
              isDismissible: true,
              showDragHandle: true,
              shape: KBottomSheetStyle.shape,
              builder: (ctx) {
                return SimpleBottomSheet(
                  primaryTitle: "Deny",
                  cancelFunction: () => Navigator.pop(ctx),
                  primaryFunction: () {
                    querylogBloc.add(
                      AllowDenyQuerylogDomain(queryModel: item, type: "deny"),
                    );
                    Navigator.pop(ctx);
                  },
                  confirmationText: "Do you want to deny domain?",
                );
              },
            );
          },
          autoClose: true,
          backgroundColor: isBlocked
              ? context.ui.slidePrimary
              : context.ui.slideError,
          icon: isBlocked ? Icons.check : Icons.block,
        ),
      ],
    );
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
          endActionPane: isBlocked
              ? allowActionPane(selectedPageItem, isBlocked)
              : denyActionPane(selectedPageItem, isBlocked),
          child: _queryLogRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KDivider.listDivider;
      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    context.ui; // updates AppUiTokens when theme changes
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // log('sizes: constraints: ${constraints.maxHeight}');
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

                  return BlocConsumer<QuerylogBloc, QuerylogState>(
                    listener: (context, state) {
                      if (state.status == QuerylogStateStatus.failure) {
                        PiUtils.handleGeneralException(
                          context,
                          "An Error Occured",
                        );
                      } else if (state.itemStatus ==
                          QuerylogItemStateStatus.failure) {
                        PiUtils.handleGeneralException(
                          context,
                          "An Error Occured",
                        );
                      } else if (state.itemStatus ==
                          QuerylogItemStateStatus.success) {
                        GlobalSnackbar.info(context, state.message, "");
                      }
                    },
                    builder: (context, state) {
                      if (state.status == QuerylogStateStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.status == QuerylogStateStatus.failure) {
                        return const CustomErrorWidget(
                          message: "Error loading data",
                        );
                      } else if (state.queries.isEmpty) {
                        return const Center(
                          child: EmptyWidget(message: "No data"),
                        );
                      } else if (state.status == QuerylogStateStatus.success) {
                        List<QueryModel> queryModels = state.queries;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: const Text(
                                "Query Log",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: generateQueryLogData(queryModels)),
                            Center(
                              child: Pager(
                                currentItemsPerPage: state.itemsPerPage,
                                currentPage: state.page,
                                totalPages:
                                    (state.recordsFiltered / state.itemsPerPage)
                                        .ceil(),
                                onPageChanged: (page) {
                                  context.read<QuerylogBloc>().add(
                                    LoadQuerylog(page, state.itemsPerPage),
                                  );
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
