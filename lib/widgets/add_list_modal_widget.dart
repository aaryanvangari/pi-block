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

class AddListModal extends StatefulWidget {
  const AddListModal({super.key});

  @override
  State<AddListModal> createState() => _AddListModalState();
}

class _AddListModalState extends State<AddListModal> {

  String type = "allow";
  PiValidators piValidators = PiValidators();
  TextEditingController commentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FocusNode commentFieldNode = FocusNode();
  final FocusNode addressFieldNode = FocusNode();
  
  @override
  void dispose() {
    commentController.dispose();
    addressController.dispose();
    commentFieldNode.dispose();
    addressFieldNode.dispose();
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
                          focusNode: addressFieldNode,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          controller: addressController,
                          maxLines: 1,
                          validator: (value) =>
                              piValidators.addressValidator(value),
                          decoration: InputDecoration(
                            labelText: "Address",
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  addressController.clear(),
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
                        Wrap(
                          spacing: 16,
                          runSpacing: 10,
                          children: [
                            CustomToggleSwitch(
                              initialLabelIndex: type == "allow"
                                  ? 0
                                  : 1,
                              labels: ['Allow', 'BLock'],
                              onToggle: (index) =>
                                  type = index == 0 ? "allow" : "block",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                                      ListsModel
                                      listsModel = ListsModel(
                                        type: type,
                                        comment: commentController.text,
                                        address: addressController.text,
                                        groups: context
                                            .read<GroupsBloc>()
                                            .state
                                            .selectedGroups
                                            .map((g) => g.id)
                                            .toList(),
                                      );
                                      context.read<ListsBloc>().add(
                                        AddListsItem(
                                          listsModel: listsModel,
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
