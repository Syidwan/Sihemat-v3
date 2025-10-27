class Vehicle {
  final int id;
  final String code;
  final String plate;
  final int totalKm;
  final int todayKm;
  final String status;
  final String type;
  final double latitude;
  final double longitude;
  final String? address;
  final String ownerId; // ID pemilik (korporasi)

  // Tax Information
  final String? taxStartDate;
  final String? taxEndDate;
  final String? stnkEndDate;
  final String? color;
  final String? brand;
  final String? model;

  // Tax Costs
  final int? pajakKendaraan;
  final int? swdkllj;
  final int? pnbpStnk;
  final int? pnbpTnkb;
  final int? adminStnk;
  final int? adminTnkb;
  final int? penerbitan;

  Vehicle({
    required this.id,
    required this.code,
    required this.plate,
    required this.totalKm,
    required this.todayKm,
    required this.status,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.ownerId,
    this.address,
    this.taxStartDate,
    this.taxEndDate,
    this.stnkEndDate,
    this.color,
    this.brand,
    this.model,
    this.pajakKendaraan,
    this.swdkllj,
    this.pnbpStnk,
    this.pnbpTnkb,
    this.adminStnk,
    this.adminTnkb,
    this.penerbitan,
  });

  int get totalPajak {
    return (pajakKendaraan ?? 0) +
        (swdkllj ?? 0) +
        (pnbpStnk ?? 0) +
        (pnbpTnkb ?? 0) +
        (adminStnk ?? 0) +
        (adminTnkb ?? 0) +
        (penerbitan ?? 0);
  }
}