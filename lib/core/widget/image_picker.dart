import 'dart:io';
import 'dart:ui'
    as ui; // dart:ui is still needed for Rect, but not for isolate work
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

// Import the image compression library
import 'package:flutter_image_compress/flutter_image_compress.dart';
// Import the image manipulation library (critical for isolate-safe cropping)
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class CropParams {
  final Uint8List imageData;
  final Rect cropRect;

  CropParams(this.imageData, this.cropRect);
}

// THIS IS THE FULLY CORRECTED, ISOLATE-SAFE VERSION
Future<Uint8List?> cropImageDataWithDartLibrary(CropParams params) async {
  try {
    // 1. Decode the image using the 'image' package, which is isolate-safe.
    final img.Image? originalImage = img.decodeImage(params.imageData);
    if (originalImage == null) {
      debugPrint("Crop error: Failed to decode image.");
      return null;
    }

    // 2. Perform the crop using the 'image' package's copyCrop function.
    // The Rect values need to be converted to integer coordinates.
    final img.Image croppedImage = img.copyCrop(
      originalImage,
      x: params.cropRect.left.toInt(),
      y: params.cropRect.top.toInt(),
      width: params.cropRect.width.toInt(),
      height: params.cropRect.height.toInt(),
    );

    // 3. Encode the newly cropped image back into a Uint8List (as a JPEG).
    return Uint8List.fromList(img.encodeJpg(croppedImage, quality: 95));
  } catch (e) {
    debugPrint("Crop error: $e");
    return null;
  }
}

/// A popup dialog for cropping images
class CropPopup extends StatefulWidget {
  final Uint8List imageBytes;
  final double? aspectRatio;

  const CropPopup({
    super.key,
    required this.imageBytes,
    required this.aspectRatio,
  });

  @override
  State<CropPopup> createState() => _CropPopupState();
}

class _CropPopupState extends State<CropPopup> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey();

  Future<void> _cropImage() async {
    final state = _editorKey.currentState;
    if (state == null) return;

    final Uint8List? rawData = state.rawImageData;
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to crop image.')));
    }
  }

  void _resetCrop() {
    _editorKey.currentState?.reset();
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
        child: ExtendedImage.memory(
          widget.imageBytes,
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
      final bytes = await _processAndNormalizeImage(
        data.buffer.asUint8List(),
        maxDimension: 512,
      );
      if (mounted && bytes != null) {
        setState(() {
          _avatarBytes = bytes;
        });
      }
    }
  }

  Future<Uint8List?> _processAndNormalizeImage(
    dynamic imageSource, {
    int maxDimension = 1024,
    int quality = 85,
  }) async {
    try {
      if (imageSource is String) {
        return await FlutterImageCompress.compressWithFile(
          imageSource,
          minWidth: maxDimension,
          minHeight: maxDimension,
          quality: quality,
          format: CompressFormat.jpeg,
        );
      } else if (imageSource is Uint8List) {
        return await FlutterImageCompress.compressWithList(
          imageSource,
          minWidth: maxDimension,
          minHeight: maxDimension,
          quality: quality,
          format: CompressFormat.jpeg,
        );
      }
      return null;
    } catch (e) {
      debugPrint("Image processing error: $e");
      return null;
    }
  }

  Future<void> _selectAndCropImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'heic', 'heif'],
    );

    if (result?.files.single.path == null) return;

    final file = result!.files.single;
    final filePath = file.path!;
    final originalFileName = file.name;

    final processedBytes = await _processAndNormalizeImage(
      filePath,
      maxDimension: 1024,
    );

    if (processedBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process image.')),
        );
      }
      return;
    }

    final decoded = await decodeImageFromList(processedBytes);
    Uint8List? finalBytes;

    final imageAspectRatio = decoded.width / decoded.height;
    final needsCrop = (imageAspectRatio - widget.aspectRatio).abs() > 0.01;

    if (needsCrop) {
      if (!mounted) return;
      final cropped = await showDialog<Uint8List>(
        context: context,
        builder: (_) => CropPopup(
          imageBytes: processedBytes,
          aspectRatio: widget.aspectRatio,
        ),
      );
      finalBytes = cropped;
    } else {
      finalBytes = processedBytes;
    }

    if (finalBytes != null && mounted) {
      final newFileName =
          '${p.basenameWithoutExtension(originalFileName)}.jpeg';

      setState(() {
        _avatarBytes = finalBytes;
        _fileName = newFileName;
        _multipartFile = dio.MultipartFile.fromBytes(
          finalBytes!,
          filename: newFileName,
          contentType: dio.DioMediaType.parse('image/jpeg'),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final aspectRatio = widget.aspectRatio;
    final width = widget.width;

    Widget imageWidget;

    if (_avatarBytes != null) {
      // Show newly picked image
      imageWidget = Image.memory(
        _avatarBytes!,
        width: width,
        height: width / aspectRatio,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else if (widget.assetPath != null) {
      // Show remote or asset image
      if (widget.assetPath!.startsWith('http')) {
        imageWidget = Image.network(
          widget.assetPath!,
          width: width,
          height: width / aspectRatio,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: width,
            height: width / aspectRatio,
            color: colors.gray4,
            child: Icon(Icons.broken_image, size: 48, color: colors.gray1),
          ),
        );
      } else {
        imageWidget = Image.asset(
          widget.assetPath!,
          width: width,
          height: width / aspectRatio,
          fit: BoxFit.cover,
        );
      }
    } else {
      // Placeholder (no image)
      imageWidget = Container(
        width: width,
        height: width / aspectRatio,
        color: colors.gray4,
        child: Icon(Icons.image, size: 48, color: colors.gray1),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }
}
