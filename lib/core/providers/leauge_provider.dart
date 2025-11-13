import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/services/league/league_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leagueCarouselItemsProvider = FutureProvider<List<League>>((_) async {
  return await LeagueService.leagueCarouselItems();
});
