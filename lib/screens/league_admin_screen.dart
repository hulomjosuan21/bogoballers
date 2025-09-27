import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/models/message.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/info_card.dart';
import 'package:bogoballers/core/widget/info_tile.dart';
import 'package:bogoballers/screens/chat_loader.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class LeagueAdministratorScreen extends StatelessWidget {
  final List<Permission> permissions;
  final LeagueAdministrator result;

  const LeagueAdministratorScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text("League Administrator"),
        flexibleSpace: Container(color: colors.gray1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAdminHeader(context, result),
            const SizedBox(height: Sizes.spaceLg),

            if (hasPermissions(permissions, required: [Permission.chat]))
              Row(
                children: [
                  GFButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatLoaderScreen(
                            partner: ConversationWith(
                              name: result.organizationName,
                              entityId: result.leagueAdministratorId,
                              imageUrl: result.organizationLogoUrl,
                              userId: result.account.userId,
                            ),
                          ),
                        ),
                      );
                    },
                    text: "Chat",
                    color: colors.color9,
                    size: GFSize.SMALL,
                  ),
                ],
              ),

            buildInfoCard(
              colors: colors,
              title: 'Organization Details',
              icon: Icons.business_outlined,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.category_outlined,
                  label: 'Type',
                  value: result.organizationType,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: result.organizationAddress,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.event_available_outlined,
                  label: 'Registered On',
                  value: DateFormat.yMMMMd().format(
                    DateTime.parse(result.leagueAdminCreatedAt),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),

            buildInfoCard(
              colors: colors,
              title: 'Administrator Contact',
              icon: Icons.person_pin_outlined,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: result.account.email,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.phone_outlined,
                  label: 'Contact',
                  value: result.account.contactNumber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildAdminHeader(BuildContext context, LeagueAdministrator admin) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  final textTheme = Theme.of(context).textTheme;
  return Column(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.radiusMd),
          image: DecorationImage(
            image: NetworkImage(admin.organizationLogoUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: colors.gray4, width: Sizes.borderWidthSm),
        ),
      ),
      const SizedBox(height: Sizes.spaceMd),
      Text(
        admin.organizationName,
        style: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}
