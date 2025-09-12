import 'package:bogoballers/core/models/user_model.dart';

class LeagueAdministrator {
  final String leagueAdministratorId;
  final String publicLeagueAdministratorId;
  final String userId;
  final String organizationName;
  final String organizationType;
  final String organizationAddress;
  final String organizationLogoUrl;
  final String leagueAdminCreatedAt;
  final String leagueAdminUpdatedAt;
  final User account;

  LeagueAdministrator({
    required this.leagueAdministratorId,
    required this.publicLeagueAdministratorId,
    required this.userId,
    required this.organizationName,
    required this.organizationType,
    required this.organizationAddress,
    required this.organizationLogoUrl,
    required this.leagueAdminCreatedAt,
    required this.leagueAdminUpdatedAt,
    required this.account,
  });

  factory LeagueAdministrator.fromMap(Map<String, dynamic> map) {
    return LeagueAdministrator(
      leagueAdministratorId: map['league_administrator_id'] as String,
      publicLeagueAdministratorId:
          map['public_league_administrator_id'] as String,
      userId: map['user_id'] as String,
      organizationName: map['organization_name'] as String,
      organizationType: map['organization_type'] as String,
      organizationAddress: map['organization_address'] as String,
      organizationLogoUrl: map['organization_logo_url'] as String,
      leagueAdminCreatedAt: map['league_admin_created_at'] as String,
      leagueAdminUpdatedAt: map['league_admin_updated_at'] as String,
      account: User.fromMap(map['account'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'league_administrator_id': leagueAdministratorId,
      'public_league_administrator_id': publicLeagueAdministratorId,
      'user_id': userId,
      'organization_name': organizationName,
      'organization_type': organizationType,
      'organization_address': organizationAddress,
      'organization_logo_url': organizationLogoUrl,
      'league_admin_created_at': leagueAdminCreatedAt,
      'league_admin_updated_at': leagueAdminUpdatedAt,
      'account': account.toMap(),
    };
  }
}
