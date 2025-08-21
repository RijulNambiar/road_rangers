import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth_screen.dart';
import 'services/notification_service.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 
 await Supabase.initialize(
   url: '',
   anonKey: '',
 );

 final notificationService = NotificationService();
 await notificationService.initializeService();

 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'STAND',
     theme: ThemeData(
       primarySwatch: Colors.blue,
       visualDensity: VisualDensity.adaptivePlatformDensity,
     ),
     home: AuthScreen(),
   );
 }
}