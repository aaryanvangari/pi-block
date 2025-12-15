import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/data/notifiers.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';
import 'package:pi_block/widgets/simple_sheet.dart';

import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class DomainsPage extends StatefulWidget {
  const DomainsPage({super.key});

  @override
  State<DomainsPage> createState() => _DomainsPageState();
}

class _DomainsPageState extends State<DomainsPage> {
  PiHttpClient piHttpClient = PiHttpClient();

  @override
  void initState() {
    super.initState();
    context.read<DomainsBloc>().add(LoadDomains());
  }

  void _addDomainSheet(BuildContext ctx) {
    String type = "allow";
    String kind = "exact";
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController domainController = TextEditingController();
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
                          controller: domainController,
                          maxLines: 1,
                          validator: (value) =>
                              piValidators.domainsDomainValidator(value),
                          onChanged: (value) {
                            Form.of(ctx).validate();
                          },
                          decoration: InputDecoration(
                            labelText: "Domain",
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
                              onPressed: () => domainController.clear(),
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
                              initialLabelIndex: (kind == "regex") ? 0 : 1,
                              labels: ['Regex', 'Exact'],
                              onToggle: (index) => (index == 0)
                                  ? kind = "regex"
                                  : kind = "exact",
                            ),
                            CustomToggleSwitch(
                              initialLabelIndex: (type == "allow") ? 0 : 1,
                              labels: ['Allow', 'Deny'],
                              onToggle: (index) =>
                                  (index == 0) ? type = "allow" : type = "deny",
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
                                  DomainModel domainModel =
                                      DomainModel.fromJson(
                                        jsonDecode("{\"groups\":[0]}"),
                                      );
                                  DomainModel tempDomainModel = domainModel
                                      .copyWith(
                                        domain: domainController.text,
                                        comment: commentController.text,
                                        type: type,
                                        kind: kind,
                                      );
                                  context.read<DomainsBloc>().add(
                                    AddDomains(tempDomainModel),
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

  void _editDomainSheet(BuildContext ctx, DomainModel domainModel) {
    String type = domainModel.type;
    bool enabled = domainModel.enabled;
    List<int> groups = domainModel.groups;
    String comment = domainModel.comment;
    String kind = domainModel.kind;
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
                            CustomToggleSwitch(
                              initialLabelIndex: (kind == "regex") ? 0 : 1,
                              labels: ['Regex', 'Exact'],
                              onToggle: (index) => (index == 0)
                                  ? kind = "regex"
                                  : kind = "exact",
                            ),
                            CustomToggleSwitch(
                              initialLabelIndex: (type == "allow") ? 0 : 1,
                              labels: ['Allow', 'Deny'],
                              onToggle: (index) =>
                                  (index == 0) ? type = "allow" : type = "deny",
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
                                  DomainModel tempDomainModel = domainModel
                                      .copyWith(
                                        type: type,
                                        kind: kind,
                                        comment: commentController.text,
                                        enabled: enabled,
                                        groups: groups,
                                      );
                                  log(tempDomainModel.toString());
                                  context.read<DomainsBloc>().add(
                                    UpdateDomains(
                                      tempDomainModel,
                                      domainModel.type,
                                      domainModel.kind,
                                    ),
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

  Widget _domainRow(DomainModel item) {
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
                            item.domain,
                            style: (item.type == "deny")
                                ? listHeaderTitleBlock.value
                                : listHeaderTitleAllow.value,
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

                    BlocBuilder<DomainsBloc, DomainsState>(
                      builder: (context, state) {
                        if (state is DomainsLoaded) {
                          return FlutterSwitch(
                            height: 25.0,
                            width: 45.0,
                            padding: 4.0,
                            toggleSize: 15.0,
                            borderRadius: 20.0,
                            activeColor: Colors.green,
                            value: item.enabled,
                            onToggle: (value) {
                              final updatedDomainItem = item.copyWith(
                                enabled: value,
                              );
                              context.read<DomainsBloc>().add(
                                UpdateDomains(
                                  updatedDomainItem,
                                  item.type,
                                  item.kind,
                                ),
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
                    Row(
                      children: [
                        CustomTagWidget(
                          iconData: (item.type == "deny")
                              ? Icons.block
                              : FontAwesomeIcons.check,
                          color: (item.type == "deny")
                              ? Colors.red
                              : Colors.green,
                          title: (item.type == "deny") ? "Deny" : "Allow",
                        ),
                        CustomTagWidget(
                          iconData: (item.kind == "regex")
                              ? Symbols.regular_expression
                              : Symbols.match_word,
                          color: (item.type == "deny")
                              ? Colors.red
                              : Colors.green,
                          title: (item.kind == "regex") ? "Regex" : "Exact",
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
        Text('Domain: ', style: KTextStyle.listExpandedTitle),
        Text('Unicode: ', style: KTextStyle.listExpandedTitle),
        Text('Comment: ', style: KTextStyle.listExpandedTitle),
        Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        Text('Added: ', style: KTextStyle.listExpandedTitle),
        Text('Modified: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
        Text(item.domain, style: KTextStyle.listExpandedValue),
        Text(item.unicode, style: KTextStyle.listExpandedValue),
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
                        ctx.read<DomainsBloc>().add(
                          DeleteDomains(selectedPageItem),
                        ),
                        Navigator.pop(ctx),
                      },
                      confirmationText: "Do you want to delete domain?",
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
                  _editDomainSheet(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: slidePrimary.value,
                icon: Icons.edit,
              ),
            ],
          ),
          child: _domainRow(selectedPageItem),
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
                BlocConsumer<DomainsBloc, DomainsState>(
                  buildWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    if (state is DomainsError) {
                      PiUtils.handleGeneralException(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is DomainsItemOperationSuccess) {
                      GlobalSnackbar.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    Widget widget = SizedBox();
                    if (state is DomainsError) {
                      widget = CustomErrorWidget(message: "Error loading data");
                    } else if (state is DomainsLoading) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (state is DomainsOperationSuccess) {
                      context.read<DomainsBloc>().add(LoadDomains());
                      return SizedBox();
                    } else if (state is DomainsLoaded) {
                      List<DomainModel> domainModels = state.domains;
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
                                  "Domains",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    _addDomainSheet(context);
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
                            child: getDomains(domainModels),
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
