import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/blocs/lists/lists_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/widgets/simple_sheet.dart';

class ListsPage extends StatelessWidget {
  const ListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ListsBloc(context.read<PiholeRepository>())..add(LoadLists()),
      child: ListsView(),
    );
  }
}

class ListsView extends StatelessWidget {
  const ListsView({super.key});

  Widget _listRow(ListsModel item, BuildContext context) {
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
                            item.comment,
                            style: (item.type == "block")
                                ? listHeaderTitleBlock.value
                                : listHeaderTitleAllow.value,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            item.address,
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
                        context.read<ListsBloc>().add(
                          ListItemToggled(listsModel: item, isEnabled: value),
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
                          iconData: FontAwesomeIcons.listOl,
                          title: item.number.toString(),
                        ),
                        CustomTagWidget(
                          iconData: (item.status == 1)
                              ? FontAwesomeIcons.download
                              : FontAwesomeIcons.clockRotateLeft,
                          color: KColors.download,
                          title: (item.status == 1) ? "Downloaded" : "Upstream",
                        ),
                        CustomTagWidget(
                          iconData: (item.type == "block")
                              ? Icons.block
                              : FontAwesomeIcons.check,
                          color: (item.type == "block")
                              ? KColors.block
                              : KColors.allow,
                          title: (item.type == "block")
                              ? "Blocklist"
                              : "Allowlist",
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Icon(Icons.update, size: 16),
                        ),
                        Text(
                          PiUtils.getTimeAgo(item.date_updated, "milliseconds"),
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
        const Text('Comment: ', style: KTextStyle.listExpandedTitle),
        const Text('Address: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Number of entries: ', style: KTextStyle.listExpandedTitle),
        const Text(
          'Number of non-domains: ',
          style: KTextStyle.listExpandedTitle,
        ),
        const Text('Added to Pi-Hole: ', style: KTextStyle.listExpandedTitle),
        const Text(
          'Database last modified: ',
          style: KTextStyle.listExpandedTitle,
        ),
        const Text(
          'Content last updated on: ',
          style: KTextStyle.listExpandedTitle,
        ),
      ],
      contentValueItems: [
        Text(item.comment, style: KTextStyle.listExpandedValue),
        Text(item.address, style: KTextStyle.listExpandedValue),
        Text(item.id.toString(), style: KTextStyle.listExpandedValue),
        Text('${item.number}', style: KTextStyle.listExpandedValue),
        Text('${item.invalid_domains}', style: KTextStyle.listExpandedValue),
        Text(
          '${PiUtils.getTimeAgo(item.date_added, "milliseconds")} (${PiUtils.getDateFormatter(item.date_added.toDouble())})',
          style: KTextStyle.listExpandedValue,
        ),
        Text(
          '${PiUtils.getTimeAgo(item.date_modified, "milliseconds")} (${PiUtils.getDateFormatter(item.date_modified.toDouble())})',
          style: KTextStyle.listExpandedValue,
        ),
        Text(
          '${PiUtils.getTimeAgo(item.date_updated, "milliseconds")} (${PiUtils.getDateFormatter(item.date_updated.toDouble())})',
          style: KTextStyle.listExpandedValue,
        ),
      ],
    );
  }

  void _editListSheet(BuildContext ctx, ListsModel listsModel) {
    String type = listsModel.type;
    bool enabled = listsModel.enabled;
    List<int> groups = listsModel.groups;
    String comment = listsModel.comment;
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController(
      text: comment,
    );
    final listsBloc = ctx.read<ListsBloc>();
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      isDismissible: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: KBottomSheetStyle.shape,
      builder: (ctx) => BlocProvider.value(
        value: listsBloc,
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
                            controller: commentController,
                            maxLines: 3,
                            validator: (value) =>
                                piValidators.listsCommentValidator(value),
                            decoration: InputDecoration(
                              labelText: "Comment",
                              border: KInputStyle.inputBorder,
                              focusedBorder: KInputStyle.focusedBorder,
                              enabledBorder: KInputStyle.enabledBorder,
                              suffixIcon: IconButton(
                                onPressed: () => commentController.clear(),
                                icon: Icon(Icons.clear),
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
                                onToggle: (index) => enabled = index == 0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BlocConsumer<ListsBloc, ListsState>(
                                listener: (context, state) {
                                  if (state.itemStatus ==
                                      ListsItemStateStatus.success) {
                                    if (Navigator.canPop(ctx)) {
                                      Navigator.pop(ctx);
                                    }
                                  } else if (state.itemStatus ==
                                      ListsItemStateStatus.failure) {
                                    if (Navigator.canPop(ctx)) {
                                      Navigator.pop(ctx);
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading =
                                      state.itemStatus ==
                                      ListsItemStateStatus.loading;
                                  return FilledButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        listsBloc.add(
                                          UpdateListsItem(
                                            listsModel: listsModel,
                                            type: type,
                                            comment: commentController.text,
                                            enabled: enabled,
                                            groups: groups,
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: isLoading
                                        ? CircularLoaderInButton()
                                        : Text("Save"),
                                  );
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text("Cancel"),
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
    );
  }

  void _addListSheet(BuildContext ctx) {
    String type = "allow";
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    final listsBloc = ctx.read<ListsBloc>();
    final formKey = GlobalKey<FormState>();
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      isDismissible: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: KBottomSheetStyle.shape,
      builder: (ctx) => BlocProvider.value(
        value: listsBloc,
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
                            controller: addressController,
                            maxLines: 1,
                            validator: (value) =>
                                piValidators.listsAddressValidator(value),
                            decoration: InputDecoration(
                              labelText: "Address",
                              border: KInputStyle.inputBorder,
                              focusedBorder: KInputStyle.focusedBorder,
                              enabledBorder: KInputStyle.enabledBorder,
                              suffixIcon: IconButton(
                                onPressed: () => addressController.clear(),
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
                                piValidators.listsCommentValidator(value),
                            decoration: InputDecoration(
                              labelText: "Comment",
                              border: KInputStyle.inputBorder,
                              focusedBorder: KInputStyle.focusedBorder,
                              enabledBorder: KInputStyle.enabledBorder,
                              suffixIcon: IconButton(
                                onPressed: () => commentController.clear(),
                                icon: Icon(Icons.clear),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 16,
                            runSpacing: 10,
                            children: [
                              CustomToggleSwitch(
                                initialLabelIndex: type == "allow" ? 0 : 1,
                                labels: ['Allow', 'BLock'],
                                onToggle: (index) =>
                                    type = index == 0 ? "allow" : "block",
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BlocConsumer<ListsBloc, ListsState>(
                                listener: (context, state) {
                                  if (state.itemStatus ==
                                      ListsItemStateStatus.success) {
                                    if (Navigator.canPop(ctx)) {
                                      Navigator.pop(ctx);
                                    }
                                  } else if (state.itemStatus ==
                                      ListsItemStateStatus.failure) {
                                    if (Navigator.canPop(ctx)) {
                                      Navigator.pop(ctx);
                                    }
                                  }
                                },
                                builder: (context, state) {
                                  final isLoading =
                                      state.itemStatus ==
                                      ListsItemStateStatus.loading;
                                  return FilledButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ListsModel listsModel = ListsModel(
                                          type: type,
                                          comment: commentController.text,
                                          address: addressController.text,
                                        );
                                        context.read<ListsBloc>().add(
                                          AddListsItem(listsModel: listsModel),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: isLoading
                                        ? CircularLoaderInButton()
                                        : const Text("Save"),
                                  );
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Cancel"),
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
    );
  }

  Widget getLists(List<ListsModel> listsModels) {
    ListView listView = ListView.separated(
      itemCount: listsModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = listsModels[index];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  final listsBloc = context.read<ListsBloc>();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    elevation: 5,
                    context: context,
                    isDismissible: true,
                    showDragHandle: true,
                    shape: KBottomSheetStyle.shape,
                    builder: (ctx) => SimpleBottomSheet(
                      primaryTitle: "Delete",
                      cancelFunction: () => Navigator.pop(ctx),
                      primaryFunction: () => {
                        listsBloc.add(
                          DeleteListsItem(listsModel: selectedPageItem),
                        ),
                        Navigator.pop(ctx),
                      },
                      confirmationText: "Do you want to delete list?",
                    ),
                  );
                },
                autoClose: true,
                backgroundColor: slideError.value,
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
                  _editListSheet(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: slidePrimary.value,
                icon: Icons.edit,
              ),
            ],
          ),
          child: _listRow(selectedPageItem, context),
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return BlocConsumer<ListsBloc, ListsState>(
                      listener: (context, state) {
                        if (state.status == ListsStateStatus.failure) {
                          PiUtils.handleGeneralException(
                            context,
                            "An Error Occured",
                          );
                        } else if (state.itemStatus ==
                            ListsItemStateStatus.failure) {
                          PiUtils.handleGeneralException(
                            context,
                            "An Error Occured",
                          );
                        } else if (state.itemStatus ==
                            ListsItemStateStatus.success) {
                          GlobalSnackbar.info(context, state.message, "");
                        }
                      },
                      builder: (context, state) {
                        if (state.status == ListsStateStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state.status == ListsStateStatus.failure) {
                          return const CustomErrorWidget(
                            message: "Error loading data",
                          );
                        } else if (state.lists.isEmpty) {
                          return const Center(
                            child: EmptyWidget(message: "No data"),
                          );
                        } else if (state.status == ListsStateStatus.success) {
                          List<ListsModel> listsModels = state.lists;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subscribed Lists",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton.filled(
                                      onPressed: () {
                                        _addListSheet(context);
                                      },
                                      icon: Icon(Icons.add, size: 15),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: getLists(listsModels)),
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
      ),
    );
  }
}
