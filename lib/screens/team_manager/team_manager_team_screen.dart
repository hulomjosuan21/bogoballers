import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:getwidget/components/button/gf_button.dart';

class TeamManagerTeamScreen extends StatefulWidget {
  final List<Permission> permissions;
  const TeamManagerTeamScreen({
    super.key,
    required this.permissions,
    required this.team,
  });
  final Team team;

  @override
  State<TeamManagerTeamScreen> createState() => _TeamManagerTeamScreenState();
}

class _TeamManagerTeamScreenState extends State<TeamManagerTeamScreen> {
  bool _isEditing = false;
  late final TextEditingController _teamNameController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _teamNameController = TextEditingController(text: widget.team.teamName);
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() {
    final Map<String, dynamic> changes = {};
    if (_teamNameController.text != widget.team.teamName) {
      changes['team_name'] = _teamNameController.text;
    }

    if (changes.isNotEmpty) {
      debugPrint("Saving changes: $changes");
    } else {
      debugPrint("No changes were made.");
    }

    setState(() => _isEditing = false);
  }

  Future<void> _handleJoin() async {
    setState(() => isProcessing = true);
    try {
      final entity = await getEntityCredentialsFromStorage();

      final response = await PlayerTeamService.addPlayer(
        teamId: widget.team.teamId,
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2, // For Pending & Invited
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(_isEditing ? "Edit Team" : "Team"),
          flexibleSpace: Container(color: colors.gray1),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit_team') {
                  setState(() => _isEditing = true);
                } else if (value == 'save_team') {
                  _handleSaveChanges();
                }
              },
              itemBuilder: (context) => [
                if (_isEditing)
                  const PopupMenuItem(
                    value: 'save_team',
                    child: Text('Save Changes'),
                  )
                else
                  const PopupMenuItem(
                    value: 'edit_team',
                    child: Text('Edit Team'),
                  ),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTeamHeader(colors, textTheme),
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
              const SizedBox(height: Sizes.spaceLg),
              _buildStatsRow(colors),
              const SizedBox(height: Sizes.spaceLg),
              _buildRosterList(colors),
              const SizedBox(height: Sizes.spaceLg),
              if (hasPermissions(
                widget.permissions,
                required: [Permission.viewNotRoster],
              ))
                _buildRequestTabs(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamHeader(AppThemeColors colors, TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.radiusMd),
            image: DecorationImage(
              image: NetworkImage(widget.team.teamLogoUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceMd),
        _isEditing
            ? TextField(
                controller: _teamNameController,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontSize: Sizes.fontSizeSm,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                ),
              )
            : Text(
                _teamNameController.text,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontSize: Sizes.fontSizeMd,
                ),
              ),
      ],
    );
  }

  Widget _buildStatsRow(AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.spaceMd),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(Sizes.radiusMd),
        border: Border.all(color: colors.gray5, width: Sizes.borderWidthSm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatCell(value: widget.team.totalWins.toString(), label: 'Wins'),
          SizedBox(
            height: 32,
            child: VerticalDivider(thickness: 1, color: colors.gray5),
          ),
          StatCell(value: widget.team.totalLosses.toString(), label: 'Losses'),
          SizedBox(
            height: 32,
            child: VerticalDivider(thickness: 1, color: colors.gray5),
          ),
          StatCell(value: widget.team.totalDraws.toString(), label: 'Draws'),
        ],
      ),
    );
  }

  Widget _buildRequestTabs(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          labelColor: colors.color9,
          unselectedLabelColor: colors.textSecondary,
          indicatorColor: colors.color9,
          dividerColor: colors.gray4,
          tabs: const [
            Tab(text: "Pending Requests"),
            Tab(text: "Invited Players"),
          ],
        ),
        SizedBox(
          height: 200,
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: widget.team.pendingPlayers.length,
                itemBuilder: (context, index) {
                  final player = widget.team.pendingPlayers[index];
                  return _PlayerListItem(
                    player: player,
                    permissions: widget.permissions,
                  );
                },
              ),
              ListView.builder(
                itemCount: widget.team.invitedPlayers.length,
                itemBuilder: (context, index) {
                  final player = widget.team.invitedPlayers[index];
                  return _PlayerListItem(
                    player: player,
                    permissions: widget.permissions,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRosterList(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Team Roster",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colors.textPrimary,
            fontSize: Sizes.fontSizeLg,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: Sizes.spaceSm),
        ListView.builder(
          itemCount: widget.team.acceptedPlayers.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final player = widget.team.acceptedPlayers[index];
            return _PlayerListItem(
              player: player,
              permissions: widget.permissions,
            );
          },
        ),
      ],
    );
  }
}

class _PlayerListItem extends StatelessWidget {
  final List<Permission> permissions;
  const _PlayerListItem({required this.player, required this.permissions});
  final PlayerTeam player;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Card(
      color: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.radiusMd),
        side: BorderSide(color: colors.gray4, width: Sizes.borderWidthSm),
      ),
      margin: const EdgeInsets.symmetric(vertical: Sizes.spaceXs),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(player.profileImageUrl),
          backgroundColor: colors.gray4,
        ),
        title: Text(
          player.fullName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        subtitle: Text(
          '#${player.jerseyNumber.toInt()} | ${player.jerseyName}',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: Sizes.fontSizeSm,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PlayerScreen(permissions: permissions, result: player),
            ),
          );
        },
      ),
    );
  }
}

class StatCell extends StatelessWidget {
  final String value;
  final String label;
  const StatCell({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: Sizes.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: Sizes.spaceXs),
        Text(
          label,
          style: TextStyle(
            fontSize: Sizes.fontSizeSm,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
