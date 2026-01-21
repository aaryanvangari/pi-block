import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/add_group_modal_widget.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/edit_group_modal_widget.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/time_ago_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GroupsBloc(context.read<PiholeRepository>())..add(LoadGroups()),
      child: GroupsView(),
    );
  }
}

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  void addGroupFormModal(BuildContext ctx) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    final groupsBloc = ctx.read<GroupsBloc>();

    WoltModalSheet.show(
      context: ctx,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            useSafeArea: true,
            navBarHeight: 40,
            pageTitle: Text(
              "Add Group",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: BlocProvider.value(
              value: groupsBloc,
              child: AddGroupModal(),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  void editGroupFormModal(BuildContext ctx, GroupModel groupModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    final groupsBloc = ctx.read<GroupsBloc>();

    WoltModalSheet.show(
      context: ctx,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            pageTitle: Text(
              "Edit Group",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: BlocProvider.value(
              value: groupsBloc,
              child: EditGroupModal(groupModel: groupModel),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  void deleteGroupModal(BuildContext context, GroupModel groupModel) {
    final groupsBloc = context.read<GroupsBloc>();

    ConfirmActionBottomSheet.show<GroupsBloc, GroupsState>(
      context: context,
      sheet: ConfirmActionBottomSheet<GroupsBloc, GroupsState>(
        bloc: groupsBloc,
        title: 'Delete Group',
        confirmationText: 'Do you want to delete group?',
        confirmButtonText: 'Delete',
        onConfirm: () {
          groupsBloc.add(DeleteGroupsItem(groupModel: groupModel));
        },
        isSuccess: (state) => state.itemStatus == GroupsItemStateStatus.success,
        isFailure: (state) => state.itemStatus == GroupsItemStateStatus.failure,
        onFailure: (context, state) {
          PiUtils.handleGeneralException(context, state.error);
        },
      ),
    );
  }

  Widget _groupRow(GroupModel item, BuildContext context) {
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
                            item.name,
                            style: KTextStyle.listHeaderTitle,
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
                        context.read<GroupsBloc>().add(
                          GroupItemToggled(groupModel: item, isEnabled: value),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TimeAgoWidget(time: item.date_modified),
              ],
            ),
          ),
        ),
      ],
      contentTitleItems: getEntityDetails(item, "titles"),
      contentValueItems: getEntityDetails(item, "values"),
    );
  }

  List<Widget> getEntityDetails(GroupModel item, String entityDetailType) {
    List<Text> entityTitles = const [
      Text('Group: ', style: KTextStyle.listExpandedTitle),
      Text('Comment: ', style: KTextStyle.listExpandedTitle),
      Text('Database ID: ', style: KTextStyle.listExpandedTitle),
      Text('Added: ', style: KTextStyle.listExpandedTitle),
      Text('Modified: ', style: KTextStyle.listExpandedTitle),
    ];

    List<Widget> entityValues = [
      Text(item.name, style: KTextStyle.listExpandedValue),
      Text(item.comment, style: KTextStyle.listExpandedValue),
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

  Widget _groupRowCard(GroupModel item, BuildContext context) {
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
                            item.name,
                            style: KTextStyle.listHeaderTitle,
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
                        context.read<GroupsBloc>().add(
                          GroupItemToggled(groupModel: item, isEnabled: value),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TimeAgoWidget(time: item.date_modified),
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
                    editGroupFormModal(context, item);
                  },
                  tooltip: "Edit",
                  icon: Icon(Icons.edit, color: context.ui.editIconColor),
                ),
                IconButton(
                  onPressed: () {
                    deleteGroupModal(context, item);
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

  Widget getGroups(List<GroupModel> groupModels) {
    ListView listView = ListView.separated(
      itemCount: groupModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = groupModels[index];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteGroupModal(context, selectedPageItem);
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
                  editGroupFormModal(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: context.ui.slidePrimary,
                icon: Icons.edit,
              ),
            ],
          ),
          child: _groupRow(selectedPageItem, context),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<GroupsBloc, GroupsState>(
                listener: (context, state) {
                  if (state.status == GroupsStateStatus.failure) {
                    PiUtils.handleGeneralException(context, "An Error Occured");
                  } else if (state.itemToggleStatus ==
                      GroupsItemToggleStateStatus.failure) {
                    context.read<GroupsBloc>().add(ResetItemToggleError());
                    PiUtils.handleGeneralException(context, "An Error Occured");
                  } else if (state.itemStatus ==
                      GroupsItemStateStatus.success) {
                    GlobalBanner.info(context, state.message, "");
                  }
                },
                builder: (context, state) {
                  if (state.status == GroupsStateStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == GroupsStateStatus.failure) {
                    return const CustomErrorWidget(
                      message: "Error loading data",
                    );
                  } else if (state.groups.isEmpty) {
                    return const Center(child: EmptyWidget(message: "No data"));
                  } else if (state.status == GroupsStateStatus.success) {
                    List<GroupModel> groupModels = state.groups;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Groups",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton.filled(
                                onPressed: () {
                                  addGroupFormModal(context);
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
                                  ? getGroups(groupModels)
                                  : GridView.builder(
                                      padding: const EdgeInsets.all(10),
                                      gridDelegate:
                                          SliverGridDelegateWithMaxCrossAxisExtent(
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            mainAxisExtent: KGridCardSizes
                                                .groups["height"]!
                                                .toDouble(),
                                            maxCrossAxisExtent: KGridCardSizes
                                                .groups["width"]!
                                                .toDouble(),
                                          ),
                                      itemCount: groupModels.length,
                                      itemBuilder: (context, index) {
                                        return _groupRowCard(
                                          groupModels[index],
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
    );
  }
}
