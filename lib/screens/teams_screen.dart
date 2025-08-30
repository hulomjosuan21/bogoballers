import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsScreen extends ConsumerStatefulWidget {
  final String? search; // <-- accept search param

  const TeamsScreen({super.key, this.search});

  @override
  ConsumerState<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends ConsumerState<TeamsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teams")),
      body: Center(
        child: Text(
          widget.search != null
              ? "Searching teams for: ${widget.search}"
              : "Showing all teams",
        ),
      ),
    );
  }
}
