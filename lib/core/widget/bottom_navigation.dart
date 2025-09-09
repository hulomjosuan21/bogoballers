import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/screens/conversation_list_screen.dart';
import 'package:bogoballers/screens/player/player_home_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_home_screen.dart';
import 'package:bogoballers/screens/team_manager/team_manager_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NavigationDestinationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final Rx<int> selectedIndex;

  const NavigationDestinationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Obx(
      () => NavigationDestination(
        icon: Icon(
          icon,
          color: selectedIndex.value == index ? colors.color9 : null,
        ),
        label: label,
      ),
    );
  }
}

class PlayerBottomNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const PlayerHomeScreen(),
    const ConversationListScreen(),
    Center(child: Text("Profile")),
  ];
}

class TeamManagerNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const TeamManagerHomeScreen(),
    const TeamManagerTeamsScreen(),
    const ConversationListScreen(),
  ];
}

Obx playerBottomNavigation({
  required PlayerBottomNavigationController controller,
  required AppThemeColors colors,
}) {
  return Obx(
    () => NavigationBar(
      height: 68,
      backgroundColor: colors.gray1,
      indicatorColor: Colors.transparent,
      elevation: 0,
      selectedIndex: controller.selectedIndex.value,
      onDestinationSelected: (index) => controller.selectedIndex.value = index,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: colors.color9,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.fontSizeSm,
          );
        }
        return TextStyle(
          color: colors.gray11,
          fontWeight: FontWeight.w500,
          fontSize: Sizes.fontSizeSm,
        );
      }),
      destinations: [
        NavigationDestinationItem(
          icon: Iconsax.home,
          label: "Home",
          index: 0,
          selectedIndex: controller.selectedIndex,
        ),
        NavigationDestinationItem(
          icon: Iconsax.message,
          label: "Chats",
          index: 1,
          selectedIndex: controller.selectedIndex,
        ),
        NavigationDestinationItem(
          icon: Iconsax.user,
          label: "Me",
          index: 2,
          selectedIndex: controller.selectedIndex,
        ),
      ],
    ),
  );
}

Obx teamManagerBottomNavigation({
  required TeamManagerNavigationController controller,
  required AppThemeColors colors,
}) {
  return Obx(
    () => NavigationBar(
      height: 68,
      backgroundColor: colors.gray1,
      indicatorColor: Colors.transparent,
      elevation: 0,
      selectedIndex: controller.selectedIndex.value,
      onDestinationSelected: (index) => controller.selectedIndex.value = index,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: colors.color9,
            fontWeight: FontWeight.w500,
            fontSize: Sizes.fontSizeSm,
          );
        }
        return TextStyle(
          color: colors.gray11,
          fontWeight: FontWeight.w500,
          fontSize: Sizes.fontSizeSm,
        );
      }),
      destinations: [
        NavigationDestinationItem(
          icon: Iconsax.home,
          label: "Home",
          index: 0,
          selectedIndex: controller.selectedIndex,
        ),
        NavigationDestinationItem(
          icon: Iconsax.people,
          label: "Team",
          index: 1,
          selectedIndex: controller.selectedIndex,
        ),
        NavigationDestinationItem(
          icon: Iconsax.message,
          label: "Chats",
          index: 2,
          selectedIndex: controller.selectedIndex,
        ),
      ],
    ),
  );
}
