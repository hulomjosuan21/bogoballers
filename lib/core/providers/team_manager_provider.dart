import 'package:bogoballers/core/models/user_model.dart';
import 'package:bogoballers/core/services/team_manager_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamManagerProvider = FutureProvider<User>((_) async {
  return await TeamManagerServices.fetchTeamManager();
});
