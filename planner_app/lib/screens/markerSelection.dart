import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planner_app/models/Models.dart';

class MarkerSelection extends StatefulWidget {
  final Travel travel;

  const MarkerSelection({super.key, required this.travel});

  @override
  State<MarkerSelection> createState() => _MarkerSelectionState();
}

class _MarkerSelectionState extends State<MarkerSelection> {
  LatLng? _initialCameraPosition;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    getCoordinates(widget.travel.title);
  }

  Future<void> getCoordinates(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        print(placeName);
        print('Latitude: $latitude');
        print('Longitude: $longitude');
        setState(() {
          _initialCameraPosition = LatLng(latitude, longitude);
        });
        _createMap();
      } else {
        print('No location found for the given place name.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _createMap() async {
    if (_initialCameraPosition != null && _mapController != null) {
      _mapController!.animateCamera(
        await CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _initialCameraPosition!,
            zoom: 14.0,
          ),
        ),
      );
      print("AAAAAAAAAAAA<AAAA");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Marker Position'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition ?? LatLng(37.2430548, -115.8120572),
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (LatLng position) {
          print("Selected Point " +
              position!.latitude.toString() +
              position!.longitude.toString());
          Navigator.of(context).pop(position);
        },
      ),
    );
  }
}
