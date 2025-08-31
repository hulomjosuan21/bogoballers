import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:flutter/material.dart';

class TeamScreen extends StatelessWidget
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
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
