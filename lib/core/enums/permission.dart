enum Permission { invitePlayer, joinTeam, joinLeague, joinLeagueAsTeam }

List<Permission> userPermission(String? accountType) {
  switch (accountType) {
    case 'Player':
      return [Permission.joinTeam, Permission.joinLeague];
    case 'Team_Manager':
      return [
        Permission.invitePlayer,
        Permission.joinLeague,
        Permission.joinLeagueAsTeam,
      ];
    default:
      return [];
  }
}

bool hasPermissions(
  List<Permission> user, {
  List<Permission>? required,
  String mode = "all",
}) {
  if (required == null || required.isEmpty) return true;

  if (mode == "all") {
    return required.every((p) => user.contains(p));
  } else {
    return required.any((p) => user.contains(p));
  }
}
