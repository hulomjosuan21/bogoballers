import 'dart:convert';
import 'package:bogoballers/core/constants/size.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class TeamSearchScreen extends StatefulWidget {
  final Map<String, dynamic>? searchResults;

  const TeamSearchScreen({super.key, this.searchResults});

  @override
  State<TeamSearchScreen> createState() => _TeamSearchScreenState();
}

class _TeamSearchScreenState extends State<TeamSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final encoder = const JsonEncoder.withIndent('  ');

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Teams")),
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
