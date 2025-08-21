// accident_card.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AccidentCard extends StatelessWidget {
  final Map<String, dynamic> accident;
  final Position userLocation;

  const AccidentCard({
    Key? key,
    required this.accident,
    required this.userLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      accident['latitude'],
      accident['longitude'],
    );

    return Card(
      child: ListTile(
        title: Text('Accident Alert'),
        subtitle: Text('${distance.round()}m away'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to accident details
        },
      ),
    );
  }
}