import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koul_network/model/location_ip.dart' as lip;
import 'package:koul_network/secrets/api.dart';
import 'package:location/location.dart';

Future<lip.LocationIpData> locationIP() async {
  String ipAddress;
  try {
    final response = await http.get(Uri.parse(IP_URL));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ipAddress = data['ip'];
    } else {
      throw Exception('Error: Could not fetch IP');
    }
    final locationData = await fetchLocation();
    return lip.LocationIpData(ipAddress: ipAddress, locationData: locationData);
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<lip.LocationData> fetchLocation() async {
  Location location = Location();
  try {
    // Check if location services are enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service disabled');
      }
    }

    // Check location permission
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      // If permission is permanently denied, throw a specific exception
      if (permissionGranted == PermissionStatus.deniedForever) {
        throw Exception('Location permission permanently denied');
      } else if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }

    // Get the device location
    final locationData = await location.getLocation();
    String lat = locationData.latitude?.toString() ?? 'unknown';
    String lon = locationData.longitude?.toString() ?? 'unknown';

    return lip.LocationData(latitude: lat, longitude: lon);
  } catch (e) {
    throw Exception('Error: $e');
  }
}
