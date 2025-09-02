import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamScreen extends StatefulWidget
    implements BaseSearchResultScreen<TeamModelForSearchResult> {
  @override
  final List<Permission> permissions;
  @override
  final TeamModelForSearchResult result;

  const TeamScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.result.team_name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.result.team_logo_url.isNotEmpty)
              Center(
                child: SizedBox(
                  width: 200,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.radiusMd),
                        image: DecorationImage(
                          image: NetworkImage(widget.result.team_logo_url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (hasPermissions(
              widget.permissions,
              required: [Permission.joinTeam],
              mode: 'all',
            ))
              GFButton(
                onPressed: isProcessing ? null : _handleJoin,
                text: "Join",
                color: colors.color9,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleJoin() async {
    setState(() => isProcessing = true);
    try {
      final entity = await getEntityCredentialsFromStorage();

      final response = await PlayerTeamService.addPlayer(
        teamId: widget.result.team_id,
        playerId: entity.entityId,
        status: "Pending",
      );
      if (mounted) {
        showAppSnackbar(
          context,
          message: response.message,
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
      setState(() => isProcessing = false);
    }
  }
}
