import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class PlayerHomeScreen extends StatelessWidget {
  const PlayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Center(child: Text("Home",style: TextStyle(color: colors.textPrimary),)),
    );
  }
}