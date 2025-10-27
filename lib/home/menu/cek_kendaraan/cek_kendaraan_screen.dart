import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';

class CekKendaraan extends StatelessWidget {
  final Vehicle vehicle;

  CekKendaraan({required this.vehicle});

  Color _getStatusColor(String status) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE53935),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cek Kendaraan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            
            // Vehicle Code & Plate
            Text(
              vehicle.code,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              vehicle.plate,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Total KM Hari Ini - Circular Display
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Km Hari ini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${vehicle.todayKm}',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 12, left: 4),
                        child: Text(
                          'Km',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Info Cards Grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Row 1: Baterai & Mode Berkendara
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.battery_charging_full,
                          title: 'Baterai',
                          value: '75%',
                          valueColor: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.wifi,
                          title: 'Mode\nBerkendara',
                          value: 'Online',
                          subtitle: 'MODE: ECO',
                          valueColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Row 2: Estimasi Jarak & Posisi
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          title: 'Estimasi Jarak\nTempuh',
                          value: '100Km',
                          subtitle: 'Perkiraan:\n4 jam 30 menit',
                          valueColor: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Posisi',
                          value: vehicle.address ?? 'Jl. Asia Afrika No.\n123, Bandung',
                          valueColor: Colors.black87,
                          isAddress: true,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 12),
                  
                  // Row 3: Suhu & Odometer
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.thermostat,
                          title: 'Suhu',
                          value: 'Mesin: 90°C\nLuar: 28°C\nBaterai: 35°C',
                          valueColor: Colors.black87,
                          isMultiLine: true,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.speed,
                          title: 'Odometer',
                          value: '${vehicle.totalKm} Km',
                          valueColor: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    required Color valueColor,
    bool isAddress = false,
    bool isMultiLine = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Colors.black54),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isAddress || isMultiLine ? 13 : 24,
              fontWeight: isAddress || isMultiLine ? FontWeight.w500 : FontWeight.bold,
              color: valueColor,
              height: isMultiLine ? 1.5 : 1.2,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}