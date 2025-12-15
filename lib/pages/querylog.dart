import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pager/pager.dart';
import 'package:pi_block/blocs/querylog/querylog_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/query_model.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/simple_sheet.dart';
import 'package:pi_block/widgets/empty_widget.dart';

class QueryLogPage extends StatefulWidget {
  const QueryLogPage({super.key});

  @override
  State<QueryLogPage> createState() => _QueryLogPageState();
}

class _QueryLogPageState extends State<QueryLogPage> {
  int pageSize = 0;
  int pagesPerView = 2;
  late int _totalPages = 1;
  int _currentPage = 1;
  int pagerHeight = 40;
  double heightForListView = 0;

  determinePageSizes() {
    /// #TODO refactor
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double pagerButtonWidth = 40;
    double pagerNumberButtonWidth = 56;
    double individualRowHeight = 71;
    double mandatoryNavigationButtons = 4 * pagerButtonWidth;
    double remainingWidth = width - mandatoryNavigationButtons;
    int maxButtons = (remainingWidth / pagerNumberButtonWidth).toInt() - 1;

    /// Limiting pages view to 5 pages as more than that would be awkward
    pagesPerView = (maxButtons > 5) ? 5 : maxButtons;
    heightForListView =
        height -
        (kToolbarHeight +
            20 + // card paddings
            26 + // query log label
            10 + // sizedbox
            20 + // android differences (maybe top status bar affecting)
            // 75 +
            pagerHeight +
            kBottomNavigationBarHeight);
    int itemsCanFit = (heightForListView / individualRowHeight).toInt();
    pageSize = itemsCanFit;
    // if (height < 600) {
    //   pageSize = 4;
    // } else if (height < 800) {
    //   pageSize = 6;
    // } else if (height < 900) {
    //   pageSize = 7;
    // } else if (height < 1000) {
    //   pageSize = 8;
    // } else if (height < 1100) {
    //   pageSize = 9;
    // } else if (height < 1200) {
    //   pageSize = 11;
    // }
  }

  String getDomainName(query) {
    String domainName = "";
    var queryStatusConstant = KConstants.queryStatus[query.status];
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
    var queryStatusConstant = KConstants.queryStatus[query.status];
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
      status = KConstants.queryStatus[query.status]["fieldtext"];
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
    var queryStatusConstant = KConstants.queryStatus[status];
    return Icon(
      queryStatusConstant["icon"],
      size: 12,
      color: queryStatusConstant["color"],
    );
  }

  Widget _queryLogRow(QueryModel item) {
    var queryStatusConstant = KConstants.queryStatus[item.status];
    bool isDarkMode = PiUtils.getDarkMode(context);
    String queryStatusColor = queryStatusConstant["colorName"];
    Color queryStatusColorWithAlpha = isDarkMode
        ? KConstants.queryLogColors[queryStatusColor]["dark"]
        : KConstants.queryLogColors[queryStatusColor]["light"];
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
        Text('Domain: ', style: KTextStyle.listExpandedTitle),
        Text('Received on: ', style: KTextStyle.listExpandedTitle),
        Text('Client: ', style: KTextStyle.listExpandedTitle),
        Text('Reply: ', style: KTextStyle.listExpandedTitle),
        Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        Text('Query Status: ', style: KTextStyle.listExpandedTitle),
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
            showModalBottomSheet(
              isScrollControlled: true,
              elevation: 5,
              context: context,
              isDismissible: true,
              showDragHandle: true,
              shape: KBottomSheetStyle.shape,
              builder: (ctx) => SimpleBottomSheet(
                primaryTitle: "Allow",
                context: context,
                backgroundColor: Theme.of(ctx).colorScheme.primary,
                cancelFunction: () => Navigator.pop(ctx),
                primaryFunction: () {
                  ctx.read<QuerylogBloc>().add(
                    AllowDenyQuerylogDomain(item, "allow"),
                  );
                  Navigator.pop(ctx);
                },
                confirmationText: "Do you want to allow domain?",
              ),
            );
          },
          autoClose: true,
          backgroundColor: isBlocked ? slidePrimary.value : slideError.value,
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
            showModalBottomSheet(
              isScrollControlled: true,
              elevation: 5,
              context: context,
              isDismissible: true,
              showDragHandle: true,
              shape: KBottomSheetStyle.shape,
              builder: (ctx) => SimpleBottomSheet(
                primaryTitle: "Deny",
                context: context,
                cancelFunction: () => Navigator.pop(ctx),
                primaryFunction: () async {
                  ctx.read<QuerylogBloc>().add(
                    AllowDenyQuerylogDomain(item, "deny"),
                  );
                  Navigator.pop(ctx);
                },
                confirmationText: "Do you want to deny domain?",
              ),
            );
          },
          autoClose: true,
          backgroundColor: isBlocked ? slidePrimary.value : slideError.value,
          icon: isBlocked ? Icons.check : Icons.block,
        ),
      ],
    );
  }

  Widget generateQueryLogData(QueryListModel queryListModel) {
    ListView listView = ListView.separated(
      itemCount: queryListModel.queries.length,
      itemBuilder: (context, index) {
        var selectedPageItem = queryListModel.queries[index];
        bool isBlocked = false;
        isBlocked =
            KConstants.queryStatus[selectedPageItem.status].containsKey(
              "blocked",
            ) &&
            KConstants.queryStatus[selectedPageItem.status]["blocked"];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          endActionPane: isBlocked
              ? allowActionPane(selectedPageItem, isBlocked)
              : denyActionPane(selectedPageItem, isBlocked),
          child: _queryLogRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  Widget getQueryLog() {
    return BlocConsumer<QuerylogBloc, QuerylogState>(
      buildWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        if (state is QuerylogError) {
          PiUtils.handleGeneralException(context, state.errorMessage);
        } else if (state is QuerylogItemOperationSuccess) {
          GlobalSnackbar.info(context, state.message, "");
        } else if (state is QuerylogItemOperationFailure) {
          GlobalSnackbar.error(context, state.errorMessage, "");
        }
      },
      builder: (context, state) {
        Widget widget = SizedBox();
        if (state is QuerylogError) {
          widget = CustomErrorWidget(message: "Error loading data");
        } else if (state is QuerylogEmpty) {
          widget = EmptyWidget(message: "No data");
        } else if (state is QuerylogLoading) {
          widget = Center(child: CircularProgressIndicator());
        } else if (state is QuerylogItemOperationSuccess) {
          context.read<QuerylogBloc>().add(
            LoadQuerylog(_currentPage, pageSize),
          );
        } else if (state is QuerylogLoaded) {
          QueryListModel queryListModel = state.queryListModel;
          widget = generateQueryLogData(queryListModel);
        }
        return widget;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    determinePageSizes();
    context.read<QuerylogBloc>().add(LoadQuerylog(1, pageSize));
    return Scaffold(
      // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Query Log",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: heightForListView,
                    width: MediaQuery.sizeOf(context).width * 0.99,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                            return getQueryLog();
                          },
                    ),
                  ),
                  BlocConsumer<QuerylogBloc, QuerylogState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is QuerylogLoaded) {
                        QueryListModel queryListModel = state.queryListModel;
                        _currentPage = state.page;
                        _totalPages =
                            (queryListModel.recordsFiltered / pageSize).ceil();
                      }
                      return Center(
                        child: Pager(
                          currentItemsPerPage: pageSize,
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                          onPageChanged: (page) {
                            context.read<QuerylogBloc>().add(
                              LoadQuerylog(page, pageSize),
                            );
                          },
                          pagesView: pagesPerView,
                          numberButtonSelectedColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          numberTextUnselectedColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
