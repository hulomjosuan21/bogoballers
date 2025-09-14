import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/info_tile.dart';
import 'package:flutter/material.dart';
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

            _buildInfoCard(
              context,
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

            _buildInfoCard(
              context,
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

// --- Reusable Helper Widgets ---

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

Widget _buildInfoCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  return Container(
    decoration: BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(Sizes.radiusMd),
      border: Border.all(color: colors.gray5, width: Sizes.borderWidthSm),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Sizes.spaceMd,
            Sizes.spaceMd,
            Sizes.spaceMd,
            Sizes.spaceSm,
          ),
          child: Row(
            children: [
              Icon(icon, size: Sizes.fontSizeLg, color: colors.textPrimary),
              const SizedBox(width: Sizes.spaceSm),
              Text(
                title,
                style: TextStyle(
                  fontSize: Sizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: Sizes.borderWidthSm,
          thickness: Sizes.borderWidthSm,
          color: colors.gray5,
        ),
        ...children,
      ],
    ),
  );
}
