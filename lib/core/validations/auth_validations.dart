import 'package:bogoballers/core/constants/regex.dart';
import 'package:bogoballers/core/enums/gender_enum.dart';
import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:bogoballers/core/utils/league_utils.dart';
import 'package:bogoballers/core/validations/validators.dart';
import 'package:flutter/material.dart';

void validateOrganizationFields({
  required TextEditingController orgNameController,
  required String? selectedOrgType,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController addressController,
  required String? fullPhoneNumber,
}) {
  if (orgNameController.text.trim().isEmpty) {
    throw ValidationException("Organization name cannot be empty");
  }
  if (selectedOrgType == null || selectedOrgType.trim().isEmpty) {
    throw ValidationException("Organization type must be selected");
  }
  if (addressController.text.trim().isEmpty) {
    throw ValidationException("Address cannot be empty");
  }
  if (emailController.text.trim().isEmpty) {
    throw ValidationException("Email cannot be empty");
  }
  if (passwordController.text.trim().isEmpty) {
    throw ValidationException("Password cannot be empty");
  }
  if (fullPhoneNumber == null || fullPhoneNumber.trim().isEmpty) {
    throw ValidationException("Phone number cannot be empty");
  }
  if (!isValidateContactNumber(fullPhoneNumber)) {
    throw ValidationException("Invalid Phone number");
  }
}

void validatePlayerFields({
  required TextEditingController fullNameController,
  required ValueNotifier<Gender?> selectedGender,
  required DateTime? selectedBirthDate,
  required TextEditingController jerseyNameController,
  required TextEditingController jerseyNumberController,
  required ValueNotifier<Set<String>> selectedPositions,
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPassController,
  required TextEditingController addressController,
  required String? fullPhoneNumber,
}) {
  final fullName = fullNameController.text.trim();
  if (fullName.isEmpty) {
    throw ValidationException("Full name cannot be empty");
  }
  if (!RegExPatterns.fullName.hasMatch(fullName)) {
    throw ValidationException(
      "Invalid Full name format\nUse: Firstname Lastname",
    );
  }
  if (selectedGender.value == null) {
    throw ValidationException("Gender must be selected");
  }
  if (selectedBirthDate == null) {
    throw ValidationException("Birthdate must be selected");
  }
  if (addressController.text.trim().isEmpty) {
    throw ValidationException("Addres name cannot be empty");
  }
  if (jerseyNameController.text.trim().isEmpty) {
    throw ValidationException("Jersey name cannot be empty");
  }
  if (jerseyNumberController.text.trim().isEmpty) {
    throw ValidationException("Jersey number cannot be empty");
  }
  if (double.tryParse(jerseyNumberController.text) == null) {
    throw ValidationException("Jersey number must be numeric");
  }
  if (selectedPositions.value.isEmpty) {
    throw ValidationException("At least one position must be selected");
  }
  if (selectedPositions.value.length > 2) {
    throw ValidationException("You can only select up to two positions");
  }
  if (emailController.text.trim().isEmpty) {
    throw ValidationException("Email cannot be empty");
  }
  if (passwordController.text.trim().isEmpty) {
    throw ValidationException("Password cannot be empty");
  }

  if (passwordController.text.trim() != confirmPassController.text.trim()) {
    throw ValidationException("Passwords do not match");
  }
  if (fullPhoneNumber == null || fullPhoneNumber.trim().isEmpty) {
    throw ValidationException("Phone number cannot be empty");
  }
  if (!isValidateContactNumber(fullPhoneNumber)) {
    throw ValidationException("Invalid Phone number");
  }
}

void validateTeamCreatorFields({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController confirmPassController,
  required String? phoneNumber,
}) {
  if (emailController.text.trim().isEmpty) {
    throw ValidationException("Email cannot be empty");
  }
  if (passwordController.text.trim().isEmpty) {
    throw ValidationException("Password cannot be empty");
  }

  if (passwordController.text.trim() != confirmPassController.text.trim()) {
    throw ValidationException("Passwords do not match");
  }
  if (phoneNumber == null || phoneNumber.trim().isEmpty) {
    throw ValidationException("Phone number cannot be empty");
  }
  if (!isValidateContactNumber(phoneNumber)) {
    throw ValidationException("Invalid Phone number");
  }
}

void validateLoginFields({
  required TextEditingController emailController,
  required TextEditingController passwordController,
}) {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty) {
    throw ValidationException("Email cannot be empty");
  }

  if (!isValidEmail(email)) {
    throw ValidationException("Invalid email format");
  }

  if (password.isEmpty) {
    throw ValidationException("Password cannot be empty");
  }
}

void validateNewLeagueFields({
  required TextEditingController titleController,
  required DateTime? registrationDeadline,
  required DateTime? openingDate,
  required DateTime? startDate,
  required TextEditingController descriptionController,
  required TextEditingController rulesController,
  required List<CategoryInputData> addedCategories,
}) {
  final title = titleController.text.trim();
  final description = descriptionController.text.trim();
  final rules = rulesController.text.trim();

  if (title.isEmpty) {
    throw ValidationException("Title cannot be empty");
  }

  if (registrationDeadline == null) {
    throw ValidationException("Registration deadline cannot be empty");
  }

  if (openingDate == null) {
    throw ValidationException("Opening date cannot be empty");
  }

  if (startDate == null) {
    throw ValidationException("Start date cannot be empty");
  }

  if (description.isEmpty) {
    throw ValidationException("Description cannot be empty");
  }

  if (rules.isEmpty) {
    throw ValidationException("Rules cannot be empty");
  }

  if (addedCategories.isEmpty) {
    throw ValidationException("At least one category must be added");
  }

  for (var cat in addedCategories) {
    if (cat.format.trim().isEmpty) {
      throw ValidationException(
        "Category '${cat.category}' must have a format",
      );
    }
    if (int.parse(cat.maxTeam) < 4) {
      throw ValidationException(
        "Category '${cat.category}' must have at least 4 teams",
      );
    }
  }
}
