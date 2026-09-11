import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'services/case_repository.dart';

class CaseDetailScreen extends StatefulWidget {
  final String? caseId;
  final String species;
  final String emoji;
  final String severity;
  final Color severityColor;
  final String description;
  final String location;
  final String distance;
  final String? imagePath;

  const CaseDetailScreen({
    super.key,
    this.caseId,
    this.imagePath,
    required this.species,
    required this.emoji,
    required this.severity,
    required this.severityColor,
    required this.description,
    required this.location,
    required this.distance,
  });

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  bool _responded = false;
  String _responseRole = 'Transporter';

  @override
  void initState() {
    super.initState();
    if (widget.caseId != null) {
      final c = CaseRepository.instance.getCaseById(widget.caseId!);
      if (c != null && c.userResponseRole != null) {
        _responded = true;
        _responseRole = c.userResponseRole!;
      }
    }
  }

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Volunteer to Assist This Case',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select how you can contribute to this rescue operation:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Transporter (Vehicle)',
                  'On-Site First Aid',
                  'Temporary Foster',
                  'Vet Consultation',
                ].map((role) {
                  final isSel = _responseRole == role;
                  return ChoiceChip(
                    label: Text(role),
                    selected: isSel,
                    selectedColor: AppColors.primaryLight,
                    backgroundColor: AppColors.surfaceSubtle,
                    side: BorderSide(
                      color: isSel ? AppColors.primary : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      color: isSel ? AppColors.primaryDark : AppColors.textSecondary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    showCheckmark: false,
                    onSelected: (_) {
                      setModalState(() => _responseRole = role);
                      setState(() => _responseRole = role);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() => _responded = true);

                    if (widget.caseId != null) {
                      CaseRepository.instance.respondToCase(widget.caseId!, _responseRole);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.primaryDark,
                        content: Text('Thank you! Dispatch team alerted that you are assisting as $_responseRole.'),
                      ),
                    );
                  },
                  child: const Text('Confirm Response & Join Chat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.volunteer_activism, color: AppColors.emergency, size: 22),
                SizedBox(width: 8),
                Text(
                  'Fund Medical Care',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              '100% of contributions directly offset emergency medications, dressings, and veterinary clinic charges.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _DonationTier(100, 'Antiseptic & Bandages', () => _completeDonation(100)),
                const SizedBox(width: 8),
                _DonationTier(250, 'Antibiotics & Fluids', () => _completeDonation(250)),
                const SizedBox(width: 8),
                _DonationTier(500, 'Full Vet Diagnosis', () => _completeDonation(500)),
                const SizedBox(width: 8),
                _DonationTier(1000, 'Critical Care', () => _completeDonation(1000)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Verified treatment ledger published upon case discharge.',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeDonation(int amount) {
    Navigator.pop(context);

    if (widget.caseId != null) {
      CaseRepository.instance.donateToCase(widget.caseId!, amount);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryDark,
        content: Text('Contribution of ₹$amount received. You helped save a life!'),
      ),
    );
  }

  void _copyProtocol() {
    Clipboard.setData(ClipboardData(
      text: 'PawRakshak Emergency Protocol for ${widget.species} (${widget.location}):\n'
          'Status: ${widget.severity}\n'
          'Immediate action: Keep warm and quiet. Do not administer human painkillers. Provide dropper water.',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Protocol copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Dynamic Header
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.imagePath != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(widget.imagePath!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.background.withValues(alpha: 0.5),
                                AppColors.background.withValues(alpha: 0.95),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: widget.severityColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '${widget.severity.toUpperCase()} PRIORITY',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryDark,
                            widget.severityColor.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 36),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                              ),
                              child: Text(widget.emoji, style: const TextStyle(fontSize: 52)),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.severityColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${widget.severity.toUpperCase()} PRIORITY',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),

          // Body Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Meta Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.species} Emergency Rescue',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primaryBorder),
                        ),
                        child: Text(
                          widget.distance,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Triage Status Step Indicator
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rescue Pipeline Status',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _PipelineStep('Reported', true, true),
                            _PipelineStep('Triage', true, true),
                            _PipelineStep('Rescuer', _responded, false),
                            _PipelineStep('Safe', false, false),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Situation Summary Card
                  const _SectionHeader('Reported Incident Details'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: 8),
                        const Row(
                          children: [
                            Icon(Icons.schedule, size: 12, color: AppColors.textMuted),
                            SizedBox(width: 4),
                            Text(
                              'Reported by citizen responder in Ahmedabad area',
                              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // AI First Aid Protocol Card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _SectionHeader('AI Immediate First-Aid Protocol'),
                      TextButton.icon(
                        onPressed: _copyProtocol,
                        icon: const Icon(Icons.copy_outlined, size: 14, color: AppColors.primary),
                        label: const Text(
                          'Share Protocol',
                          style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryBorder),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Do this
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.check_circle_outline, color: AppColors.primary, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'DO THIS IMMEDIATELY:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              _ProtocolPoint('Keep animal still, shaded, and warm with cloth or cardboard.'),
                              _ProtocolPoint('If internal or spinal trauma suspected, do not lift unnecessarily.'),
                              _ProtocolPoint('Hydrate sparingly with a clean dropper; do not submerge muzzle.'),
                              _ProtocolPoint('Cover any open lacerations gently with sterile clean bandage.'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Do not do this
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.emergencyLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.emergencyBorder),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.cancel_outlined, color: AppColors.emergency, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    'STRICT PRECAUTIONS:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.emergency,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              _ProtocolPoint('Never administer human medications like paracetamol or aspirin.'),
                              _ProtocolPoint('Do not force solid food down the animal throat.'),
                              _ProtocolPoint('Avoid sudden loud noises or surrounding the injured animal.'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Vet handover note
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.moderateLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.moderateBorder),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: AppColors.moderate),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Handover Note: Mention exact time of finding and whether pupil response was normal.',
                                  style: TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.35),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Nearby Verified Vets
                  const _SectionHeader('Nearby Verified Responders & Clinics'),
                  const SizedBox(height: 8),
                  const _VetTile(
                    name: 'Dr. Rajiv Mehta',
                    clinic: 'Navrangpura Veterinary Clinic',
                    distance: '0.8 km',
                    rating: '4.9',
                    isAvailable: true,
                  ),
                  const SizedBox(height: 8),
                  const _VetTile(
                    name: 'Dr. Ananya Shah',
                    clinic: 'Satellite Animal Hospital',
                    distance: '1.9 km',
                    rating: '4.8',
                    isAvailable: true,
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _responded ? null : _showHelpDialog,
                      icon: Icon(
                        _responded ? Icons.check_circle : Icons.volunteer_activism,
                        color: Colors.white,
                      ),
                      label: Text(
                        _responded ? 'Assisting as $_responseRole' : 'I Can Help This Animal',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _responded ? AppColors.textMuted : AppColors.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _showDonateSheet,
                      icon: const Icon(Icons.favorite_outline, color: AppColors.emergency, size: 18),
                      label: const Text(
                        'Fund Medical Treatment',
                        style: TextStyle(color: AppColors.emergency, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.emergencyBorder, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _ProtocolPoint extends StatelessWidget {
  final String text;
  const _ProtocolPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.4, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool hasNext;

  const _PipelineStep(this.label, this.isCompleted, this.hasNext);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primary : AppColors.surfaceSubtle,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
                    color: isCompleted ? AppColors.primaryDark : AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (hasNext)
            Container(
              width: 18,
              height: 2,
              color: isCompleted ? AppColors.primary : AppColors.border,
            ),
        ],
      ),
    );
  }
}

class _VetTile extends StatelessWidget {
  final String name;
  final String clinic;
  final String distance;
  final String rating;
  final bool isAvailable;

  const _VetTile({
    required this.name,
    required this.clinic,
    required this.distance,
    required this.rating,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, size: 14, color: AppColors.primary),
                  ],
                ),
                Text(clinic, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: AppColors.urgent),
                  const SizedBox(width: 2),
                  Text(rating, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonationTier extends StatelessWidget {
  final int amount;
  final String description;
  final VoidCallback onTap;

  const _DonationTier(this.amount, this.description, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryBorder),
          ),
          child: Column(
            children: [
              Text(
                '₹$amount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}