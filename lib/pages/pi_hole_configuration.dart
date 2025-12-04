import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:pi_block/widgets/empty_card_widget.dart';
import 'package:pi_block/widgets/error_card_widget.dart';
import 'package:pi_block/components/pi_http_client.dart';
import 'package:pi_block/components/utils.dart';
import 'package:pi_block/data/constants.dart';

class PiholeConfigurationPage extends StatefulWidget {
  const PiholeConfigurationPage({super.key});

  @override
  State<PiholeConfigurationPage> createState() =>
      _PiholeConfigurationPageState();
}

class _PiholeConfigurationPageState extends State<PiholeConfigurationPage> {
  Future<Map<String, dynamic>> getPiholeConfiguration() async {
    try {
      PiHttpClient piHttpClient = PiHttpClient();
      var result = await piHttpClient.get(KUrls.config);
      PiUtils.handleAPIException(result, false);

      log(
        result.toString(),
        level: Level.FINE.value,
        name: "PiholeConfigurationPage.getPiholeConfiguration",
      );

      return result["config"];
    } catch (e) {
      if (!mounted) return {};
      PiUtils.handleGeneralException(context, e);
      rethrow;
    }
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
                FutureBuilder(
                  future: getPiholeConfiguration(),
                  builder: (context, AsyncSnapshot snapshot) {
                    Widget widget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      widget = Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      var configResult = snapshot.data;

                      widget = Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pi-Hole Config",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  // color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.78,
                                child: JsonView.map(
                                  configResult,
                                  theme: JsonViewTheme(
                                    // viewType: JsonViewType.collapsible,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surface,
                                    closeIcon: Icon(
                                      Icons.close,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    openIcon: Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    separator: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Icon(
                                        Icons.arrow_right_alt_outlined,
                                        size: 20,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      widget = ErrorCardWidget(
                        header: "Pi-Hole Config",
                        message: "Error loading data",
                      );
                    } else {
                      widget = EmptyCardWidget(
                        header: "Pi-Hole Config",
                        message: "No data",
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
