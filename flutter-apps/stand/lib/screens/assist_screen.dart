import 'package:flutter/material.dart';
import 'package:stand/widgets/bottom_nav.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/notification_service.dart';
import '../widgets/medical_guide.dart';
import 'package:intl/intl.dart';

class AssistScreen extends StatefulWidget {
  @override
  _AssistScreenState createState() => _AssistScreenState();
}

class _AssistScreenState extends State<AssistScreen> {
  Map<String, dynamic>? _latestAccident;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchLatestAccident();
  }

  Future<void> _fetchLatestAccident() async {
    try {
      final response = await _supabase
          .from('accident')
          .select()
          .order('reported_at', ascending: false)
          .limit(1)
          .single();
      setState(() => _latestAccident = response);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching accident data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accident Assistance'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: _latestAccident == null
          ? Center(
              child: CircularProgressIndicator(color: Colors.red),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildAccidentDetailsCard(),
                  _buildQuickActionsCard(),
                  _buildGeneralInstructionsCard(),
                ],
              ),
            ),
      bottomNavigationBar: BottomNav(),
    );
  }

  Widget _buildAccidentDetailsCard() {
    final timestamp = DateTime.parse(_latestAccident!['reported_at']);
    final formattedTime = DateFormat('MMM d, y - h:mm a').format(timestamp.toLocal());

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accident Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            Divider(color: Colors.red.shade200),
            _buildDetailRow(
              Icons.access_time,
              'Reported',
              formattedTime,
            ),
            _buildDetailRow(
              Icons.location_on,
              'Location',
              'Lat: ${_latestAccident!['latitude'].toStringAsFixed(6)}\nLong: ${_latestAccident!['longitude'].toStringAsFixed(6)}',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => NotificationService.openLocationInMap(
                      _latestAccident!['latitude'],
                      _latestAccident!['longitude'],
                    ),
                    icon: Icon(Icons.map),
                    label: Text('View on Map'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => MedicalGuide.showGuide(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('First Aid Guide'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInstructionsCard() {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Instructions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            _buildInstruction(
              Icons.priority_high,
              'Stay Calm',
              'Maintain composure to help effectively',
            ),
            _buildInstruction(
              Icons.visibility,
              'Assess the Scene',
              'Check for any potential dangers',
            ),
            _buildInstruction(
              Icons.medical_services,
              'Check Victims',
              'Look for visible injuries and consciousness',
            ),
            _buildInstruction(
              Icons.call,
              'Call for Help',
              'Contact emergency services immediately',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade400, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue.shade700),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}