import 'dart:async';
import 'package:planner_app/main.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:planner_app/models/Models.dart';
import 'package:planner_app/screens/TripDetailsPage.dart';

class TripOverviewPage extends StatefulWidget {
  final Travel travel;
  final pickedimage;

  const TripOverviewPage(
      {super.key, required this.travel, required this.pickedimage});

  @override
  State<TripOverviewPage> createState() => _TripOverviewPageState();
}

class _TripOverviewPageState extends State<TripOverviewPage> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _initialCameraPosition;

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 2.5 / 6,
            // color: const Color(0xffb3a78b1),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(80),
              image: DecorationImage(
                  image: widget.travel.imageURL != null &&
                          widget.travel.imageURL != 'null'
                      ? NetworkImage(widget.travel.imageURL!)
                      //: pickedimage != null
                      //  ? FileImage(File(pickedimage!.path))
                      : const AssetImage('lib/images/blue.png')
                          as ImageProvider<Object>,
                  // image: AssetImage('lib/images/amsterdam.jpg'),
                  fit: BoxFit.fill),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.travel.startDate.day}${_getDaySuffix(widget.travel.startDate.day)} ${_getMonthAbbreviation(widget.travel.startDate.month)}-${widget.travel.endDate.day}${_getDaySuffix(widget.travel.endDate.day)} ${_getMonthAbbreviation(widget.travel.endDate.month)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          capitalize(widget.travel.title),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xfb3a78b1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    capitalize(widget.travel.description),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    _initialCameraPosition ?? LatLng(37.2430548, -115.8120572),
                zoom: 14.0, // Set the initial zoom level
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              myLocationEnabled: false, // Enable user's current location
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 1 / 6,
            color: Colors.white,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      builder: (context) =>
                          TripDetailsPage(travel: widget.travel),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  backgroundColor: const Color(0xffb3a78b1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                ),
                child: const Text('View Activities'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }

    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
