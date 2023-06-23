import 'package:geocoding/geocoding.dart';

class GoogleMaps {
  Future<Location> getCoordinates(String placeName) async {
    try {
      final places = await locationFromAddress(placeName);
      return places.first;
    } catch (e) {
      throw Exception('Failed to fetch coordinates');
    }
  }
}
