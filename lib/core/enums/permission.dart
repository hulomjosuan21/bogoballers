enum Permission { invitePlayer }

List<Permission> userPermission(String? accountType) {
  switch (accountType) {
    case 'Player':
      return [];
    case 'Team_Manager':
      return [Permission.invitePlayer];
    default:
      return [];
  }
}
