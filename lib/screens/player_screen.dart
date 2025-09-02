import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/providers/team_provider.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/team_manager/team_manager_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class PlayerScreen extends ConsumerStatefulWidget
    implements BaseSearchResultScreen<PlayerModel> {
  @override
  final List<Permission> permissions;
  @override
  final PlayerModel result;
  const PlayerScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.result.full_name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.result.profile_image_url.isNotEmpty)
              Center(
                child: SizedBox(
                  width: 200,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.radiusMd),
                        image: DecorationImage(
                          image: NetworkImage(widget.result.profile_image_url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            if (hasPermissions(
              widget.permissions,
              required: [Permission.invitePlayer],
              mode: 'all',
            ))
              GFButton(
                onPressed: isProcessing ? null : _handleInvite,
                text: "Invite",
                color: colors.color9,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleInvite() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeamManagerTeamsScreen(selectMode: true),
      ),
    );

    if (result == null) return;

    setState(() => isProcessing = true);

    try {
      final response = await PlayerTeamService.addPlayer(
        teamId: result['teamId'],
        playerId: widget.result.player_id,
        status: "Invited",
        teamLogoUrl: result['teamLogoUrl'],
      );
      final _ = await ref.refresh(teamsProvider.future);
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
