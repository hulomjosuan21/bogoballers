import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class EntityLeagueScreen extends StatelessWidget {
  const EntityLeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("League"),
        flexibleSpace: Container(color: colors.color1),
      ),
    );
  }
}
