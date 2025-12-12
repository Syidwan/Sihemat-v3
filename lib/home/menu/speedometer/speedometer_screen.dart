import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/home/track/live_tracking_screen.dart';

class SpeedometerScreen extends StatelessWidget {
  final Vehicle vehicle;
  
  const SpeedometerScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final currentAccount = SessionManager.currentAccount;
    
    // Demo values - in production, get from real-time data
    final double speed = 120;
    final double battery = 78;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text(
          'Speedometer',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Info Kendaraan
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kode: ${vehicle.code}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Plat: ${vehicle.plate}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: vehicle.status == 'online' 
                                ? Colors.green 
                                : Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.wifi,
                            color: vehicle.status == 'online'
                                ? Colors.green
                                : Colors.grey,
                            size: 20,
                          ),
                        ],
                      )
                    ],
                  ),
                  
                  // Owner info (jika pengguna)
                  if (currentAccount?.role == 'pengguna') ...[
                    SizedBox(height: 8),
                    Divider(height: 1),
                    SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final owner = AccountRepository.getVehicleOwner(vehicle.id);
                        if (owner == null) return SizedBox.shrink();
                        
                        return Row(
                          children: [
                            Icon(Icons.business, size: 14, color: Colors.orange.shade700),
                            SizedBox(width: 6),
                            Text(
                              'Pemilik: ${owner.fullName}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Speedometer Digital
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Lingkaran speedometer
                  CustomPaint(
                    size: const Size(220, 220),
                    painter: _SpeedometerPainter(speed),
                  ),

                  // Nilai speed digital
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        speed.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'km/h',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Info Tambahan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBox(Icons.battery_full, '$battery%', 'Baterai'),
                _infoBox(Icons.route, '${vehicle.todayKm} km', 'Hari Ini'),
                _infoBox(Icons.speed, '${vehicle.totalKm} km', 'Odometer'),
              ],
            ),

            const SizedBox(height: 24),

            // Tombol
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(
                  Icons.location_searching,
                  'Lacak',
                  Colors.red,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveTrackingScreen(vehicle: vehicle),
                      ),
                    );
                  },
                ),
                _actionButton(
                  Icons.info_outline,
                  'Informasi',
                  Colors.blue,
                  () {
                    _showVehicleInfo(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showVehicleInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Kendaraan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _infoRow('Kode', vehicle.code),
            _infoRow('Plat Nomor', vehicle.plate),
            _infoRow('Tipe', vehicle.type == 'motorcycle' ? 'Motor' : 'Mobil'),
            _infoRow('Status', vehicle.status),
            _infoRow('Total KM', '${vehicle.totalKm} km'),
            _infoRow('KM Hari Ini', '${vehicle.todayKm} km'),
            if (vehicle.address != null)
              _infoRow('Lokasi', vehicle.address!),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(IconData icon, String value, String label) {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Courier',
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// Custom Painter Speedometer Arc
class _SpeedometerPainter extends CustomPainter {
  final double speed;
  _SpeedometerPainter(this.speed);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startAngle = math.pi;
    final sweepAngle = (speed / 180) * math.pi;

    // background arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        math.pi, false, basePaint);

    // progress arc
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}