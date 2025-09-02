import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league.dart';
import 'package:bogoballers/core/models/league_admin_model.dart';
import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/search_service.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/core/widget/search_screem_list_tiles.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  final FocusNode _searchFocusNode = FocusNode();
  late final String? accountType;
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _getAccountTypeFromStorage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getAccountTypeFromStorage() async {
    final entity = await getEntityCredentialsFromStorageOrNull();
    accountType = entity?.accountType;
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    try {
      final searchResult = await _searchService.searchEntity(query);

      if (searchResult['total_results'] == 0) {
        if (mounted) {
          showAppSnackbar(
            context,
            message: "no results found",
            title: "Not Found",
            variant: SnackbarVariant.info,
          );
        }
        return;
      }

      setState(() {
        _searchResults = searchResult['results'];
      });
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          focusNode: _searchFocusNode,
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) async => await _performSearch(value.trim()),
          decoration: InputDecoration(
            hintText: "Search...",
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(Sizes.spaceMd),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: Icon(Icons.search, color: colors.gray11),
                    onPressed: () async =>
                        await _performSearch(_searchController.text.trim()),
                  ),
          ),
        ),
        flexibleSpace: Container(color: colors.gray1),
      ),
      body: Column(
        children: [
          SizedBox(height: Sizes.spaceMd),

          if (_searchController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.all(Sizes.spaceMd),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Sizes.radiusMd),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://res.cloudinary.com/dod3lmxm6/image/upload/v1756398128/25443958_7089019_f9pzyh.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: _searchResults.isEmpty && !_isSearching
                  ? const Center(child: Text("No results"))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        final type = result['type'];
                        final data = result['data'];

                        if (type == 'player') {
                          final player = PlayerModel.fromMap(data);
                          return PlayerSearchResultListTile(
                            result: player,
                            permissions: userPermission(accountType),
                          );
                        } else if (type == 'team') {
                          final team = TeamModelForSearchResult.fromMap(data);
                          return TeamSearchResultListTile(
                            result: team,
                            permissions: userPermission(accountType),
                          );
                        } else if (type == 'league_administrator') {
                          final leagueAdmin = LeagueAdminModel.fromMap(data);
                          return LeagueAdministratorSearchResultListTile(
                            result: leagueAdmin,
                            permissions: userPermission(accountType),
                          );
                        } else if (type == 'league') {
                          final league = LeagueModel.fromMap(data);
                          return LeagueSearchResultListTile(
                            result: league,
                            permissions: userPermission(accountType),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
            ),
        ],
      ),
    );
  }
}
