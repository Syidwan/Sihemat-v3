import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/menu/speedometer/speedometer_list_screen.dart';
import 'package:sihemat_v3/home/menu/speedometer/speedometer_screen.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';


class SpeedometerNavigator {
  /// Navigasi speedometer berdasarkan role user
  /// - Korporasi: Tampilkan list kendaraan untuk dipilih
  /// - Pengguna: Langsung ke speedometer kendaraan yang ditugaskan
  static void navigate(BuildContext context) {
    final currentAccount = SessionManager.currentAccount;
    
    if (currentAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan login terlebih dahulu')),
      );
      return;
    }

    if (currentAccount.role == 'korporasi') {
      // Korporasi: Tampilkan list kendaraan
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeedometerListScreen(),
        ),
      );
    } else if (currentAccount.role == 'pengguna') {
      // Pengguna: Langsung ke speedometer kendaraan yang ditugaskan
      if (currentAccount.assignedVehicleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anda belum memiliki kendaraan yang ditugaskan')),
        );
        return;
      }

      final vehicle = VehicleRepository.getVehicleById(
        currentAccount.assignedVehicleId!,
      );

      if (vehicle == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kendaraan tidak ditemukan')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeedometerScreen(vehicle: vehicle),
        ),
      );
    }
  }
}