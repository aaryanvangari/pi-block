import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart'
    hide ResetItemToggleError;
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_multi_select_dropdown.dart';
import 'package:pi_block/widgets/custom_tag.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class DomainsPage extends StatelessWidget {
  const DomainsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              DomainsBloc(context.read<PiholeRepository>())..add(LoadDomains()),
        ),
        BlocProvider(
          create: (_) =>
              GroupsBloc(context.read<PiholeRepository>())..add(LoadGroups()),
        ),
      ],
      child: DomainsView(),
    );
  }
}

class DomainsView extends StatelessWidget {
  const DomainsView({super.key});

  void addDomainFormModal(BuildContext ctx) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    String type = "allow";
    String kind = "exact";
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController domainController = TextEditingController();
    List<int> selectedGroupIds = [0];
    final domainsBloc = ctx.read<DomainsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();
    final formKey = GlobalKey<FormState>();
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
                                  controller: domainController,
                                  maxLines: 1,
                                  validator: (value) =>
                                      piValidators.domainValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Domain",
                                    suffixIcon: IconButton(
                                      onPressed: () => domainController.clear(),
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
                                BlocBuilder<GroupsBloc, GroupsState>(
                                  builder: (context, state) {
                                    if (state.status ==
                                        GroupsStateStatus.success) {
                                      return CustomMultiSelectDropdown<
                                        GroupModel
                                      >(
                                        hintText: 'Select Groups',
                                        items: state.groups,
                                        selectedItems: state.selectedGroups,
                                        labelBuilder: (g) => g.name,
                                        validator: (list) => list.isEmpty
                                            ? 'Select at least one group'
                                            : null,
                                        onChanged: (groups) {
                                          context.read<GroupsBloc>().add(
                                            GroupsSelectionChanged(groups),
                                          );
                                          // Updating list of groupIds to set it up for
                                          // sending data to backend
                                          selectedGroupIds = state
                                              .selectedGroups
                                              .map((g) => g.id)
                                              .toList();
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 10,
                                  children: [
                                    CustomToggleSwitch(
                                      initialLabelIndex: kind == "regex"
                                          ? 0
                                          : 1,
                                      labels: ['Regex', 'Exact'],
                                      onToggle: (index) => kind = (index == 0)
                                          ? "regex"
                                          : "exact",
                                    ),
                                    CustomToggleSwitch(
                                      initialLabelIndex: type == "allow"
                                          ? 0
                                          : 1,
                                      labels: ['Allow', 'Deny'],
                                      onToggle: (index) => type = (index == 0)
                                          ? "allow"
                                          : "deny",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<DomainsBloc, DomainsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            DomainsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            DomainsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            DomainsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              DomainModel
                                              domainModel = DomainModel(
                                                domain: domainController.text,
                                                comment: commentController.text,
                                                type: type,
                                                kind: kind,
                                                groups: selectedGroupIds,
                                              );
                                              context.read<DomainsBloc>().add(
                                                AddDomainsItem(
                                                  domainModel: domainModel,
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
      domainController.dispose();
      pageIndexNotifier.dispose();
    });
  }

  void editDomainFormModal(BuildContext ctx, DomainModel domainModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    String type = domainModel.type;
    bool enabled = domainModel.enabled;
    List<int> groups = domainModel.groups;
    String comment = domainModel.comment;
    String kind = domainModel.kind;
    PiValidators piValidators = PiValidators();
    List<int> selectedGroupIds = groups;
    final domainsBloc = ctx.read<DomainsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();
    final formKey = GlobalKey<FormState>();
    final preSelectedGroupIds = groupsBloc.state.groups
        .where((group) => groups.contains(group.id))
        .toList();
    groupsBloc.add(GroupsSelectionChanged(preSelectedGroupIds));
    TextEditingController commentController = TextEditingController(
      text: comment,
    );

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
                                BlocBuilder<GroupsBloc, GroupsState>(
                                  builder: (context, state) {
                                    if (state.status ==
                                        GroupsStateStatus.success) {
                                      return CustomMultiSelectDropdown<
                                        GroupModel
                                      >(
                                        hintText: 'Select Groups',
                                        items: state.groups,
                                        selectedItems: state.selectedGroups,
                                        labelBuilder: (g) => g.name,
                                        validator: (list) => list.isEmpty
                                            ? 'Select at least one group'
                                            : null,
                                        onChanged: (groups) {
                                          context.read<GroupsBloc>().add(
                                            GroupsSelectionChanged(groups),
                                          );
                                          // Updating list of groupIds to set it up for
                                          // sending data to backend
                                          selectedGroupIds = state
                                              .selectedGroups
                                              .map((g) => g.id)
                                              .toList();
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
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
                                    CustomToggleSwitch(
                                      initialLabelIndex: kind == "regex"
                                          ? 0
                                          : 1,
                                      labels: ['Regex', 'Exact'],
                                      onToggle: (index) => kind = (index == 0)
                                          ? "regex"
                                          : "exact",
                                    ),
                                    CustomToggleSwitch(
                                      initialLabelIndex: type == "allow"
                                          ? 0
                                          : 1,
                                      labels: ['Allow', 'Deny'],
                                      onToggle: (index) => type = (index == 0)
                                          ? "allow"
                                          : "deny",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<DomainsBloc, DomainsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            DomainsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            DomainsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            DomainsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<DomainsBloc>().add(
                                                UpdateDomainsItem(
                                                  domainModel: domainModel,
                                                  type: type,
                                                  kind: kind,
                                                  comment:
                                                      commentController.text,
                                                  enabled: enabled,
                                                  groups: selectedGroupIds,
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
        const Text('Domain: ', style: KTextStyle.listExpandedTitle),
        const Text('Unicode: ', style: KTextStyle.listExpandedTitle),
        const Text('Comment: ', style: KTextStyle.listExpandedTitle),
        const Text('Groups: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Added: ', style: KTextStyle.listExpandedTitle),
        const Text('Modified: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
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
      ],
    );
  }

  Widget _domainRowCard(DomainModel item, BuildContext context) {
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
                            const Text(
                              'Domain: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Unicode: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Comment: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Groups: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Database ID: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Added: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                            const Text(
                              'Modified: ',
                              style: KTextStyle.listExpandedTitle,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.domain,
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              item.unicode,
                              style: KTextStyle.listExpandedValue,
                            ),
                            Text(
                              item.comment,
                              style: KTextStyle.listExpandedValue,
                            ),
                            BlocBuilder<GroupsBloc, GroupsState>(
                              builder: (context, state) {
                                if (state.status == GroupsStateStatus.success) {
                                  String groupsListString = state.groups
                                      .where(
                                        (group) =>
                                            (item.groups.contains(group.id)),
                                      )
                                      .map((group) => group.name)
                                      .join(' • ');
                                  return Text(groupsListString);
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            Text(
                              item.id.toString(),
                              style: KTextStyle.listExpandedValue,
                            ),
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
                    editDomainFormModal(context, item);
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
                    deleteDomainModal(context, item);
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
                      GlobalSnackbar.info(context, state.message, "");
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
                                    ? getDomains(domainModels)
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(10),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              mainAxisExtent: KGridCardSizes.domains["height"]!.toDouble(),
                                              maxCrossAxisExtent: KGridCardSizes.domains["width"]!.toDouble(),
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
