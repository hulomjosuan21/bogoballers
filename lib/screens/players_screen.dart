import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayersScreen extends ConsumerStatefulWidget {
  final String? search;

  const PlayersScreen({super.key, this.search});

  @override
  ConsumerState<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends ConsumerState<PlayersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players")),
      body: Center(
        child: Text(
          widget.search != null
              ? "Searching players for: ${widget.search}"
              : "Showing all players",
        ),
      ),
    );
  }
}
