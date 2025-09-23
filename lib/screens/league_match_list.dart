import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/providers/league_match_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:intl/intl.dart';

class LeagueMatchesList extends ConsumerStatefulWidget {
  const LeagueMatchesList({super.key});

  @override
  ConsumerState<LeagueMatchesList> createState() => _LeagueMatchesListState();
}

class _LeagueMatchesListState extends ConsumerState<LeagueMatchesList> {
  Future<void> _refreshMatches() async {
    // ignore: unused_result
    await ref.refresh(leagueMatchesProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final matchesAsync = ref.watch(leagueMatchesProvider);

    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return const Center(child: Text("No upcoming matches yet."));
        }

        return RefreshIndicator(
          onRefresh: _refreshMatches,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: matches.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    "Upcoming Matches",
                    style: TextStyle(
                      fontSize: Sizes.fontSizeMd,
                      fontWeight: FontWeight.bold,
                      color: colors.gray9,
                    ),
                  ),
                );
              }

              final match = matches[index - 1];
              final home = match.homeTeam?.teamName ?? "TBD";
              final away = match.awayTeam?.teamName ?? "TBD";
              final homeScore = match.homeTeamScore?.toString() ?? "-";
              final awayScore = match.awayTeamScore?.toString() ?? "-";
              final schedule = match.scheduledDate != null
                  ? DateTime.tryParse(match.scheduledDate!) != null
                        ? DateFormat('MMM dd, yyyy – hh:mm a').format(
                            DateTime.parse(match.scheduledDate!).toLocal(),
                          )
                        : match.scheduledDate
                  : "Not Scheduled";

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(Sizes.spaceMd),
                decoration: BoxDecoration(
                  color: colors.gray1,
                  borderRadius: BorderRadius.circular(Sizes.radiusMd),
                  border: Border.all(
                    color: colors.gray6,
                    width: Sizes.borderWidthSm,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(home)),
                        Text(
                          "$homeScore - $awayScore",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Expanded(child: Text(away, textAlign: TextAlign.end)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "League: ${match.league.leagueTitle}",
                      style: TextStyle(color: colors.gray9, fontSize: 12),
                    ),
                    Text(
                      "Court: ${match.court ?? "TBD"}",
                      style: TextStyle(color: colors.gray9, fontSize: 12),
                    ),
                    Text(
                      "Scheduled: $schedule",
                      style: TextStyle(color: colors.gray9, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        if (kDebugMode) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: err,
              stack: stack,
              library: 'leagueMatchesProvider',
              context: ErrorDescription('while loading league matches'),
            ),
          );
          throw err;
        }
        return Center(child: Text("Error loading matches"));
      },
    );
  }
}
