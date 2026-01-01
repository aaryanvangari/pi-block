import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
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
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController groupController = TextEditingController();
    final groupsBloc = ctx.read<GroupsBloc>();
    final formKey = GlobalKey<FormState>();

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: formKey,
                        child: Builder(
                          builder: (ctx) {
                            return Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: groupController,
                                  maxLines: 1,
                                  validator: (value) =>
                                      piValidators.groupValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Group",
                                    suffixIcon: IconButton(
                                      onPressed: () => groupController.clear(),
                                      icon: Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: commentController,
                                  maxLines: 2,
                                  validator: (value) =>
                                      piValidators.commentValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Comment",
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          commentController.clear(),
                                      icon: Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<GroupsBloc, GroupsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            GroupsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            GroupsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            GroupsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              GroupModel
                                              groupModel = GroupModel(
                                                name: groupController.text,
                                                comment: commentController.text,

                                                /// New groups are always enabled
                                                enabled: true,
                                              );
                                              context.read<GroupsBloc>().add(
                                                AddGroupsItem(
                                                  groupModel: groupModel,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: isLoading
                                              ? CircularLoaderInButton()
                                              : const Text("Save"),
                                        );
                                      },
                                    ),
                                    CancelButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ],
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
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      commentController.dispose();
      groupController.dispose();
      pageIndexNotifier.dispose();
    });
  }

  void editGroupFormModal(BuildContext ctx, GroupModel groupModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    bool enabled = groupModel.enabled;
    String comment = groupModel.comment;
    String name = groupModel.name;
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController(
      text: comment,
    );
    TextEditingController groupController = TextEditingController(text: name);
    final groupsBloc = ctx.read<GroupsBloc>();
    final formKey = GlobalKey<FormState>();

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
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(ctx).viewInsets.bottom + 15,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: formKey,
                        child: Builder(
                          builder: (ctx) {
                            return Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: groupController,
                                  maxLines: 1,
                                  validator: (value) =>
                                      piValidators.groupValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Group",
                                    suffixIcon: IconButton(
                                      onPressed: () => groupController.clear(),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: commentController,
                                  maxLines: 3,
                                  validator: (value) =>
                                      piValidators.commentValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Comment",
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          commentController.clear(),
                                      icon: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 10,
                                  children: [
                                    CustomToggleSwitch(
                                      initialLabelIndex: enabled ? 0 : 1,
                                      labels: ['Enabled', 'Disabled'],
                                      onToggle: (index) =>
                                          enabled = (index == 0) ? true : false,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<GroupsBloc, GroupsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            GroupsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            GroupsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            GroupsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<GroupsBloc>().add(
                                                UpdateGroupsItem(
                                                  groupModel: groupModel,
                                                  comment:
                                                      commentController.text,
                                                  enabled: enabled,
                                                  name: groupController.text,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: isLoading
                                              ? CircularLoaderInButton()
                                              : const Text("Save"),
                                        );
                                      },
                                    ),
                                    CancelButton(
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ],
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
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      commentController.dispose();
      groupController.dispose();
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
          groupsBloc.add(
            DeleteGroupsItem(groupModel: groupModel),
          );
        },
        isSuccess: (state) =>
            state.itemStatus == GroupsItemStateStatus.success,
        isFailure: (state) =>
            state.itemStatus == GroupsItemStateStatus.failure,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: const Icon(Icons.update, size: 16),
                        ),
                        Text(
                          PiUtils.getTimeAgo(
                            item.date_modified,
                            "milliseconds",
                          ),
                          style: KTextStyle.listHeaderTimeTitle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
      contentTitleItems: [
        const Text('Group: ', style: KTextStyle.listExpandedTitle),
        const Text('Comment: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Added: ', style: KTextStyle.listExpandedTitle),
        const Text('Modified: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
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
      ],
    );
  }

  Widget _groupRowCard(GroupModel item, BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: const Icon(Icons.update, size: 16),
                        ),
                        Text(
                          PiUtils.getTimeAgo(
                            item.date_modified,
                            "milliseconds",
                          ),
                          style: KTextStyle.listHeaderTimeTitle,
                        ),
                      ],
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
                            const Text('Group: ', style: KTextStyle.listExpandedTitle),
                            const Text('Comment: ', style: KTextStyle.listExpandedTitle),
                            const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
                            const Text('Added: ', style: KTextStyle.listExpandedTitle),
                            const Text('Modified: ', style: KTextStyle.listExpandedTitle),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                    editGroupFormModal(context, item);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(170),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteGroupModal(context, item);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(170),
                  ),
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Groups"),
          elevation: 0,
          leading: BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<GroupsBloc, GroupsState>(
                  listener: (context, state) {
                    if (state.status == GroupsStateStatus.failure) {
                      PiUtils.handleGeneralException(
                        context,
                        "An Error Occured",
                      );
                    } else if (state.itemToggleStatus ==
                        GroupsItemToggleStateStatus.failure) {
                      context.read<GroupsBloc>().add(ResetItemToggleError());
                      PiUtils.handleGeneralException(
                        context,
                        "An Error Occured",
                      );
                    } else if (state.itemStatus ==
                        GroupsItemStateStatus.success) {
                      GlobalSnackbar.info(context, state.message, "");
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
                      return const Center(
                        child: EmptyWidget(message: "No data"),
                      );
                    } else if (state.status == GroupsStateStatus.success) {
                      List<GroupModel> groupModels = state.groups;
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
                                              mainAxisExtent: KGridCardSizes.groups["height"]!.toDouble(),
                                              maxCrossAxisExtent: KGridCardSizes.groups["width"]!.toDouble(),
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
      ),
    );
  }
}
