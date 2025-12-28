import 'package:flutter/material.dart';

class LocalDnsPage extends StatelessWidget {
  const LocalDnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Local DNS"),
          elevation: 0,
          leading: BackButton(),
        ),
        body: SingleChildScrollView(
          child: Column(children: [Text("Local DNS")]),
        ),
      ),
    );
  }
}
