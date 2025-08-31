import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class PlayerScreen extends StatefulWidget
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
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Player")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.permissions.contains(Permission.invitePlayer))
              GFButton(onPressed: () {}, text: "Invite"),
          ],
        ),
      ),
    );
  }
}
