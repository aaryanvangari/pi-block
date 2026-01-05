import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/clients/clients_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/client_model.dart';
import 'package:pi_block/models/clients_suggestion_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/custom_multi_select_dropdown.dart';

class AddClientModal extends StatefulWidget {
  const AddClientModal({super.key});

  @override
  State<AddClientModal> createState() => _AddClientModalState();
}

class _AddClientModalState extends State<AddClientModal> {
  TextEditingController commentController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode commentFieldNode = FocusNode();
  final FocusNode clientFieldNode = FocusNode();
  final PiValidators piValidators = PiValidators();

  @override
  void dispose() {
    commentController.dispose();
    clientController.dispose();
    commentFieldNode.dispose();
    clientFieldNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
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
                          focusNode: clientFieldNode,
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
                          focusNode: commentFieldNode,
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
                                        groups: context
                                            .read<GroupsBloc>()
                                            .state
                                            .selectedGroups
                                            .map((g) => g.id)
                                            .toList(),
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
    );
  }
}
