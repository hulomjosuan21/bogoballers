import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/helpers/formaters.dart';
import 'package:bogoballers/core/models/league.dart';
import 'package:bogoballers/core/services/league/league_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/team_manager/team_manager_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.fontSizeSm,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: Sizes.fontSizeSm),
          ),
        ),
      ],
    ),
  );
}

class LeagueScreen extends StatefulWidget
    implements BaseSearchResultScreen<LeagueModel> {
  @override
  final List<Permission> permissions;
  @override
  final LeagueModel result;

  const LeagueScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("League", maxLines: 1, overflow: TextOverflow.ellipsis),
        flexibleSpace: Container(color: colors.gray1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.result.banner_url.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(Sizes.spaceMd),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.radiusMd),
                      image: DecorationImage(
                        image: NetworkImage(widget.result.banner_url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.only(
                left: Sizes.spaceMd,
                right: Sizes.spaceMd,
                bottom: Sizes.spaceXs,
              ),
              child: Text(
                widget.result.league_title,
                maxLines: 2,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                left: Sizes.spaceMd,
                right: Sizes.spaceMd,
                bottom: Sizes.spaceMd,
              ),
              child: Text(
                widget.result.league_description,
                maxLines: 40,
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: Sizes.fontSizeSm),
                textAlign: TextAlign.justify,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceMd),
              child: const Text(
                "League Info",
                style: TextStyle(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Sizes.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow("📍 Address", widget.result.league_address),
                  infoRow(
                    "📅 Season Year",
                    widget.result.season_year.toString(),
                  ),
                  infoRow(
                    "📝 Registration Deadline",
                    Formater.formatDateTime(
                      widget.result.registration_deadline,
                    ),
                  ),
                  infoRow(
                    "🎉 Opening Date",
                    Formater.formatDateTime(widget.result.opening_date),
                  ),
                  infoRow("✅ Status", widget.result.status),
                  if (widget.result.league_schedule.isNotEmpty)
                    infoRow(
                      "📆 Schedule",
                      "From ${Formater.formatDate(widget.result.league_schedule.first)} to ${Formater.formatDate(widget.result.league_schedule.last)}",
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.spaceMd,
                vertical: Sizes.spaceSm,
              ),
              child: const Text(
                "Categories",
                style: TextStyle(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            if (widget.result.categories.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.result.categories.length,
                itemBuilder: (context, index) {
                  final category = widget.result.categories[index];
                  return _categorTile(category);
                },
              ),
            const SizedBox(height: Sizes.spaceLg),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _categorTile(LeagueCategory category) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(
              category.category_name,
              style: TextStyle(fontSize: Sizes.fontSizeMd),
            ),
          ),
          if (category.accept_teams) ...[
            const SizedBox(width: 8),
            _buildBadge('Open', Colors.green),
          ],
        ],
      ),
      trailing: const Icon(Icons.chevron_right, size: Sizes.fontSizeMd),
      onTap: () {
        if (category.accept_teams) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeagueCategoryScreen(
                leagueCategory: category,
                permissions: widget.permissions,
              ),
            ),
          );
        } else {
          showAppSnackbar(
            context,
            message: "Registration is not open",
            title: "Unavailable",
            variant: SnackbarVariant.error,
          );
        }
      },
    );
  }
}

class LeagueCategoryScreen extends StatefulWidget {
  final LeagueCategory leagueCategory;
  final List<Permission> permissions;
  const LeagueCategoryScreen({
    super.key,
    required this.leagueCategory,
    required this.permissions,
  });

  @override
  State<LeagueCategoryScreen> createState() => _LeagueCategoryScreenState();
}

class _LeagueCategoryScreenState extends State<LeagueCategoryScreen> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.leagueCategory.category_name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(color: colors.gray1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Sizes.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  infoRow("Gender", widget.leagueCategory.player_gender),
                ],
              ),
            ),

            if (hasPermissions(
              widget.permissions,
              required: [Permission.joinLeague, Permission.joinLeagueAsTeam],
              mode: 'all',
            ))
              GFButton(
                onPressed: isProcessing ? null : onPressed,
                text: "Join",
                color: colors.color9,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeamManagerTeamsScreen(selectMode: true),
      ),
    );

    if (result == null) return;
    if (!mounted) return;
    final paymentMethod = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Payment Method"),
          content: const Text("Do you want to pay online or on-site?"),
          actions: [
            GFButton(
              onPressed: () => Navigator.pop(context, "on-site"),
              text: "On-site",
              size: GFSize.SMALL,
              type: GFButtonType.outline,
              color: colors.color9,
            ),
            GFButton(
              onPressed: () => Navigator.pop(context, "online"),
              text: "Online",
              color: colors.color9,
              size: GFSize.SMALL,
            ),
          ],
        );
      },
    );

    if (paymentMethod == null) return;

    setState(() => isProcessing = true);

    Map<String, dynamic> data = {
      "team_id": result['teamId'],
      "league_id": widget.leagueCategory.league_id,
      "league_category_id": widget.leagueCategory.league_category_id,
      "amount_paid": widget.leagueCategory.team_entrance_fee_amount,
      "payment_method": paymentMethod,
    };

    try {
      final response = await LeagueService.registerTeam(data);
      final payload = response.data["payload"];

      if (payload != null && payload["checkout_url"] != null) {
        final checkoutUrl = payload["checkout_url"];
        await _openCheckout(checkoutUrl);
      } else {
        if (!mounted) return;
        showAppSnackbar(
          context,
          message: response.data["message"],
          title: "Success",
          variant: SnackbarVariant.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  Future<void> _openCheckout(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch $url");
    }
  }
}
