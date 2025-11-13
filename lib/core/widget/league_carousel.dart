import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/screens/league_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bogoballers/core/providers/leauge_provider.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class LeagueCarousel extends ConsumerWidget {
  final String accountType;
  const LeagueCarousel({super.key, required this.accountType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final leagueAsync = ref.watch(leagueCarouselItemsProvider);

    return leagueAsync.when(
      loading: () => const SizedBox.shrink(),

      error: (e, _) => Center(child: Text("Error: $e")),
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text("No leagues available"));
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
          ),
          items: items.map((league) {
            return Builder(
              builder: (context) {
                return Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),

                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeagueScreen(
                          permissions: userPermission(accountType),
                          result: league,
                        ),
                      ),
                    ),

                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colors.gray1,
                        image: league.bannerUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(league.bannerUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),

                      child: Container(
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black54, Colors.transparent],
                          ),
                        ),
                        child: Text(
                          league.leagueTitle,
                          style: TextStyle(
                            color: colors.contrast,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
