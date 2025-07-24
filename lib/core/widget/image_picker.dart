import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:image/image.dart' as img; // Add image package for resizing

/// Helper class for image cropping parameters
class CropParams {
  final Uint8List imageData;
  final Rect cropRect;

  CropParams(this.imageData, this.cropRect);
}

/// Crops image data using Dart's UI library in an isolate
Future<Uint8List?> cropImageDataWithDartLibrary(CropParams params) async {
  try {
    final ui.Codec codec = await ui.instantiateImageCodec(params.imageData);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final paint = Paint();
    final src = params.cropRect;
    final dst = Rect.fromLTWH(0, 0, src.width, src.height);

    canvas.drawImageRect(image, src, dst, paint);

    final ui.Image croppedImage = await recorder.endRecording().toImage(
      src.width.toInt(),
      src.height.toInt(),
    );

    final ByteData? byteData = await croppedImage.toByteData(
      format: ui.ImageByteFormat.png,
    );

    // Clean up resources
    image.dispose();
    croppedImage.dispose();
    codec.dispose();

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

    final Uint8List? rawData = await state.rawImageData;
    final Rect? cropRect = state.getCropRect();
    if (rawData == null || cropRect == null) return;

    // Offload cropping to an isolate
    final croppedBytes = await compute(
      cropImageDataWithDartLibrary,
      CropParams(rawData, cropRect),
    );

    if (croppedBytes != null && mounted) {
      Navigator.pop(context, croppedBytes);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to crop image.')),
      );
    }
  }

  void _resetCrop() {
    final state = _editorKey.currentState;
    state?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.7;

    return AlertDialog(
      elevation: 4,
      title: Row(
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
            icon: const Icon(Icons.close, size: 18),
          ),
        ],
      ),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
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
            // Optimize memory usage
            initCropRectType: InitCropRectType.imageRect,
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

  dio.MultipartFile? get multipartFile => _state?._multipartFile;

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
      final bytes = data.buffer.asUint8List();
      // Resize asset image to reduce memory usage
      final resized = await _resizeImage(bytes, 512);
      if (mounted) {
        setState(() {
          _avatarBytes = resized;
        });
      }
    }
  }

  /// Resizes image to a maximum dimension while preserving aspect ratio
  Future<Uint8List> _resizeImage(Uint8List bytes, int maxDimension) async {
    final image = img.decodeImage(bytes);
    if (image == null) return bytes;

    final width = image.width;
    final height = image.height;
    if (width <= maxDimension && height <= maxDimension) return bytes;

    final scale = maxDimension / (width > height ? width : height);
    final resized = img.copyResize(
      image,
      width: (width * scale).toInt(),
      height: (height * scale).toInt(),
    );

    return Uint8List.fromList(img.encodePng(resized));
  }

  Future<void> _selectAndCropImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result?.files.single.path == null) return;

    final filePath = result!.files.single.path!;
    final fileName = result.files.single.name;
    final fileExtension = fileName.split('.').last.toLowerCase();

    // Validate file extension case-insensitively
    if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unsupported file type! Please select a JPG, JPEG, or PNG image.',
            ),
          ),
        );
      }
      return;
    }

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    // Resize image before processing
    final resizedBytes = await _resizeImage(bytes, 1024);
    final decoded = await decodeImageFromList(resizedBytes);

    Uint8List? finalBytes;

    if (decoded.width != decoded.height) {
      if (!mounted) return;
      final cropped = await showDialog<Uint8List>(
        context: context,
        builder: (_) => CropPopup(
          file: File.fromUri(Uri.file(filePath)),
          aspectRatio: widget.aspectRatio,
        ),
      );
      finalBytes = cropped;
    } else {
      finalBytes = resizedBytes;
    }

    if (finalBytes != null && mounted) {
      setState(() {
        _avatarBytes = finalBytes;
        _fileName = fileName;
        _multipartFile = dio.MultipartFile.fromBytes(
          finalBytes as List<int>,
          filename: fileName,
          contentType: dio.DioMediaType.parse(
            fileExtension == 'png' ? 'image/png' : 'image/jpeg',
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      key: ValueKey(_fileName), // Prevent unnecessary rebuilds
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _avatarBytes != null
              ? Image.memory(
                  _avatarBytes!,
                  width: widget.width,
                  height: widget.width / widget.aspectRatio,
                  fit: BoxFit.cover,
                  gaplessPlayback: true, // Smooth image transitions
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