import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json/flutter_json.dart';
import 'package:pi_block/blocs/pihole_config/pihole_config_bloc.dart';
import 'package:pi_block/data/repository/pihole_repository.dart';
import 'package:pi_block/models/pihole_config_model.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

class PiholeConfigurationPage extends StatelessWidget {
  const PiholeConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PiholeConfigBloc(context.read<PiholeRepository>())
            ..add(PiholeConfigFetched()),
      child: _PiholeConfigurationView(),
    );
  }
}

class _PiholeConfigurationView extends StatefulWidget {
  const _PiholeConfigurationView();
  @override
  State<_PiholeConfigurationView> createState() =>
      _PiholeConfigurationViewState();
}

class _PiholeConfigurationViewState extends State<_PiholeConfigurationView> {
  final controller = JsonController();
  int _selectedIndex = 0;
  CodeLineEditingController? codeEditorController;

  @override
  void dispose() {
    codeEditorController?.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget jsonViewWidget(Map<String, dynamic> jsonData) {
    return JsonWidget(
      controller: controller,
      json: jsonData,
      initialExpandDepth: 1,
    );
  }

  Widget codeEditorViewWidget() {
    return CodeEditor(
      controller: codeEditorController,
      readOnly: true,
      indicatorBuilder:
          (context, editingController, chunkController, notifier) {
            return Row(
              children: [
                DefaultCodeLineNumber(
                  controller: editingController,
                  notifier: notifier,
                ),
                DefaultCodeChunkIndicator(
                  width: 20,
                  controller: chunkController,
                  notifier: notifier,
                ),
              ],
            );
          },
      style: CodeEditorStyle(
        codeTheme: CodeHighlightTheme(
          languages: {'json': CodeHighlightThemeMode(mode: langJson)},
          theme: PiUtils.getDarkMode(context)
              ? atomOneDarkTheme
              : atomOneLightTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pi-Hole Configuration"),
        elevation: 0,
        leading: BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<PiholeConfigBloc, PiholeConfigState>(
                  listener: (context, state) {
                    if (state is PiholeConfigFailure) {
                      PiUtils.handleGeneralException(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is PiholeConfigFailure) {
                      return const CustomErrorWidget(
                        message: "Error loading data",
                      );
                    }
                    if (state is PiholeConfigLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is PiholeConfigSuccess) {
                      PiholeConfigModel piholeConfigModel =
                          state.piholeConfigModel;
                      final jsonMap = piholeConfigModel.config.toJson();
                      codeEditorController ??=
                          CodeLineEditingController.fromText(
                            const JsonEncoder.withIndent(
                              '  ',
                            ).convert(piholeConfigModel),
                          );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SegmentedButton<int>(
                                segments: const [
                                  ButtonSegment(
                                    value: 0,
                                    label: Text('JSON Tree'),
                                    icon: Icon(Icons.data_object),
                                  ),
                                  ButtonSegment(
                                    value: 1,
                                    label: Text('Raw JSON'),
                                    icon: Icon(Icons.code),
                                  ),
                                ],
                                selected: {_selectedIndex},
                                onSelectionChanged: (value) {
                                  setState(() {
                                    _selectedIndex = value.first;
                                  });
                                },
                              ),
                              if (_selectedIndex == 0) ...[
                                IconButton(
                                  onPressed: () => controller.expandAllNodes(),
                                  icon: const Icon(Icons.expand_rounded),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.collapseAllNodes(),
                                  icon: const Icon(Icons.compress),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: IndexedStack(
                              index: _selectedIndex,
                              children: [
                                jsonViewWidget(jsonMap),
                                codeEditorViewWidget(),
                              ],
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
