import 'package:sihemat_v3/models/account.dart';

class AccountRepository {
  static final List<Account> _registeredAccounts = [
    // 2 Akun Pengguna - menggunakan kendaraan milik korporasi
    Account(
      id: "USR001",
      role: "pengguna",
      email: "budi.santoso@gmail.com",
      password: "budi123",
      verificationCode: "BUDI2025", // Kode verifikasi untuk guest
      firstName: "Budi",
      lastName: "Santoso",
      phone: "081234567890",
      platNomor: "D 1234 AB",
      assignedVehicleId: 1, // Menggunakan kendaraan ID 1 milik Pertamina
    ),
    Account(
      id: "USR002",
      role: "pengguna",
      email: "siti.nurhaliza@gmail.com",
      password: "siti456",
      verificationCode: "SITI2025", // Kode verifikasi untuk guest
      firstName: "Siti",
      lastName: "Nurhaliza",
      phone: "082345678901",
      platNomor: "D 5678 CD",
      assignedVehicleId: 6, // Menggunakan kendaraan ID 6 milik Shell
    ),
    
    // 2 Akun Korporasi - masing-masing memiliki 5 kendaraan
    Account(
      id: "CORP001",
      role: "korporasi",
      email: "admin@pertamina.co.id",
      password: "pertamina123",
      verificationCode: "PTMN2025", // Kode verifikasi untuk guest
      companyName: "PT Pertamina",
      ownedVehicleIds: [1, 2, 3, 4, 5], // Memiliki 5 kendaraan
    ),
    Account(
      id: "CORP002",
      role: "korporasi",
      email: "contact@shellindo.com",
      password: "shell456",
      verificationCode: "SHEL2025", // Kode verifikasi untuk guest
      companyName: "Shell Indonesia",
      ownedVehicleIds: [6, 7, 8, 9, 10], // Memiliki 5 kendaraan
    ),
  ];

  static List<Account> getAllAccounts() {
    return List.unmodifiable(_registeredAccounts);
  }

  static Account? login(String email, String password) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => account.email == email && account.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Guest login dengan plat nomor dan verification code
  static Account? guestLogin(String platNomor, String verificationCode) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => 
          account.platNomor?.toUpperCase() == platNomor.toUpperCase() && 
          account.verificationCode.toUpperCase() == verificationCode.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Cek apakah plat nomor terdaftar
  static Account? getAccountByPlatNomor(String platNomor) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => account.platNomor?.toUpperCase() == platNomor.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  static bool register(Account newAccount) {
    final emailExists = _registeredAccounts.any(
      (account) => account.email == newAccount.email,
    );
    
    if (emailExists) {
      return false;
    }
    
    _registeredAccounts.add(newAccount);
    return true;
  }

  static bool isEmailRegistered(String email) {
    return _registeredAccounts.any((account) => account.email == email);
  }

  static Account? getAccountByEmail(String email) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => account.email == email,
      );
    } catch (e) {
      return null;
    }
  }

  static List<Account> getAccountsByRole(String role) {
    return _registeredAccounts
        .where((account) => account.role == role)
        .toList();
  }

  // Get korporasi pemilik kendaraan
  static Account? getVehicleOwner(int vehicleId) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => account.ownedVehicleIds.contains(vehicleId),
      );
    } catch (e) {
      return null;
    }
  }

  // Get pengguna yang menggunakan kendaraan tertentu
  static Account? getVehicleUser(int vehicleId) {
    try {
      return _registeredAccounts.firstWhere(
        (account) => account.assignedVehicleId == vehicleId,
      );
    } catch (e) {
      return null;
    }
  }
}