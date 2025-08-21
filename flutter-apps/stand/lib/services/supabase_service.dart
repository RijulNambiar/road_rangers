import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SupabaseService {
 final supabase = Supabase.instance.client;

 Future<List<Map<String, dynamic>>> getNearbyAccidents(Position userLocation) async {
   final response = await supabase
       .from('accident')
       .select()
       .order('reported_at', ascending: false);
       
   return (response as List<Map<String, dynamic>>).where((accident) {
     double distance = Geolocator.distanceBetween(
       userLocation.latitude,
       userLocation.longitude,
       accident['latitude'],
       accident['longitude'],
     );
     return distance <= 500;
   }).toList();
 }

 Future<Map<String, dynamic>?> getLatestAccident() async {
   final response = await supabase
       .from('accident')
       .select()
       .order('reported_at', ascending: false)
       .limit(1)
       .maybeSingle();
   return response;
 }

 Future<void> reportAccident(double lat, double lng) async {
   final userId = supabase.auth.currentUser?.id;
   await supabase.from('accident').insert({
     'person_id': userId,
     'latitude': lat,
     'longitude': lng,
     'reported_at': DateTime.now().toUtc().toIso8601String(),
   });
 }
}