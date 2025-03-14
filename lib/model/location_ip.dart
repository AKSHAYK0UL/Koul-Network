class LocationIpData {
  final String ipAddress;
  final LocationData locationData;

  LocationIpData({
    required this.ipAddress,
    required this.locationData,
  });
}

class LocationData {
  final String latitude;
  final String longitude;

  LocationData({required this.latitude, required this.longitude});
}
