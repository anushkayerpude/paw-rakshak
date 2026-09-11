import 'package:flutter/material.dart';
import '../models/case_model.dart';
import '../theme/app_theme.dart';

class CaseRepository extends ChangeNotifier {
  static final CaseRepository instance = CaseRepository._internal();
  CaseRepository._internal();

  final List<RescueCase> _cases = [
    RescueCase(
      id: 'PR-101',
      species: 'Cat',
      emoji: '🐱',
      imagePath: 'assets/images/rescued_cat.jpg',
      severity: 'Critical',
      severityColor: AppColors.emergency,
      description: 'Severe parvo suspicion. Severe dehydration and not responsive.',
      location: 'Navrangpura, Ahmedabad',
      distance: '0.8 km',
      timeAgo: '6m ago',
      status: 'Awaiting Rescuer',
      responders: 0,
      donationsRaised: 350,
      createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
    RescueCase(
      id: 'PR-102',
      species: 'Dog',
      emoji: '🐶',
      imagePath: 'assets/images/hero_rescued_dog.jpg',
      severity: 'Critical',
      severityColor: AppColors.emergency,
      description: 'Hit by speeding vehicle. Deep laceration on hind leg with bleeding.',
      location: 'Satellite, Ahmedabad',
      distance: '1.4 km',
      timeAgo: '14m ago',
      status: 'Rescuer En Route',
      responders: 1,
      donationsRaised: 750,
      createdAt: DateTime.now().subtract(const Duration(minutes: 14)),
    ),
    RescueCase(
      id: 'PR-103',
      species: 'Cow',
      emoji: '🐄',
      imagePath: 'assets/images/rescued_cow.jpg',
      severity: 'High',
      severityColor: AppColors.urgent,
      description: 'Constricted barbed wire wound on left hoof. Swollen and limping heavily.',
      location: 'Maninagar, Ahmedabad',
      distance: '2.8 km',
      timeAgo: '32m ago',
      status: 'Awaiting Transport',
      responders: 2,
      donationsRaised: 500,
      createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
    ),
    RescueCase(
      id: 'PR-104',
      species: 'Bird',
      emoji: '🕊️',
      severity: 'Medium',
      severityColor: AppColors.moderate,
      description: 'Pigeon entangled in glass-coated kite thread. Wing partially restricted.',
      location: 'Vastrapur, Ahmedabad',
      distance: '3.1 km',
      timeAgo: '1h ago',
      status: 'Volunteer Assigned',
      responders: 1,
      donationsRaised: 100,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    RescueCase(
      id: 'PR-105',
      species: 'Dog',
      emoji: '🐕',
      imagePath: 'assets/images/hero_rescued_dog.jpg',
      severity: 'Medium',
      severityColor: AppColors.moderate,
      description: 'Puppy stuck in dry storm drain near market. Whining but active.',
      location: 'Paldi, Ahmedabad',
      distance: '3.9 km',
      timeAgo: '2h ago',
      status: 'Community Monitoring',
      responders: 3,
      donationsRaised: 250,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  List<RescueCase> get cases => List.unmodifiable(_cases);

  int get activeSosCount => _cases.where((c) => c.severity == 'Critical' || c.status != 'Recovered').length;
  int get vetsOnlineCount => 8;
  int get totalLivesSaved => 143;
  int get totalFundsRaised => _cases.fold(0, (sum, c) => sum + c.donationsRaised);

  void addCase({
    required String species,
    required String emoji,
    String? imagePath,
    required String severity,
    required Color severityColor,
    required String description,
    required String location,
  }) {
    final newCase = RescueCase(
      id: 'PR-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      species: species,
      emoji: emoji,
      imagePath: imagePath ?? (species == 'Dog'
          ? 'assets/images/hero_rescued_dog.jpg'
          : species == 'Cat'
              ? 'assets/images/rescued_cat.jpg'
              : species == 'Cow'
                  ? 'assets/images/rescued_cow.jpg'
                  : null),
      severity: severity,
      severityColor: severityColor,
      description: description,
      location: location,
      distance: '0.2 km',
      timeAgo: 'Just now',
      status: 'Awaiting Rescuer',
      responders: 0,
      donationsRaised: 0,
      createdAt: DateTime.now(),
    );

    _cases.insert(0, newCase);
    notifyListeners();
  }

  void respondToCase(String id, String role) {
    final index = _cases.indexKeyWhere(id);
    if (index != -1) {
      final current = _cases[index];
      _cases[index] = current.copyWith(
        status: 'Rescuer Assigned ($role)',
        responders: current.responders + 1,
        userResponseRole: role,
      );
      notifyListeners();
    }
  }

  void donateToCase(String id, int amount) {
    final index = _cases.indexKeyWhere(id);
    if (index != -1) {
      final current = _cases[index];
      _cases[index] = current.copyWith(
        donationsRaised: current.donationsRaised + amount,
      );
      notifyListeners();
    }
  }

  RescueCase? getCaseById(String id) {
    final index = _cases.indexKeyWhere(id);
    if (index != -1) return _cases[index];
    return null;
  }
}

extension _ListSearch on List<RescueCase> {
  int indexKeyWhere(String id) {
    return indexWhere((c) => c.id == id);
  }
}
