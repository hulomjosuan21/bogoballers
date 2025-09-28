import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/enums/permission.dart';
import 'package:bogoballers/core/models/league_model.dart';
import 'package:bogoballers/core/services/league/league_service.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';
import 'package:bogoballers/core/utils/error_handler.dart';
import 'package:bogoballers/core/widget/info_list_tile.dart';
import 'package:bogoballers/core/widget/info_tile.dart';
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:bogoballers/screens/team_manager/team_manager_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
                if (result.leagueCategories.isEmpty ||
                    result.status == 'Pending')
                  Padding(
                    padding: const EdgeInsets.all(Sizes.spaceMd),
                    child: Text(
                      result.status != 'Pending'
                          ? 'No categories available for this league yet.'
                          : 'League is pending not yet approved',
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
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
              official.photo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person),
            ),
          ),
          title: Text(official.fullName),
          subtitle: Text(official.role),
        );
      },
    );
  }

  Widget _buildRefereeList(BuildContext context, List<LeagueReferee> referees) {
    if (referees.isEmpty) {
      return const Center(child: Text('No referees listed.'));
    }
    return ListView.builder(
      itemCount: referees.length,
      itemBuilder: (context, index) {
        final referee = referees[index];
        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
              referee.photo,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person),
            ),
          ),
          title: Text(referee.fullName),
          subtitle: Text(referee.contactInfo),
        );
      },
    );
  }

  Widget _buildCourtList(BuildContext context, List<LeagueCourt> courts) {
    if (courts.isEmpty) {
      return const Center(child: Text('No courts listed.'));
    }
    return ListView.builder(
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final court = courts[index];
        return ListTile(
          title: Text(court.name),
          subtitle: Text(court.location),
        );
      },
    );
  }

  Widget _buildAffiliateList(
    BuildContext context,
    List<LeagueAffiliate> affiliates,
  ) {
    if (affiliates.isEmpty) {
      return const Center(child: Text('No courts listed.'));
    }
    return ListView.builder(
      itemCount: affiliates.length,
      itemBuilder: (context, index) {
        final affiliate = affiliates[index];
        return ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Image.network(
              affiliate.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.person),
            ),
          ),
          title: Text(affiliate.name),
          subtitle: Text(affiliate.contactInfo),
        );
      },
    );
  }
}

class LeagueCategoryScreen extends StatefulWidget {
  final LeagueCategory leagueCategory;
  final List<Permission> permissions;

  const LeagueCategoryScreen({
    super.key,
    required this.leagueCategory,
    required this.permissions,
  });

  @override
  State<LeagueCategoryScreen> createState() => _LeagueCategoryScreenState();
}

class _LeagueCategoryScreenState extends State<LeagueCategoryScreen> {
  bool isProcessing = false;

  Future<void> onPressed() async {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TeamManagerTeamsScreen(selectMode: true),
      ),
    );
    if (result == null || !mounted) return;

    final paymentMethod = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Payment Method"),
          content: const Text("Do you want to pay online or on-site?"),
          actions: [
            GFButton(
              onPressed: () => Navigator.pop(context, "Pay on site"),
              text: "On-site",
              size: GFSize.SMALL,
              type: GFButtonType.outline,
              color: colors.color9,
            ),
            GFButton(
              onPressed: () => Navigator.pop(context, "Pay online"),
              text: "Online",
              color: colors.color9,
              size: GFSize.SMALL,
            ),
          ],
        );
      },
    );
    if (paymentMethod == null) return;

    setState(() => isProcessing = true);

    final data = {
      "team_id": result['teamId'],
      "league_id": widget.leagueCategory.leagueId,
      "league_category_id": widget.leagueCategory.leagueCategoryId,
      "payment_method": paymentMethod,
      if (paymentMethod == "Pay online")
        "amount": widget.leagueCategory.teamEntranceFeeAmount,
    };

    try {
      final response = await LeagueService.registerTeam(data);
      final responseData = response.data;

      if (paymentMethod == "Pay online" &&
          responseData['checkout_url'] != null) {
        if (!mounted) return;
        showAppSnackbar(
          context,
          message: responseData['message'],
          title: "Success",
          variant: SnackbarVariant.success,
        );
        await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PaymentWebViewPage(checkoutUrl: responseData['checkout_url']),
          ),
        );
      } else {
        if (!mounted) return;
        showAppSnackbar(
          context,
          message: responseData['message'],
          title: "Success",
          variant: SnackbarVariant.success,
        );
      }
    } catch (e) {
      if (!mounted) return;
      showAppSnackbar(
        context,
        message: ErrorHandler.getErrorMessage(e),
        title: "Error",
        variant: SnackbarVariant.error,
      );
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.leagueCategory.categoryName,
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
                  value: widget.leagueCategory.maxTeam.toString(),
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.person_search_outlined,
                  label: 'Gender',
                  value: widget.leagueCategory.playerGender,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.cake_outlined,
                  label: 'Age Requirement',
                  value: widget.leagueCategory.checkPlayerAge
                      ? '${widget.leagueCategory.playerMinAge ?? 'Any'} - ${widget.leagueCategory.playerMaxAge ?? 'Any'} years old'
                      : 'No age restriction',
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.flag_outlined,
                  label: 'Status',
                  value: widget.leagueCategory.leagueCategoryStatus,
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.attach_money_outlined,
                  label: 'Entrance Fee',
                  value:
                      '₱${widget.leagueCategory.teamEntranceFeeAmount.toStringAsFixed(2)}',
                ),
                InfoTile(
                  colors: colors,
                  icon: Icons.policy_outlined,
                  label: 'Requires Documents',
                  value: widget.leagueCategory.requiresValidDocument
                      ? 'Yes'
                      : 'No',
                ),
                if (widget.leagueCategory.requiresValidDocument &&
                    widget.leagueCategory.allowedDocuments != null)
                  InfoListTile(
                    colors: colors,
                    icon: Icons.description_outlined,
                    label: 'Allowed Documents',
                    values: widget.leagueCategory.allowedDocuments,
                  ),
              ],
            ),
            const SizedBox(height: Sizes.spaceMd),
            _buildInfoCard(
              context,
              title: 'Tournament Rounds',
              icon: Icons.emoji_events_outlined,
              children: [
                if (widget.leagueCategory.rounds.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(Sizes.spaceMd),
                    child: Text(
                      'Rounds have not been set up yet.',
                      style: TextStyle(color: colors.textSecondary),
                    ),
                  )
                else
                  ...widget.leagueCategory.rounds.map(
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
              widget.permissions,
              required: [Permission.joinLeague, Permission.joinLeagueAsTeam],
            ))
              GFButton(
                onPressed: onPressed,
                text: "Join Category",
                textStyle: TextStyle(
                  color: colors.contrast,
                  fontWeight: FontWeight.bold,
                ),
                color: colors.color9,
                blockButton: true,
                size: GFSize.MEDIUM,
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

class PaymentWebViewPage extends StatefulWidget {
  final String checkoutUrl;

  const PaymentWebViewPage({super.key, required this.checkoutUrl});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
