import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/case_repository.dart';
import 'models/case_model.dart';
import 'landing_page.dart';
import 'report_screen.dart';
import 'case_detail_screen.dart';

void main() {
  runApp(const PawRakshakApp());
}

class PawRakshakApp extends StatelessWidget {
  const PawRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawRakshak',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RootNavigationContainer(),
    );
  }
}

class RootNavigationContainer extends StatefulWidget {
  const RootNavigationContainer({super.key});

  @override
  State<RootNavigationContainer> createState() => _RootNavigationContainerState();
}

class _RootNavigationContainerState extends State<RootNavigationContainer> {
  int _currentTab = 0; // 0 = Landing Page, 1 = Live Dashboard

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: [
          LandingPage(
            onLaunchDashboard: () => setState(() => _currentTab = 1),
          ),
          DashboardScreen(
            onBackToLanding: () => setState(() => _currentTab = 0),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(top: BorderSide(color: AppColors.border, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavButton(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Overview',
                  isSelected: _currentTab == 0,
                  onTap: () => setState(() => _currentTab = 0),
                ),
                _NavButton(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Live Dashboard',
                  isSelected: _currentTab == 1,
                  onTap: () => setState(() => _currentTab = 1),
                ),
                _NavButton(
                  icon: Icons.add_alert_outlined,
                  activeIcon: Icons.add_alert_rounded,
                  label: 'Report SOS',
                  isEmergency: true,
                  isSelected: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ReportScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final bool isEmergency;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    this.isEmergency = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmergency) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.emergency,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(activeIcon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final VoidCallback onBackToLanding;

  const DashboardScreen({super.key, required this.onBackToLanding});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  int _viewMode = 0; // 0 = List View, 1 = Radar Map View
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RescueCase> _filterCases(List<RescueCase> cases) {
    return cases.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.species.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.description.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedCategory == 'All') return true;
      if (_selectedCategory == 'Critical SOS') return c.severity == 'Critical';
      if (_selectedCategory == 'My Responses') return c.userResponseRole != null;
      return c.species == _selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CaseRepository.instance,
      builder: (context, _) {
        final repo = CaseRepository.instance;
        final filteredCases = _filterCases(repo.cases);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            titleSpacing: 16,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  tooltip: 'Back to Overview',
                  onPressed: widget.onBackToLanding,
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🐾', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Rescue Dashboard',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Active Triage & Response Feed',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // View toggle
              Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.list_alt_rounded,
                        size: 18,
                        color: _viewMode == 0 ? AppColors.primaryDark : AppColors.textMuted,
                      ),
                      tooltip: 'List Feed',
                      onPressed: () => setState(() => _viewMode = 0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.radar_rounded,
                        size: 18,
                        color: _viewMode == 1 ? AppColors.primaryDark : AppColors.textMuted,
                      ),
                      tooltip: 'Radar Grid',
                      onPressed: () => setState(() => _viewMode = 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Real-time Metric Cards Bar
                      Row(
                        children: [
                          _DashboardStat(
                            title: 'Active Cases',
                            value: '${repo.activeSosCount}',
                            badgeColor: AppColors.emergency,
                            badgeBg: AppColors.emergencyLight,
                            icon: Icons.warning_amber_rounded,
                          ),
                          const SizedBox(width: 8),
                          _DashboardStat(
                            title: 'Vets Online',
                            value: '${repo.vetsOnlineCount}',
                            badgeColor: AppColors.primary,
                            badgeBg: AppColors.primaryLight,
                            icon: Icons.medical_services_outlined,
                          ),
                          const SizedBox(width: 8),
                          _DashboardStat(
                            title: 'Total Rescues',
                            value: '${repo.totalLivesSaved}',
                            badgeColor: AppColors.moderate,
                            badgeBg: AppColors.moderateLight,
                            icon: Icons.verified_outlined,
                          ),
                          const SizedBox(width: 8),
                          _DashboardStat(
                            title: 'Care Fund',
                            value: '₹${repo.totalFundsRaised}',
                            badgeColor: AppColors.urgent,
                            badgeBg: AppColors.urgentLight,
                            icon: Icons.favorite_outline,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: const TextStyle(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search by neighborhood (e.g. Navrangpura) or injury...',
                            prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'All',
                            'Critical SOS',
                            'Dog',
                            'Cat',
                            'Cow',
                            'Bird',
                            'My Responses',
                          ].map((cat) {
                            final isSel = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(
                                  cat == 'Dog' ? '🐕 Dogs' :
                                  cat == 'Cat' ? '🐈 Cats' :
                                  cat == 'Cow' ? '🐄 Cattle' :
                                  cat == 'Bird' ? '🕊️ Birds' :
                                  cat == 'My Responses' ? '🙋 My Responses' : cat,
                                ),
                                selected: isSel,
                                selectedColor: AppColors.primaryLight,
                                backgroundColor: AppColors.surface,
                                side: BorderSide(
                                  color: isSel ? AppColors.primary : AppColors.border,
                                  width: isSel ? 1.5 : 1,
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                                  color: isSel ? AppColors.primaryDark : AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                showCheckmark: false,
                                onSelected: (_) => setState(() => _selectedCategory = cat),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _viewMode == 0
                                ? 'Live Incident Dispatch (${filteredCases.length})'
                                : 'Ahmedabad Rescue Clusters',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Updated Just now',
                            style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // View Switcher (Feed or Radar)
              if (_viewMode == 0)
                filteredCases.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.check_circle_outline, size: 48, color: AppColors.primary),
                                const SizedBox(height: 12),
                                const Text(
                                  'No incidents match your filter',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'All local cases in this category are stabilized.',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = filteredCases[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _LiveCaseCard(item: item),
                              );
                            },
                            childCount: filteredCases.length,
                          ),
                        ),
                      )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    child: _RadarSectorView(cases: filteredCases),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportScreen()),
              );
            },
            backgroundColor: AppColors.emergency,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add_alert_rounded),
            label: const Text(
              'REPORT ANIMAL SOS',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        );
      },
    );
  }
}

class _DashboardStat extends StatelessWidget {
  final String title;
  final String value;
  final Color badgeColor;
  final Color badgeBg;
  final IconData icon;

  const _DashboardStat({
    required this.title,
    required this.value,
    required this.badgeColor,
    required this.badgeBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
              child: Icon(icon, size: 14, color: badgeColor),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: badgeColor,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveCaseCard extends StatelessWidget {
  final RescueCase item;

  const _LiveCaseCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CaseDetailScreen(
              caseId: item.id,
              imagePath: item.imagePath,
              species: item.species,
              emoji: item.emoji,
              severity: item.severity,
              severityColor: item.severityColor,
              description: item.description,
              location: item.location,
              distance: item.distance,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.severity == 'Critical' ? AppColors.emergencyBorder : AppColors.border,
            width: item.severity == 'Critical' ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 58,
                    height: 58,
                    child: item.imagePath != null
                        ? Image.asset(item.imagePath!, fit: BoxFit.cover)
                        : Container(
                            decoration: BoxDecoration(
                              color: item.severityColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: item.severityColor.withValues(alpha: 0.3)),
                            ),
                            child: Center(
                              child: Text(item.emoji, style: const TextStyle(fontSize: 26)),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item.species,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.severityColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: item.severityColor.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              item.severity.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.severityColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.timeAgo,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Dynamic Responder & Fund Badges
            if (item.userResponseRole != null || item.donationsRaised > 0) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (item.userResponseRole != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primaryBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Assigned: You (${item.userResponseRole})',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ),
                  if (item.donationsRaised > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.urgentLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.urgentBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.favorite, size: 11, color: AppColors.urgent),
                          const SizedBox(width: 4),
                          Text(
                            '₹${item.donationsRaised} Care Fund Raised',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.urgent),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item.location,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: item.status.contains('Assigned') ? AppColors.primaryDark : AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.near_me_outlined, size: 11, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        item.distance,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarSectorView extends StatelessWidget {
  final List<RescueCase> cases;

  const _RadarSectorView({required this.cases});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.radar, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Ahmedabad Triage Radius Sectors',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Live clusters of reported distress calls organized by municipal zones:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              _SectorRow('Navrangpura & Commerce Six Roads', '3 Active Cases', 'Average ETA: 4m', AppColors.emergency),
              const SizedBox(height: 10),
              _SectorRow('Satellite & Shyamal Cross Roads', '2 Active Cases', 'Average ETA: 6m', AppColors.urgent),
              const SizedBox(height: 10),
              _SectorRow('Maninagar & Kankaria Lake', '1 Active Case', 'Average ETA: 8m', AppColors.moderate),
              const SizedBox(height: 10),
              _SectorRow('Vastrapur & Gurukul', '2 Active Cases', 'Average ETA: 5m', AppColors.moderate),
              const SizedBox(height: 10),
              _SectorRow('Paldi & Mahalaxmi', '1 Active Case', 'Average ETA: 7m', AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectorRow extends StatelessWidget {
  final String sector;
  final String casesCount;
  final String eta;
  final Color indicatorColor;

  const _SectorRow(this.sector, this.casesCount, this.eta, this.indicatorColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: indicatorColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sector, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(eta, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: indicatorColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              casesCount,
              style: TextStyle(color: indicatorColor, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}