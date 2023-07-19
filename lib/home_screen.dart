import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String address='Hey buddy';
  String loc = 'loc';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(address),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async{
                List<Placemark> placemarks = await placemarkFromCoordinates(25.419523, 68.343991);
                // List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");
                // loc = locations.last.latitude.toString() + locations.last.longitude.toString();
                setState(() {
                  address = placemarks.reversed.last.street.toString()+' ' +placemarks.last.administrativeArea.toString();
                });
              },
              child: Container(
                height: 50,
                color: Colors.teal,
                child: Center(child:Text('Convert')),
              ),
            ),
          )
        ],
      ),
    );
  }
}
