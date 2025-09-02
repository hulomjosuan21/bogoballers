// ignore_for_file: non_constant_identifier_names

class Category {
  final String category_id;
  final String category_name;
  final bool check_player_age;
  final int? player_min_age;
  final int? player_max_age;
  final String player_gender;
  final bool check_address;
  final String? allowed_address;
  final bool allow_guest_team;
  final double team_entrance_fee_amount;
  final bool allow_guest_player;
  final double guest_player_fee_amount;
  final bool requires_valid_document;
  final List<String>? allowed_documents;
  final String? document_valid_until;

  Category({
    required this.category_id,
    required this.category_name,
    required this.check_player_age,
    required this.player_min_age,
    required this.player_max_age,
    required this.player_gender,
    required this.check_address,
    required this.allowed_address,
    required this.allow_guest_team,
    required this.team_entrance_fee_amount,
    required this.allow_guest_player,
    required this.guest_player_fee_amount,
    required this.requires_valid_document,
    required this.allowed_documents,
    required this.document_valid_until,
  });
}
