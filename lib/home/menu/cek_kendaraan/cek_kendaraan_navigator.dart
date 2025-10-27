import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/menu/cek_kendaraan/cek_kendaraan_list.dart';
import 'package:sihemat_v3/home/menu/cek_kendaraan/cek_kendaraan_screen.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

class CekKendaraanNavigator {
  /// Navigasi cek kendaraan berdasarkan role user
  /// - Korporasi: Tampilkan list kendaraan
  /// - Pengguna: Langsung ke detail kendaraan yang ditugaskan
  static void navigate(BuildContext context) {
    // Get current logged in account
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
          builder: (context) => CekKendaraanListPage(),
        ),
      );
    } else if (currentAccount.role == 'pengguna') {
      // Pengguna: Langsung ke detail kendaraan yang ditugaskan
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
          builder: (context) => CekKendaraan(vehicle: vehicle),
        ),
      );
    }
  }
}