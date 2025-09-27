import 'package:bogoballers/core/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:get/get.dart';

class PlayerMainScreen extends StatelessWidget {
  const PlayerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlayerBottomNavigationController());
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: playerBottomNavigation(
        controller: controller,
        colors: colors,
      ),
    );
  }
}
