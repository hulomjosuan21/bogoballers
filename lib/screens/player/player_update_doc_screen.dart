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

class _PlayerUpdateDocSectionState extends State<PlayerUpdateDocSection> {
  final List<Map<String, String>> requiredDocs = [
    {"value": "Birth Certificate", "format": "single"},
    {"value": "Live Birth", "format": "single"},
    {"value": "Barangay Clearance", "format": "single"},
    {"value": "Medical Certificate", "format": "single"},
    {"value": "National ID", "format": "back_to_back"},
    {"value": "PSA Birth Certificate", "format": "back_to_back"},
    {"value": "PSA Marriage Certificate", "format": "back_to_back"},
    {"value": "PSA CENOMAR (Certificate of No Marriage)", "format": "multiple"},
  ];

  final Map<String, List<AppImagePickerController>> _controllersMap = {};
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
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

  Future<void> _uploadAllDocuments() async {
    final dio = DioClient().client;
    setState(() => _isUploading = true);

    try {
      for (final doc in requiredDocs) {
        final docType = doc["value"]!;
        final format = doc["format"]!;
        final controllers = _controllersMap[docType]!;

        // Collect Multipart files for this document
        final files = <MultipartFile>[];
        for (final controller in controllers) {
          final file = controller.multipartFile;
          if (file != null) files.add(file);
        }

        // Skip empty documents (not uploaded yet)
        if (files.isEmpty) continue;

        // Prepare FormData
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

        // ✅ Backend response: { "message": "...", "document_urls": [...] }
        if (response.statusCode == 200 || response.statusCode == 201) {
          final message = response.data["message"] ?? "Upload completed.";
          final urls = (response.data["document_urls"] as List).cast<String>();

          log("✅ $message");

          // 🔁 Update local validDocuments list
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
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All documents uploaded successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
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
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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

        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: requiredDocs.length,
          itemBuilder: (context, index) {
            final doc = requiredDocs[index];
            final docType = doc["value"]!;
            final format = doc["format"]!;
            final existing = widget.validDocuments.firstWhere(
              (d) => d.documentType == docType,
              orElse: () => PlayerValidDocModel.empty(docType, format),
            );

            final controllers = _controllersMap[docType]!;
            final urls = existing.documentUrls;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      docType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (format == "single") ...[
                            _buildImagePickerWithLabelAndButton(
                              label: "Single",
                              controller: controllers.first,
                              url: urls.isNotEmpty ? urls.first : null,
                              colors: colors,
                            ),
                          ] else if (format == "back_to_back") ...[
                            _buildImagePickerWithLabelAndButton(
                              label: "Front",
                              controller: controllers[0],
                              url: urls.isNotEmpty ? urls[0] : null,
                              colors: colors,
                            ),
                            const SizedBox(width: 16),
                            _buildImagePickerWithLabelAndButton(
                              label: "Back",
                              controller: controllers.length > 1
                                  ? controllers[1]
                                  : AppImagePickerController(),
                              url: urls.length > 1 ? urls[1] : null,
                              colors: colors,
                            ),
                          ] else if (format == "multiple") ...[
                            Row(
                              children: [
                                for (
                                  int i = 0;
                                  i < controllers.length;
                                  i++
                                ) ...[
                                  _buildImagePickerWithLabelAndButton(
                                    label: "Image ${i + 1}",
                                    controller: controllers[i],
                                    url: urls.length > i ? urls[i] : null,
                                    colors: colors,
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                GFButton(
                                  onPressed: () => _addPage(docType),
                                  text: "+ Add Image",
                                  color: colors.color9,
                                  size: GFSize.SMALL,
                                  shape: GFButtonShape.standard,
                                  type: GFButtonType.outline,
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // --- Upload Button ---
        const SizedBox(height: 12),
        Center(
          child: GFButton(
            onPressed: _isUploading ? null : _uploadAllDocuments,
            text: _isUploading ? "Uploading..." : "Upload Documents",
            color: colors.color9,
            size: GFSize.MEDIUM,
            shape: GFButtonShape.pills,
            type: GFButtonType.solid,
          ),
        ),
      ],
    );
  }

  /// Helper builder for labeled picker + button
  Widget _buildImagePickerWithLabelAndButton({
    required AppImagePickerController controller,
    required AppThemeColors colors,
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
          aspectRatio: 9 / 16,
          width: 120,
          assetPath: url,
        ),
        const SizedBox(height: 6),
        GFButton(
          onPressed: controller.pickImage,
          text: 'Select Image',
          color: colors.color9,
          size: GFSize.SMALL,
          shape: GFButtonShape.standard,
          type: GFButtonType.outline,
        ),
      ],
    );
  }
}
