import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pi_block/blocs/lists/lists_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';
import 'package:pi_block/widgets/simple_sheet.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key});

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ListsBloc>().add(LoadLists());
  }

  Widget _listRow(ListsModel item) {
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

                    BlocBuilder<ListsBloc, ListsState>(
                      builder: (context, state) {
                        if (state is ListsLoaded) {
                          return FlutterSwitch(
                            height: 25.0,
                            width: 45.0,
                            padding: 4.0,
                            toggleSize: 15.0,
                            borderRadius: 20.0,
                            activeColor: Colors.green,
                            value: item.enabled,
                            onToggle: (value) {
                              final updatedListItem = item.copyWith(
                                enabled: value,
                              );
                              context.read<ListsBloc>().add(
                                UpdateLists(updatedListItem),
                              );
                            },
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
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
                          color: Colors.green,
                          title: (item.status == 1) ? "Downloaded" : "Upstream",
                        ),
                        CustomTagWidget(
                          iconData: (item.type == "block")
                              ? Icons.block
                              : FontAwesomeIcons.check,
                          color: (item.type == "block")
                              ? Colors.red
                              : Colors.green,
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
        Text('Comment: ', style: KTextStyle.listExpandedTitle),
        Text('Address: ', style: KTextStyle.listExpandedTitle),
        Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        Text('Number of entries: ', style: KTextStyle.listExpandedTitle),
        Text('Number of non-domains: ', style: KTextStyle.listExpandedTitle),
        Text('Added to Pi-Hole: ', style: KTextStyle.listExpandedTitle),
        Text('Database last modified: ', style: KTextStyle.listExpandedTitle),
        Text('Content last updated on: ', style: KTextStyle.listExpandedTitle),
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
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      isDismissible: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: KBottomSheetStyle.shape,
      builder: (ctx) => SingleChildScrollView(
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
                child: Builder(
                  builder: (ctx) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: commentController,
                          maxLines: 3,
                          validator: (value) =>
                              piValidators.listsCommentValidator(value),
                          onChanged: (value) {
                            Form.of(ctx).validate();
                          },
                          decoration: InputDecoration(
                            labelText: "Comment",
                            border: KInputStyle.inputBorder,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => commentController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 16,
                          runSpacing: 10,
                          children: [
                            CustomToggleSwitch(
                              initialLabelIndex: (enabled) ? 0 : 1,
                              labels: ['Enabled', 'Disabled'],
                              onToggle: (index) => (index == 0)
                                  ? enabled = true
                                  : enabled = false,
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton(
                              onPressed: () {
                                if (Form.of(ctx).validate()) {
                                  ListsModel tempListsModel = listsModel
                                      .copyWith(
                                        type: type,
                                        comment: commentController.text,
                                        enabled: enabled,
                                        groups: groups,
                                      );
                                  log(tempListsModel.toString());
                                  context.read<ListsBloc>().add(
                                    UpdateLists(tempListsModel),
                                  );
                                  Navigator.pop(ctx);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text("Save"),
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
    );
  }

  void _addListSheet(BuildContext ctx) {
    String type = "allow";
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    showModalBottomSheet(
      isScrollControlled: true,
      elevation: 5,
      context: ctx,
      isDismissible: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: KBottomSheetStyle.shape,
      builder: (ctx) => SingleChildScrollView(
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
                child: Builder(
                  builder: (ctx) {
                    return Column(
                      children: [
                        TextFormField(
                          controller: addressController,
                          maxLines: 1,
                          validator: (value) =>
                              piValidators.listsAddressValidator(value),
                          onChanged: (value) {
                            Form.of(ctx).validate();
                          },
                          decoration: InputDecoration(
                            labelText: "Address",
                            border: KInputStyle.inputBorder,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => addressController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: commentController,
                          maxLines: 2,
                          validator: (value) =>
                              piValidators.listsCommentValidator(value),
                          onChanged: (value) {
                            Form.of(ctx).validate();
                          },
                          decoration: InputDecoration(
                            labelText: "Comment",
                            border: KInputStyle.inputBorder,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => commentController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 16,
                          runSpacing: 10,
                          children: [
                            CustomToggleSwitch(
                              initialLabelIndex: (type == "allow") ? 0 : 1,
                              labels: ['Allow', 'BLock'],
                              onToggle: (index) => (index == 0)
                                  ? type = "allow"
                                  : type = "block",
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton(
                              onPressed: () {
                                if (Form.of(ctx).validate()) {
                                  /// #TODO refactor
                                  ListsModel listsModel = ListsModel.fromJson(
                                    jsonDecode("{\"groups\":[0]}"),
                                  );
                                  ListsModel tempListsModel = listsModel
                                      .copyWith(
                                        address: addressController.text,
                                        comment: commentController.text,
                                        type: type,
                                      );
                                  context.read<ListsBloc>().add(
                                    AddLists(tempListsModel),
                                  );
                                  Navigator.pop(ctx);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text("Save"),
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
                  showModalBottomSheet(
                    isScrollControlled: true,
                    elevation: 5,
                    context: context,
                    isDismissible: true,
                    showDragHandle: true,
                    shape: KBottomSheetStyle.shape,
                    builder: (ctx) => SimpleBottomSheet(
                      primaryTitle: "Delete",
                      context: context,
                      cancelFunction: () => Navigator.pop(ctx),
                      primaryFunction: () => {
                        ctx.read<ListsBloc>().add(
                          DeleteLists(selectedPageItem),
                        ),
                        Navigator.pop(ctx),
                      },
                      confirmationText: "Do you want to delete list?",
                    ),
                  );
                },
                autoClose: true,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.error.withAlpha(200),
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
          child: _listRow(selectedPageItem),
        );
      },
      separatorBuilder: (context, index) {
        return KListStyle.listDivider;
      },
    );
    return listView;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BlocConsumer<ListsBloc, ListsState>(
                  buildWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    if (state is ListsError) {
                      PiUtils.handleGeneralException(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is ListsItemOperationSuccess) {
                      GlobalSnackbar.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    Widget widget = SizedBox();
                    if (state is ListsError) {
                      widget = CustomErrorWidget(message: "Error loading data");
                    } else if (state is ListsLoading) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (state is ListsOperationSuccess) {
                      context.read<ListsBloc>().add(LoadLists());
                      return SizedBox();
                    } else if (state is ListsLoaded) {
                      List<ListsModel> listsModels = state.lists;
                      widget = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: 10),
                          SizedBox(
                            height:
                                MediaQuery.sizeOf(context).height * 0.9 -
                                kToolbarHeight -
                                8 -
                                kBottomNavigationBarHeight,
                            width: MediaQuery.sizeOf(context).width * 0.99,
                            child: getLists(listsModels),
                          ),
                        ],
                      );
                    }
                    return widget;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
