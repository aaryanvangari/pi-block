import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/widgets/gradient_background.dart';
import 'package:pi_block/provider/auth_provider.dart';
import 'package:pi_block/widgets/logo.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadAuthInfo();
    if (!mounted) return;
    if (auth.isAuthenticated) {
      context.go("/home");
    } else if (auth.sid != null && !auth.isAuthenticated) {
      GlobalSnackbar.error(context, "Session Expired", "");
      context.go("/");
    }
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
                  _buildCirle(size.width * 1.2, Colors.white.withAlpha(10), 0),
                  _buildCirle(size.width * 0.9, Colors.white.withAlpha(15), 0),
                  _buildCirle(size.width * 0.6, Colors.white.withAlpha(20), 0),
                  _buildCirle(size.width * 0.3, Colors.white.withAlpha(30), 0),
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
                    child: Text(
                      "Get Started",
                    ),
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
