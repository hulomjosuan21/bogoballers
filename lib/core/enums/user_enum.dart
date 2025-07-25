// ignore_for_file: constant_identifier_names

enum AccountTypeEnum {
  PLAYER("Player"),
  TEAM_MANAGER("Team_Manager"),
  LOCAL_ADMINISTRATOR("League_Administrator_Local"),
  LGU_ADMINISTRATOR("League_Administrator_LGU"),
  SYSTEM("System");

  final String value;
  const AccountTypeEnum(this.value);
  static AccountTypeEnum? fromValue(String? value) {
    if (value == null) return null;
    return AccountTypeEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid account type value: $value'),
    );
  }
}

extension AccountTypeEnumHelper on AccountTypeEnum {
  static AccountTypeEnum? fromName(String? name) {
    if (name == null) return null;
    return AccountTypeEnum.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw ArgumentError('Invalid account type name: $name'),
    );
  }

  /// Compare enum to a string (value or name)
  bool equalsString(String input) {
    return input == value || input == name;
  }
}
