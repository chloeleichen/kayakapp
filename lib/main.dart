import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:custom_info_window/custom_info_window.dart';

final LatLng _KAYAK = LatLng(-33.84932499087874, 151.18251329157735);

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomInfoWindowExample(),
    );
  }
}

class CustomInfoWindowExample extends StatefulWidget {
  @override
  _CustomInfoWindowExampleState createState() =>
      _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  final LatLng _latLng = LatLng(-33.868820, 151.209290);
  final double _zoom = 15.0;
  BitmapDescriptor? myIcon;

  static final CameraPosition _kayak= CameraPosition(
  target: _KAYAK,
  zoom: 19.151926040649414);

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: MarkerId("Kayak #1"),
        position: _KAYAK,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(image: AssetImage('images/kayak1.jpg')),
                          Text(
                            "Yellow single Kayak",
                          ),
                         TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Kayak reserved!'),
                                        backgroundColor: Colors.deepOrange,
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_view_month_rounded),
                                  Text("Reserve")
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ],
            ),
            _KAYAK,
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayapp'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Account'),
                    ),
                    body: const Center(
                      child: Text(
                        'Your accoutn details',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: _zoom,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 210,
            width: 200,
            offset: 50,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){_customInfoWindowController.googleMapController?.animateCamera(CameraUpdate.newCameraPosition(_kayak));
    },
        label: Text('Find a Kayak!'),
        icon: Icon(Icons.kayaking),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}