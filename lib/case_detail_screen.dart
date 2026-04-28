import 'package:flutter/material.dart';

class CaseDetailScreen extends StatefulWidget {
  final String species;
  final String emoji;
  final String severity;
  final Color severityColor;
  final String description;
  final String location;
  final String distance;

  const CaseDetailScreen({super.key, 
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

  void _respond() {
    setState(() => _responded = true);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🐾', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text('Thank you!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16a34a))),
            SizedBox(height: 8),
            Text(
              'The person who reported this animal has been notified. You are a hero!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close',
              style: TextStyle(color: Color(0xFF16a34a))),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [

          // Big header with animal emoji
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: widget.severityColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: widget.severityColor.withOpacity(0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(widget.emoji,
                      style: TextStyle(fontSize: 80)),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.severityColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(widget.severity,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Animal + location
                  Text(widget.species,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_on,
                      size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(widget.location,
                      style: TextStyle(color: Colors.grey)),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF16a34a).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(widget.distance,
                        style: TextStyle(
                          color: Color(0xFF16a34a),
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                    ),
                  ]),
                  SizedBox(height: 20),

                  // What was reported
                  _SectionTitle('What was reported'),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(widget.description,
                      style: TextStyle(
                        fontSize: 15, height: 1.5)),
                  ),
                  SizedBox(height: 20),

                  // AI First Aid — THE KEY FEATURE
                  _SectionTitle('🩺 AI First Aid Guide'),
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Do these RIGHT NOW:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800])),
                        SizedBox(height: 8),
                        _AidStep('Keep the animal warm and calm'),
                        _AidStep('Do NOT move if spine injury suspected'),
                        _AidStep('Give water slowly with a dropper'),
                        _AidStep('Cover wounds with clean cloth'),
                        SizedBox(height: 12),
                        Text('Do NOT do these:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[800])),
                        SizedBox(height: 8),
                        _DontStep('Give human medicine'),
                        _DontStep('Force feed food'),
                        _DontStep('Leave the animal alone'),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            Icon(Icons.info_outline,
                              color: Colors.blue, size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tell the vet: Animal found on street, '
                                'symptoms for unknown duration.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[800])),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Nearby vets
                  _SectionTitle('Nearby Vets Available'),
                  SizedBox(height: 8),
                  _VetCard('Dr. Mehta', 'Dogs & Cats',
                    '0.8 km', '4.9', true),
                  SizedBox(height: 8),
                  _VetCard('Dr. Shah', 'All Animals',
                    '2.1 km', '4.7', true),
                  SizedBox(height: 24),

                  // I CAN HELP button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _responded ? null : _respond,
                      icon: Icon(
                        _responded
                          ? Icons.check : Icons.volunteer_activism,
                        color: Colors.white),
                      label: Text(
                        _responded
                          ? 'Responding ✓' : 'I Can Help This Animal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _responded
                          ? Colors.grey : Color(0xFF16a34a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Donate button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () => _showDonateSheet(context),
                      icon: Icon(Icons.favorite,
                        color: Colors.red),
                      label: Text('Fund Treatment',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDonateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fund This Animal\'s Treatment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('100% goes directly to vet treatment',
              style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [50, 100, 250, 500].map((amount) =>
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(
                        '❤️ ₹$amount donated! Thank you!')));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF16a34a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('₹$amount',
                    style: TextStyle(color: Colors.white)),
                )
              ).toList(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Helper widgets
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold));
  }
}

class _AidStep extends StatelessWidget {
  final String text;
  const _AidStep(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('✅ ',
            style: TextStyle(fontSize: 13)),
          Expanded(child: Text(text,
            style: TextStyle(fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}

class _DontStep extends StatelessWidget {
  final String text;
  const _DontStep(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('❌ ',
            style: TextStyle(fontSize: 13)),
          Expanded(child: Text(text,
            style: TextStyle(fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}

class _VetCard extends StatelessWidget {
  final String name, specialty, distance, rating;
  final bool available;
  const _VetCard(this.name, this.specialty,
           this.distance, this.rating, this.available);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: Color(0xFF16a34a).withOpacity(0.1),
          child: Text('👨‍⚕️')),
        SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: TextStyle(fontWeight: FontWeight.bold)),
            Text(specialty,
              style: TextStyle(
                color: Colors.grey, fontSize: 12)),
          ],
        )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('⭐ $rating',
              style: TextStyle(fontSize: 12)),
            SizedBox(height: 2),
            Text(distance,
              style: TextStyle(
                color: Color(0xFF16a34a),
                fontSize: 12,
                fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Free',
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 11,
              fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }
}