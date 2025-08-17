import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/data/static_data.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/providers/team_provider.dart';
import 'package:bogoballers/core/services/team_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/utils/terms.dart';
import 'package:bogoballers/core/validations/validators.dart';
import 'package:bogoballers/core/widget/image_picker.dart';
import 'package:bogoballers/core/widget/phone_number_input.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class CreateTeamSreen extends ConsumerStatefulWidget {
  const CreateTeamSreen({super.key});

  @override
  ConsumerState<CreateTeamSreen> createState() => _CreateTeamSreenState();
}

class _CreateTeamSreenState extends ConsumerState<CreateTeamSreen> {
  List<String> barangays = [];
  List<String> leagueCategories = [];
  bool hasAcceptedTerms = false;
  bool isProcessing = false;

  String? selectedBarangay;
  String? selectedLeagueCategories;
  String? phoneNumber;
  AppImagePickerController teamLogoController = AppImagePickerController();

  final teamNameController = TextEditingController();
  final teamMotoController = TextEditingController();
  final teamCoachController = TextEditingController();
  final teamAssistantCoachController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStaticData();
  }

  Future<void> _loadStaticData() async {
    final staticData = await loadStaticData();
    setState(() {
      leagueCategories = staticData.leagueCategories;
      selectedLeagueCategories = staticData.leagueCategories[0];
      barangays = staticData.barangays;
      selectedBarangay = staticData.barangays[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Create new team")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.spaceLg),
          child: Column(
            children: [
              AppImagePicker(controller: teamLogoController, aspectRatio: 1),
              SizedBox(height: Sizes.spaceSm),
              GFButton(
                onPressed: teamLogoController.pickImage,
                text: 'Select Image',
                color: colors.color9,
                type: GFButtonType.outline,
                size: GFSize.SMALL,
              ),
              SizedBox(height: Sizes.spaceMd),
              TextField(
                controller: teamNameController,
                decoration: const InputDecoration(labelText: "Team name"),
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
              const SizedBox(height: Sizes.spaceMd),
              PHPhoneInput(
                phoneValue: phoneNumber,
                onChanged: (phone) {
                  phoneNumber = phone;
                },
              ),
              const SizedBox(height: Sizes.spaceMd),
              TextField(
                controller: teamMotoController,
                decoration: const InputDecoration(labelText: "Team moto"),
              ),
              const SizedBox(height: Sizes.spaceMd),
              TextField(
                controller: teamCoachController,
                decoration: const InputDecoration(labelText: "Team coach"),
              ),
              const SizedBox(height: Sizes.spaceMd),
              TextField(
                controller: teamAssistantCoachController,
                decoration: const InputDecoration(
                  labelText: "Team assistant coach",
                ),
              ),
              const SizedBox(height: Sizes.spaceMd),
              DropdownSearch<String>(
                items: (filter, infiniteScrollProps) => leagueCategories,
                selectedItem: selectedLeagueCategories ?? "No Data",
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                ),
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: 'Select team category',
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedLeagueCategories = value;
                  });
                },
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
              GFButton(
                onPressed: (hasAcceptedTerms && !isProcessing)
                    ? _handleCreate
                    : null,
                disabledColor: colors.color6,
                disabledTextColor: colors.gray1,
                text: "Create",
                size: GFSize.MEDIUM,
                color: colors.color9,
                fullWidthButton: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreate() async {
    setState(() => isProcessing = true);
    try {
      final multipartFile = teamLogoController.multipartFile;
      validateTeamFields(
        teamNameController: teamNameController,
        selectedBarangay: selectedBarangay,
        phoneNumber: phoneNumber,
        teamMotoController: teamMotoController,
        teamLogo: multipartFile,
        teamCoachController: teamCoachController,
        teamAssistantCoachController: teamAssistantCoachController,
        selectedLeagueCategory: selectedLeagueCategories,
      );

      final newTeam = CreateTeam(
        team_name: teamNameController.text,
        team_address: selectedBarangay!,
        contact_number: phoneNumber!,
        team_motto: teamMotoController.text,
        team_logo: multipartFile!,
        coach_name: teamCoachController.text,
        assistant_coach_name: teamAssistantCoachController.text,
        team_category: selectedLeagueCategories!,
      );

      final response = await TeamService.createTeam(newTeam.toFormData());

      final _ = await ref.refresh(teamsProvider.future);
      if (mounted) {
        showAppSnackbar(
          context,
          message: response.message,
          title: "Success",
          variant: SnackbarVariant.success,
        );

        Navigator.pop(context);
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
