/// Model untuk titik koordinat dalam rute
class RoutePoint {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double speed; // km/h
  final String? address;

  const RoutePoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speed,
    this.address,
  });
}

/// Model untuk histori perjalanan kendaraan
class TripHistory {
  final int id;
  final int vehicleId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalDistance; // km
  final double avgSpeed; // km/h
  final double maxSpeed; // km/h
  final List<RoutePoint> routePoints;
  final String startAddress;
  final String endAddress;

  const TripHistory({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.avgSpeed,
    required this.maxSpeed,
    required this.routePoints,
    required this.startAddress,
    required this.endAddress,
  });

  Duration get duration => endTime.difference(startTime);
  
  String get durationString {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}j ${minutes}m';
    }
    return '${minutes} menit';
  }
}
