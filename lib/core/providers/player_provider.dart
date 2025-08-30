import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/services/player/player_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider = FutureProvider<PlayerModel>((_) async {
  return await PlayerService.fetchPlayer();
});

final fetchAllPlayersProvider =
    FutureProvider.family<List<PlayerModel>, String?>((ref, search) async {
      return await PlayerService.fetchAllPlayers(search);
    });
