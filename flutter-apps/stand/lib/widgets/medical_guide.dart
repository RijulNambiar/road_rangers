import 'package:flutter/material.dart';

class MedicalGuide {
  static void showGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medical_services, color: Colors.white, size: 30),
                      SizedBox(width: 12),
                      Text(
                        'First Aid Guide & Safety Tips',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  _buildGuideCard(
                    'Initial Assessment',
                    Icons.check_circle_outline,
                    [
                      'Ensure the scene is safe',
                      'Check if the person is conscious',
                      'Call emergency services immediately',
                      'Look for obvious injuries',
                      'Check for medical identification',
                    ],
                  ),
                  _buildGuideCard(
                    'Basic Life Support',
                    Icons.favorite,
                    [
                      'Check breathing and pulse',
                      'If not breathing, begin CPR if trained',
                      'Place in recovery position if breathing',
                      'Monitor vital signs until help arrives',
                      'Keep the person warm',
                    ],
                  ),
                  _buildGuideCard(
                    'Bleeding Control',
                    Icons.healing,
                    [
                      'Apply direct pressure to wound',
                      'Use clean cloth or gauze',
                      'Keep the injured person warm',
                      'Don\'t remove embedded objects',
                      'Elevate injured limbs if possible',
                    ],
                  ),
                  _buildGuideCard(
                    'Head & Spine Injuries',
                    Icons.accessibility_new,
                    [
                      'Don\'t move the person',
                      'Stabilize the head and neck',
                      'Check for responsiveness',
                      'Monitor breathing carefully',
                      'Note any clear fluid from ears/nose',
                    ],
                  ),
                  _buildGuideCard(
                    'Important Don\'ts',
                    Icons.do_not_disturb,
                    [
                      'Don\'t move the victim unless necessary',
                      'Don\'t remove helmet if present',
                      'Don\'t give food or water',
                      'Don\'t leave the victim alone',
                      'Don\'t remove clothing stuck to burns',
                    ],
                  ),
                  _buildGuideCard(
                    'Your Safety First',
                    Icons.security,
                    [
                      'Park your vehicle safely',
                      'Turn on hazard lights',
                      'Wear high-visibility clothing if available',
                      'Set up warning triangles if available',
                      'Keep yourself safe from traffic',
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

  static Widget _buildGuideCard(String title, IconData icon, List<String> points) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.red.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.red, size: 28),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...points.map((point) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.arrow_right, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}