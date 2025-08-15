import 'dart:convert';

import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/services/player_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/utils/terms.dart';
import 'package:bogoballers/core/validations/auth_validations.dart';
import 'package:bogoballers/core/widget/datetime_picker.dart';
import 'package:bogoballers/core/widget/image_picker.dart';
import 'package:bogoballers/core/widget/password_field.dart';
import 'package:bogoballers/core/widget/phone_number_input.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class PlayerRegisterScreen extends StatelessWidget {
  const PlayerRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Register as Player")),
      body: PlayerRegisterPageView(),
    );
  }
}

class PlayerRegisterPageView extends StatefulWidget {
  const PlayerRegisterPageView({super.key});

  @override
  State<PlayerRegisterPageView> createState() => _PlayerRegisterPageViewState();
}

class _PlayerRegisterPageViewState extends State<PlayerRegisterPageView> {
  List<String> barangays = [];
  String? selectedBarangay;
  final ValueNotifier<String?> selectedGender = ValueNotifier(null);

  bool isProcessing = false;

  final fullNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bdayController = TextEditingController();
  final jerseyNameController = TextEditingController();
  final jerseyNumberController = TextEditingController();
  DateTime? selectedBirthDate;

  String? phoneNumber;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool hasAcceptedTerms = false;

  AppImagePickerController profileImageController = AppImagePickerController();
  final PageController _controller = PageController();
  int _currentPage = 0;
  final List<String> positions = [];
  final List<String> allPositions = [
    "Point Guard",
    "Shooting Guard",
    "Small Forward",
    "Power Forward",
    "Center",
  ];

  @override
  void initState() {
    super.initState();
    _loadBarangays();
  }

  Future<void> _loadBarangays() async {
    final jsonString = await rootBundle.loadString(
      'assets/json/barangays.json',
    );
    final List<dynamic> data = json.decode(jsonString);
    setState(() {
      barangays = List<String>.from(data);
      if (barangays.isNotEmpty) {
        selectedBarangay = barangays[0];
      }
    });
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPositionsPage(AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(Sizes.spaceLg),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Which positions do you play?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Sizes.fontSizeLg,
              color: colors.gray11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: Sizes.spaceMd),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: allPositions.map((pos) {
              final isSelected = positions.contains(pos);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected ? positions.remove(pos) : positions.add(pos);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.color9 : colors.color1,
                    border: Border.all(color: colors.gray6, width: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pos,
                    style: TextStyle(
                      color: isSelected ? colors.color1 : colors.color9,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInputs(AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.spaceLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please fill in your account details below.\n'
            'Make sure your email and phone number are valid.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: colors.gray11,
              fontWeight: FontWeight.w500,
            ),
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
        ],
      ),
    );
  }

  Widget _buildPlayerInputs(AppThemeColors colors) {
    return Padding(
      padding: EdgeInsets.all(Sizes.spaceLg),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '* Please provide a valid and proper player profile image. This is required for league validation.',
              style: TextStyle(fontSize: 10, color: colors.gray11),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Sizes.spaceSm),
            AppImagePicker(controller: profileImageController, aspectRatio: 1),
            SizedBox(height: Sizes.spaceSm),
            GFButton(
              onPressed: profileImageController.pickImage,
              text: 'Select Image',
              color: colors.color9,
              type: GFButtonType.outline,
              size: GFSize.SMALL,
            ),
            SizedBox(height: Sizes.spaceSm),
            Text(
              '* Please provide a valid info about you. This is required for league validation.',
              style: TextStyle(fontSize: 10, color: colors.gray11),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Sizes.spaceSm),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                label: Text("Full name"),
                helperText: "Format: [First Name] [Last Name]",
              ),
            ),
            SizedBox(height: Sizes.spaceSm),
            Text(
              "Select Gender",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: Sizes.fontSizeMd,
                fontWeight: FontWeight.w500,
              ),
            ),
            ValueListenableBuilder<String?>(
              valueListenable: selectedGender,
              builder: (context, gender, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          activeColor: colors.color9,
                          value: "Male",
                          groupValue: gender,
                          onChanged: (String? value) {
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
                        Radio<String>(
                          activeColor: colors.color4,
                          value: "Female",
                          groupValue: gender,
                          onChanged: (String? value) {
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
            SizedBox(height: Sizes.spaceMd),
            DropdownSearch<String>(
              items: (filter, infiniteScrollProps) => barangays,
              selectedItem: selectedBarangay ?? "No Data",
              popupProps: PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: 'Select Barangay',
                  border: OutlineInputBorder(),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedBarangay = value;
                });
              },
            ),
            SizedBox(height: Sizes.spaceMd),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    final pages = [
      _buildPositionsPage(colors),
      _buildAccountInputs(colors),
      _buildPlayerInputs(colors),
    ];

    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: pages,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GFButton(
                onPressed: _previousPage,
                text: "Back",
                size: GFSize.SMALL,
                color: colors.gray9,
                type: GFButtonType.outline,
              ),
              if (_currentPage < 2)
                GFButton(
                  onPressed: _nextPage,
                  text: "Next",
                  size: GFSize.SMALL,
                  color: colors.color9,
                ),
              if (_currentPage == 2)
                GFButton(
                  onPressed: hasAcceptedTerms || isProcessing
                      ? () => _handleRegister()
                      : null,
                  disabledColor: colors.color6,
                  disabledTextColor: colors.gray1,
                  text: "Register",
                  size: GFSize.SMALL,
                  color: colors.color9,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    setState(() => isProcessing = true);
    try {
      final multipartFile = profileImageController.multipartFile;
      validatePlayerFields(
        fullNameController: fullNameController,
        selectedGender: selectedGender,
        selectedBirthDate: selectedBirthDate,
        jerseyNameController: jerseyNameController,
        address: selectedBarangay,
        jerseyNumberController: jerseyNumberController,
        selectedPositions: positions,
        emailController: emailController,
        passwordController: passwordController,
        confirmPassController: confirmPassController,
        fullPhoneNumber: phoneNumber,
        profileImage: multipartFile,
      );

      final CreatePlayer data = CreatePlayer(
        email: emailController.text,
        password_str: passwordController.text,
        contact_number: phoneNumber!,
        full_name: fullNameController.text,
        gender: selectedGender.value.toString(),
        birth_date: selectedBirthDate!.toIso8601String(),
        player_address: selectedBarangay!,
        jersey_name: jerseyNameController.text,
        jersey_number: double.parse(jerseyNumberController.text),
        position: positions,
        profile_image: multipartFile!,
      );

      final response = await PlayerService.createNewPlayer(
        data.toFormDataForCreation(),
      );

      if (mounted) {
        showAppSnackbar(
          context,
          message: response.message,
          title: "Success",
          variant: SnackbarVariant.success,
        );
        Navigator.pushReplacementNamed(context, '/auth/login');
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    } finally {
      setState(() => isProcessing = false);
    }
  }
}
