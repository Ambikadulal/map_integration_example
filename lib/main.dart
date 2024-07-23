import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(
        itemsWithLocation: [
          LocationItem(
            id: '1',
            title: 'Location 1',
            location:
                LocationCoordinates(coordinates: [85.318825202, 27.708309903]),
          ),
          LocationItem(
            id: '2',
            title: 'Location 2',
            location:
                LocationCoordinates(coordinates: [85.319825202, 27.709309903]),
          ),
        ],
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  final List<LocationItem> itemsWithLocation;
  const MapScreen({super.key, required this.itemsWithLocation});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _setMarkers() {
    for (var item in widget.itemsWithLocation) {
      markers.add(Marker(
        markerId: MarkerId(item.id),
        position: LatLng(
            item.location!.coordinates![1], item.location!.coordinates![0]),
        infoWindow: InfoWindow(title: item.title),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: GoogleMap(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.25),
        mapType: MapType.normal,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        markers: markers,
        onCameraMove: (CameraPosition cameraPosition) {
          if (kDebugMode) {
            print(cameraPosition.zoom);
          }
        },
        onMapCreated: (controller) {
          mapController = controller;
          if (widget.itemsWithLocation.isNotEmpty) {
            mapController.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(widget.itemsWithLocation[0].location!.coordinates![1],
                  widget.itemsWithLocation[0].location!.coordinates![0]),
              12.0,
            ));
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.itemsWithLocation.isNotEmpty
                ? widget.itemsWithLocation[0].location!.coordinates![1]
                : 27.708309903,
            widget.itemsWithLocation.isNotEmpty
                ? widget.itemsWithLocation[0].location!.coordinates![0]
                : 85.318825202,
          ),
          zoom: 12.0,
        ),
      ),
    );
  }
}

class LocationItem {
  final String id;
  final String title;
  final LocationCoordinates? location;

  LocationItem({required this.id, required this.title, this.location});
}

class LocationCoordinates {
  final List<double>? coordinates;

  LocationCoordinates({this.coordinates});
}
