import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/message.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/providers/team_provider.dart';
import 'package:bogoballers/core/services/player/player_team_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/info_card.dart';
import 'package:bogoballers/core/widget/info_tile.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/chat_loader.dart';
import 'package:bogoballers/screens/team_manager/team_manager_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/getwidget.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

String formatRfcDate(String rfcDateString) {
  if (rfcDateString.isEmpty) return 'N/A';
  try {
    final inputFormat = DateFormat("E, d MMM yyyy HH:mm:ss 'GMT'");
    final dateTime = inputFormat.parse(rfcDateString, true);
    return DateFormat.yMMMMd().format(dateTime);
  } catch (e) {
    return rfcDateString;
  }
}

class PlayerScreen extends ConsumerStatefulWidget {
  final List<Permission> permissions;
  final Player result;

  const PlayerScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  bool _isEditing = false;
  bool isProcessing = false;

  late final TextEditingController _fullNameController;
  late final TextEditingController _jerseyNameController;
  late final TextEditingController _jerseyNumberController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _positionsController;

  @override
  void initState() {
    super.initState();
    final player = widget.result;
    _fullNameController = TextEditingController(text: player.fullName);
    _jerseyNameController = TextEditingController(text: player.jerseyName);
    _jerseyNumberController = TextEditingController(
      text: player.jerseyNumber.toInt().toString(),
    );
    _heightController = TextEditingController(text: player.heightIn.toString());
    _weightController = TextEditingController(text: player.weightKg.toString());
    _positionsController = TextEditingController(
      text: player.position.join(', '),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _jerseyNameController.dispose();
    _jerseyNumberController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _positionsController.dispose();
    super.dispose();
  }

  void _handleSaveChanges() {
    final Map<String, dynamic> changes = {};
    final originalPlayer = widget.result;

    if (_fullNameController.text != originalPlayer.fullName) {
      changes['full_name'] = _fullNameController.text;
    }

    if (_jerseyNameController.text != originalPlayer.jerseyName) {
      changes['jersey_name'] = _jerseyNameController.text;
    }

    if (_jerseyNumberController.text !=
        originalPlayer.jerseyNumber.toInt().toString()) {
      changes['jersey_number'] = _jerseyNumberController.text;
    }

    if (_heightController.text != originalPlayer.heightIn.toString()) {
      changes['height_in'] = _heightController.text;
    }

    if (_weightController.text != originalPlayer.weightKg.toString()) {
      changes['weight_kg'] = _weightController.text;
    }

    if (_positionsController.text != originalPlayer.position.join(', ')) {
      changes['positions'] = _positionsController.text
          .split(',')
          .map((p) => p.trim())
          .toList();
    }

    if (changes.isNotEmpty) {
      debugPrint("Saving changes: $changes");

      showAppSnackbar(
        context,
        message: "Player data updated locally.",
        title: "Success",
        variant: SnackbarVariant.success,
      );
    } else {
      debugPrint("No changes were made.");
    }

    setState(() => _isEditing = false);
  }

  Future<void> _handleInvite() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => const TeamManagerTeamsScreen(selectMode: true),
      ),
    );

    if (result == null || !result.containsKey('teamId')) return;

    setState(() => isProcessing = true);

    try {
      final response = await PlayerTeamService.addPlayer(
        teamId: result['teamId'],
        playerId: widget.result.playerId,
        status: "Invited",
      );
      ref.invalidate(teamsProvider);

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
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final canEdit = hasPermissions(
      widget.permissions,
      required: [Permission.editPlayerProfile],
    );

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _isEditing ? "Edit Profile" : "Profile",
          style: TextStyle(color: colors.textPrimary),
        ),
        flexibleSpace: Container(color: colors.gray1),
        iconTheme: IconThemeData(color: colors.textPrimary),
        actions: [
          if (canEdit)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.save_outlined : Icons.edit_outlined,
              ),
              onPressed: () {
                if (_isEditing) {
                  _handleSaveChanges();
                } else {
                  setState(() => _isEditing = true);
                }
              },
              tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(colors),
            const SizedBox(height: Sizes.spaceLg),
            Row(
              children: [
                if (hasPermissions(
                  widget.permissions,
                  required: [Permission.invitePlayer],
                ))
                  GFButton(
                    onPressed: isProcessing ? null : _handleInvite,
                    text: "Invite this Player",
                    color: colors.color9,
                    size: GFSize.SMALL,
                  ),
                SizedBox(width: Sizes.spaceMd),
                if (hasPermissions(
                  widget.permissions,
                  required: [Permission.chat],
                ))
                  GFButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatLoaderScreen(
                            partner: ConversationWith(
                              name: widget.result.fullName,
                              entityId: widget.result.playerId,
                              imageUrl: widget.result.profileImageUrl,
                              userId: widget.result.userId,
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
              title: 'Player Information',
              icon: Icons.person_outline,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.cake_outlined,
                  label: 'Birth Date',
                  value: formatRfcDate(widget.result.birthDate),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.transgender_outlined,
                  label: 'Gender',
                  value: widget.result.gender,
                ),
                _EditableInfoTile(
                  colors: colors,
                  icon: Icons.height_outlined,
                  label: 'Height',
                  controller: _heightController,
                  isEditing: _isEditing,
                  suffixText: 'in',
                  keyboardType: TextInputType.number,
                ),
                _EditableInfoTile(
                  colors: colors,
                  icon: Icons.scale_outlined,
                  label: 'Weight',
                  controller: _weightController,
                  isEditing: _isEditing,
                  suffixText: 'kg',
                  keyboardType: TextInputType.number,
                ),
                _EditableInfoTile(
                  colors: colors,
                  icon: Icons.sports_basketball_outlined,
                  label: 'Positions',
                  controller: _positionsController,
                  isEditing: _isEditing,
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            buildInfoCard(
              colors: colors,
              title: 'Career Stats',
              icon: Icons.query_stats,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.leaderboard_outlined,
                  label: 'Games Played',
                  value: widget.result.totalGamesPlayed.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.scoreboard_outlined,
                  label: 'Points Scored',
                  value: widget.result.totalPointsScored.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.assistant_outlined,
                  label: 'Assists',
                  value: widget.result.totalAssists.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.restart_alt,
                  label: 'Rebounds',
                  value: widget.result.totalRebounds.toString(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppThemeColors colors) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.radiusMd),
            image: DecorationImage(
              image: NetworkImage(widget.result.profileImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceMd),
        _isEditing
            ? TextField(
                controller: _fullNameController,
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
                _fullNameController.text,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                  fontSize: Sizes.fontSizeLg,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        const SizedBox(height: Sizes.spaceXs),
        _isEditing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    child: TextField(
                      controller: _jerseyNumberController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
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
                    ),
                  ),
                  Text(
                    ' | ',
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _jerseyNameController,
                      textAlign: TextAlign.start,
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
                    ),
                  ),
                ],
              )
            : Text(
                '#${_jerseyNumberController.text} | ${_jerseyNameController.text}',
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textSecondary,
                  fontSize: Sizes.fontSizeSm,
                ),
              ),
      ],
    );
  }
}

class _EditableInfoTile extends StatelessWidget {
  final AppThemeColors colors;
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType keyboardType;
  final String? suffixText;

  const _EditableInfoTile({
    required this.colors,
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEditing,
    this.keyboardType = TextInputType.text,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceMd,
        vertical: Sizes.spaceXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: Sizes.fontSizeXl, color: colors.textSecondary),
          const SizedBox(width: Sizes.spaceMd),
          Text(
            label,
            style: TextStyle(
              fontSize: Sizes.fontSizeSm,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(width: Sizes.spaceSm),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                    keyboardType: keyboardType,
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
                    controller.text,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: Sizes.fontSizeSm,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }
}
