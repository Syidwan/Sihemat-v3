class Account {
  final String id;
  final String role; // "pengguna" atau "korporasi"
  final String email;
  final String password;
  final String verificationCode; // Kode verifikasi untuk guest access
  
  // Field untuk pengguna
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? platNomor;
  
  // Field untuk korporasi
  final String? companyName;
  
  // Relasi kendaraan
  final List<int> ownedVehicleIds; // ID kendaraan yang dimiliki (untuk korporasi)
  final int? assignedVehicleId; // ID kendaraan yang digunakan (untuk pengguna)

  Account({
    required this.id,
    required this.role,
    required this.email,
    required this.password,
    required this.verificationCode,
    this.firstName,
    this.lastName,
    this.phone,
    this.platNomor,
    this.companyName,
    this.ownedVehicleIds = const [],
    this.assignedVehicleId,
  });

  String get fullName => 
      role == "pengguna" ? "$firstName $lastName" : companyName ?? "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'password': password,
      'verificationCode': verificationCode,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'platNomor': platNomor,
      'companyName': companyName,
      'ownedVehicleIds': ownedVehicleIds,
      'assignedVehicleId': assignedVehicleId,
    };
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      role: json['role'],
      email: json['email'],
      password: json['password'],
      verificationCode: json['verificationCode'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      platNomor: json['platNomor'],
      companyName: json['companyName'],
      ownedVehicleIds: List<int>.from(json['ownedVehicleIds'] ?? []),
      assignedVehicleId: json['assignedVehicleId'],
    );
  }
}