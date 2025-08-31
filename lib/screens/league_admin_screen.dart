import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:flutter/material.dart';

class LeagueAdministratorScreen extends StatelessWidget
    implements BaseSearchResultScreen<LeagueAdminModel> {
  @override
  final List<Permission> permissions;
  @override
  final LeagueAdminModel result;
  const LeagueAdministratorScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
