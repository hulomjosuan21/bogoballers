import 'dart:convert';
import 'package:flutter/services.dart';

Future<({List<String> barangays, List<String> leagueCategories})>
loadStaticData() async {
  try {
    final barangaysJson = await rootBundle.loadString(
      'assets/json/barangays.json',
    );
    final List<dynamic> barangaysData = json.decode(barangaysJson);
    final List<String> barangays = barangaysData
        .map((e) => e.toString())
        .toList();

    final leagueCategoriesJson = await rootBundle.loadString(
      'assets/json/league_categories.json',
    );
    final List<dynamic> leagueCategoriesData = json.decode(
      leagueCategoriesJson,
    );
    final List<String> leagueCategories = leagueCategoriesData
        .map((e) => e.toString())
        .toList();

    return (barangays: barangays, leagueCategories: leagueCategories);
  } catch (e) {
    return (barangays: <String>[], leagueCategories: <String>[]);
  }
}
