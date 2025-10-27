import 'package:sihemat_v3/models/account.dart';

class SessionManager {
  static String? userRole;
  static Account? currentAccount;

  // Login dan simpan account
  static void login(Account account) {
    currentAccount = account;
    userRole = account.role;
  }

  // Logout
  static void logout() {
    currentAccount = null;
    userRole = null;
  }

  // Check if logged in
  static bool get isLoggedIn => currentAccount != null;
}