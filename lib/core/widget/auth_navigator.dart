import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

RichText authNavigator(
  BuildContext context,
  String text,
  String textTo,
  void Function() callback,
) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  return RichText(
    text: TextSpan(
      text: text,
      style: TextStyle(color: colors.gray11, fontSize: 12),
      children: [
        TextSpan(
          text: textTo,
          style: TextStyle(
            color: colors.color9,
            fontWeight: FontWeight.w600,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              callback();
            },
        ),
      ],
    ),
  );
}
