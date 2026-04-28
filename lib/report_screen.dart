import 'package:flutter/material.dart';
import 'ai_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _species = 'Cat';
  String _severity = 'Critical';
  final _descController = TextEditingController();
  bool _submitted = false;
  bool _isSubmitting = false;
  String _aiFirstAid = '';

  Future<void> _submitCase() async {
    setState(() => _isSubmitting = true);
    final firstAid = await AiService.getFirstAid(
      species: _species,
      symptoms: _descController.text.isEmpty
        ? '$_species found injured'
        : _descController.text,
    );
    setState(() {
      _isSubmitting = false;
      _submitted = true;
      _aiFirstAid = firstAid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessScreen(firstAid: _aiFirstAid);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: Text('Report Injured Animal',
          style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 48, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text('Tap to take photo',
                    style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Animal Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Cat','Dog','Cow','Bird','Other']
                .map((s) => ChoiceChip(
                  label: Text(s),
                  selected: _species == s,
                  selectedColor: Color(0xFF16a34a).withOpacity(0.2),
                  onSelected: (_) => setState(() => _species = s),
                )).toList(),
            ),
            SizedBox(height: 20),
            Text('How Urgent?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            Row(
              children: [
                _SeverityButton('Critical', Colors.red, _severity,
                  (v) => setState(() => _severity = v)),
                SizedBox(width: 8),
                _SeverityButton('High', Colors.orange, _severity,
                  (v) => setState(() => _severity = v)),
                SizedBox(width: 8),
                _SeverityButton('Medium', Colors.green, _severity,
                  (v) => setState(() => _severity = v)),
              ],
            ),
            SizedBox(height: 20),
            Text('What do you see?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe the animal and situation...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF16a34a), width: 2)),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Navrangpura, Ahmedabad',
                    style: TextStyle(color: Colors.blue[800])),
                  Spacer(),
                  Text('📍 Auto-detected',
                    style: TextStyle(fontSize: 12, color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submitCase,
                icon: _isSubmitting
                  ? SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                  : Icon(Icons.send, color: Colors.white),
                label: Text(
                  _isSubmitting ? 'Getting AI First Aid...' : 'SEND ALERT NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeverityButton extends StatelessWidget {
  final String label;
  final Color color;
  final String selected;
  final Function(String) onTap;
  const _SeverityButton(this.label, this.color, this.selected, this.onTap);

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(label),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? color : Colors.grey[300]!,
              width: isSelected ? 2 : 1),
          ),
          child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? color : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  final String firstAid;
  const _SuccessScreen({required this.firstAid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF16a34a).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('🐾', style: TextStyle(fontSize: 50))),
              ),
              SizedBox(height: 24),
              Text('Alert Sent!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16a34a))),
              SizedBox(height: 12),
              Text('Nearby vets and rescuers have been notified!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('🩺 ', style: TextStyle(fontSize: 16)),
                      Text('AI First Aid',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          fontSize: 15)),
                    ]),
                    SizedBox(height: 8),
                    Text(
                      firstAid.isEmpty
                        ? 'Keep the animal warm and calm.\nDo NOT give human medicine.\nVet is on the way!'
                        : firstAid,
                      style: TextStyle(height: 1.6)),
                  ],
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF16a34a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
