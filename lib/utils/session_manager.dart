import 'package:sihemat_v3/models/account.dart';

class SessionManager {
  static Account? _currentAccount;
  static bool _isGuestMode = false;

  static Account? get currentAccount => _currentAccount;
  static bool get isGuestMode => _isGuestMode;

  // Regular login
  static void login(Account account) {
    _currentAccount = account;
    _isGuestMode = false;
  }

  // Guest login
  static void loginAsGuest(Account account) {
    _currentAccount = account;
    _isGuestMode = true;
  }

  // Logout
  static void logout() {
    _currentAccount = null;
    _isGuestMode = false;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _currentAccount != null;
}