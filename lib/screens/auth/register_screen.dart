import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/gender_enum.dart';
import 'package:bogoballers/core/enums/user_enum.dart';
import 'package:bogoballers/core/extension/extensions.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/services/player_service.dart';
import 'package:bogoballers/core/services/team_creator_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:bogoballers/core/utils/terms.dart';
import 'package:bogoballers/core/validations/auth_validations.dart';
import 'package:bogoballers/core/widget/datetime_picker.dart';
import 'package:bogoballers/core/widget/image_picker.dart';
import 'package:bogoballers/core/widget/password_field.dart';
import 'package:bogoballers/core/widget/phone_number_input.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class TeamCreatorRegisterScreen extends StatefulWidget {
  const TeamCreatorRegisterScreen({super.key});

  @override
  State<TeamCreatorRegisterScreen> createState() =>
      _TeamCreatorRegisterScreenState();
}

class _TeamCreatorRegisterScreenState extends State<TeamCreatorRegisterScreen> {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  String? phoneNumber;
  bool hasAcceptedTerms = false;
  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      body: Center(
        child: isRegistering
            ? CircularProgressIndicator(color: colors.color9)
            : SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 350),
                  padding: const EdgeInsets.all(Sizes.spaceMd),
                  decoration: BoxDecoration(
                    color: colors.gray1,
                    border: Border.all(
                      width: Sizes.borderWidthSm,
                      color: colors.gray6,
                    ),
                    borderRadius: BorderRadius.circular(Sizes.radiusMd),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Register as a Team Creator",
                        style: TextStyle(
                          fontSize: Sizes.fontSizeMd,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceSm),
                      Text(
                        "Fill in the required details below to create your profile.",
                        style: TextStyle(fontSize: 11, color: colors.gray8),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceMd),
                      PHPhoneInput(
                        phoneValue: phoneNumber,
                        onChanged: (phone) => phoneNumber = phone,
                      ),
                      const SizedBox(height: Sizes.spaceMd),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceMd),
                      PasswordField(
                        controller: passwordController,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: Sizes.spaceMd),
                      PasswordField(
                        controller: confirmPassController,
                        hintText: 'Confirm Password',
                      ),
                      const SizedBox(height: Sizes.spaceMd),
                      termAndCondition(
                        context: context,
                        hasAcceptedTerms: hasAcceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            hasAcceptedTerms = value ?? false;
                          });
                        },
                        key: 'auth_terms_and_conditions',
                      ),
                      const SizedBox(height: Sizes.spaceLg),
                      GFButton(
                        onPressed: _handleRegister,
                        text: 'Register',
                        color: colors.color9,
                        shape: GFButtonShape.standard,
                        size: GFSize.MEDIUM,
                        fullWidthButton: true,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    setState(() {
      isRegistering = true;
    });
    try {
      validateTeamCreatorFields(
        emailController: emailController,
        passwordController: passwordController,
        phoneNumber: phoneNumber,
        confirmPassController: confirmPassController,
      );

      final user = UserModel.create(
        email: emailController.text,
        contact_number: phoneNumber!,
        password_str: passwordController.text,
        account_type: AccountTypeEnum.TEAM_MANAGER,
      );

      final service = TeamCreatorServices();

      final response = await service.createNewTeamCreator(user);

      if (mounted) {
        showAppSnackbar(
          context,
          message: response.message,
          title: "Success",
          variant: SnackbarVariant.success,
        );

        final redirect = response.redirect;
        if (redirect == null) {
          throw AppException("Something went wrong!");
        }

        await Navigator.pushReplacementNamed(context, redirect);
      }
    } catch (e) {
      if (context.mounted) {
        handleErrorCallBack(e, (message) {
          showAppSnackbar(
            context,
            message: message,
            title: "Error",
            variant: SnackbarVariant.error,
          );
        });
      }
    } finally {
      if (context.mounted) {
        setState(() {
          isRegistering = false;
        });
      }
    }
  }
}

class PlayerRegisterScreen extends StatefulWidget {
  const PlayerRegisterScreen({super.key});

  @override
  State<PlayerRegisterScreen> createState() => _PlayerRegisterScreenState();
}

class _PlayerRegisterScreenState extends State<PlayerRegisterScreen> {
  final ValueNotifier<Gender?> selectedGender = ValueNotifier(null);
  DateTime? selectedBirthDate;
  final List<String> positions = ["Guard", "Forward", "Center"];
  final ValueNotifier<Set<String>> selectedPositions = ValueNotifier({});
  AppImagePickerController profileImageController = AppImagePickerController();

  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bdayController = TextEditingController();
  final jerseyNameController = TextEditingController();
  final addressController = TextEditingController();
  final jerseyNumberController = TextEditingController();

  String? phoneNumber;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool hasAcceptedTerms = false;
  AccountTypeEnum? selectedAccountType;

  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    Widget buildPlayerRegisterInputs() {
      return Container(
        constraints: BoxConstraints(maxWidth: 350),
        margin: EdgeInsets.only(top: 54, bottom: 16),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colors.gray1,
          border: Border.all(width: 0.5, color: colors.gray6),
          borderRadius: BorderRadius.circular(Sizes.radiusSm),
        ),
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register as a Player",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: Sizes.spaceSm),
                  Text(
                    "Fill in the required details below to create your profile.",
                    style: TextStyle(fontSize: 11, color: colors.gray8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceMd),
            AppImagePicker(controller: profileImageController, aspectRatio: 1),
            SizedBox(height: Sizes.spaceSm),
             GFButton(
                                    onPressed: profileImageController.pickImage,
                                    text: 'Select Image',
                                    color: colors.color9,
                                    type: GFButtonType.outline,
                                    shape: GFButtonShape.standard,
                                    size: GFSize.SMALL,
                                  ),
          
            SizedBox(height: Sizes.spaceXs),
            Center(
              child: Text(
                '* Please provide a valid and proper player profile image. This is required for league validation.',
                style: TextStyle(fontSize: 10, color: colors.gray8),
              ),
            ),
            const SizedBox(height: Sizes.spaceMd),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                label: Text("Full name"),
                helperText: "Format: [First Name] [Last Name]",
              ),
            ),
            const SizedBox(height: Sizes.spaceMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Gender",
                  style: TextStyle(
                    fontSize: Sizes.fontSizeMd,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Sizes.spaceSm),
                ValueListenableBuilder<Gender?>(
                  valueListenable: selectedGender,
                  builder: (context, gender, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<Gender>(
                              activeColor: colors.color9,
                              value: Gender.Male,
                              groupValue: gender,
                              onChanged: (Gender? value) {
                                selectedGender.value = value;
                              },
                            ),
                            Text(
                              "Male",
                              style: TextStyle(fontSize: Sizes.fontSizeSm),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            Radio<Gender>(
                              activeColor: colors.color4,
                              value: Gender.Female,
                              groupValue: gender,
                              onChanged: (Gender? value) {
                                selectedGender.value = value;
                              },
                            ),
                            Text(
                              "Female",
                              style: TextStyle(fontSize: Sizes.fontSizeSm),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            DateTimePickerField(
              selectedDate: selectedBirthDate,
              labelText: 'Birthdate',
              helperText: "You must be at least 4 years old to continue.",
              onChanged: (date) {
                setState(() {
                  selectedBirthDate = date;
                });
              },
            ),
            const SizedBox(height: Sizes.spaceMd),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                label: Text("Address"),
                helperText:
                    "Format: Brgy. [Barangay], [City/Municipality], [Province]",
              ),
            ),

            const SizedBox(height: Sizes.spaceMd),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: jerseyNameController,
                    decoration: InputDecoration(label: Text("Jersey name")),
                  ),
                ),
                const SizedBox(width: Sizes.spaceSm),
                Expanded(
                  child: TextField(
                    controller: jerseyNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(label: Text("Jersey number")),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            Center(
              child: Text(
                "Choose up to two positions",
                style: TextStyle(
                  fontSize: Sizes.fontSizeSm,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: Sizes.spaceSm),
            ValueListenableBuilder<Set<String>>(
              valueListenable: selectedPositions,
              builder: (context, selected, _) {
                return Column(
                  children: positions.map((position) {
                    return CheckboxListTile(
                      visualDensity: VisualDensity.compact,
                      title: Text(
                        position,
                        style: TextStyle(fontSize: Sizes.fontSizeSm),
                      ),
                      value: selected.contains(position),
                      onChanged: (bool? checked) {
                        if (checked == true && selected.length >= 2) {
                          showAppSnackbar(
                            context,
                            message:
                                "You can only select two positions. Deselect one to choose another.",
                            title: "Selection Limit Reached",
                            variant: SnackbarVariant.warning,
                          );
                          return;
                        }
                        selectedPositions.value = Set.from(selected)
                          ..toggle(position, checked);
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: Sizes.spaceMd),
            PHPhoneInput(
              phoneValue: phoneNumber,
              onChanged: (phone) {
                phoneNumber = phone;
              },
            ),
            const SizedBox(height: Sizes.spaceMd),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                label: Text("Email"),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: Sizes.spaceMd),
            PasswordField(controller: passwordController, hintText: 'Password'),
            const SizedBox(height: Sizes.spaceMd),
            PasswordField(
              controller: confirmPassController,
              hintText: 'Confirm Passowrd',
            ),
            const SizedBox(height: Sizes.spaceMd),
            termAndCondition(
              context: context,
              hasAcceptedTerms: hasAcceptedTerms,
              onChanged: (value) {
                setState(() {
                  hasAcceptedTerms = value ?? false;
                });
              },
              key: 'auth_terms_and_conditions',
            ),
            SizedBox(height: Sizes.spaceLg),
             GFButton(
                                    onPressed: !hasAcceptedTerms ? null : _handleRegisterPlayer,
                                    text: 'Register',
                                    color: colors.color9,
                                    type: GFButtonType.outline,
                                    shape: GFButtonShape.standard,
                                    size: GFSize.MEDIUM,
                                    fullWidthButton: true,
                                    
                                  ),
         
          ],
        ),
      );
    }

    return Scaffold(
      body: isRegistering
          ? Center(
              child: CircularProgressIndicator(
                color: colors.color9,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: buildPlayerRegisterInputs()),
              ),
            ),
    );
  }

  Future<void> _handleRegisterPlayer() async {
    setState(() {
      isRegistering = true;
    });
    try {
      validatePlayerFields(
        fullNameController: fullNameController,
        selectedGender: selectedGender,
        selectedBirthDate: selectedBirthDate,
        jerseyNameController: jerseyNameController,
        addressController: addressController,
        jerseyNumberController: jerseyNumberController,
        selectedPositions: selectedPositions,
        emailController: emailController,
        passwordController: passwordController,
        confirmPassController: confirmPassController,
        fullPhoneNumber: phoneNumber,
      );

      final multipartFile = profileImageController.multipartFile;
      if (multipartFile == null) {
        throw ValidationException("Please select an organization logo!");
      }

      final user = UserModel.create(
        email: emailController.text,
        contact_number: phoneNumber!,
        password_str: passwordController.text,
        account_type: AccountTypeEnum.PLAYER,
      );

      final player = PlayerModel.create(
        full_name: fullNameController.text,
        gender: selectedGender.value!.name,
        player_address: addressController.text,
        birth_date: selectedBirthDate!,
        jersey_name: jerseyNameController.text,
        jersey_number: double.parse(jerseyNumberController.text),
        position: selectedPositions.value.join(', '),
        user: user,
        profile_image: multipartFile,
      );

      final service = PlayerServices();

      final response = await service.createNewPlayer(player);
      if (mounted) {
        showAppSnackbar(
          context,
          message: response.message,
          title: "Success",
          variant: SnackbarVariant.success,
        );

        final redirect = response.redirect;
        if (redirect == null) {
          throw AppException("Something went wrong!");
        }

        await Navigator.pushReplacementNamed(context, redirect);
      }
    } catch (e) {
      if (context.mounted) {
        handleErrorCallBack(e, (message) {
          showAppSnackbar(
            context,
            message: message,
            title: "Error",
            variant: SnackbarVariant.error,
          );
        });
      }
    } finally {
      if (context.mounted) {
        setState(() {
          isRegistering = false;
        });
      }
    }
  }
}
