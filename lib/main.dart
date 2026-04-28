import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'case_detail_screen.dart';

void main() {
  runApp(PawRakshakApp());
}

class PawRakshakApp extends StatelessWidget {
  const PawRakshakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawRakshak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF16a34a),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF16a34a),
        title: Row(
          children: [
            Text('🐾', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text('PawRakshak',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFFf0fdf4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF16a34a)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Every paw deserves help 🐾',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16a34a))),
                  SizedBox(height: 6),
                  Text(
                      'Report injured animals. Connect with vets. Save lives.',
                      style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _StatCard('12', 'Active Cases', Colors.red),
                SizedBox(width: 12),
                _StatCard('8', 'Vets Online', Color(0xFF16a34a)),
                SizedBox(width: 12),
                _StatCard('143', 'Lives Saved', Colors.orange),
              ],
            ),
            SizedBox(height: 20),
            Text('Active Cases Near You',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _CaseCard(
              species: 'Cat',
              emoji: '🐱',
              severity: 'Critical',
              severityColor: Colors.red,
              description: 'Suspected parvo. Not eating for 3 days.',
              location: 'Navrangpura, Ahmedabad',
              distance: '0.8 km away',
            ),
            SizedBox(height: 12),
            _CaseCard(
              species: 'Dog',
              emoji: '🐶',
              severity: 'High',
              severityColor: Colors.orange,
              description: 'Hit by car. Bleeding from back leg.',
              location: 'Satellite, Ahmedabad',
              distance: '2.1 km away',
            ),
            SizedBox(height: 12),
            _CaseCard(
              species: 'Cow',
              emoji: '🐄',
              severity: 'Medium',
              severityColor: Colors.green,
              description: 'Deep wound on left leg from wire.',
              location: 'Maninagar, Ahmedabad',
              distance: '3.4 km away',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ReportScreen()));
        },
        backgroundColor: Colors.red,
        icon: Icon(Icons.add_alert, color: Colors.white),
        label: Text('Report Animal',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final Color color;
  const _StatCard(this.number, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(number,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final String species, emoji, severity, description, location, distance;
  final Color severityColor;

  const _CaseCard({
    required this.species,
    required this.emoji,
    required this.severity,
    required this.severityColor,
    required this.description,
    required this.location,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CaseDetailScreen(
            species: species,
            emoji: emoji,
            severity: severity,
            severityColor: severityColor,
            description: description,
            location: location,
            distance: distance,
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(emoji, style: TextStyle(fontSize: 26))),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(species,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: severityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: severityColor.withOpacity(0.5)),
                        ),
                        child: Text(severity,
                            style: TextStyle(
                                color: severityColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(description,
                      style: TextStyle(color: Colors.grey[700])),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 13, color: Colors.grey),
                      Text(location,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey)),
                      Spacer(),
                      Text(distance,
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF16a34a),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}