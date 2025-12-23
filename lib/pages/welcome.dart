import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/widgets/gradient_background.dart';
import 'package:pi_block/widgets/logo.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _buildCirle(double diameter, Color color, int index) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index < 2 ? color : Colors.transparent,
        border: index >= 2 ? Border.all(color: color, width: 1) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size.height * 0.15,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildCirle(size.width * 1.2, KColors.welcomeCircle1, 0),
                  _buildCirle(size.width * 0.9, KColors.welcomeCircle2, 0),
                  _buildCirle(size.width * 0.6, KColors.welcomeCircle3, 0),
                  _buildCirle(size.width * 0.3, KColors.welcomeCircle4, 0),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(type: "welcome"),
                  SizedBox(height: 20),
                  Text(
                    "Manage your Pi-Hole server",
                    style: TextStyle(fontWeight: FontWeight.w600),
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
                    ),
                    child: Text("Get Started"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
