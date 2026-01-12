import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';

class AddGroupModal extends StatefulWidget {
  const AddGroupModal({super.key});

  @override
  State<AddGroupModal> createState() => _AddGroupModalState();
}

class _AddGroupModalState extends State<AddGroupModal> {
  PiValidators piValidators = PiValidators();
  TextEditingController commentController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FocusNode commentFieldNode = FocusNode();
  final FocusNode groupFieldNode = FocusNode();

  @override
  void dispose() {
    commentController.dispose();
    groupController.dispose();
    commentFieldNode.dispose();
    groupFieldNode.dispose();
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
                          focusNode: groupFieldNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          focusNode: commentFieldNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: commentController,
                          maxLines: 2,
                          validator: (value) =>
                              piValidators.commentValidator(value),
                          decoration: InputDecoration(
                            labelText: "Comment",
                            suffixIcon: IconButton(
                              onPressed: () => commentController.clear(),
                              icon: Icon(Icons.clear),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    if (formKey.currentState!.validate()) {
                                      GroupModel groupModel = GroupModel(
                                        name: groupController.text,
                                        comment: commentController.text,

                                        /// New groups are always enabled
                                        enabled: true,
                                      );
                                      context.read<GroupsBloc>().add(
                                        AddGroupsItem(groupModel: groupModel),
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
