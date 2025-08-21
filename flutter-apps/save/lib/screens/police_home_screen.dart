// police_home_screen.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:save/services/notification_service.dart';

class PoliceHomeScreen extends StatelessWidget {
 const PoliceHomeScreen({super.key});

 Future<Map<String, dynamic>> fetchAccidentData() async {
   final supabase = Supabase.instance.client;
   final accidentData = await supabase
       .from('accident')
       .select('*')
       .order('reported_at', ascending: false)
       .limit(1)
       .single();

   final hospitalData = await supabase
       .from('hospital')
       .select('hospital_latitude, hospital_longitude, dropped_at')
       .eq('person_id', accidentData['person_id'])
       .order('dropped_at', ascending: false)
       .limit(1)
       .maybeSingle();

   return {
     ...accidentData,
     'hospital': hospitalData,
   };
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Police Dashboard'),
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
       child: FutureBuilder<Map<String, dynamic>>(
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
           
           if (!snapshot.hasData) {
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

           final data = snapshot.data!;
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
                         leading: Icon(Icons.person, color: Colors.teal[700]),
                         title: const Text('Person ID'),
                         subtitle: Text('${data['person_id']}'),
                       ),
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
               if (data['hospital'] != null) 
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
                               'Hospital Details',
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
                           leading: Icon(Icons.access_time, color: Colors.teal[700]),
                           title: const Text('Time'),
                           subtitle: Text(DateTime.parse(data['hospital']['dropped_at'])
                               .toString()
                               .split(' ')[1]
                               .split('.')[0]),
                         ),
                         ListTile(
                           contentPadding: EdgeInsets.zero,
                           leading: Icon(Icons.calendar_today, color: Colors.teal[700]),
                           title: const Text('Date'),
                           subtitle: Text(DateTime.parse(data['hospital']['dropped_at'])
                               .toString()
                               .split(' ')[0]),
                         ),
                         ListTile(
                           contentPadding: EdgeInsets.zero,
                           leading: Icon(Icons.location_on, color: Colors.teal[700]),
                           title: const Text('Location'),
                           subtitle: Text(
                               '(${data['hospital']['hospital_latitude']}, ${data['hospital']['hospital_longitude']})'),
                         ),
                         const SizedBox(height: 16),
                         ElevatedButton.icon(
                           onPressed: () => NotificationService.openLocationInMap(
                             data['hospital']['hospital_latitude'],
                             data['hospital']['hospital_longitude'],
                           ),
                           icon: const Icon(Icons.local_hospital),
                           label: const Text('View Hospital Location'),
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