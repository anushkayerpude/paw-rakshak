import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'ai_service.dart';
import 'services/case_repository.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _species = 'Dog';
  String _severity = 'Critical';
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  bool _submitted = false;
  bool _isSubmitting = false;
  bool _hasPhoto = false;
  String _aiFirstAid = '';

  final List<String> _quickSymptoms = [
    'Hit by vehicle',
    'Heavy bleeding',
    'Unable to walk',
    'Severe dehydration',
    'Shivering / Trauma',
    'Deep open wound',
  ];

  @override
  void dispose() {
    _descController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _addSymptom(String symptom) {
    final currentText = _descController.text.trim();
    if (currentText.isEmpty) {
      _descController.text = symptom;
    } else if (!currentText.contains(symptom)) {
      _descController.text = '$currentText, $symptom';
    }
  }

  String get _speciesEmoji {
    switch (_species) {
      case 'Dog':
        return '🐶';
      case 'Cat':
        return '🐱';
      case 'Cow':
        return '🐄';
      case 'Bird':
        return '🕊️';
      default:
        return '🐾';
    }
  }

  Color get _severityColor {
    switch (_severity) {
      case 'Critical':
        return AppColors.emergency;
      case 'High':
        return AppColors.urgent;
      default:
        return AppColors.moderate;
    }
  }

  Future<void> _submitCase() async {
    setState(() => _isSubmitting = true);
    final symptoms = _descController.text.isEmpty
        ? '$_species found injured on street requiring triage'
        : _descController.text;

    final firstAid = await AiService.getFirstAid(
      species: _species,
      symptoms: symptoms,
    );

    // Save newly reported case to reactive repository
    CaseRepository.instance.addCase(
      species: _species,
      emoji: _speciesEmoji,
      severity: _severity,
      severityColor: _severityColor,
      description: symptoms,
      location: _landmarkController.text.isNotEmpty
          ? 'Navrangpura (${_landmarkController.text.trim()}), Ahmedabad'
          : 'Navrangpura, Ahmedabad',
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _submitted = true;
      _aiFirstAid = firstAid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessScreen(
        species: _species,
        severity: _severity,
        firstAid: _aiFirstAid,
        location: 'Navrangpura, Ahmedabad',
        landmark: _landmarkController.text.isEmpty ? 'Near Commerce Six Roads' : _landmarkController.text,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Report Injured Animal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.emergencyLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.emergencyBorder),
            ),
            child: const Row(
              children: [
                Icon(Icons.flash_on, color: AppColors.emergency, size: 14),
                SizedBox(width: 4),
                Text(
                  'SOS MODE',
                  style: TextStyle(
                    color: AppColors.emergency,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Evidence Photo Box
            GestureDetector(
              onTap: () {
                setState(() => _hasPhoto = !_hasPhoto);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Text(_hasPhoto ? 'Photo captured successfully' : 'Photo removed'),
                  ),
                );
              },
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _hasPhoto ? AppColors.primaryLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _hasPhoto ? AppColors.primary : AppColors.border,
                    width: _hasPhoto ? 2 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _hasPhoto
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : AppColors.surfaceSubtle,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _hasPhoto ? Icons.check_circle_rounded : Icons.add_a_photo_outlined,
                          size: 32,
                          color: _hasPhoto ? AppColors.primary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _hasPhoto ? 'Photo Attached (Tap to change)' : 'Tap to photograph the animal',
                        style: TextStyle(
                          color: _hasPhoto ? AppColors.primaryDark : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _hasPhoto
                            ? 'AI visual diagnosis will assist on-site triage'
                            : 'Helps rescuers and vets evaluate injury severity instantly',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Animal Selection
            const Text(
              '1. Animal Species',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  {'name': 'Dog', 'emoji': '🐕'},
                  {'name': 'Cat', 'emoji': '🐈'},
                  {'name': 'Cow', 'emoji': '🐄'},
                  {'name': 'Bird', 'emoji': '🕊️'},
                  {'name': 'Other', 'emoji': '🐾'},
                ].map((item) {
                  final isSelected = _species == item['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('${item['emoji']} ${item['name']}'),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.8 : 1,
                      ),
                      labelStyle: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _species = item['name']!),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 22),

            // Urgency Triage Level
            const Text(
              '2. Urgency Triage Level',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _TriageButton(
                  title: 'Critical',
                  subtitle: 'Heavy bleed / shock',
                  color: AppColors.emergency,
                  bgColor: AppColors.emergencyLight,
                  borderColor: AppColors.emergencyBorder,
                  isSelected: _severity == 'Critical',
                  onTap: () => setState(() => _severity = 'Critical'),
                ),
                const SizedBox(width: 8),
                _TriageButton(
                  title: 'High',
                  subtitle: 'Fracture / trauma',
                  color: AppColors.urgent,
                  bgColor: AppColors.urgentLight,
                  borderColor: AppColors.urgentBorder,
                  isSelected: _severity == 'High',
                  onTap: () => setState(() => _severity = 'High'),
                ),
                const SizedBox(width: 8),
                _TriageButton(
                  title: 'Medium',
                  subtitle: 'Limping / wounds',
                  color: AppColors.moderate,
                  bgColor: AppColors.moderateLight,
                  borderColor: AppColors.moderateBorder,
                  isSelected: _severity == 'Medium',
                  onTap: () => setState(() => _severity = 'Medium'),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Symptoms Quick Tags
            const Text(
              '3. Quick Observation Tags',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap common symptoms to add them directly into your report:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickSymptoms.map((symptom) {
                final isAdded = _descController.text.contains(symptom);
                return ActionChip(
                  avatar: Icon(
                    isAdded ? Icons.check : Icons.add,
                    size: 14,
                    color: isAdded ? AppColors.primary : AppColors.textSecondary,
                  ),
                  label: Text(symptom),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: isAdded ? AppColors.primaryDark : AppColors.textSecondary,
                    fontWeight: isAdded ? FontWeight.bold : FontWeight.w500,
                  ),
                  backgroundColor: isAdded ? AppColors.primaryLight : AppColors.surface,
                  side: BorderSide(
                    color: isAdded ? AppColors.primaryBorder : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: () => _addSymptom(symptom),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Detailed Description
            TextField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Describe condition, behavior, and exact spot (e.g. Under neem tree, unable to rise)...',
              ),
            ),

            const SizedBox(height: 22),

            // Geolocation Card
            const Text(
              '4. Incident Location',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.my_location, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Navrangpura, Ahmedabad',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'GPS locked (Accuracy within 6m)',
                              style: TextStyle(fontSize: 11, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _landmarkController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      hintText: 'Nearby landmark (e.g. Opposite SBI ATM, Commerce Six Roads)',
                      fillColor: AppColors.surfaceSubtle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitCase,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                label: Text(
                  _isSubmitting ? 'GENERATING AI TRIAGE PROTOCOL...' : 'DISPATCH EMERGENCY ALERT',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergency,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TriageButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _TriageButton({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isSelected ? color : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? color : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  final String species;
  final String severity;
  final String firstAid;
  final String location;
  final String landmark;

  const _SuccessScreen({
    required this.species,
    required this.severity,
    required this.firstAid,
    required this.location,
    required this.landmark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Emergency Dispatched', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Success Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryBorder, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 36),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'SOS Alert Transmitted',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Case Reference: PR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.broadcast_on_personal, size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'Alerted 8 nearby verified rescuers in $location',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // AI First Aid Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primaryBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medical_services_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'AI Immediate First-Aid Protocol',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: SelectableText(
                      firstAid,
                      style: const TextStyle(fontSize: 13, height: 1.55, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Return to Live Dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
