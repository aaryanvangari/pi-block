import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_json/flutter_json.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/pihole_config/pihole_config_bloc.dart';
import 'package:pi_block/models/pihole_config_model.dart';
import 'package:pi_block/widgets/custom_error_widget.dart';
import 'package:pi_block/components/utils.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';
import 'package:re_highlight/styles/atom-one-light.dart';

class PiholeConfigurationPage extends StatefulWidget {
  const PiholeConfigurationPage({super.key});

  @override
  State<PiholeConfigurationPage> createState() =>
      _PiholeConfigurationPageState();
}

class _PiholeConfigurationPageState extends State<PiholeConfigurationPage> {
  @override
  void initState() {
    super.initState();
    context.read<PiholeConfigBloc>().add(PiholeConfigFetched());
  }

  final controller = JsonController();
  int _selectedIndex = 0;
  late CodeLineEditingController codeEditorController;

  @override
  void dispose() {
    codeEditorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pi-Hole Configuration"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/home");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                BlocConsumer<PiholeConfigBloc, PiholeConfigState>(
                  listener: (context, state) {
                    if (state is PiholeConfigFailure) {
                      PiUtils.handleGeneralException(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    Widget widget = SizedBox();
                    if (state is PiholeConfigFailure) {
                      widget = CustomErrorWidget(message: "Error loading data");
                    }
                    if (state is PiholeConfigLoading) {
                      widget = Center(child: CircularProgressIndicator());
                    }

                    if (state is PiholeConfigSuccess) {
                      PiholeConfigModel piholeConfigModel =
                          state.piholeConfigModel;
                      codeEditorController = CodeLineEditingController.fromText(
                        const JsonEncoder.withIndent(
                          '  ',
                        ).convert(piholeConfigModel),
                      );
                      widget = Column(
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
                          SizedBox(height: 10),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.78,
                            child: IndexedStack(
                              index: _selectedIndex,
                              children: [
                                JsonWidget(
                                  controller: controller,
                                  json: piholeConfigModel.config.toJson(),
                                  initialExpandDepth: 1,
                                ),
                                CodeEditor(
                                  controller: codeEditorController,
                                  readOnly: true,
                                  indicatorBuilder:
                                      (
                                        context,
                                        editingController,
                                        chunkController,
                                        notifier,
                                      ) {
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
                                      languages: {
                                        'json': CodeHighlightThemeMode(
                                          mode: langJson,
                                        ),
                                      },
                                      theme:
                                          MediaQuery.of(
                                                context,
                                              ).platformBrightness ==
                                              Brightness.dark
                                          ? atomOneDarkTheme
                                          : atomOneLightTheme,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return widget;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
