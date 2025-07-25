import 'dart:async';

import 'package:bogoballers/core/constants/file_strings.dart';
import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/services/auth_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/custom_exceptions.dart';
import 'package:bogoballers/core/validations/auth_validations.dart';
import 'package:bogoballers/core/widget/auth_navigator.dart';
import 'package:bogoballers/core/widget/password_field.dart';
import 'package:bogoballers/core/widget/slider_intro_banner.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/auth/select_role_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  bool stayLoggedIn = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController(text: 'password123');

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    try {
      validateLoginFields(
        emailController: emailController,
        passwordController: passwordController,
      );

      final user = UserModel.login(
        email: emailController.text,
        password_str: passwordController.text,
      );

      final response = await AuthService.login(
        u: user.toFormDataForLogin(),
        s: stayLoggedIn,
      );
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
    } catch (e, stackTrace) {
      if (context.mounted) {
        // Log the full error and stack trace for debugging
        debugPrint('Login error: $e');
        debugPrint('Stack trace: $stackTrace');

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
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: colors.color9))
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Top banner with logo
                          Stack(
                            children: [
                              Container(
                                height: 400,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(ImageStrings.bgImg1),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        ImageStrings.appLogo,
                                        width: 80,
                                        height: 80,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "BogoBallers",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 4,
                                              color: Colors.black.withAlpha(
                                                128,
                                              ),
                                              offset: Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SlidingIntroBanner(),
                            ],
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: Sizes.spaceMd),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      label: Text("Email"),
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                  ),
                                  const SizedBox(height: Sizes.spaceMd),
                                  PasswordField(
                                    controller: passwordController,
                                    hintText: "Password",
                                  ),
                                  const SizedBox(height: Sizes.spaceSm),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: stayLoggedIn,
                                            onChanged: (value) => setState(
                                              () =>
                                                  stayLoggedIn = value ?? false,
                                            ),
                                          ),
                                          const Text(
                                            "Stay logged in",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {}, // forgot password
                                        child: Text(
                                          "Forgot password?",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: colors.color9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Sizes.spaceMd),
                                  GFButton(
                                    onPressed: _handleLogin,
                                    text: 'Login',
                                    color: colors.color9,
                                    shape: GFButtonShape.standard,
                                    size: GFSize.MEDIUM,
                                    fullWidthButton: true,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Register navigator
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: Sizes.spaceSm,
                                right: Sizes.spaceSm,
                                top: Sizes.spaceSm,
                                bottom: Sizes.spaceLg,
                              ),
                              child: authNavigator(
                                context,
                                "Don't have an account yet?",
                                " Register",
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ClientAuthScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
