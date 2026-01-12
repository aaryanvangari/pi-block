import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/domains/domains_bloc.dart';
import 'package:pi_block/blocs/groups/groups_bloc.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/models/domain_model.dart';
import 'package:pi_block/models/groups_model.dart';
import 'package:pi_block/widgets/cancel_button.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/custom_multi_select_dropdown.dart';
import 'package:pi_block/widgets/custom_toggle_switch.dart';

class AddDomainModal extends StatefulWidget {
  const AddDomainModal({super.key});

  @override
  State<AddDomainModal> createState() => _AddDomainModalState();
}

class _AddDomainModalState extends State<AddDomainModal> {
  TextEditingController commentController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FocusNode commentFieldNode = FocusNode();
  final FocusNode domainFieldNode = FocusNode();
  String type = "allow";
  String kind = "exact";
  final PiValidators piValidators = PiValidators();

  @override
  void dispose() {
    commentController.dispose();
    domainController.dispose();
    commentFieldNode.dispose();
    domainFieldNode.dispose();
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
            children: [
              Form(
                key: formKey,
                child: Builder(
                  builder: (ctx) {
                    return Column(
                      children: [
                        TextFormField(
                          focusNode: domainFieldNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        BlocBuilder<GroupsBloc, GroupsState>(
                          builder: (context, state) {
                            if (state.status == GroupsStateStatus.success) {
                              return CustomMultiSelectDropdown<GroupModel>(
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
                              initialLabelIndex: kind == "regex" ? 0 : 1,
                              labels: ['Regex', 'Exact'],
                              onToggle: (index) =>
                                  kind = (index == 0) ? "regex" : "exact",
                            ),
                            CustomToggleSwitch(
                              initialLabelIndex: type == "allow" ? 0 : 1,
                              labels: ['Allow', 'Deny'],
                              onToggle: (index) =>
                                  type = (index == 0) ? "allow" : "deny",
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    if (formKey.currentState!.validate()) {
                                      DomainModel domainModel = DomainModel(
                                        domain: domainController.text,
                                        comment: commentController.text,
                                        type: type,
                                        kind: kind,
                                        groups: context
                                            .read<GroupsBloc>()
                                            .state
                                            .selectedGroups
                                            .map((g) => g.id)
                                            .toList(),
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
