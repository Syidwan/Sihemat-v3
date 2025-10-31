import 'package:flutter/material.dart';
import 'package:sihemat_v3/authentication/auth_selection_screen.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/models/account.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Account? _currentAccount;

  @override
  void initState() {
    super.initState();
    _loadCurrentAccount();
  }

  void _loadCurrentAccount() {
    setState(() {
      _currentAccount = SessionManager.currentAccount;
    });
  }

  String _getDisplayName() {
    if (_currentAccount == null) return 'Guest User';

    // Jika guest mode, tampilkan "Mode Guest"
    if (SessionManager.isGuestMode) {
      return 'Mode Guest';
    }

    if (_currentAccount!.role == 'korporasi') {
      return _currentAccount!.companyName ?? 'Perusahaan';
    } else {
      final firstName = _currentAccount!.firstName ?? '';
      final lastName = _currentAccount!.lastName ?? '';
      return '$firstName $lastName'.trim();
    }
  }

  String _getDisplayRole() {
    if (_currentAccount == null) return 'Guest';

    // Jika guest mode, tampilkan "Akses Sementara"
    if (SessionManager.isGuestMode) {
      return 'Akses Sementara';
    }

    if (_currentAccount!.role == 'korporasi') {
      return 'Akun Korporasi';
    } else {
      return 'Akun Pengguna';
    }
  }

  String _getInitials() {
    if (_currentAccount == null) return 'G';

    // Jika guest mode, tampilkan "G"
    if (SessionManager.isGuestMode) {
      return 'G';
    }

    if (_currentAccount!.role == 'korporasi') {
      final companyName = _currentAccount!.companyName ?? 'P';
      return companyName.isNotEmpty ? companyName[0].toUpperCase() : 'P';
    } else {
      final firstName = _currentAccount!.firstName ?? '';
      final lastName = _currentAccount!.lastName ?? '';
      final initials =
          '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
              .toUpperCase();
      return initials.isNotEmpty ? initials : 'U';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: SessionManager.isGuestMode
                    ? Colors
                          .grey
                          .shade700 // Warna berbeda untuk guest
                    : Color(0xFFE53935),
              ),
              padding: EdgeInsets.fromLTRB(24, 60, 24, 32),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: Container(
                        color: SessionManager.isGuestMode
                            ? Colors.grey.shade500
                            : Color(0xFF5DADE2),
                        child: Center(
                          child: Text(
                            _getInitials(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 16),

                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo,',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _getDisplayName(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          _getDisplayRole(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Account Info Card (for pengguna and korporasi)
            if (_currentAccount != null && !SessionManager.isGuestMode)
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    if (_currentAccount!.role == 'pengguna') ...[
                      _buildInfoRow(
                        Icons.phone,
                        'Telepon',
                        _currentAccount!.phone ?? '-',
                      ),
                      SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.directions_car,
                        'Plat Nomor',
                        _currentAccount!.platNomor ?? '-',
                      ),
                      if (_currentAccount!.assignedVehicleId != null) ...[
                        SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.credit_card,
                          'Kendaraan',
                          VehicleRepository.getVehicleById(
                                _currentAccount!.assignedVehicleId!,
                              )?.code ??
                              '-',
                        ),
                      ],
                    ] else if (_currentAccount!.role == 'korporasi') ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              Icons.business,
                              'Perusahaan',
                              _currentAccount!.companyName ?? '-',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoRow(
                              Icons.directions_car,
                              'Total Kendaraan',
                              '${_currentAccount!.ownedVehicleIds.length} unit',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

            // Guest Info Card (simple - hanya plat nomor dan kendaraan)
            if (_currentAccount != null && SessionManager.isGuestMode)
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade700,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Anda sedang dalam Mode Guest',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.directions_car,
                      'Plat Nomor',
                      _currentAccount!.platNomor ?? '-',
                    ),
                    if (_currentAccount!.assignedVehicleId != null) ...[
                      SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.credit_card,
                        'Kendaraan',
                        VehicleRepository.getVehicleById(
                              _currentAccount!.assignedVehicleId!,
                            )?.code ??
                            '-',
                      ),
                    ],
                  ],
                ),
              ),

            // Menu List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline,
                    title: 'Edit Profil',
                    onTap: () {
                      _showUnderConstruction(context, 'Edit Profil');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Pengaturan',
                    onTap: () {
                      _showUnderConstruction(context, 'Pengaturan');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    onTap: () {
                      _showUnderConstruction(context, 'Notifikasi');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Laporan',
                    onTap: () {
                      _showUnderConstruction(context, 'Laporan');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.tune,
                    title: 'Konfigurasi',
                    onTap: () {
                      _showUnderConstruction(context, 'Konfigurasi');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.mail_outline,
                    title: 'Umpan Balik',
                    onTap: () {
                      _showUnderConstruction(context, 'Umpan Balik');
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'Tentang',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),

                  SizedBox(height: 16),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        SessionManager.isGuestMode
                            ? 'Keluar dari Mode Guest'
                            : 'Ganti Akun / Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey.shade400,
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showUnderConstruction(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text('🚧'),
            SizedBox(width: 8),
            Text('Under Construction'),
          ],
        ),
        content: Text('Fitur $feature sedang dalam pengembangan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFE53935)),
            SizedBox(width: 8),
            Text('Tentang'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SiHemat',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Smart Energy Tracker App'),
            SizedBox(height: 16),
            Text('Versi: 1.0.0'),
            SizedBox(height: 8),
            Text('© 2025 SiHemat Team'),
            SizedBox(height: 16),
            Text(
              'Aplikasi pelacakan dan monitoring kendaraan untuk efisiensi energi.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isGuest = SessionManager.isGuestMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isGuest ? 'Keluar dari Mode Guest' : 'Keluar'),
        content: Text(
          isGuest
              ? 'Apakah Anda yakin ingin keluar dari mode guest?'
              : 'Apakah Anda yakin ingin keluar dari akun ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _performLogout(context);
            },
            child: Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _performLogout(BuildContext context) {
    // Clear session
    SessionManager.logout();

    // Navigate to AuthSelectionScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthSelectionScreen()),
      (route) => false,
    );
  }
}
