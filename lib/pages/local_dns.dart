import 'package:flutter/material.dart';

class LocalDnsPage extends StatelessWidget {
  const LocalDnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [Text("Local DNS")]),
      ),
    );
  }
}
