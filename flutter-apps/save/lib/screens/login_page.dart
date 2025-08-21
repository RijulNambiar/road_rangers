// login_page.dart

import 'package:flutter/material.dart';
import 'package:save/screens/ambulance_home_screen.dart';
import 'package:save/screens/police_home_screen.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class LoginPage extends StatelessWidget {
 const LoginPage({super.key});

 Future<void> stopBackgroundService() async {
   final service = FlutterBackgroundService();
   var isRunning = await service.isRunning();
   if (isRunning) {
     service.invoke("stopService");
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       decoration: BoxDecoration(
         gradient: LinearGradient(
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [Colors.teal[400]!, Colors.teal[200]!],
         ),
       ),
       child: SafeArea(
         child: Center(
           child: SingleChildScrollView(
             padding: const EdgeInsets.all(24.0),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.9),
                     shape: BoxShape.circle,
                   ),
                   child: Icon(
                     Icons.emergency,
                     size: 80,
                     color: Colors.teal[700],
                   ),
                 ),
                 const SizedBox(height: 24),
                 Text(
                   'Emergency Response',
                   style: TextStyle(
                     fontSize: 32,
                     fontWeight: FontWeight.bold,
                     color: Colors.white,
                     shadows: [
                       Shadow(
                         offset: const Offset(1, 1),
                         blurRadius: 3.0,
                         color: Colors.black.withOpacity(0.3),
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 48),
                 Card(
                   elevation: 4,
                   child: Padding(
                     padding: const EdgeInsets.all(24.0),
                     child: Column(
                       children: [
                         ElevatedButton.icon(
                           onPressed: () => Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => const PoliceHomeScreen()),
                           ),
                           icon: const Icon(Icons.local_police, size: 24),
                           label: const Text(
                             'Login as Police',
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                           ),
                           style: ElevatedButton.styleFrom(
                             foregroundColor: Colors.white,
                             backgroundColor: Colors.blue[600],
                             minimumSize: const Size(double.infinity, 54),
                           ),
                         ),
                         const SizedBox(height: 16),
                         ElevatedButton.icon(
                           onPressed: () => Navigator.pushReplacement(
                             context,
                             MaterialPageRoute(builder: (context) => const AmbulanceHomeScreen()),
                           ),
                           icon: const Icon(Icons.local_hospital, size: 24),
                           label: const Text(
                             'Login as Ambulance',
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                           ),
                           style: ElevatedButton.styleFrom(
                             foregroundColor: Colors.white,
                             backgroundColor: Colors.red[400],
                             minimumSize: const Size(double.infinity, 54),
                           ),
                         ),
                         const SizedBox(height: 16),
                         ElevatedButton.icon(
                           onPressed: () async {
                             await stopBackgroundService();
                             if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                   content: Text(
                                     'Accident alert service stopped',
                                     style: TextStyle(color: Colors.white),
                                   ),
                                   backgroundColor: Colors.orange,
                                 ),
                               );
                             }
                           },
                           icon: const Icon(Icons.stop_circle, size: 24),
                           label: const Text(
                             'Stop Accident Alert Service',
                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                           ),
                           style: ElevatedButton.styleFrom(
                             foregroundColor: Colors.white,
                             backgroundColor: Colors.grey[800],
                             minimumSize: const Size(double.infinity, 54),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ),
     ),
   );
 }
}