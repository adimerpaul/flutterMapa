import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/location_service.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MapController _mapController = MapController();
  var lat = -17.969667;
  var lon = -67.114658;
  List locations = [];

  @override
  void initState() {
    super.initState();
    permission();
    // miUbicacion();
    getLocations();
  }
  getLocations() async {
    var locations = await LocationService().getLocations();
    print(locations);
    setState(() {
      this.locations = locations;
    });
  }
  permission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }
  miUbicacion() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    _mapController.move(LatLng(lat, lon), 17);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              // return ListTile(
              //   title: Text(locations[index]['name']),
              //   subtitle: Text(locations[index]['city']),
              //   onTap: () {
              //     setState(() {
              //       lat = double.parse(locations[index]['latitude']);
              //       lon = double.parse(locations[index]['longitude']);
              //     });
              //     _mapController.move(LatLng(lat, lon), 6);
              //   },
              // );
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    lat = double.parse(locations[index]['latitude']);
                    lon = double.parse(locations[index]['longitude']);
                  });
                  _mapController.move(LatLng(lat, lon), 6);
                },
                child: Text(locations[index]['name']),
              );
            },
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(lat, lon),
                initialZoom: 6,
              ),
              children: [
                TileLayer( // Display map tiles from any source
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                  userAgentPackageName: 'com.example.app',
                  // And many more recommended properties!
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat, lon),
                      width: 25,
                      height: 25,
                      child: Icon(Icons.location_on, color: Colors.red),
                    ),
                  ],
                ),
                RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => print('OpenStreetMap contributors'),
                    ),
                    // Also add images...
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
