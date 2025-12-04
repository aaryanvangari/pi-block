import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  final String type;
  const LogoWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "π",
          style: GoogleFonts.roboto(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: (type == "drawer") ? 70 : 120,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "Block",
          style: TextStyle(
            fontSize: (type == "drawer") ? 30 : 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
