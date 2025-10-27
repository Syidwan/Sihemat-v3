import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';

class MapUtils {
  /// Get status color based on vehicle status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.grey;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  
  /// Calculate distance between two coordinates (in meters)
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final Distance distance = Distance();
    return distance.as(
      LengthUnit.Meter,
      LatLng(lat1, lon1),
      LatLng(lat2, lon2),
    );
  }
  
  /// Get center point from multiple vehicles
  static LatLng getCenterPoint(List<Vehicle> vehicles) {
    if (vehicles.isEmpty) {
      return LatLng(-6.9175, 107.6191); // Default: Bandung
    }
    
    double totalLat = 0;
    double totalLng = 0;
    
    for (var vehicle in vehicles) {
      totalLat += vehicle.latitude;
      totalLng += vehicle.longitude;
    }
    
    return LatLng(
      totalLat / vehicles.length,
      totalLng / vehicles.length,
    );
  }
  
  /// Format distance for display
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }
  
  /// Check if vehicle is within bounds
  static bool isVehicleInBounds(
    Vehicle vehicle,
    LatLng northEast,
    LatLng southWest,
  ) {
    return vehicle.latitude <= northEast.latitude &&
        vehicle.latitude >= southWest.latitude &&
        vehicle.longitude <= northEast.longitude &&
        vehicle.longitude >= southWest.longitude;
  }
}