import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/auth_navigator.dart';
import 'package:bogoballers/screens/player/player_register_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';

class ClientAuthScreen extends StatelessWidget {
  const ClientAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    Widget buildOption({
      required String text,
      required String imagePath,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Dark overlay
            Positioned(
              bottom: 10,
              left: 20,
              right: 20,
              child: GFButton(
                onPressed: onTap,
                text: text,
                fullWidthButton: true,
                size: GFSize.SMALL,
                color: colors.color9,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Select Role")),
      body: Column(
        children: [
          buildOption(
            text: "I’m a Player",
            imagePath: "assets/images/player_option_image.png",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerRegisterScreen()),
            ),
          ),
          buildOption(
            text: "I’m a Team Manager",
            imagePath: "assets/images/team_manager_option_image.png",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeamManagerRegisterScreen(),
              ),
            ),
          ),
          // Optional: Login text
          Padding(
            padding: EdgeInsets.all(Sizes.spaceSm),
            child: authNavigator(
              context,
              "Already have an account?",
              " Login",
              () => Navigator.pushReplacementNamed(context, '/auth/login'),
            ),
          ),
        ],
      ),
    );
  }
}
