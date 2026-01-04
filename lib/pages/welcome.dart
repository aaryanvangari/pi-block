import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/router/app_routes.dart';
import 'package:pi_block/theme/app_colors.dart';
import 'package:pi_block/widgets/logo.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.welcomeScreenBackground,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FractionallySizedBox(
                  widthFactor: isWide ? 0.35 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LogoWidget(type: "welcome"),
                      const SizedBox(height: 20),
                      Text(
                        "Manage your Pi-Hole server",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            context.pushNamed(AppRoutes.login);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              double.infinity,
                              50,
                            ),
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
