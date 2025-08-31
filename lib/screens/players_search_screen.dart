import 'dart:convert';
import 'package:bogoballers/core/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class PlayersSeachScreen extends StatefulWidget {
  final Map<String, dynamic>? searchResults;

  const PlayersSeachScreen({super.key, this.searchResults});

  @override
  State<PlayersSeachScreen> createState() => _PlayersSeachScreenState();
}

class _PlayersSeachScreenState extends State<PlayersSeachScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final encoder = const JsonEncoder.withIndent('  ');

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Players")),
      body: Column(
        children: [
          if (widget.searchResults != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Sizes.spaceMd),
                child: Text(
                  encoder.convert(widget.searchResults?['results']),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: colors.gray11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
