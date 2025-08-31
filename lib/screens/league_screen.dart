import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:flutter/material.dart';

class LeagueScreen extends StatelessWidget
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
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
