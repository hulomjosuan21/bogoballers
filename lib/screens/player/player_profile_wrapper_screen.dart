import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/providers/player_provider.dart';
import 'package:bogoballers/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerProfileWrapperScreen extends ConsumerStatefulWidget {
  const PlayerProfileWrapperScreen({super.key});

  @override
  ConsumerState<PlayerProfileWrapperScreen> createState() =>
      _PlayerProfileWrapperScreenState();
}

class _PlayerProfileWrapperScreenState
    extends ConsumerState<PlayerProfileWrapperScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playerAsyncValue = ref.watch(playerProvider);

    return playerAsyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (player) {
        return PlayerScreen(
          permissions: [
            Permission.editPlayerProfile,
            Permission.uploadDocPlayer,
          ],
          result: player,
        );
      },
    );
  }
}
