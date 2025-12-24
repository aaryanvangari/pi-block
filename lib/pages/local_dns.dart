import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LocalDnsPage extends StatelessWidget {
  const LocalDnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Local DNS"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/home");
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [Text("Local DNS")]),
        ),
      ),
    );
  }
}
