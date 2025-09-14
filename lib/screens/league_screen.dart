import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/widget/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class LeagueScreen extends StatelessWidget {
  final List<Permission> permissions;
  final League result;

  const LeagueScreen({
    super.key,
    required this.permissions,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text("League", style: TextStyle(color: colors.textPrimary)),
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (result.bannerUrl.isNotEmpty)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.radiusMd),
                  image: DecorationImage(
                    image: NetworkImage(result.bannerUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: Sizes.spaceMd),
            Text(
              result.leagueTitle,
              style: textTheme.headlineSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: Sizes.fontSizeMd,
              ),
            ),
            const SizedBox(height: Sizes.spaceSm),
            Text(
              result.leagueDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.textSecondary,
                fontSize: Sizes.fontSizeSm,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: Sizes.spaceLg),
            _buildInfoCard(
              context,
              title: 'League Details',
              icon: Icons.info_outline,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.location_on_outlined,
                  label: 'Address',
                  value: result.leagueAddress,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.calendar_today_outlined,
                  label: 'Season',
                  value: result.seasonYear.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.flag_outlined,
                  label: 'Status',
                  value: result.status,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.event_busy_outlined,
                  label: 'Registration Deadline',
                  value: DateFormat.yMMMMd().format(
                    DateTime.parse(result.registrationDeadline),
                  ),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.celebration_outlined,
                  label: 'Opening Date',
                  value: DateFormat.yMMMMd().format(
                    DateTime.parse(result.openingDate),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            _buildInfoCard(
              context,
              title: 'Categories',
              icon: Icons.category_outlined,
              children: [
                if (result.leagueCategories.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(Sizes.spaceMd),
                    child: Text(
                      'No categories available for this league yet.',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  )
                else
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: result.leagueCategories.length,
                    itemBuilder: (context, index) {
                      final category = result.leagueCategories[index];
                      return _CategoryListItem(
                        category: category,
                        permissions: permissions,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            _buildResourcesCard(context, result),
          ],
        ),
      ),
    );
  }

  Widget _buildResourcesCard(BuildContext context, League league) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return _buildInfoCard(
      context,
      title: 'Additional info',
      icon: Icons.groups_outlined,
      children: [
        DefaultTabController(
          length: 4,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: colors.color9,
                unselectedLabelColor: colors.textSecondary,
                indicatorColor: colors.color9,
                dividerColor: colors.gray6,
                tabs: const [
                  Tab(text: 'Officials'),
                  Tab(text: 'Referees'),
                  Tab(text: 'Courts'),
                  Tab(text: 'Sponsors'),
                ],
              ),
              SizedBox(
                height: 220,
                child: TabBarView(
                  children: [
                    _buildOfficialList(context, league.leagueOfficials),
                    _buildRefereeList(context, league.leagueReferees),
                    _buildCourtList(context, league.leagueCourts),
                    _buildAffiliateList(context, league.leagueAffiliates),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfficialList(
    BuildContext context,
    List<LeagueOfficial> officials,
  ) {
    if (officials.isEmpty) {
      return const Center(child: Text('No officials listed.'));
    }
    return ListView.builder(
      itemCount: officials.length,
      itemBuilder: (context, index) {
        final official = officials[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(official.photo)),
          title: Text(official.fullName),
          subtitle: Text(official.role),
        );
      },
    );
  }

  // ... Similar list builders for Referees, Courts, and Affiliates
  Widget _buildRefereeList(
    BuildContext context,
    List<LeagueReferee> referees,
  ) => Container();
  Widget _buildCourtList(BuildContext context, List<LeagueCourt> courts) =>
      Container();
  Widget _buildAffiliateList(
    BuildContext context,
    List<LeagueAffiliate> affiliates,
  ) => Container();
}

// --- League Category Screen ---

class LeagueCategoryScreen extends StatelessWidget {
  final LeagueCategory leagueCategory;
  final List<Permission> permissions;

  const LeagueCategoryScreen({
    super.key,
    required this.leagueCategory,
    required this.permissions,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          leagueCategory.categoryName,
          style: TextStyle(color: colors.textPrimary),
        ),
        backgroundColor: colors.surface,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              context,
              title: 'Category Details & Rules',
              icon: Icons.shield_outlined,
              children: [
                InfoTile(
                  colors: colors,
                  icon: Icons.groups_outlined,
                  label: 'Max Teams',
                  value: leagueCategory.maxTeam.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.person_search_outlined,
                  label: 'Gender',
                  value: leagueCategory.playerGender,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.cake_outlined,
                  label: 'Age Requirement',
                  value: leagueCategory.checkPlayerAge
                      ? '${leagueCategory.playerMinAge ?? 'Any'} - ${leagueCategory.playerMaxAge ?? 'Any'} years old'
                      : 'No age restriction',
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.attach_money_outlined,
                  label: 'Entrance Fee',
                  value:
                      '₱${leagueCategory.teamEntranceFeeAmount.toStringAsFixed(2)}',
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.policy_outlined,
                  label: 'Requires Documents',
                  value: leagueCategory.requiresValidDocument ? 'Yes' : 'No',
                ),
                if (leagueCategory.requiresValidDocument &&
                    leagueCategory.allowedDocuments != null)
                  InfoTile(
                    colors: colors,
                    icon: Icons.description_outlined,
                    label: 'Allowed Documents',
                    value: leagueCategory.allowedDocuments!.join(', '),
                  ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            _buildInfoCard(
              context,
              title: 'Tournament Rounds',
              icon: Icons.emoji_events_outlined,
              children: [
                if (leagueCategory.rounds.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(Sizes.spaceMd),
                    child: Text(
                      'Rounds have not been set up yet.',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  )
                else
                  ...leagueCategory.rounds.map(
                    (round) => ListTile(
                      title: Text(
                        round.roundName,
                        style: TextStyle(color: colors.textPrimary),
                      ),
                      dense: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Sizes.spaceLg),
            if (hasPermissions(
              permissions,
              required: [Permission.joinLeague, Permission.joinLeagueAsTeam],
            ))
              GFButton(
                onPressed: () {},
                text: "Join Category",
                textStyle: TextStyle(
                  color: colors.contrast,
                  fontWeight: FontWeight.bold,
                ),
                color: colors.color9,
                blockButton: true,
                size: GFSize.LARGE,
              ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoCard(
  BuildContext context, {
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  final colors = Theme.of(context).extension<AppThemeColors>()!;
  return Container(
    decoration: BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(Sizes.radiusMd),
      border: Border.all(color: colors.gray5, width: Sizes.borderWidthSm),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Sizes.spaceMd,
            Sizes.spaceMd,
            Sizes.spaceMd,
            Sizes.spaceSm,
          ),
          child: Row(
            children: [
              Icon(icon, size: Sizes.fontSizeLg, color: colors.textPrimary),
              const SizedBox(width: Sizes.spaceSm),
              Text(
                title,
                style: TextStyle(
                  fontSize: Sizes.fontSizeLg,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: Sizes.borderWidthSm,
          thickness: Sizes.borderWidthSm,
          color: colors.gray5,
        ),
        ...children,
      ],
    ),
  );
}

class _CategoryListItem extends StatelessWidget {
  final LeagueCategory category;
  final List<Permission> permissions;

  const _CategoryListItem({required this.category, required this.permissions});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Card(
      color: colors.surface,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.spaceSm,
        vertical: Sizes.spaceXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.radiusMd),
        side: BorderSide(color: colors.gray4, width: Sizes.borderWidthSm),
      ),
      child: ListTile(
        title: Text(
          category.categoryName,
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${category.playerGender} | Max ${category.maxTeam} Teams',
          style: TextStyle(color: colors.textSecondary),
        ),
        trailing: category.acceptTeams
            ? Icon(Icons.chevron_right, color: colors.color9)
            : Icon(Icons.lock_outline, color: colors.gray8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LeagueCategoryScreen(
                leagueCategory: category,
                permissions: permissions,
              ),
            ),
          );
        },
      ),
    );
  }
}
