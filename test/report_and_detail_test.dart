import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paw_rakshak/theme/app_theme.dart';
import 'package:paw_rakshak/report_screen.dart';
import 'package:paw_rakshak/case_detail_screen.dart';
import 'package:paw_rakshak/services/case_repository.dart';

void main() {
  testWidgets('ReportScreen renders triage fields and quick symptom tags', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: const ReportScreen(),
    ));
    await tester.pump();

    // Verify key triage sections
    expect(find.text('Report Injured Animal'), findsOneWidget);
    expect(find.text('1. Animal Species'), findsOneWidget);
    expect(find.text('2. Urgency Triage Level'), findsOneWidget);
    expect(find.text('3. Quick Observation Tags'), findsOneWidget);
    expect(find.text('4. Incident Location'), findsOneWidget);
    expect(find.text('DISPATCH EMERGENCY ALERT'), findsOneWidget);

    // Tap a quick symptom chip and verify it appends
    await tester.tap(find.text('Heavy bleeding'));
    await tester.pump();
    expect(find.textContaining('Heavy bleeding'), findsWidgets);
  });

  testWidgets('CaseDetailScreen renders protocol and volunteer actions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: const CaseDetailScreen(
        caseId: 'PR-101',
        species: 'Dog',
        emoji: '🐶',
        severity: 'Critical',
        severityColor: AppColors.emergency,
        description: 'Severe accident on SG Highway.',
        location: 'Bodakdev, Ahmedabad',
        distance: '1.2 km',
      ),
    ));
    await tester.pump();

    // Verify key sections
    expect(find.text('Dog Emergency Rescue'), findsOneWidget);
    expect(find.text('CRITICAL PRIORITY'), findsOneWidget);
    expect(find.text('Rescue Pipeline Status'), findsOneWidget);
    expect(find.text('Reported Incident Details'), findsOneWidget);
    expect(find.text('AI Immediate First-Aid Protocol'), findsOneWidget);
    expect(find.text('Nearby Verified Responders & Clinics'), findsOneWidget);
    expect(find.text('I Can Help This Animal'), findsOneWidget);
    expect(find.text('Fund Medical Treatment'), findsOneWidget);
  });

  testWidgets('CaseRepository reacts to case updates and donations', (WidgetTester tester) async {
    final repo = CaseRepository.instance;
    final initialCasesCount = repo.cases.length;

    repo.addCase(
      species: 'Dog',
      emoji: '🐕',
      severity: 'Critical',
      severityColor: AppColors.emergency,
      description: 'Fracture on drive-in road',
      location: 'Drive-in Road, Ahmedabad',
    );

    expect(repo.cases.length, initialCasesCount + 1);
    expect(repo.cases.first.description, 'Fracture on drive-in road');

    final newCaseId = repo.cases.first.id;
    repo.respondToCase(newCaseId, 'Transporter');
    expect(repo.cases.first.userResponseRole, 'Transporter');
    expect(repo.cases.first.status, contains('Transporter'));

    repo.donateToCase(newCaseId, 500);
    expect(repo.cases.first.donationsRaised, 500);
  });
}
