import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeamManagerMainScreen extends StatelessWidget {
  const TeamManagerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamManagerNavigationController());
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: teamManagerBottomNavigation(controller: controller,colors: colors),
    );
  }
}