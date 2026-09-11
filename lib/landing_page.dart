import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'report_screen.dart';

class LandingPage extends StatefulWidget {
  final VoidCallback onLaunchDashboard;

  const LandingPage({super.key, required this.onLaunchDashboard});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.25).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showHelplines(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.phone_in_talk, color: AppColors.emergency, size: 22),
                SizedBox(width: 8),
                Text('Emergency Animal Helplines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Toll-free emergency numbers for stray and wild animals across India:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            _HelplineRow('National Animal Ambulance', '1962', '24x7 Government emergency response'),
            const SizedBox(height: 10),
            _HelplineRow('Ahmedabad Animal Control', '079-25353800', 'Municipal stray rescue division'),
            const SizedBox(height: 10),
            _HelplineRow('Jeevdaya Charitable Trust', '+91 99244 18181', 'Non-profit emergency hospital'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header Navbar
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            backgroundColor: AppColors.surface.withValues(alpha: 0.95),
            surfaceTintColor: Colors.transparent,
            titleSpacing: 12,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: const Text('🐾', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                const Flexible(
                  child: Text(
                    'PawRakshak',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => _showHelplines(context),
                tooltip: '1962 Helpline',
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.emergencyLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.emergencyBorder),
                  ),
                  child: const Icon(Icons.phone_outlined, size: 16, color: AppColors.emergency),
                ),
              ),
              const SizedBox(width: 4),
              ElevatedButton.icon(
                onPressed: widget.onLaunchDashboard,
                icon: const Icon(Icons.grid_view_rounded, size: 15, color: Colors.black),
                label: const Text('Live Dashboard', style: TextStyle(fontSize: 12, color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          // Main Hero Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live status eyebrow
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primaryBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'OVER 1,400 ACTIVE VOLUNTEERS IN GUJARAT',
                          style: TextStyle(
                            color: AppColors.primaryMedium,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Display Headline
                  const Text(
                    'Every injured animal\ndeserves a rapid rescue',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      height: 1.15,
                      letterSpacing: -1.0,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'India\'s community emergency rescue platform. Report distressed strays, receive instant AI first-aid triage protocols, and mobilize nearby rescuers and veterinary clinics within minutes.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Hero Action Buttons
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.onLaunchDashboard,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.black),
                        label: const Text('Enter Live Rescue Dashboard', style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(220, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ReportScreen()),
                          );
                        },
                        icon: const Icon(Icons.add_alert_rounded, size: 18, color: Colors.white),
                        label: const Text('Report Animal SOS', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emergency,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(190, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Real Animal Hero Photo Showcase
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/hero_rescued_dog.jpg',
                            fit: BoxFit.cover,
                          ),
                          // Dark gradient overlay to ensure text contrast
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.background.withValues(alpha: 0.4),
                                  AppColors.background.withValues(alpha: 0.95),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          PositionfulTriageOverlay(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Live Metric Ticker
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: const [
                        _TickerItem('143', 'Lives Saved'),
                        _TickerDivider(),
                        _TickerItem('8', 'On-Duty Vets'),
                        _TickerDivider(),
                        _TickerItem('4.2m', 'Avg Dispatch'),
                        _TickerDivider(),
                        _TickerItem('98%', 'Survival Rate'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Section Title: Real Rescues in Care
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Animals in Active Care',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.6,
                        ),
                      ),
                      Text(
                        'Live Gujarat Shelters',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryMedium, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Real street animals reported, rescued, and undergoing rehabilitation today:',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 18),

                  // Real Animal Cards Gallery
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _AnimalPhotoCard(
                          imagePath: 'assets/images/hero_rescued_dog.jpg',
                          name: 'Leo',
                          species: '🐕 Street Dog',
                          status: 'Fracture Bandaged',
                          statusColor: AppColors.emergency,
                          location: 'Satellite, Ahmedabad',
                          story: 'Rescued from road traffic with leg trauma. Now resting safely.',
                        ),
                        const SizedBox(width: 14),
                        _AnimalPhotoCard(
                          imagePath: 'assets/images/rescued_cat.jpg',
                          name: 'Mimi',
                          species: '🐈 Domestic Stray',
                          status: 'Receiving IV Fluids',
                          statusColor: AppColors.urgent,
                          location: 'Navrangpura, Ahmedabad',
                          story: 'Severe dehydration treated by Dr. Mehta. Active recovery.',
                        ),
                        const SizedBox(width: 14),
                        _AnimalPhotoCard(
                          imagePath: 'assets/images/rescued_cow.jpg',
                          name: 'Gauri',
                          species: '🐄 Street Cattle',
                          status: 'Hoof Wound Healing',
                          statusColor: AppColors.primary,
                          location: 'Maninagar, Ahmedabad',
                          story: 'Barbed wire removed safely. Feeding and sheltered peacefully.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Section Title: Bento Grid
                  const Text(
                    'Built for Emergency Animal Welfare',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'A specialized triage platform designed to bridge citizens, volunteer rescuers, and veterinary clinics.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  // Bento Grid
                  _BentoCard(
                    icon: Icons.psychology_outlined,
                    iconBg: AppColors.primaryLight,
                    iconColor: AppColors.primaryMedium,
                    title: 'Instant AI First-Aid Protocol',
                    subtitle: 'Powered by Gemini, PawRakshak delivers immediate stabilization instructions tailored to the species and injury type before medical professionals arrive on site.',
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _BentoCard(
                          icon: Icons.near_me_outlined,
                          iconBg: AppColors.moderateLight,
                          iconColor: AppColors.moderate,
                          title: '5km Radius Dispatch',
                          subtitle: 'Instantly alerts nearby verified volunteers with transport vehicles and rescue crates.',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _BentoCard(
                          icon: Icons.volunteer_activism_outlined,
                          iconBg: AppColors.emergencyLight,
                          iconColor: AppColors.emergency,
                          title: 'Direct Medical Ledger',
                          subtitle: '100% of micro-donations directly fund antibiotics, antiseptic dressings, and surgery.',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _BentoCard(
                    icon: Icons.support_agent_outlined,
                    iconBg: AppColors.urgentLight,
                    iconColor: AppColors.urgent,
                    title: 'Direct Integration with Emergency Helplines',
                    subtitle: 'Fast one-tap routing to India\'s National Animal Helpline 1962, municipal animal control, and trusted non-profit veterinary shelters.',
                  ),

                  const SizedBox(height: 48),

                  // How It Works
                  const Text(
                    'How PawRakshak Works in 3 Steps',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'From street spotting to clinical recovery in three clear actions.',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  _StepTile(
                    number: '1',
                    title: 'Spot & Photograph the Animal',
                    description: 'Take a clear photo and mark the severity level. GPS coordinates lock automatically to guide responders.',
                  ),
                  const SizedBox(height: 12),
                  _StepTile(
                    number: '2',
                    title: 'Follow AI First-Aid & Broadcast Alert',
                    description: 'Get immediate safety guidelines on what to do and what NOT to do while the rescue alert mobilizes the community.',
                  ),
                  const SizedBox(height: 12),
                  _StepTile(
                    number: '3',
                    title: 'Volunteer Reaches & Animal is Treated',
                    description: 'A responder arrives with medical supplies or transport. Treatment progress updates live on the community ledger.',
                  ),

                  const SizedBox(height: 48),

                  // Final CTA Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.primaryBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Ready to help save street animals?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join our open network as a reporter, transporter, or veterinary contributor.',
                          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: widget.onLaunchDashboard,
                          icon: const Icon(Icons.arrow_forward_rounded, color: Colors.black),
                          label: const Text('Launch Live Dashboard', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size(220, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Minimal Footer
                  Center(
                    child: Text(
                      'PawRakshak Emergency Animal Welfare Foundation • Gujarat, India',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PositionfulTriageOverlay extends StatelessWidget {
  const PositionfulTriageOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: Colors.black),
                    SizedBox(width: 4),
                    Text(
                      'CASE STABILIZED',
                      style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: const Text(
                  'Ahmedabad West Division',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Community Care in Action',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Rescued strays receive on-site triage, wound bandaging, and loving foster shelter.',
            style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _AnimalPhotoCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String species;
  final String status;
  final Color statusColor;
  final String location;
  final String story;

  const _AnimalPhotoCard({
    required this.imagePath,
    required this.name,
    required this.species,
    required this.status,
    required this.statusColor,
    required this.location,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      species,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  story,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.35),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TickerItem extends StatelessWidget {
  final String value;
  final String label;

  const _TickerItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryMedium,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TickerDivider extends StatelessWidget {
  const _TickerDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _BentoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepTile({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelplineRow extends StatelessWidget {
  final String title;
  final String number;
  final String subtitle;

  const _HelplineRow(this.title, this.number, this.subtitle);

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(number, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryMedium)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dialing $number')),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(60, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            child: const Text('Call', style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
