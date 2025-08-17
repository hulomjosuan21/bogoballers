import 'package:bogoballers/core/models/team_model.dart';
import 'package:bogoballers/core/services/team_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamsProvider = FutureProvider<List<TeamModel>>((_) async {
  return await TeamService.fetchTeams();
});
