// ambulance_home_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:save/services/notification_service.dart';
import 'package:geolocator/geolocator.dart';

class AmbulanceHomeScreen extends StatelessWidget {
 const AmbulanceHomeScreen({super.key});

 Future<List<Map<String, dynamic>>> fetchAccidentData() async {
   final supabase = Supabase.instance.client;
   final response = await supabase
       .from('accident')
       .select('*')
       .order('reported_at', ascending: false)
       .limit(1);
   return List<Map<String, dynamic>>.from(response);
 }

 Future<void> updateHospitalLocation(BuildContext context, dynamic personId) async {
   final supabase = Supabase.instance.client;
   try {
     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       throw Exception('Location services are disabled.');
     }

     LocationPermission permission = await Geolocator.requestPermission();
     if (permission == LocationPermission.denied) {
       throw Exception('Location permission denied');
     }
     
     if (permission == LocationPermission.deniedForever) {
       throw Exception('Location permissions are permanently denied');
     }

     Position position = await Geolocator.getCurrentPosition();
     
     await supabase.from('hospital').insert({
       'person_id': personId.toString(),
       'hospital_latitude': position.latitude,
       'hospital_longitude': position.longitude,
     });
     
     if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Row(
             children: [
               const Icon(Icons.check_circle, color: Colors.white),
               const SizedBox(width: 8),
               const Text('Hospital location updated'),
             ],
           ),
           backgroundColor: Colors.green[600],
           behavior: SnackBarBehavior.floating,
         ),
       );
     }
   } catch (e) {
     if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Row(
             children: [
               const Icon(Icons.error_outline, color: Colors.white),
               const SizedBox(width: 8),
               Expanded(child: Text('Error: $e')),
             ],
           ),
           backgroundColor: Colors.red[600],
           behavior: SnackBarBehavior.floating,
         ),
       );
     }
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Ambulance Dashboard'),
       automaticallyImplyLeading: false,
     ),
     body: Container(
       decoration: BoxDecoration(
         gradient: LinearGradient(
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [Colors.teal[50]!, Colors.white],
         ),
       ),
       child: FutureBuilder<List<Map<String, dynamic>>>(
         future: fetchAccidentData(),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           }
           
           if (snapshot.hasError) {
             return Center(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.error_outline, size: 48, color: Colors.red),
                     const SizedBox(height: 16),
                     Text(
                       'Error: ${snapshot.error}',
                       style: const TextStyle(color: Colors.red),
                       textAlign: TextAlign.center,
                     ),
                   ],
                 ),
               ),
             );
           }
           
           if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
                   SizedBox(height: 16),
                   Text(
                     'No accident reports found',
                     style: TextStyle(fontSize: 18),
                   ),
                 ],
               ),
             );
           }

           final data = snapshot.data!.first;
           return ListView(
             padding: const EdgeInsets.all(16),
             children: [
               Card(
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(Icons.warning_amber_rounded, 
                               color: Colors.orange[700], size: 28),
                           const SizedBox(width: 12),
                           const Text(
                             'Accident Details',
                             style: TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       ),
                       const Divider(height: 30),
                       ListTile(
                         contentPadding: EdgeInsets.zero,
                         leading: Icon(Icons.location_on, color: Colors.teal[700]),
                         title: const Text('Location'),
                         subtitle: Text('(${data['latitude']}, ${data['longitude']})'),
                       ),  
                       const SizedBox(height: 16),
                       ElevatedButton.icon(
                         onPressed: () => NotificationService.openLocationInMap(
                           data['latitude'],
                           data['longitude'],
                         ),
                         icon: const Icon(Icons.map),
                         label: const Text('View Accident Location'),
                         style: ElevatedButton.styleFrom(
                           foregroundColor: Colors.white,
                           backgroundColor: Colors.teal[600],
                           minimumSize: const Size(double.infinity, 45),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               const SizedBox(height: 16),
               Card(
                 child: Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Icon(Icons.local_hospital, 
                               color: Colors.red[400], size: 28),
                           const SizedBox(width: 12),
                           const Text(
                             'Hospital Information',
                             style: TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ],
                       ),
                       const Divider(height: 30),
                       const SizedBox(height: 8),
                       ElevatedButton.icon(
                         onPressed: () => updateHospitalLocation(context, data['person_id']),
                         icon: const Icon(Icons.add_location_alt),
                         label: const Text('Update Hospital Location'),
                         style: ElevatedButton.styleFrom(
                           foregroundColor: Colors.white,
                           backgroundColor: Colors.red[400],
                           minimumSize: const Size(double.infinity, 45),
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               const SizedBox(height: 16),
               ElevatedButton.icon(
                 onPressed: () {
                   Navigator.pushReplacementNamed(context, '/');
                 },
                 icon: const Icon(Icons.logout),
                 label: const Text('Logout'),
                 style: ElevatedButton.styleFrom(
                   foregroundColor: Colors.white,
                   backgroundColor: Colors.grey[700],
                   minimumSize: const Size(double.infinity, 45),
                 ),
               ),
             ],
           );
         },
       ),
     ),
   );
 }
}