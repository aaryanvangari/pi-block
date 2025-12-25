import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/widgets/logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: KColors.welcomeScreenBackground,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoWidget(type: "welcome"),
                SizedBox(height: 20),
                Text(
                  "Manage your Pi-Hole server",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                SizedBox(height: 30),
                FilledButton(
                  onPressed: () {
                    context.go("/login");
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(size.width * 0.7, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                  ),
                  child: Text("Get Started"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
