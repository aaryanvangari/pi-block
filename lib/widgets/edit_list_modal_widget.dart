import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/blocs/lists/lists_bloc.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/models/lists_model.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/custom_multi_select_dropdown.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';

class EditListModal extends StatefulWidget {
  final ListsModel listsModel;

  const EditListModal({super.key, required this.listsModel});

  @override
  State<EditListModal> createState() => _EditListModalState();
}

class _EditListModalState extends State<EditListModal> {
  late final TextEditingController commentController;
  final FocusNode commentFieldNode = FocusNode();

  late String type;
  late bool enabled;

  final formKey = GlobalKey<FormState>();
  final PiValidators piValidators = PiValidators();

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController(text: widget.listsModel.comment);
    type = widget.listsModel.type;
    enabled = widget.listsModel.enabled;
    
    final groupsBloc = context.read<GroupsBloc>();

    // Reset previous modal’s selection
    // this is very important otherwise previous iteration editing groups appear here
    groupsBloc.add(ResetGroupsSelection());

    // Initialize selection for current edit
    final initialSelection = groupsBloc.state.groups
        .where((g) => widget.listsModel.groups.contains(g.id))
        .toList();

    groupsBloc.add(GroupsSelectionChanged(initialSelection));
  }

  @override
  void dispose() {
    commentController.dispose();
    commentFieldNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Builder(
                  builder: (ctx) {
                    return Column(
                      children: [
                        TextFormField(
                          focusNode: commentFieldNode,
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
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
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
                                  PiUtils.handleGeneralException(
                                    context,
                                    state.error,
                                  );
                                }
                              },
                              builder: (context, state) {
                                final isLoading =
                                    state.itemStatus ==
                                    ListsItemStateStatus.loading;
                                return FilledButton(
                                  onPressed: () {
                                    if (formKey.currentState!
                                        .validate()) {
                                      context.read<ListsBloc>().add(
                                        UpdateListsItem(
                                          listsModel: widget.listsModel,
                                          type: type,
                                          comment:
                                              commentController.text,
                                          enabled: enabled,
                                          groups: context
                                            .read<GroupsBloc>()
                                            .state
                                            .selectedGroups
                                            .map((g) => g.id)
                                            .toList(),
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
                                      : Text("Save"),
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
