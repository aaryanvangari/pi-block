import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';

class EditGroupModal extends StatefulWidget {
  final GroupModel groupModel;

  const EditGroupModal({super.key, required this.groupModel});

  @override
  State<EditGroupModal> createState() => _EditGroupModalState();
}

class _EditGroupModalState extends State<EditGroupModal> {
  late final TextEditingController commentController;
  late final TextEditingController groupController;
  final FocusNode commentFieldNode = FocusNode();
  final FocusNode groupFieldNode = FocusNode();

  late String comment;
  late bool enabled;
  late String name;

  final formKey = GlobalKey<FormState>();
  final PiValidators piValidators = PiValidators();

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController(text: widget.groupModel.comment);
    groupController = TextEditingController(text: widget.groupModel.name);
    comment = widget.groupModel.comment;
    enabled = widget.groupModel.enabled;
    name = widget.groupModel.name;
  }

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
                              icon: const Icon(Icons.clear),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          focusNode: commentFieldNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: commentController,
                          maxLines: 3,
                          validator: (value) =>
                              piValidators.commentValidator(value),
                          decoration: InputDecoration(
                            labelText: "Comment",
                            suffixIcon: IconButton(
                              onPressed: () => commentController.clear(),
                              icon: const Icon(Icons.clear),
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
                              onToggle: (index) =>
                                  enabled = (index == 0) ? true : false,
                            ),
                          ],
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
                                      context.read<GroupsBloc>().add(
                                        UpdateGroupsItem(
                                          groupModel: widget.groupModel,
                                          comment: commentController.text,
                                          enabled: enabled,
                                          name: groupController.text,
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
