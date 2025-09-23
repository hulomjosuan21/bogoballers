import 'package:bogoballers/core/models/leagueMatch.dart';
import 'package:bogoballers/core/services/league_match_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leagueMatchesProvider = FutureProvider<List<LeagueMatchModel>>((_) async {
  return await LeagueMatchService.getAllByUserId();
});
