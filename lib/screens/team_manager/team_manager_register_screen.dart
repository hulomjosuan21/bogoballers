import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/display_name_generator.dart';
import 'package:bogoballers/core/models/team_manager.dart';
import 'package:bogoballers/core/services/team_manager_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:bogoballers/core/utils/terms.dart';
import 'package:bogoballers/core/validations/auth_validations.dart';
import 'package:bogoballers/core/widget/password_field.dart';
import 'package:bogoballers/core/widget/phone_number_input.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';

class TeamManagerRegisterScreen extends StatefulWidget {
  const TeamManagerRegisterScreen({super.key});

  @override
  State<TeamManagerRegisterScreen> createState() =>
      _TeamManagerRegisterScreenState();
}

class _TeamManagerRegisterScreenState extends State<TeamManagerRegisterScreen> {
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  String? phoneNumber;
  bool hasAcceptedTerms = false;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();
    displayNameController.text = generateDisplayName();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Register as a Team Manager"),
        flexibleSpace: Container(color: colors.gray1),
      ),
      body: Container(
        padding: const EdgeInsets.all(Sizes.spaceLg),
        decoration: BoxDecoration(
          color: colors.gray1,
          borderRadius: BorderRadius.circular(Sizes.radiusMd),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "",
                style: TextStyle(
                  fontSize: Sizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: Sizes.spaceSm),
              Text(
                '* Please fill in your account details below.\n'
                'Make sure your email and phone number are valid.',
                style: TextStyle(fontSize: 10, color: colors.gray11),
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: displayNameController,
                      decoration: const InputDecoration(
                        labelText: "Display name",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        displayNameController.text = generateDisplayName();
                      });
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
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
                onPressed: (hasAcceptedTerms && !isRegistering)
                    ? _handleRegister
                    : null,
                text: 'Register',
                color: colors.color9,
                shape: GFButtonShape.standard,
                disabledColor: colors.color6,
                disabledTextColor: colors.gray1,
                size: GFSize.MEDIUM,
                fullWidthButton: true,
              ),
            ],
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
      validateTeamManagerFields(
        emailController: emailController,
        displayNameController: displayNameController,
        passwordController: passwordController,
        phoneNumber: phoneNumber,
        confirmPassController: confirmPassController,
      );

      final user = CreateTeamManager(
        email: emailController.text,
        contact_number: phoneNumber!,
        password_str: passwordController.text,
        display_name: displayNameController.text,
      );

      final service = TeamManagerServices();

      final response = await service.createNewTeamManager(user);

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
