import 'package:bogoballers/core/models/player_model.dart';
import 'package:bogoballers/core/services/player_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProvider = FutureProvider<PlayerModel>((_) async {
  return await PlayerService.fetchPlayer();
});
