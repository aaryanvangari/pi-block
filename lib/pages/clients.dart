import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pi_block/blocs/clients/clients_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart'
    hide ResetItemToggleError;
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/constants/constants.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/theme/app_styles.dart';
import 'package:pi_block/theme/app_ui_context.dart';
import 'package:pi_block/widgets/add_client_modal_widget.dart';
import 'package:pi_block/widgets/confirm_action_bottom_sheet.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/widgets/custom_expansion_tile_widget.dart';
import 'package:pi_block/widgets/edit_client_modal_widget.dart';
import 'package:pi_block/widgets/empty_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/widgets/time_ago_widget.dart';
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
    final clientsBloc = ctx.read<ClientsBloc>();
    final groupsBloc = ctx.read<GroupsBloc>();
    groupsBloc.add(ResetGroupsSelection());
    clientsBloc.add(LoadClientsSuggestions());

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
              child: AddClientModal(),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
      pageIndexNotifier.dispose();
    });
  }

  void editClientFormModal(BuildContext ctx, ClientModel clientModel) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    final clientsBloc = ctx.read<ClientsBloc>();
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
              "Edit Client",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ClientsBloc>.value(value: clientsBloc),
                BlocProvider<GroupsBloc>.value(value: groupsBloc),
              ],
              child: EditClientModal(clientModel: clientModel),
            ),
          ),
        ];
      },
      modalTypeBuilder: (ctx) => PiUtils.getModalTypeBuilder(ctx),
    ).whenComplete(() {
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

  List<Widget> getEntityDetails(ClientModel item, String entityDetailType) {
    List<Text> entityTitles = const [
      Text('Client: ', style: KTextStyle.listExpandedTitle),
      Text('Comment: ', style: KTextStyle.listExpandedTitle),
      Text('Groups: ', style: KTextStyle.listExpandedTitle),
      Text('Database ID: ', style: KTextStyle.listExpandedTitle),
      Text('Added: ', style: KTextStyle.listExpandedTitle),
      Text('Modified: ', style: KTextStyle.listExpandedTitle),
    ];

    List<Widget> entityValues = [
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
    ];
    if (entityDetailType == "titles") {
      return entityTitles;
    } else if (entityDetailType == "values") {
      return entityValues;
    } else {
      return [];
    }
  }

  Widget _clientRowCard(ClientModel item, BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: KCardStyle.cardPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    editClientFormModal(context, item);
                  },
                  tooltip: "Edit",
                  icon: Icon(Icons.edit, color: context.ui.editIconColor),
                ),
                IconButton(
                  onPressed: () {
                    deleteClientModal(context, item);
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ClientsBloc, ClientsState>(
                listener: (context, state) {
                  if (state.status == ClientsStateStatus.failure) {
                    PiUtils.handleGeneralException(context, "An Error Occured");
                  } else if (state.itemStatus ==
                      ClientsItemStateStatus.success) {
                    GlobalBanner.info(context, state.message, "");
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
                    return const Center(child: EmptyWidget(message: "No data"));
                  } else if (state.status == ClientsStateStatus.success) {
                    List<ClientModel> clientModels = state.clients;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                            mainAxisExtent: KGridCardSizes
                                                .clients["height"]!
                                                .toDouble(),
                                            maxCrossAxisExtent: KGridCardSizes
                                                .clients["width"]!
                                                .toDouble(),
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
    );
  }
}
