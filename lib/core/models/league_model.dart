import 'package:bogoballers/core/models/category.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';

class LeagueOfficial {
  final String fullName;
  final String role;
  final String contactInfo;
  final String photo;

  LeagueOfficial({
    required this.fullName,
    required this.role,
    required this.contactInfo,
    required this.photo,
  });

  factory LeagueOfficial.fromMap(Map<String, dynamic> map) {
    return LeagueOfficial(
      fullName: map['full_name'] as String,
      role: map['role'] as String,
      contactInfo: map['contact_info'] as String,
      photo: map['photo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'role': role,
      'contact_info': contactInfo,
      'photo': photo,
    };
  }
}

class LeagueReferee {
  final String fullName;
  final String contactInfo;
  final String photo;
  final bool isAvailable;

  LeagueReferee({
    required this.fullName,
    required this.contactInfo,
    required this.photo,
    required this.isAvailable,
  });

  factory LeagueReferee.fromMap(Map<String, dynamic> map) {
    return LeagueReferee(
      fullName: map['full_name'] as String,
      contactInfo: map['contact_info'] as String,
      photo: map['photo'] as String,
      isAvailable: map['is_available'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'contact_info': contactInfo,
      'photo': photo,
      'is_available': isAvailable,
    };
  }
}

class LeagueAffiliate {
  final String name;
  final String value;
  final String image;
  final String contactInfo;

  LeagueAffiliate({
    required this.name,
    required this.value,
    required this.image,
    required this.contactInfo,
  });

  factory LeagueAffiliate.fromMap(Map<String, dynamic> map) {
    return LeagueAffiliate(
      name: map['name'] as String,
      value: map['value'] as String,
      image: map['image'] as String,
      contactInfo: map['contact_info'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'value': value,
      'image': image,
      'contact_info': contactInfo,
    };
  }
}

class LeagueCourt {
  final String name;
  final String location;
  final bool isAvailable;

  LeagueCourt({
    required this.name,
    required this.location,
    required this.isAvailable,
  });

  factory LeagueCourt.fromMap(Map<String, dynamic> map) {
    return LeagueCourt(
      name: map['name'] as String,
      location: map['location'] as String,
      isAvailable: map['is_available'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'location': location, 'is_available': isAvailable};
  }
}

class LeagueResource {
  final List<LeagueCourt> leagueCourts;
  final List<LeagueOfficial> leagueOfficials;
  final List<LeagueReferee> leagueReferees;
  final List<LeagueAffiliate> leagueAffiliates;

  LeagueResource({
    required this.leagueCourts,
    required this.leagueOfficials,
    required this.leagueReferees,
    required this.leagueAffiliates,
  });

  factory LeagueResource.fromMap(Map<String, dynamic> map) {
    return LeagueResource(
      leagueCourts: (map['league_courts'] as List)
          .map((e) => LeagueCourt.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueOfficials: (map['league_officials'] as List)
          .map((e) => LeagueOfficial.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueReferees: (map['league_referees'] as List)
          .map((e) => LeagueReferee.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueAffiliates: (map['league_affiliates'] as List)
          .map((e) => LeagueAffiliate.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'league_courts': leagueCourts.map((e) => e.toMap()).toList(),
      'league_officials': leagueOfficials.map((e) => e.toMap()).toList(),
      'league_referees': leagueReferees.map((e) => e.toMap()).toList(),
      'league_affiliates': leagueAffiliates.map((e) => e.toMap()).toList(),
    };
  }
}

class LeagueCategory extends Category {
  final String leagueCategoryId;
  final String leagueId;
  final int maxTeam;
  final bool acceptTeams;
  final String leagueCategoryCreatedAt;
  final String leagueCategoryUpdatedAt;
  final String leagueCategoryStatus;
  final List<LeagueCategoryRound> rounds;

  LeagueCategory({
    required this.leagueCategoryId,
    required this.leagueId,
    required this.maxTeam,
    required this.acceptTeams,
    required this.leagueCategoryCreatedAt,
    required this.leagueCategoryStatus,
    required this.leagueCategoryUpdatedAt,
    required this.rounds,
    required super.categoryId,
    required super.categoryName,
    required super.leagueAdministratorId,
    required super.checkPlayerAge,
    super.playerMinAge,
    super.playerMaxAge,
    required super.playerGender,
    required super.checkAddress,
    super.allowedAddress,
    required super.allowGuestTeam,
    required super.allowGuestPlayer,
    required super.guestPlayerFeeAmount,
    required super.teamEntranceFeeAmount,
    required super.requiresValidDocument,
    super.allowedDocuments,
    super.documentValidUntil,
    required super.categoryCreatedAt,
    required super.categoryUpdatedAt,
  });

  factory LeagueCategory.fromMap(Map<String, dynamic> map) {
    return LeagueCategory(
      leagueCategoryId: map['league_category_id'] as String,
      leagueId: map['league_id'] as String,
      maxTeam: map['max_team'] as int,
      acceptTeams: map['accept_teams'] as bool,
      leagueCategoryCreatedAt: map['league_category_created_at'] as String,
      leagueCategoryUpdatedAt: map['league_category_updated_at'] as String,
      rounds: (map['rounds'] as List)
          .map((e) => LeagueCategoryRound.fromMap(e as Map<String, dynamic>))
          .toList(),
      categoryId: map['category_id'] as String,
      leagueCategoryStatus: map['league_category_status'] as String,
      categoryName: map['category_name'] as String,
      leagueAdministratorId: map['league_administrator_id'] as String,
      checkPlayerAge: map['check_player_age'] as bool,
      playerMinAge: map['player_min_age'] as int?,
      playerMaxAge: map['player_max_age'] as int?,
      playerGender: map['player_gender'] as String,
      checkAddress: map['check_address'] as bool,
      allowedAddress: map['allowed_address'] as String?,
      allowGuestTeam: map['allow_guest_team'] as bool,
      allowGuestPlayer: map['allow_guest_player'] as bool,
      guestPlayerFeeAmount: map['guest_player_fee_amount'] as double,
      teamEntranceFeeAmount: map['team_entrance_fee_amount'] as double,
      requiresValidDocument: map['requires_valid_document'] as bool,
      allowedDocuments: map['allowed_documents'] != null
          ? List<String>.from(map['allowed_documents'] as List)
          : null,
      documentValidUntil: map['document_valid_until'] as String?,
      categoryCreatedAt: map['category_created_at'] as String,
      categoryUpdatedAt: map['category_updated_at'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'league_category_id': leagueCategoryId,
      'league_id': leagueId,
      'max_team': maxTeam,
      'accept_teams': acceptTeams,
      'league_category_created_at': leagueCategoryCreatedAt,
      'league_category_updated_at': leagueCategoryUpdatedAt,
      'rounds': rounds.map((e) => e.toMap()).toList(),
    };
  }
}

class League extends LeagueResource {
  final String leagueId;
  final String publicLeagueId;
  final String leagueAdministratorId;
  final String leagueTitle;
  final String leagueDescription;
  final String leagueAddress;
  final double leagueBudget;
  final String registrationDeadline;
  final String openingDate;
  final List<String> leagueSchedule;
  final String bannerUrl;
  final String status;
  final int seasonYear;
  final List<String> sportsmanshipRules;
  final String leagueCreatedAt;
  final String leagueUpdatedAt;
  final LeagueAdministrator creator;
  final List<LeagueCategory> leagueCategories;

  League({
    required this.leagueId,
    required this.publicLeagueId,
    required this.leagueAdministratorId,
    required this.leagueTitle,
    required this.leagueDescription,
    required this.leagueAddress,
    required this.leagueBudget,
    required this.registrationDeadline,
    required this.openingDate,
    required this.leagueSchedule,
    required this.bannerUrl,
    required this.status,
    required this.seasonYear,
    required this.sportsmanshipRules,
    required this.leagueCreatedAt,
    required this.leagueUpdatedAt,
    required this.creator,
    required this.leagueCategories,
    required super.leagueCourts,
    required super.leagueOfficials,
    required super.leagueReferees,
    required super.leagueAffiliates,
  });

  factory League.fromMap(Map<String, dynamic> map) {
    return League(
      leagueId: map['league_id'] as String,
      publicLeagueId: map['public_league_id'] as String,
      leagueAdministratorId: map['league_administrator_id'] as String,
      leagueTitle: map['league_title'] as String,
      leagueDescription: map['league_description'] as String,
      leagueAddress: map['league_address'] as String,
      leagueBudget: map['league_budget'] as double,
      registrationDeadline: map['registration_deadline'] as String,
      openingDate: map['opening_date'] as String,
      leagueSchedule: List<String>.from(map['league_schedule'] as List),
      bannerUrl: map['banner_url'] as String,
      status: map['status'] as String,
      seasonYear: map['season_year'] as int,
      sportsmanshipRules: List<String>.from(map['sportsmanship_rules'] as List),
      leagueCreatedAt: map['league_created_at'] as String,
      leagueUpdatedAt: map['league_updated_at'] as String,
      creator: LeagueAdministrator.fromMap(
        map['creator'] as Map<String, dynamic>,
      ),
      leagueCategories: (map['league_categories'] as List)
          .map((e) => LeagueCategory.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueCourts: (map['league_courts'] as List)
          .map((e) => LeagueCourt.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueOfficials: (map['league_officials'] as List)
          .map((e) => LeagueOfficial.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueReferees: (map['league_referees'] as List)
          .map((e) => LeagueReferee.fromMap(e as Map<String, dynamic>))
          .toList(),
      leagueAffiliates: (map['league_affiliates'] as List)
          .map((e) => LeagueAffiliate.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'league_id': leagueId,
      'public_league_id': publicLeagueId,
      'league_administrator_id': leagueAdministratorId,
      'league_title': leagueTitle,
      'league_description': leagueDescription,
      'league_address': leagueAddress,
      'league_budget': leagueBudget,
      'registration_deadline': registrationDeadline,
      'opening_date': openingDate,
      'league_schedule': leagueSchedule,
      'banner_url': bannerUrl,
      'status': status,
      'season_year': seasonYear,
      'sportsmanship_rules': sportsmanshipRules,
      'league_created_at': leagueCreatedAt,
      'league_updated_at': leagueUpdatedAt,
      'creator': creator.toMap(),
      'league_categories': leagueCategories.map((e) => e.toMap()).toList(),
    };
  }
}

class LeagueCategoryRound {
  final String roundId;
  final String publicRoundId;
  final String leagueCategoryId;
  final String roundName;
  final int roundOrder;
  final String roundStatus;
  final bool matchesGenerated;
  final String? formatType;
  final String? roundFormat;
  final String? nextRoundId;
  final String leagueCategoryRoundCreatedAt;
  final String leagueCategoryRoundUpdatedAt;

  LeagueCategoryRound({
    required this.roundId,
    required this.publicRoundId,
    required this.leagueCategoryId,
    required this.roundName,
    required this.roundOrder,
    required this.roundStatus,
    required this.matchesGenerated,
    this.formatType,
    this.roundFormat,
    this.nextRoundId,
    required this.leagueCategoryRoundCreatedAt,
    required this.leagueCategoryRoundUpdatedAt,
  });

  factory LeagueCategoryRound.fromMap(Map<String, dynamic> map) {
    return LeagueCategoryRound(
      roundId: map['round_id'] as String,
      publicRoundId: map['public_round_id'] as String,
      leagueCategoryId: map['league_category_id'] as String,
      roundName: map['round_name'] as String,
      roundOrder: map['round_order'] as int,
      roundStatus: map['round_status'] as String,
      matchesGenerated: map['matches_generated'] as bool,
      formatType: map['format_type'] as String?,
      nextRoundId: map['next_round_id'] as String?,
      leagueCategoryRoundCreatedAt:
          map['league_category_round_created_at'] as String,
      leagueCategoryRoundUpdatedAt:
          map['league_category_round_updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'round_id': roundId,
      'public_round_id': publicRoundId,
      'league_category_id': leagueCategoryId,
      'round_name': roundName,
      'round_order': roundOrder,
      'round_status': roundStatus,
      'matches_generated': matchesGenerated,
      'format_type': formatType,
      'round_format': roundFormat,
      'next_round_id': nextRoundId,
      'league_category_round_created_at': leagueCategoryRoundCreatedAt,
      'league_category_round_updated_at': leagueCategoryRoundUpdatedAt,
    };
  }
}
