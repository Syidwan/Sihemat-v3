import 'package:sihemat_v3/models/vehicle_model.dart';

class VehicleRepository {
  // 10 kendaraan: 5 milik Pertamina, 5 milik Shell
  static final List<Vehicle> _vehicles = [
    // 5 Kendaraan PT Pertamina (CORP001)
    Vehicle(
      id: 1,
      code: 'M0T0125000',
      plate: 'D 1234 AB',
      totalKm: 23000,
      todayKm: 100,
      status: 'online',
      type: 'motorcycle',
      latitude: -6.9175,
      longitude: 107.6191,
      address: 'Jl. Sukajadi No. 123, Bandung',
      ownerId: 'CORP001',
      taxStartDate: '12 Jan 2026',
      taxEndDate: '12 Jan 2027',
      stnkEndDate: '12 Jan 2030',
      color: 'WHITE BLUE',
      brand: 'HONDA',
      model: 'BEAT',
      pajakKendaraan: 100000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 2,
      code: 'M0131L4000',
      plate: 'D 2345 BC',
      totalKm: 18000,
      todayKm: 85,
      status: 'online',
      type: 'motorcycle',
      latitude: -6.9147,
      longitude: 107.6098,
      address: 'Jl. Dago No. 456, Bandung',
      ownerId: 'CORP001',
      taxStartDate: '15 Mar 2026',
      taxEndDate: '15 Mar 2027',
      stnkEndDate: '15 Mar 2030',
      color: 'RED',
      brand: 'YAMAHA',
      model: 'NMAX 155',
      pajakKendaraan: 95000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 3,
      code: 'C4126000',
      plate: 'D 3456 CD',
      totalKm: 45000,
      todayKm: 120,
      status: 'online',
      type: 'car',
      latitude: -6.9039,
      longitude: 107.6186,
      address: 'Jl. Pasteur No. 789, Bandung',
      ownerId: 'CORP001',
      taxStartDate: '20 Jun 2026',
      taxEndDate: '20 Jun 2027',
      stnkEndDate: '20 Jun 2031',
      color: 'BLACK',
      brand: 'TOYOTA',
      model: 'AVANZA 1.3 G MT',
      pajakKendaraan: 250000,
      swdkllj: 143000,
      pnbpStnk: 100000,
      pnbpTnkb: 0,
      adminStnk: 50000,
      adminTnkb: 25000,
      penerbitan: 0,
    ),
    Vehicle(
      id: 4,
      code: 'M0T0125002',
      plate: 'D 4567 DE',
      totalKm: 12000,
      todayKm: 60,
      status: 'offline',
      type: 'motorcycle',
      latitude: -6.9344,
      longitude: 107.6048,
      address: 'Jl. Buah Batu No. 321, Bandung',
      ownerId: 'CORP001',
      taxStartDate: '05 Feb 2026',
      taxEndDate: '05 Feb 2027',
      stnkEndDate: '05 Feb 2030',
      color: 'BLUE',
      brand: 'SUZUKI',
      model: 'GSX-R150',
      pajakKendaraan: 110000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 5,
      code: 'C4E120X1000',
      plate: 'D 5678 EF',
      totalKm: 38000,
      todayKm: 95,
      status: 'online',
      type: 'car',
      latitude: -6.8945,
      longitude: 107.6107,
      address: 'Jl. Setiabudhi No. 654, Bandung',
      ownerId: 'CORP001',
      taxStartDate: '10 Aug 2026',
      taxEndDate: '10 Aug 2027',
      stnkEndDate: '10 Aug 2031',
      color: 'SILVER',
      brand: 'DAIHATSU',
      model: 'XENIA 1.3 R MT',
      pajakKendaraan: 230000,
      swdkllj: 143000,
      pnbpStnk: 100000,
      pnbpTnkb: 0,
      adminStnk: 50000,
      adminTnkb: 25000,
      penerbitan: 0,
    ),

    // 5 Kendaraan Shell Indonesia (CORP002)
    Vehicle(
      id: 6,
      code: 'M0T0125003',
      plate: 'D 6789 FG',
      totalKm: 15000,
      todayKm: 50,
      status: 'online',
      type: 'motorcycle',
      latitude: -6.9285,
      longitude: 107.6369,
      address: 'Jl. Soekarno Hatta No. 987, Bandung',
      ownerId: 'CORP002',
      taxStartDate: '01 Jan 2026',
      taxEndDate: '01 Jan 2027',
      stnkEndDate: '01 Jan 2030',
      color: 'GREEN',
      brand: 'KAWASAKI',
      model: 'NINJA 250',
      pajakKendaraan: 120000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 7,
      code: 'M0131L4001',
      plate: 'D 7890 GH',
      totalKm: 21000,
      todayKm: 75,
      status: 'online',
      type: 'motorcycle',
      latitude: -6.9122,
      longitude: 107.6289,
      address: 'Jl. Cihampelas No. 111, Bandung',
      ownerId: 'CORP002',
      taxStartDate: '18 Apr 2026',
      taxEndDate: '18 Apr 2027',
      stnkEndDate: '18 Apr 2030',
      color: 'BLACK',
      brand: 'HONDA',
      model: 'VARIO 160',
      pajakKendaraan: 105000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 8,
      code: 'C4126001',
      plate: 'D 8901 HI',
      totalKm: 52000,
      todayKm: 140,
      status: 'online',
      type: 'car',
      latitude: -6.9024,
      longitude: 107.6195,
      address: 'Jl. Surya Sumantri No. 222, Bandung',
      ownerId: 'CORP002',
      taxStartDate: '25 May 2026',
      taxEndDate: '25 May 2027',
      stnkEndDate: '25 May 2031',
      color: 'WHITE',
      brand: 'HONDA',
      model: 'MOBILIO 1.5 S MT',
      pajakKendaraan: 270000,
      swdkllj: 143000,
      pnbpStnk: 100000,
      pnbpTnkb: 0,
      adminStnk: 50000,
      adminTnkb: 25000,
      penerbitan: 0,
    ),
    Vehicle(
      id: 9,
      code: 'M0T0125004',
      plate: 'D 9012 IJ',
      totalKm: 9000,
      todayKm: 40,
      status: 'offline',
      type: 'motorcycle',
      latitude: -6.9456,
      longitude: 107.6012,
      address: 'Jl. Kopo No. 333, Bandung',
      ownerId: 'CORP002',
      taxStartDate: '30 Sep 2026',
      taxEndDate: '30 Sep 2027',
      stnkEndDate: '30 Sep 2030',
      color: 'ORANGE',
      brand: 'KTM',
      model: 'DUKE 200',
      pajakKendaraan: 130000,
      swdkllj: 35000,
      pnbpStnk: 66100,
      pnbpTnkb: 0,
      adminStnk: 35000,
      adminTnkb: 0,
      penerbitan: 0,
    ),
    Vehicle(
      id: 10,
      code: 'C4E120X1001',
      plate: 'D 0123 JK',
      totalKm: 41000,
      todayKm: 110,
      status: 'online',
      type: 'car',
      latitude: -6.8834,
      longitude: 107.6223,
      address: 'Jl. Gatot Subroto No. 444, Bandung',
      ownerId: 'CORP002',
      taxStartDate: '12 Dec 2026',
      taxEndDate: '12 Dec 2027',
      stnkEndDate: '12 Dec 2031',
      color: 'GREY',
      brand: 'SUZUKI',
      model: 'ERTIGA GX MT',
      pajakKendaraan: 240000,
      swdkllj: 143000,
      pnbpStnk: 100000,
      pnbpTnkb: 0,
      adminStnk: 50000,
      adminTnkb: 25000,
      penerbitan: 0,
    ),
  ];

  static List<Vehicle> getAllVehicles() {
    return List.unmodifiable(_vehicles);
  }

  static Vehicle? getVehicleById(int id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Vehicle> getVehiclesByOwnerId(String ownerId) {
    return _vehicles.where((v) => v.ownerId == ownerId).toList();
  }

  static List<Vehicle> getVehiclesByType(String type) {
    return _vehicles.where((v) => v.type == type).toList();
  }

  static List<Vehicle> getVehiclesByStatus(String status) {
    return _vehicles.where((v) => v.status == status).toList();
  }

  /// Menambah kendaraan baru ke daftar
  static bool addVehicle(Vehicle vehicle) {
    // Cek apakah plat nomor sudah ada
    final exists = _vehicles.any((v) => v.plate.toUpperCase() == vehicle.plate.toUpperCase());
    if (exists) return false;
    
    _vehicles.add(vehicle);
    return true;
  }

  /// Menghapus kendaraan berdasarkan ID
  static bool deleteVehicle(int id) {
    final initialLength = _vehicles.length;
    _vehicles.removeWhere((v) => v.id == id);
    return _vehicles.length < initialLength;
  }

  /// Mendapatkan ID berikutnya untuk kendaraan baru
  static int getNextId() {
    if (_vehicles.isEmpty) return 1;
    return _vehicles.map((v) => v.id).reduce((a, b) => a > b ? a : b) + 1;
  }
}