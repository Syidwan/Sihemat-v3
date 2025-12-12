import 'package:sihemat_v3/models/route_history.dart';

/// Repository untuk menyimpan data historis perjalanan kendaraan
/// Data ini bersifat statis untuk demo, di production bisa diambil dari API/database
class RouteHistoryRepository {
  /// Mendapatkan semua trip history untuk kendaraan tertentu
  static List<TripHistory> getTripsByVehicleId(int vehicleId) {
    return _allTripHistories
        .where((trip) => trip.vehicleId == vehicleId)
        .toList();
  }

  /// Mendapatkan trip history berdasarkan ID
  static TripHistory? getTripById(int tripId) {
    try {
      return _allTripHistories.firstWhere((trip) => trip.id == tripId);
    } catch (e) {
      return null;
    }
  }

  /// Mendapatkan trip terakhir untuk kendaraan tertentu
  static TripHistory? getLatestTripByVehicleId(int vehicleId) {
    final trips = getTripsByVehicleId(vehicleId);
    if (trips.isEmpty) return null;
    trips.sort((a, b) => b.startTime.compareTo(a.startTime));
    return trips.first;
  }

  /// Data statis untuk semua trip history
  /// Menggunakan koordinat area Bandung
  static final List<TripHistory> _allTripHistories = [
    // ============================================
    // VEHICLE 1: D 1234 AB (Motor Honda Beat - Pertamina)
    // Trip: Sukajadi -> Dago -> Cihampelas
    // ============================================
    TripHistory(
      id: 1,
      vehicleId: 1,
      startTime: DateTime(2025, 12, 11, 7, 30, 0),
      endTime: DateTime(2025, 12, 11, 8, 15, 0),
      totalDistance: 8.5,
      avgSpeed: 25.0,
      maxSpeed: 45.0,
      startAddress: 'Jl. Sukajadi No. 123, Bandung',
      endAddress: 'Jl. Cihampelas No. 160, Bandung',
      routePoints: [
        // Start: Sukajadi
        RoutePoint(
          latitude: -6.8895,
          longitude: 107.5955,
          timestamp: DateTime(2025, 12, 11, 7, 30, 0),
          speed: 0,
          address: 'Jl. Sukajadi No. 123',
        ),
        RoutePoint(
          latitude: -6.8890,
          longitude: 107.5980,
          timestamp: DateTime(2025, 12, 11, 7, 32, 0),
          speed: 20,
        ),
        RoutePoint(
          latitude: -6.8885,
          longitude: 107.6010,
          timestamp: DateTime(2025, 12, 11, 7, 35, 0),
          speed: 30,
        ),
        // Menuju Setiabudi
        RoutePoint(
          latitude: -6.8870,
          longitude: 107.6050,
          timestamp: DateTime(2025, 12, 11, 7, 38, 0),
          speed: 35,
        ),
        RoutePoint(
          latitude: -6.8855,
          longitude: 107.6090,
          timestamp: DateTime(2025, 12, 11, 7, 42, 0),
          speed: 40,
        ),
        // Melewati Dago
        RoutePoint(
          latitude: -6.8880,
          longitude: 107.6130,
          timestamp: DateTime(2025, 12, 11, 7, 46, 0),
          speed: 35,
          address: 'Jl. Ir. H. Juanda (Dago)',
        ),
        RoutePoint(
          latitude: -6.8920,
          longitude: 107.6150,
          timestamp: DateTime(2025, 12, 11, 7, 50, 0),
          speed: 25,
        ),
        RoutePoint(
          latitude: -6.8960,
          longitude: 107.6140,
          timestamp: DateTime(2025, 12, 11, 7, 55, 0),
          speed: 30,
        ),
        // Menuju Cihampelas
        RoutePoint(
          latitude: -6.8990,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 8, 0, 0),
          speed: 35,
        ),
        RoutePoint(
          latitude: -6.9020,
          longitude: 107.6050,
          timestamp: DateTime(2025, 12, 11, 8, 5, 0),
          speed: 40,
        ),
        RoutePoint(
          latitude: -6.9050,
          longitude: 107.6020,
          timestamp: DateTime(2025, 12, 11, 8, 10, 0),
          speed: 25,
        ),
        // End: Cihampelas
        RoutePoint(
          latitude: -6.9080,
          longitude: 107.6010,
          timestamp: DateTime(2025, 12, 11, 8, 15, 0),
          speed: 0,
          address: 'Jl. Cihampelas No. 160',
        ),
      ],
    ),

    // Trip 2: Siang hari - Cihampelas -> Pasteur -> Sukajadi (pulang)
    TripHistory(
      id: 2,
      vehicleId: 1,
      startTime: DateTime(2025, 12, 11, 17, 0, 0),
      endTime: DateTime(2025, 12, 11, 17, 50, 0),
      totalDistance: 9.2,
      avgSpeed: 22.0,
      maxSpeed: 40.0,
      startAddress: 'Jl. Cihampelas No. 160, Bandung',
      endAddress: 'Jl. Sukajadi No. 123, Bandung',
      routePoints: [
        RoutePoint(
          latitude: -6.9080,
          longitude: 107.6010,
          timestamp: DateTime(2025, 12, 11, 17, 0, 0),
          speed: 0,
          address: 'Jl. Cihampelas No. 160',
        ),
        RoutePoint(
          latitude: -6.9050,
          longitude: 107.6030,
          timestamp: DateTime(2025, 12, 11, 17, 5, 0),
          speed: 15,
        ),
        RoutePoint(
          latitude: -6.9020,
          longitude: 107.6070,
          timestamp: DateTime(2025, 12, 11, 17, 10, 0),
          speed: 20,
        ),
        RoutePoint(
          latitude: -6.8990,
          longitude: 107.6110,
          timestamp: DateTime(2025, 12, 11, 17, 15, 0),
          speed: 25,
        ),
        // Via Pasteur
        RoutePoint(
          latitude: -6.8950,
          longitude: 107.6080,
          timestamp: DateTime(2025, 12, 11, 17, 20, 0),
          speed: 30,
          address: 'Jl. Dr. Djunjunan (Pasteur)',
        ),
        RoutePoint(
          latitude: -6.8920,
          longitude: 107.6040,
          timestamp: DateTime(2025, 12, 11, 17, 25, 0),
          speed: 35,
        ),
        RoutePoint(
          latitude: -6.8900,
          longitude: 107.6000,
          timestamp: DateTime(2025, 12, 11, 17, 32, 0),
          speed: 40,
        ),
        RoutePoint(
          latitude: -6.8890,
          longitude: 107.5970,
          timestamp: DateTime(2025, 12, 11, 17, 40, 0),
          speed: 25,
        ),
        RoutePoint(
          latitude: -6.8895,
          longitude: 107.5955,
          timestamp: DateTime(2025, 12, 11, 17, 50, 0),
          speed: 0,
          address: 'Jl. Sukajadi No. 123',
        ),
      ],
    ),

    // ============================================
    // VEHICLE 2: D 2345 BC (Yamaha NMAX - Pertamina)
    // Trip: Dago -> Dipatiukur -> ITB
    // ============================================
    TripHistory(
      id: 3,
      vehicleId: 2,
      startTime: DateTime(2025, 12, 11, 8, 0, 0),
      endTime: DateTime(2025, 12, 11, 8, 30, 0),
      totalDistance: 5.0,
      avgSpeed: 20.0,
      maxSpeed: 35.0,
      startAddress: 'Jl. Dago No. 456, Bandung',
      endAddress: 'Kampus ITB, Bandung',
      routePoints: [
        RoutePoint(
          latitude: -6.8850,
          longitude: 107.6130,
          timestamp: DateTime(2025, 12, 11, 8, 0, 0),
          speed: 0,
          address: 'Jl. Dago No. 456',
        ),
        RoutePoint(
          latitude: -6.8870,
          longitude: 107.6140,
          timestamp: DateTime(2025, 12, 11, 8, 5, 0),
          speed: 15,
        ),
        RoutePoint(
          latitude: -6.8900,
          longitude: 107.6150,
          timestamp: DateTime(2025, 12, 11, 8, 10, 0),
          speed: 25,
        ),
        // Belok ke Dipatiukur
        RoutePoint(
          latitude: -6.8930,
          longitude: 107.6170,
          timestamp: DateTime(2025, 12, 11, 8, 15, 0),
          speed: 30,
          address: 'Jl. Dipatiukur',
        ),
        RoutePoint(
          latitude: -6.8950,
          longitude: 107.6180,
          timestamp: DateTime(2025, 12, 11, 8, 20, 0),
          speed: 20,
        ),
        // Menuju ITB
        RoutePoint(
          latitude: -6.8920,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 8, 25, 0),
          speed: 25,
        ),
        RoutePoint(
          latitude: -6.8910,
          longitude: 107.6090,
          timestamp: DateTime(2025, 12, 11, 8, 30, 0),
          speed: 0,
          address: 'Kampus ITB',
        ),
      ],
    ),

    // ============================================
    // VEHICLE 3: D 3456 CD (Toyota Avanza - Pertamina)
    // Trip: Pasteur -> Soekarno Hatta -> Buah Batu
    // ============================================
    TripHistory(
      id: 4,
      vehicleId: 3,
      startTime: DateTime(2025, 12, 11, 9, 0, 0),
      endTime: DateTime(2025, 12, 11, 10, 0, 0),
      totalDistance: 15.0,
      avgSpeed: 30.0,
      maxSpeed: 60.0,
      startAddress: 'Jl. Pasteur No. 789, Bandung',
      endAddress: 'Jl. Buah Batu No. 123, Bandung',
      routePoints: [
        RoutePoint(
          latitude: -6.8900,
          longitude: 107.5920,
          timestamp: DateTime(2025, 12, 11, 9, 0, 0),
          speed: 0,
          address: 'Jl. Pasteur No. 789',
        ),
        RoutePoint(
          latitude: -6.8950,
          longitude: 107.5950,
          timestamp: DateTime(2025, 12, 11, 9, 5, 0),
          speed: 30,
        ),
        RoutePoint(
          latitude: -6.9000,
          longitude: 107.6000,
          timestamp: DateTime(2025, 12, 11, 9, 10, 0),
          speed: 45,
        ),
        // Masuk Soekarno Hatta
        RoutePoint(
          latitude: -6.9100,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 9, 18, 0),
          speed: 55,
          address: 'Jl. Soekarno Hatta',
        ),
        RoutePoint(
          latitude: -6.9200,
          longitude: 107.6200,
          timestamp: DateTime(2025, 12, 11, 9, 25, 0),
          speed: 60,
        ),
        RoutePoint(
          latitude: -6.9300,
          longitude: 107.6250,
          timestamp: DateTime(2025, 12, 11, 9, 32, 0),
          speed: 50,
        ),
        // Menuju Buah Batu
        RoutePoint(
          latitude: -6.9350,
          longitude: 107.6280,
          timestamp: DateTime(2025, 12, 11, 9, 40, 0),
          speed: 40,
          address: 'Persimpangan Buah Batu',
        ),
        RoutePoint(
          latitude: -6.9400,
          longitude: 107.6300,
          timestamp: DateTime(2025, 12, 11, 9, 48, 0),
          speed: 30,
        ),
        RoutePoint(
          latitude: -6.9450,
          longitude: 107.6320,
          timestamp: DateTime(2025, 12, 11, 9, 55, 0),
          speed: 20,
        ),
        RoutePoint(
          latitude: -6.9480,
          longitude: 107.6340,
          timestamp: DateTime(2025, 12, 11, 10, 0, 0),
          speed: 0,
          address: 'Jl. Buah Batu No. 123',
        ),
      ],
    ),

    // ============================================
    // VEHICLE 6: D 6789 FG (Kawasaki Ninja - Shell)
    // Trip: Soekarno Hatta -> Kopo -> Tegalega
    // ============================================
    TripHistory(
      id: 5,
      vehicleId: 6,
      startTime: DateTime(2025, 12, 11, 7, 0, 0),
      endTime: DateTime(2025, 12, 11, 7, 45, 0),
      totalDistance: 12.0,
      avgSpeed: 28.0,
      maxSpeed: 50.0,
      startAddress: 'Jl. Soekarno Hatta No. 987, Bandung',
      endAddress: 'Tegalega, Bandung',
      routePoints: [
        RoutePoint(
          latitude: -6.9285,
          longitude: 107.6369,
          timestamp: DateTime(2025, 12, 11, 7, 0, 0),
          speed: 0,
          address: 'Jl. Soekarno Hatta No. 987',
        ),
        RoutePoint(
          latitude: -6.9320,
          longitude: 107.6300,
          timestamp: DateTime(2025, 12, 11, 7, 5, 0),
          speed: 25,
        ),
        RoutePoint(
          latitude: -6.9360,
          longitude: 107.6220,
          timestamp: DateTime(2025, 12, 11, 7, 10, 0),
          speed: 35,
        ),
        // Menuju Kopo
        RoutePoint(
          latitude: -6.9400,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 7, 18, 0),
          speed: 45,
          address: 'Jl. Kopo',
        ),
        RoutePoint(
          latitude: -6.9420,
          longitude: 107.6000,
          timestamp: DateTime(2025, 12, 11, 7, 25, 0),
          speed: 50,
        ),
        RoutePoint(
          latitude: -6.9380,
          longitude: 107.5920,
          timestamp: DateTime(2025, 12, 11, 7, 32, 0),
          speed: 40,
        ),
        // Menuju Tegalega
        RoutePoint(
          latitude: -6.9320,
          longitude: 107.5880,
          timestamp: DateTime(2025, 12, 11, 7, 38, 0),
          speed: 30,
          address: 'Jl. Astana Anyar',
        ),
        RoutePoint(
          latitude: -6.9280,
          longitude: 107.5850,
          timestamp: DateTime(2025, 12, 11, 7, 42, 0),
          speed: 20,
        ),
        RoutePoint(
          latitude: -6.9250,
          longitude: 107.5830,
          timestamp: DateTime(2025, 12, 11, 7, 45, 0),
          speed: 0,
          address: 'Tegalega',
        ),
      ],
    ),

    // ============================================
    // VEHICLE 8: D 8901 HI (Honda Mobilio - Shell)
    // Trip: Surya Sumantri -> Setiabudi -> Lembang
    // ============================================
    TripHistory(
      id: 6,
      vehicleId: 8,
      startTime: DateTime(2025, 12, 11, 6, 30, 0),
      endTime: DateTime(2025, 12, 11, 7, 30, 0),
      totalDistance: 18.0,
      avgSpeed: 35.0,
      maxSpeed: 55.0,
      startAddress: 'Jl. Surya Sumantri No. 222, Bandung',
      endAddress: 'Lembang, Bandung Barat',
      routePoints: [
        RoutePoint(
          latitude: -6.8820,
          longitude: 107.5900,
          timestamp: DateTime(2025, 12, 11, 6, 30, 0),
          speed: 0,
          address: 'Jl. Surya Sumantri No. 222',
        ),
        RoutePoint(
          latitude: -6.8780,
          longitude: 107.5950,
          timestamp: DateTime(2025, 12, 11, 6, 35, 0),
          speed: 30,
        ),
        RoutePoint(
          latitude: -6.8740,
          longitude: 107.6010,
          timestamp: DateTime(2025, 12, 11, 6, 40, 0),
          speed: 40,
        ),
        // Menuju Setiabudi
        RoutePoint(
          latitude: -6.8700,
          longitude: 107.6080,
          timestamp: DateTime(2025, 12, 11, 6, 48, 0),
          speed: 45,
          address: 'Jl. Dr. Setiabudi',
        ),
        RoutePoint(
          latitude: -6.8650,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 6, 55, 0),
          speed: 50,
        ),
        RoutePoint(
          latitude: -6.8580,
          longitude: 107.6120,
          timestamp: DateTime(2025, 12, 11, 7, 2, 0),
          speed: 55,
        ),
        // Naik ke Lembang
        RoutePoint(
          latitude: -6.8480,
          longitude: 107.6140,
          timestamp: DateTime(2025, 12, 11, 7, 10, 0),
          speed: 45,
          address: 'Jl. Raya Lembang',
        ),
        RoutePoint(
          latitude: -6.8350,
          longitude: 107.6180,
          timestamp: DateTime(2025, 12, 11, 7, 18, 0),
          speed: 40,
        ),
        RoutePoint(
          latitude: -6.8200,
          longitude: 107.6200,
          timestamp: DateTime(2025, 12, 11, 7, 25, 0),
          speed: 35,
        ),
        RoutePoint(
          latitude: -6.8120,
          longitude: 107.6180,
          timestamp: DateTime(2025, 12, 11, 7, 30, 0),
          speed: 0,
          address: 'Lembang, Bandung Barat',
        ),
      ],
    ),

    // ============================================
    // VEHICLE 10: D 0123 JK (Suzuki Ertiga - Shell)
    // Trip: Gatot Subroto -> Asia Afrika -> Alun-alun
    // ============================================
    TripHistory(
      id: 7,
      vehicleId: 10,
      startTime: DateTime(2025, 12, 11, 10, 0, 0),
      endTime: DateTime(2025, 12, 11, 10, 35, 0),
      totalDistance: 7.0,
      avgSpeed: 20.0,
      maxSpeed: 35.0,
      startAddress: 'Jl. Gatot Subroto No. 444, Bandung',
      endAddress: 'Alun-alun Bandung',
      routePoints: [
        RoutePoint(
          latitude: -6.9200,
          longitude: 107.6100,
          timestamp: DateTime(2025, 12, 11, 10, 0, 0),
          speed: 0,
          address: 'Jl. Gatot Subroto No. 444',
        ),
        RoutePoint(
          latitude: -6.9180,
          longitude: 107.6080,
          timestamp: DateTime(2025, 12, 11, 10, 5, 0),
          speed: 20,
        ),
        RoutePoint(
          latitude: -6.9160,
          longitude: 107.6050,
          timestamp: DateTime(2025, 12, 11, 10, 10, 0),
          speed: 25,
        ),
        // Menuju Asia Afrika
        RoutePoint(
          latitude: -6.9180,
          longitude: 107.6020,
          timestamp: DateTime(2025, 12, 11, 10, 15, 0),
          speed: 30,
          address: 'Jl. Asia Afrika',
        ),
        RoutePoint(
          latitude: -6.9200,
          longitude: 107.5980,
          timestamp: DateTime(2025, 12, 11, 10, 20, 0),
          speed: 25,
        ),
        RoutePoint(
          latitude: -6.9210,
          longitude: 107.5940,
          timestamp: DateTime(2025, 12, 11, 10, 25, 0),
          speed: 20,
        ),
        // Menuju Alun-alun
        RoutePoint(
          latitude: -6.9220,
          longitude: 107.6090,
          timestamp: DateTime(2025, 12, 11, 10, 30, 0),
          speed: 15,
          address: 'Jl. Alun-alun Barat',
        ),
        RoutePoint(
          latitude: -6.9215,
          longitude: 107.6075,
          timestamp: DateTime(2025, 12, 11, 10, 35, 0),
          speed: 0,
          address: 'Alun-alun Bandung',
        ),
      ],
    ),
  ];
}
