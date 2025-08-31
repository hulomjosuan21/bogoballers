import 'package:bogoballers/core/services/search_service.dart';
import 'package:bogoballers/screens/players_search_screen.dart';
import 'package:bogoballers/screens/teams_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService(); // Your API service
  bool _isSearching = false;

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      // Call your unified search endpoint
      final searchResult = await _searchService.searchTeamOrPlayer(query);

      if (searchResult['total_results'] == 0) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No results found")));
        }
        return;
      }

      // Determine which entity type has more results
      final playersCount = searchResult['players_count'] as int;
      final teamsCount = searchResult['teams_count'] as int;

      if (mounted) {
        if (playersCount > teamsCount) {
          // More players found - redirect to Players Search Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayersSeachScreen(
                searchResults: searchResult, // Pass the results if needed
              ),
            ),
          );
        } else if (teamsCount > playersCount) {
          // More teams found - redirect to Team Search Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamSearchScreen(
                searchResults: searchResult, // Pass the results if needed
              ),
            ),
          );
        } else {
          // Equal results or both zero - show selection dialog
          _showSearchResultsDialog(
            query,
            playersCount,
            teamsCount,
            searchResult,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  void _showSearchResultsDialog(
    String query,
    int playersCount,
    int teamsCount,
    Map<String, dynamic> searchResult,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Results for "$query"'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Players ($playersCount)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PlayersSeachScreen(searchResults: searchResult),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.groups),
              title: Text('Teams ($teamsCount)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TeamSearchScreen(searchResults: searchResult),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) async {
            await _performSearch(value.trim());
          },
          decoration: InputDecoration(
            hintText: "Search players or teams...",
            hintStyle: TextStyle(color: colors.gray7),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.search, color: colors.gray11),
                    onPressed: () async {
                      await _performSearch(_searchController.text.trim());
                    },
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Keep your existing body for manual navigation
          ListTile(
            leading: Icon(Icons.person, color: colors.color9),
            title: const Text("Players"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayersSeachScreen(),
              ),
            ),
          ),
          Divider(color: colors.gray4),
          ListTile(
            leading: Icon(Icons.groups, color: colors.color9),
            title: const Text("Teams"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TeamSearchScreen()),
            ),
          ),
          const SizedBox(height: 20),
          // Optional: Show recent searches or suggestions
          if (!_isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Start typing to search across players and teams",
                style: TextStyle(color: colors.gray7, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
