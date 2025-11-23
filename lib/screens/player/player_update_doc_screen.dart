import 'dart:developer';
import 'package:bogoballers/core/models/player_valid_doc_model.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:bogoballers/core/network/dio_client.dart';

class PlayerUpdateDocSection extends StatefulWidget {
  final String playerId;
  final List<PlayerValidDocModel> validDocuments;

  const PlayerUpdateDocSection({
    super.key,
    required this.playerId,
    required this.validDocuments,
  });

  @override
  State<PlayerUpdateDocSection> createState() => _PlayerUpdateDocSectionState();
}

class _PlayerUpdateDocSectionState extends State<PlayerUpdateDocSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> requiredDocs = [
    {
      "value": "NSO Birth Certificate",
      "format": "single",
      "aspectRatio": 9 / 16,
    },
    {
      "value": "PSA Birth Certificate",
      "format": "single",
      "aspectRatio": 9 / 16,
    },
    {"value": "Live Birth", "format": "single", "aspectRatio": 9 / 16},
    {"value": "Barangay Clearance", "format": "single", "aspectRatio": 9 / 16},
    {"value": "Medical Certificate", "format": "single", "aspectRatio": 9 / 16},
    {"value": "National ID", "format": "back_to_back", "aspectRatio": 3 / 2},
    {
      "value": "PSA Marriage Certificate",
      "format": "single",
      "aspectRatio": 9 / 16,
    },
    {
      "value": "PSA CENOMAR (Certificate of No Marriage)",
      "format": "single",
      "aspectRatio": 9 / 16,
    },
  ];

  final Map<String, List<AppImagePickerController>> _controllersMap = {};
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Initialize Tab Controller
    _tabController = TabController(length: requiredDocs.length, vsync: this);

    // Listen to tab changes to update the button text
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    for (final doc in requiredDocs) {
      final docType = doc["value"]!;
      final format = doc["format"]!;
      final existing = widget.validDocuments.firstWhere(
        (d) => d.documentType == docType,
        orElse: () => PlayerValidDocModel.empty(docType, format),
      );

      final controllers = <AppImagePickerController>[];

      if (existing.documentUrls.isNotEmpty) {
        for (final _ in existing.documentUrls) {
          controllers.add(AppImagePickerController());
        }
      } else {
        if (format == "back_to_back") {
          controllers.add(AppImagePickerController());
          controllers.add(AppImagePickerController());
        } else {
          controllers.add(AppImagePickerController());
        }
      }

      _controllersMap[docType] = controllers;
    }
  }

  void _addPage(String docType) {
    setState(() {
      _controllersMap[docType]?.add(AppImagePickerController());
    });
  }

  String get _currentButtonText {
    final currentIndex = _tabController.index;
    final docType = requiredDocs[currentIndex]["value"];

    final existing = widget.validDocuments.firstWhere(
      (d) => d.documentType == docType,
      orElse: () => PlayerValidDocModel.empty(docType, ''),
    );

    return existing.documentUrls.isNotEmpty
        ? "Save Changes"
        : "Upload Document";
  }

  Future<void> _uploadCurrentDocument() async {
    final currentIndex = _tabController.index;
    final docConfig = requiredDocs[currentIndex];
    final docType = docConfig["value"]!;
    final format = docConfig["format"]!;

    final dio = DioClient().client;
    setState(() => _isUploading = true);

    try {
      final controllers = _controllersMap[docType]!;

      final files = <MultipartFile>[];
      for (final controller in controllers) {
        final file = controller.multipartFile;
        if (file != null) files.add(file);
      }

      if (files.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No new images selected to upload.")),
          );
        }
        return;
      }

      final formData = FormData.fromMap({
        "document_type": docType,
        "document_format": format,
        "files": files,
      });

      log("📤 Uploading: $docType (${files.length} file(s))");

      final response = await dio.post(
        "/player/upload-doc/${widget.playerId}",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.data["message"] ?? "Upload completed.";
        final urls = (response.data["document_urls"] as List).cast<String>();

        log("✅ $message");

        setState(() {
          final existingIndex = widget.validDocuments.indexWhere(
            (d) => d.documentType == docType,
          );

          final newDoc = PlayerValidDocModel(
            docId: existingIndex != -1
                ? widget.validDocuments[existingIndex].docId
                : null,
            playerId: widget.playerId,
            documentType: docType,
            documentUrls: urls,
            documentFormat: format,
            uploadedAt: DateTime.now().toIso8601String(),
          );

          if (existingIndex != -1) {
            widget.validDocuments[existingIndex] = newDoc;
          } else {
            widget.validDocuments.add(newDoc);
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e, st) {
      log("❌ Upload failed: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload failed. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Player Document Uploads",
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "These documents are required for player verification and league eligibility. "
              "You can upload them now or later, but make sure to provide all files that "
              "your league requires before participating in any league.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.gray6,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),

        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: colors.color9,
          unselectedLabelColor: colors.textSecondary,
          indicatorColor: colors.color9,
          dividerColor: colors.gray4,
          tabAlignment: TabAlignment.start,
          tabs: requiredDocs.map((doc) {
            return Tab(text: doc["value"] as String);
          }).toList(),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 450,
          child: TabBarView(
            controller: _tabController,
            children: requiredDocs.map((doc) {
              return _buildDocUploadPanel(doc, colors);
            }).toList(),
          ),
        ),

        const SizedBox(height: 12),
        Center(
          child: GFButton(
            onPressed: _isUploading ? null : _uploadCurrentDocument,
            text: _isUploading ? "Processing..." : _currentButtonText,
            color: colors.color9,
            size: GFSize.MEDIUM,
          ),
        ),
      ],
    );
  }

  Widget _buildDocUploadPanel(Map<String, dynamic> doc, AppThemeColors colors) {
    final docType = doc["value"]!;
    final format = doc["format"]!;
    final existing = widget.validDocuments.firstWhere(
      (d) => d.documentType == docType,
      orElse: () => PlayerValidDocModel.empty(docType, format),
    );

    final aspectRatio = doc["aspectRatio"];
    final controllers = _controllersMap[docType]!;
    final urls = existing.documentUrls;

    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(width: 0.5, color: colors.gray6),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              docType,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              existing.documentUrls.isNotEmpty
                  ? "Status: Uploaded ✅"
                  : "Status: Pending ⚠️",
              style: TextStyle(
                fontSize: 12,
                color: existing.documentUrls.isNotEmpty
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (format == "single") ...[
                      _buildImagePickerWithLabelAndButton(
                        aspectRatio: aspectRatio,
                        label: "Single View",
                        controller: controllers.first,
                        url: urls.isNotEmpty ? urls.first : null,
                        colors: colors,
                      ),
                    ] else if (format == "back_to_back") ...[
                      _buildImagePickerWithLabelAndButton(
                        aspectRatio: aspectRatio,
                        label: "Front",
                        controller: controllers[0],
                        url: urls.isNotEmpty ? urls[0] : null,
                        colors: colors,
                      ),
                      const SizedBox(width: 16),
                      _buildImagePickerWithLabelAndButton(
                        aspectRatio: aspectRatio,
                        label: "Back",
                        controller: controllers.length > 1
                            ? controllers[1]
                            : AppImagePickerController(),
                        url: urls.length > 1 ? urls[1] : null,
                        colors: colors,
                      ),
                    ] else if (format == "multiple") ...[
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (int i = 0; i < controllers.length; i++) ...[
                              _buildImagePickerWithLabelAndButton(
                                aspectRatio: aspectRatio,
                                label: "Image ${i + 1}",
                                controller: controllers[i],
                                url: urls.length > i ? urls[i] : null,
                                colors: colors,
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: GFButton(
                                onPressed: () => _addPage(docType),
                                text: "+ Add Image",
                                color: colors.color9,
                                size: GFSize.SMALL,
                                shape: GFButtonShape.standard,
                                type: GFButtonType.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerWithLabelAndButton({
    required AppImagePickerController controller,
    required AppThemeColors colors,
    required double aspectRatio,
    String? label,
    String? url,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        const SizedBox(height: 6),
        AppImagePicker(
          controller: controller,
          aspectRatio: aspectRatio,
          width: 130,
          assetPath: url,
        ),
        const SizedBox(height: 8),
        GFButton(
          onPressed: controller.pickImage,
          text: url != null ? 'Change' : 'Select',
          color: colors.color9,
          size: GFSize.SMALL,
          shape: GFButtonShape.standard,
          type: GFButtonType.outline,
        ),
      ],
    );
  }
}
