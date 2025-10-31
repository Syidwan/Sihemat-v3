// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';

class VehicleMarker {
  final Vehicle vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  VehicleMarker({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (vehicle.status) {
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

  Marker toMarker() {
    return Marker(
      point: LatLng(vehicle.latitude, vehicle.longitude),
      width: isSelected ? 90 : 60,
      height: isSelected ? 90 : 60,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.all(isSelected ? 14 : 10),
              decoration: BoxDecoration(
                color: _getStatusColor(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 4 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? _getStatusColor().withOpacity(0.6)
                        : Colors.black.withOpacity(0.3),
                    blurRadius: isSelected ? 12 : 6,
                    spreadRadius: isSelected ? 2 : 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                vehicle.type == 'motorcycle'
                    ? Icons.two_wheeler
                    : Icons.directions_car,
                color: Colors.white,
                size: isSelected ? 26 : 18,
              ),
            ),
            if (isSelected) ...[
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      vehicle.code,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}