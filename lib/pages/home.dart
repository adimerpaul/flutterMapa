import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MapController _mapController = MapController();
  var lat = -17.969667;
  var lon = -67.114658;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission();
    miUbicacion();
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
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(lat, lon),
          initialZoom: 13,
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
      )
    );
  }
}
