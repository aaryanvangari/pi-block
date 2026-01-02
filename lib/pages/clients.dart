import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pi_block/blocs/clients/clients_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart'
    hide ResetItemToggleError;
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/models/clients_suggestion_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/custom_multi_select_dropdown.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ClientsBloc(context.read<PiholeRepository>())..add(LoadClients()),
        ),
        BlocProvider(
          create: (_) =>
              GroupsBloc(context.read<PiholeRepository>())..add(LoadGroups()),
        ),
      ],
      child: ClientsView(),
    );
  }
}

class ClientsView extends StatelessWidget {
  const ClientsView({super.key});

  void addClientFormModal(BuildContext ctx) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    PiValidators piValidators = PiValidators();

    TextEditingController commentController = TextEditingController();
    TextEditingController clientController = TextEditingController();
    List<int> selectedGroupIds = [0];
    final clientsBloc = ctx.read<ClientsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();
    final formKey = GlobalKey<FormState>();
    groupsBloc.add(ResetGroupsSelection());
    clientsBloc.add(LoadClientsSuggestions());

    final theme = Theme.of(ctx);
    final colorScheme = theme.colorScheme;

    WoltModalSheet.show(
      context: ctx,
      pageIndexNotifier: pageIndexNotifier,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            navBarHeight: 40,
            resizeToAvoidBottomInset: true,
            pageTitle: Text(
              "Add Client",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ClientsBloc>.value(value: clientsBloc),
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
                                BlocBuilder<ClientsBloc, ClientsState>(
                                  builder: (context, state) {
                                    if (state.suggestionStatus ==
                                        ClientsSuggestionsStateStatus.success) {
                                      return CustomDropdown<
                                        ClientSuggestionModel
                                      >.search(
                                        items: state.suggestions,
                                        hintText: 'Suggested Clients',
                                        overlayHeight: 400,
                                        decoration: CustomDropdownDecoration(
                                          searchFieldDecoration:
                                              SearchFieldDecoration(
                                                fillColor: colorScheme.surface,
                                              ),
                                          expandedFillColor:
                                              colorScheme.surface,
                                          closedFillColor: Colors.transparent,
                                          closedBorder: BoxBorder.all(
                                            color: Colors.transparent,
                                          ),
                                          closedErrorBorder: BoxBorder.all(
                                            color: Colors.transparent,
                                          ),
                                          errorStyle: TextStyle(
                                            color: colorScheme.error,
                                          ),
                                          listItemDecoration:
                                              ListItemDecoration(
                                                selectedColor: colorScheme
                                                    .secondaryContainer,
                                                highlightColor: colorScheme
                                                    .onSecondaryContainer,
                                              ),
                                          hintStyle: theme.textTheme.bodyLarge,
                                        ),

                                        onChanged: (client) {
                                          if (client == null) return;

                                          // parse data of format 'hostname (ip)' or 'macaddress'
                                          final text = client.toString();
                                          clientController.text =
                                              RegExp(
                                                r'\(([^)]+)\)',
                                              ).firstMatch(text)?.group(1) ??
                                              text;

                                          // Move cursor to end
                                          clientController.selection =
                                              TextSelection.fromPosition(
                                                TextPosition(
                                                  offset: clientController
                                                      .text
                                                      .length,
                                                ),
                                              );
                                        },
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),

                                const SizedBox(height: 10),

                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: clientController,
                                  maxLines: 1,
                                  validator: (value) =>
                                      piValidators.clientValidator(value),
                                  decoration: InputDecoration(
                                    labelText: "Client",
                                    suffixIcon: IconButton(
                                      onPressed: () => clientController.clear(),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<ClientsBloc, ClientsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            ClientsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            ClientsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            ClientsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              ClientModel
                                              clientModel = ClientModel(
                                                client: clientController.text,
                                                comment: commentController.text,
                                                groups: selectedGroupIds,
                                              );
                                              context.read<ClientsBloc>().add(
                                                AddClientsItem(
                                                  clientModel: clientModel,
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
      clientController.dispose();
      pageIndexNotifier.dispose();
    });
  }

  void editClientFormModal(BuildContext ctx, ClientModel clientModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    List<int> groups = clientModel.groups;
    String comment = clientModel.comment;
    PiValidators piValidators = PiValidators();
    List<int> selectedGroupIds = groups;
    final clientsBloc = ctx.read<ClientsBloc>();
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
              "Edit Client",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ClientsBloc>.value(value: clientsBloc),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BlocConsumer<ClientsBloc, ClientsState>(
                                      listener: (context, state) {
                                        if (state.itemStatus ==
                                            ClientsItemStateStatus.success) {
                                          if (Navigator.canPop(ctx)) {
                                            Navigator.pop(ctx);
                                          }
                                        } else if (state.itemStatus ==
                                            ClientsItemStateStatus.failure) {
                                          PiUtils.handleGeneralException(
                                            context,
                                            state.error,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        final isLoading =
                                            state.itemStatus ==
                                            ClientsItemStateStatus.loading;
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<ClientsBloc>().add(
                                                UpdateClientsItem(
                                                  clientModel: clientModel,
                                                  comment:
                                                      commentController.text,
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

  void deleteClientModal(BuildContext context, ClientModel clientModel) {
    final clientsBloc = context.read<ClientsBloc>();

    ConfirmActionBottomSheet.show<ClientsBloc, ClientsState>(
      context: context,
      sheet: ConfirmActionBottomSheet<ClientsBloc, ClientsState>(
        bloc: clientsBloc,
        title: 'Delete Client',
        confirmationText: 'Do you want to delete client?',
        confirmButtonText: 'Delete',
        onConfirm: () {
          clientsBloc.add(DeleteClientsItem(clientModel: clientModel));
        },
        isSuccess: (state) =>
            state.itemStatus == ClientsItemStateStatus.success,
        isFailure: (state) =>
            state.itemStatus == ClientsItemStateStatus.failure,
        onFailure: (context, state) {
          PiUtils.handleGeneralException(context, state.error);
        },
      ),
    );
  }

  Widget _clientRow(ClientModel item, BuildContext context) {
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
                            style: KTextStyle.listHeaderTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            item.client,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
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
        const Text('Client: ', style: KTextStyle.listExpandedTitle),
        const Text('Comment: ', style: KTextStyle.listExpandedTitle),
        const Text('Groups: ', style: KTextStyle.listExpandedTitle),
        const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
        const Text('Added: ', style: KTextStyle.listExpandedTitle),
        const Text('Modified: ', style: KTextStyle.listExpandedTitle),
      ],
      contentValueItems: [
        Text(item.client, style: KTextStyle.listExpandedValue),
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

  Widget _clientRowCard(ClientModel item, BuildContext context) {
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
                            item.comment,
                            style: KTextStyle.listHeaderTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            item.client,
                            style: KTextStyle.listHeaderSubTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
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
                            const Text('Client: ', style: KTextStyle.listExpandedTitle),
                            const Text('Comment: ', style: KTextStyle.listExpandedTitle),
                            const Text('Groups: ', style: KTextStyle.listExpandedTitle),
                            const Text('Database ID: ', style: KTextStyle.listExpandedTitle),
                            const Text('Added: ', style: KTextStyle.listExpandedTitle),
                            const Text('Modified: ', style: KTextStyle.listExpandedTitle),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.client, style: KTextStyle.listExpandedValue),
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
                    editClientFormModal(context, item);
                  },
                  tooltip: "Edit",
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(170),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteClientModal(context, item);
                  },
                  tooltip: "Delete",
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

  Widget getClients(List<ClientModel> clientModels) {
    ListView listView = ListView.separated(
      itemCount: clientModels.length,
      itemBuilder: (context, index) {
        var selectedPageItem = clientModels[index];
        return Slidable(
          key: Key(selectedPageItem.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.2,
            children: [
              SlidableAction(
                onPressed: (context) {
                  deleteClientModal(context, selectedPageItem);
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
                  editClientFormModal(context, selectedPageItem);
                },
                autoClose: true,
                backgroundColor: context.ui.slidePrimary,
                icon: Icons.edit,
              ),
            ],
          ),
          child: _clientRow(selectedPageItem, context),
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
          title: const Text("Clients"),
          elevation: 0,
          leading: BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ClientsBloc, ClientsState>(
                  listener: (context, state) {
                    if (state.status == ClientsStateStatus.failure) {
                      PiUtils.handleGeneralException(
                        context,
                        "An Error Occured",
                      );
                    } else if (state.itemStatus ==
                        ClientsItemStateStatus.success) {
                      GlobalSnackbar.info(context, state.message, "");
                    }
                  },
                  builder: (context, state) {
                    if (state.status == ClientsStateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.status == ClientsStateStatus.failure) {
                      return const CustomErrorWidget(
                        message: "Error loading data",
                      );
                    } else if (state.clients.isEmpty) {
                      return const Center(
                        child: EmptyWidget(message: "No data"),
                      );
                    } else if (state.status == ClientsStateStatus.success) {
                      List<ClientModel> clientModels = state.clients;
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
                                  "Clients",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton.filled(
                                  onPressed: () {
                                    addClientFormModal(context);
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
                                    ? getClients(clientModels)
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(10),
                                        gridDelegate:
                                            SliverGridDelegateWithMaxCrossAxisExtent(
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              mainAxisExtent: KGridCardSizes.clients["height"]!.toDouble(),
                                              maxCrossAxisExtent: KGridCardSizes.clients["width"]!.toDouble(),
                                            ),
                                        itemCount: clientModels.length,
                                        itemBuilder: (context, index) {
                                          return _clientRowCard(
                                            clientModels[index],
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
