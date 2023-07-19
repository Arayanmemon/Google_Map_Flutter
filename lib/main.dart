import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_app/home_screen.dart';
import 'package:google_map_app/search_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const SearchPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> _marker = [];
  final List<Marker> _list = const[
      Marker(markerId: MarkerId('1'), position: LatLng(25.422110, 68.340493), draggable: true, infoWindow: InfoWindow(title: 'My Home')),
      // Marker(markerId: MarkerId('2'), position: LatLng(25.408410, 68.262192), draggable: true, infoWindow: InfoWindow(title: 'Muet Jamshoro')),
      Marker(markerId: MarkerId('3'), position: LatLng(25.418410, 68.302192), draggable: true, infoWindow: InfoWindow(title: 'Jamshoro City')),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
    LocateUser();
  }

  LocateUser(){
    getUserLocation().then((data) async {
      _live = CameraPosition(target: LatLng(data.latitude, data.longitude), zoom: 16);
      _marker.add(Marker(markerId: MarkerId('4'),
          position: LatLng(data.latitude, data.longitude),
          infoWindow: InfoWindow(title: 'My Current Location')
      ));

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_live));
      setState(() {

      });
    });
  }

  Future<Position> getUserLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }
  CameraPosition _live = CameraPosition(target: LatLng(25.422110, 68.340493), zoom: 10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps App'),
      ),
      body:  SafeArea(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers: Set<Marker>.of(_marker),
            initialCameraPosition: _live,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          padding: EdgeInsets.all(8.0),
          compassEnabled: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_city),
          onPressed: (){

      }),
    );
  }
}
