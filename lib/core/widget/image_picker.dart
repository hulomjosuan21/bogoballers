import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

Future<Uint8List?> cropImageDataWithDartLibrary({
  required ExtendedImageEditorState state,
}) async {
  try {
    final Uint8List? data = await state.rawImageData;
    if (data == null) return null;

    final Rect? cropRect = state.getCropRect();
    if (cropRect == null) return null;

    final ui.Codec codec = await ui.instantiateImageCodec(data);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final paint = Paint();
    final src = cropRect;
    final dst = Rect.fromLTWH(0, 0, cropRect.width, cropRect.height);

    canvas.drawImageRect(image, src, dst, paint);

    final ui.Image croppedImage = await recorder.endRecording().toImage(
      cropRect.width.toInt(),
      cropRect.height.toInt(),
    );

    final ByteData? byteData = await croppedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return byteData?.buffer.asUint8List();
  } catch (e) {
    debugPrint("Crop error: $e");
    return null;
  }
}

/// A popup dialog for cropping images
class CropPopup extends StatefulWidget {
  final File file;
  final double? aspectRatio;

  const CropPopup({super.key, required this.file, required this.aspectRatio});

  @override
  State<CropPopup> createState() => _CropPopupState();
}

class _CropPopupState extends State<CropPopup> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();

  Future<void> _cropImage() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final Uint8List? croppedBytes = await cropImageDataWithDartLibrary(
      state: state,
    );

    if (croppedBytes != null) {
      if(!mounted) return;
      Navigator.pop(context, croppedBytes);
    }
  }

  void _resetCrop() {
    final state = _editorKey.currentState;
    if (state != null) {
      state.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return AlertDialog(
      elevation: 4,
      title: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Crop Image",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, size: 18),
            ),
          ],
        ),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          height: 470,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 400,
                height: 410,
                child: ExtendedImage.file(
                  widget.file,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _editorKey,
                  cacheRawData: true,
                  initEditorConfigHandler: (_) => EditorConfig(
                    cropAspectRatio: widget.aspectRatio,
                    cornerColor: colors.color8,
                    hitTestSize: 20,
                    cropRectPadding: const EdgeInsets.all(20),
                    maxScale: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        GFButton(
          onPressed: _resetCrop,
          text: 'Reset',
          color: colors.color9,
          shape: GFButtonShape.standard,
          size: GFSize.SMALL,
          type: GFButtonType.outline,
        ),
        GFButton(
          onPressed: _cropImage,
          text: 'Crop',
          color: colors.color9,
          shape: GFButtonShape.standard,
          size: GFSize.SMALL,
        ),
      ],
    );
  }
}

class AppImagePickerController {
  _AppImagePickerState? _state;

  /// Get the MultipartFile containing the selected and cropped image data
  dio.MultipartFile? get multipartFile => _state?._multipartFile;

  /// Call this to open the picker + cropper
  Future<void> pickImage() async {
    await _state?._selectAndCropImage();
  }
}

class AppImagePicker extends StatefulWidget {
  final AppImagePickerController controller;
  final double aspectRatio;
  final double width;
  final String? assetPath;

  const AppImagePicker({
    super.key,
    required this.controller,
    this.aspectRatio = 1.0,
    this.width = 180,
    this.assetPath,
  });

  @override
  State<AppImagePicker> createState() => _AppImagePickerState();
}

class _AppImagePickerState extends State<AppImagePicker> {
  Uint8List? _avatarBytes;
  dio.MultipartFile? _multipartFile;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    widget.controller._state = this;
    _loadAssetImage();
  }

  @override
  void dispose() {
    widget.controller._state = null;
    super.dispose();
  }

  Future<void> _loadAssetImage() async {
    if (widget.assetPath != null) {
      final ByteData data = await rootBundle.load(widget.assetPath!);
      setState(() {
        _avatarBytes = data.buffer.asUint8List();
      });
    }
  }

  Future<void> _selectAndCropImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
      ], // Match backend ALLOWED_EXTENSIONS
    );

    if (result?.files.single.path == null) return;

    final filePath = result!.files.single.path!;
    final fileName = result.files.single.name;
    final fileExtension = fileName.split('.').last.toLowerCase();

    // Validate file extension
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unsupported file type! Please select a JPG, JPEG, or PNG image.',
          ),
        ),
      );
      return;
    }

    final file = File(filePath);
    final decoded = await decodeImageFromList(await file.readAsBytes());

    Uint8List? finalBytes;

    if (decoded.width != decoded.height) {
      if(!mounted) return;
      final cropped = await showDialog<Uint8List>(
        context: context,
        builder: (_) => CropPopup(file: file, aspectRatio: widget.aspectRatio),
      );
      finalBytes = cropped;
    } else {
      finalBytes = await file.readAsBytes();
    }

    if (finalBytes != null) {
      setState(() {
        _avatarBytes = finalBytes;
        _fileName = fileName;
        _multipartFile = dio.MultipartFile.fromBytes(
          finalBytes as List<int>,
          filename: fileName,
          contentType: dio.DioMediaType.parse(
            fileExtension == 'png' ? 'image/png' : 'image/jpeg',
          ), // Correct MIME type as DioMediaType
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _avatarBytes != null
              ? Image.memory(
                  _avatarBytes!,
                  width: widget.width,
                  height: widget.width / widget.aspectRatio,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: widget.width,
                  height: widget.width / widget.aspectRatio,
                  color: colors.gray4,
                  child: Icon(Icons.image, size: 48, color: colors.gray1),
                ),
        ),
        if (_fileName != null) ...[
          const SizedBox(height: 8),
          Text(
            _fileName!,
            style: TextStyle(
              color: colors.gray11,
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ],
    );
  }
}
