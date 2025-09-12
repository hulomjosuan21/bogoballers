class User {
  final String userId;
  final String email;
  final String contactNumber;
  final bool isVerified;
  final String accountType;
  final String? displayName;
  final String userCreatedAt;
  final String userUpdatedAt;

  User({
    required this.userId,
    required this.email,
    required this.contactNumber,
    required this.isVerified,
    required this.accountType,
    this.displayName,
    required this.userCreatedAt,
    required this.userUpdatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] as String,
      email: map['email'] as String,
      contactNumber: map['contact_number'] as String,
      isVerified: map['is_verified'] as bool,
      accountType: map['account_type'] as String,
      displayName: map['display_name'] as String?,
      userCreatedAt: map['user_created_at'] as String,
      userUpdatedAt: map['user_updated_at'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'email': email,
      'contact_number': contactNumber,
      'is_verified': isVerified,
      'account_type': accountType,
      'display_name': displayName,
      'user_created_at': userCreatedAt,
      'user_updated_at': userUpdatedAt,
    };
  }
}
