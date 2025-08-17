import 'package:bogoballers/core/models/team_manager.dart';
import 'package:bogoballers/core/services/team_manager_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamManagerProvider = FutureProvider<TeamManagerModel>((_) async {
  return await TeamManagerServices.fetchTeamManager();
});
