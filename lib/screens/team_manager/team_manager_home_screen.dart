import 'dart:convert';
import 'package:bogoballers/core/helpers/logout.dart';
import 'package:bogoballers/core/providers/team_manager_provider.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/test_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamManagerHomeScreen extends ConsumerStatefulWidget {
  const TeamManagerHomeScreen({super.key});

  @override
  ConsumerState<TeamManagerHomeScreen> createState() =>
      _TeamManagerHomeScreenState();
}

class _TeamManagerHomeScreenState extends ConsumerState<TeamManagerHomeScreen> {
  String? _userId;
  String? _entityId;

  @override
  Widget build(BuildContext context) {
    final teamManagerAsync = ref.watch(teamManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(onTap: testWriteID, child: const Text('Test')),
              PopupMenuItem(
                onTap: () => logout(context),
                child: const Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final info = await getEntityCredentialsFromStorage();
                  setState(() {
                    _userId = info.userId;
                    _entityId = info.entityId;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child: const Text("Show IDs"),
            ),
          ),

          // 🔹 Display the IDs if available
          if (_userId != null && _entityId != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "User ID: $_userId\nEntity ID: $_entityId",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // 🔹 Keep your JSON output below
          Expanded(
            child: teamManagerAsync.when(
              data: (teamManager) {
                const encoder = JsonEncoder.withIndent("  ");
                final jsonString = encoder.convert(teamManager.toMap());

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    jsonString,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text("Error: $err")),
            ),
          ),
        ],
      ),
    );
  }
}
