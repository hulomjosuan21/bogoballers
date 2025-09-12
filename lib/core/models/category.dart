class Category {
  final String categoryId;
  final String categoryName;
  final String leagueAdministratorId;
  final bool checkPlayerAge;
  final int? playerMinAge;
  final int? playerMaxAge;
  final String playerGender;
  final bool checkAddress;
  final String? allowedAddress;
  final bool allowGuestTeam;
  final bool allowGuestPlayer;
  final int guestPlayerFeeAmount;
  final int teamEntranceFeeAmount;
  final bool requiresValidDocument;
  final List<String>? allowedDocuments;
  final String? documentValidUntil;
  final String categoryCreatedAt;
  final String categoryUpdatedAt;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.leagueAdministratorId,
    required this.checkPlayerAge,
    this.playerMinAge,
    this.playerMaxAge,
    required this.playerGender,
    required this.checkAddress,
    this.allowedAddress,
    required this.allowGuestTeam,
    required this.allowGuestPlayer,
    required this.guestPlayerFeeAmount,
    required this.teamEntranceFeeAmount,
    required this.requiresValidDocument,
    this.allowedDocuments,
    this.documentValidUntil,
    required this.categoryCreatedAt,
    required this.categoryUpdatedAt,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['category_id'] as String,
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
      guestPlayerFeeAmount: map['guest_player_fee_amount'] as int,
      teamEntranceFeeAmount: map['team_entrance_fee_amount'] as int,
      requiresValidDocument: map['requires_valid_document'] as bool,
      allowedDocuments: map['allowed_documents'] != null
          ? List<String>.from(map['allowed_documents'] as List)
          : null,
      documentValidUntil: map['document_valid_until'] as String?,
      categoryCreatedAt: map['category_created_at'] as String,
      categoryUpdatedAt: map['category_updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'league_administrator_id': leagueAdministratorId,
      'check_player_age': checkPlayerAge,
      'player_min_age': playerMinAge,
      'player_max_age': playerMaxAge,
      'player_gender': playerGender,
      'check_address': checkAddress,
      'allowed_address': allowedAddress,
      'allow_guest_team': allowGuestTeam,
      'allow_guest_player': allowGuestPlayer,
      'guest_player_fee_amount': guestPlayerFeeAmount,
      'team_entrance_fee_amount': teamEntranceFeeAmount,
      'requires_valid_document': requiresValidDocument,
      'allowed_documents': allowedDocuments,
      'document_valid_until': documentValidUntil,
      'category_created_at': categoryCreatedAt,
      'category_updated_at': categoryUpdatedAt,
    };
  }
}
