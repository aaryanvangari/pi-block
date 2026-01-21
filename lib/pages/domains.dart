import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart'
    hide ResetItemToggleError;
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/add_domain_modal_widget.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/edit_domain_modal_widget.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/time_ago_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DomainsPage extends StatelessWidget {
  const DomainsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              GroupsBloc(context.read<PiholeRepository>())..add(LoadGroups()),
        ),
      ],
      child: DomainsView(),
    );
  }
}

class DomainsView extends StatefulWidget {
  const DomainsView({super.key});

  @override
  State<DomainsView> createState() => _DomainsViewState();
}

class _DomainsViewState extends State<DomainsView> {
  @override
  void initState() {
    super.initState();
    // getting bloc from appView context as domains data is being shared by querylog and domains
    // querylog is using it for allow/deny action and it needs to update domains
    // if the bloc is page scoped then both data will be different and does not update
    // unless a reload of bloc which happens only when logout and login
    // Loading domains
    context.read<DomainsBloc>().add(LoadDomains());
  }

  void addDomainFormModal(BuildContext ctx) {
    final pageIndexNotifier = ValueNotifier<int>(0);

    final domainsBloc = ctx.read<DomainsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();
    groupsBloc.add(ResetGroupsSelection());

    WoltModalSheet.show(
      context: ctx,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            resizeToAvoidBottomInset: true,
            pageTitle: Text(
              "Add Domain",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DomainsBloc>.value(value: domainsBloc),
                BlocProvider<GroupsBloc>.value(value: groupsBloc),
              ],
              child: AddDomainModal(),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  void editDomainFormModal(BuildContext ctx, DomainModel domainModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    final domainsBloc = ctx.read<DomainsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();

    WoltModalSheet.show(
      context: ctx,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            resizeToAvoidBottomInset: true,
            pageTitle: Text(
              "Edit Domain",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DomainsBloc>.value(value: domainsBloc),
                BlocProvider<GroupsBloc>.value(value: groupsBloc),
              ],
              child: EditDomainModal(domainModel: domainModel),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  void deleteDomainModal(BuildContext context, DomainModel domainModel) {
    final domainsBloc = context.read<DomainsBloc>();

    ConfirmActionBottomSheet.show<DomainsBloc, DomainsState>(
      context: context,
      sheet: ConfirmActionBottomSheet<DomainsBloc, DomainsState>(
        bloc: domainsBloc,
        title: 'Delete Domain',
        confirmationText: 'Do you want to delete domain?',
        confirmButtonText: 'Delete',
        onConfirm: () {
          domainsBloc.add(DeleteDomainsItem(domainModel: domainModel));
        },
        isSuccess: (state) =>
            state.itemStatus == DomainsItemStateStatus.success,
        isFailure: (state) =>
            state.itemStatus == DomainsItemStateStatus.failure,
        onFailure: (context, state) {
          PiUtils.handleGeneralException(context, state.error);
        },
      ),
    );
  }

  Widget _domainRow(DomainModel item, BuildContext context) {
    return CustomExpansionTileWidget(
      isHeaderARow: true,
      headerItems: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.domain,
                            style: (item.type == "deny")
                                ? context.ui.listHeaderTitleBlock
                                : context.ui.listHeaderTitleAllow,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            item.comment,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),

                    FlutterSwitch(
                      height: 25.0,
                      width: 45.0,
                      padding: 4.0,
                      toggleSize: 15.0,
                      borderRadius: 20.0,
                      activeColor: KColors.flutterSwitch,
                      value: item.enabled,
                      onToggle: (value) {
                        context.read<DomainsBloc>().add(
                          DomainItemToggled(
                            domainModel: item,
                            isEnabled: value,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 3,
                      children: [
                        CustomTagWidget(
                          iconData: item.type == "deny"
                              ? Icons.block
                              : FontAwesomeIcons.check,
                          color: item.type == "deny"
                              ? KColors.deny
                              : KColors.allow,
                          title: item.type == "deny" ? "Deny" : "Allow",
                        ),
                        CustomTagWidget(
                          iconData: item.kind == "regex"
                              ? Symbols.regular_expression
                              : Symbols.match_word,
                          color: item.type == "deny"
                              ? KColors.deny
                              : KColors.allow,
                          title: item.kind == "regex" ? "Regex" : "Exact",
                        ),
                      ],
                    ),
                    TimeAgoWidget(time: item.date_modified),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      contentTitleItems : getEntityDetails(item, "titles"),
      contentValueItems: getEntityDetails(item, "values"),
    );
  }

  List<Widget> getEntityDetails(DomainModel item, String entityDetailType) {
    List<Text> entityTitles = const [
      Text('Domain: ', style: KTextStyle.listExpandedTitle),
      Text('Unicode: ', style: KTextStyle.listExpandedTitle),
      Text('Comment: ', style: KTextStyle.listExpandedTitle),
      Text('Groups: ', style: KTextStyle.listExpandedTitle),
      Text('Database ID: ', style: KTextStyle.listExpandedTitle),
      Text('Added: ', style: KTextStyle.listExpandedTitle),
      Text('Modified: ', style: KTextStyle.listExpandedTitle),
    ];

    List<Widget> entityValues = [
      Text(item.domain, style: KTextStyle.listExpandedValue),
      Text(item.unicode, style: KTextStyle.listExpandedValue),
      Text(item.comment, style: KTextStyle.listExpandedValue),
      BlocBuilder<GroupsBloc, GroupsState>(
        builder: (context, state) {
          if (state.status == GroupsStateStatus.success) {
            String groupsListString = state.groups
                .where((group) => (item.groups.contains(group.id)))
                .map((group) => group.name)
                .join(' • ');
            return Text(groupsListString);
          }
          return const SizedBox.shrink();
        },
      ),
      Text(item.id.toString(), style: KTextStyle.listExpandedValue),
      Text(
        '${PiUtils.getTimeAgo(item.date_added, "milliseconds")} (${PiUtils.getDateFormatter(item.date_added.toDouble())})',
        style: KTextStyle.listExpandedValue,
      ),
      Text(
        '${PiUtils.getTimeAgo(item.date_modified, "milliseconds")} (${PiUtils.getDateFormatter(item.date_modified.toDouble())})',
        style: KTextStyle.listExpandedValue,
      ),
    ];
    if (entityDetailType == "titles") {
      return entityTitles;
    } else if (entityDetailType == "values") {
      return entityValues;
    } else {
      return [];
    }
  }

  Widget _domainRowCard(DomainModel item, BuildContext context) {
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
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.domain,
                            style: (item.type == "deny")
                                ? context.ui.listHeaderTitleBlock
                                : context.ui.listHeaderTitleAllow,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            item.comment,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),

                    FlutterSwitch(
                      height: 25.0,
                      width: 45.0,
                      padding: 4.0,
                      toggleSize: 15.0,
                      borderRadius: 20.0,
                      activeColor: KColors.flutterSwitch,
                      value: item.enabled,
                      onToggle: (value) {
                        context.read<DomainsBloc>().add(
                          DomainItemToggled(
                            domainModel: item,
                            isEnabled: value,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 3,
                      children: [
                        CustomTagWidget(
                          iconData: item.type == "deny"
                              ? Icons.block
                              : FontAwesomeIcons.check,
                          color: item.type == "deny"
                              ? KColors.deny
                              : KColors.allow,
                          title: item.type == "deny" ? "Deny" : "Allow",
                        ),
                        CustomTagWidget(
                          iconData: item.kind == "regex"
                              ? Symbols.regular_expression
                              : Symbols.match_word,
                          color: item.type == "deny"
                              ? KColors.deny
                              : KColors.allow,
                          title: item.kind == "regex" ? "Regex" : "Exact",
                        ),
                      ],
                    ),
                    TimeAgoWidget(time: item.date_modified),
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
                          children: getEntityDetails(item, "titles"),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getEntityDetails(item, "values"),
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
                    editDomainFormModal(context, item);
                  },
                  tooltip: "Edit",
                  icon: Icon(Icons.edit, color: context.ui.editIconColor),
                ),
                IconButton(
                  onPressed: () {
                    deleteDomainModal(context, item);
                  },
                  tooltip: "Delete",
                  icon: Icon(Icons.delete, color: context.ui.deleteIconColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDomains(List<DomainModel> domainModels) {
    ListView listView = ListView.separated(
      itemCount: domainModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = domainModels[index];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteDomainModal(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: context.ui.slideError,
                icon: Icons.delete,
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  editDomainFormModal(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: context.ui.slidePrimary,
                icon: Icons.edit,
              ),
            ],
          ),
          child: _domainRow(selectedPageItem, context),
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<DomainsBloc, DomainsState>(
                  listener: (context, state) {
                    if (state.status == DomainsStateStatus.failure) {
                      PiUtils.handleGeneralException(
                        context,
                        "An Error Occured",
                      );
                    } else if (state.itemToggleStatus ==
                        DomainsItemToggleStateStatus.failure) {
                      context.read<DomainsBloc>().add(ResetItemToggleError());
                      PiUtils.handleGeneralException(
                        context,
                        "An Error Occured",
                      );
                    } else if (state.itemStatus ==
                        DomainsItemStateStatus.success) {
                      GlobalBanner.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    if (state.status == DomainsStateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == DomainsStateStatus.failure) {
                      return const CustomErrorWidget(
                        message: "Error loading data",
                      );
                    } else if (state.domains.isEmpty) {
                      return const Center(
                        child: EmptyWidget(message: "No data"),
                      );
                    } else if (state.status == DomainsStateStatus.success) {
                      List<DomainModel> domainModels = state.domains;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Domains",
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
                                  tooltip: 'Refresh Domains',
                                  onPressed: () {
                                    context.read<DomainsBloc>().add(
                                      LoadDomains(),
                                    );
                                  },
                                  icon: Icon(Icons.refresh),
                                ),
                                const SizedBox(width: 5),
                                IconButton.filled(
                                  onPressed: () {
                                    addDomainFormModal(context);
                                  },
                                  icon: Icon(Icons.add, size: 15),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final width = constraints.maxWidth;

                                return width < 500
                                    ? RefreshIndicator(
                                        onRefresh: () async {
                                          context.read<DomainsBloc>().add(
                                            LoadDomains(),
                                          );
                                        },
                                        child: getDomains(domainModels),
                                      )
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(10),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              mainAxisExtent: KGridCardSizes
                                                  .domains["height"]!
                                                  .toDouble(),
                                              maxCrossAxisExtent: KGridCardSizes
                                                  .domains["width"]!
                                                  .toDouble(),
                                            ),
                                        itemCount: domainModels.length,
                                        itemBuilder: (context, index) {
                                          return _domainRowCard(
                                            domainModels[index],
                                            context,
                                          );
                                        },
                                      );
                              },
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
          ),
        ),
      ),
    );
  }
}
