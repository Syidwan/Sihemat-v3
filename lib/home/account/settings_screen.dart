import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state
  bool _darkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _language = 'Indonesia';
  String _mapType = 'OpenStreetMap';
  bool _autoUpdate = true;
  bool _locationTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Pengaturan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Appearance Section
            _buildSectionHeader('Tampilan'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.dark_mode,
                title: 'Mode Gelap',
                subtitle: 'Aktifkan tema gelap untuk aplikasi',
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
              ),
              _buildDivider(),
              _buildDropdownTile(
                icon: Icons.language,
                title: 'Bahasa',
                value: _language,
                options: ['Indonesia', 'English'],
                onChanged: (val) => setState(() => _language = val!),
              ),
            ]),

            // Notifications Section
            _buildSectionHeader('Notifikasi'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.notifications,
                title: 'Push Notification',
                subtitle: 'Terima notifikasi langsung',
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.email,
                title: 'Email Notification',
                subtitle: 'Terima notifikasi via email',
                value: _emailNotifications,
                onChanged: (val) => setState(() => _emailNotifications = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.volume_up,
                title: 'Suara',
                subtitle: 'Aktifkan suara notifikasi',
                value: _soundEnabled,
                onChanged: (val) => setState(() => _soundEnabled = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.vibration,
                title: 'Getar',
                subtitle: 'Aktifkan getaran notifikasi',
                value: _vibrationEnabled,
                onChanged: (val) => setState(() => _vibrationEnabled = val),
              ),
            ]),

            // Map & Tracking Section
            _buildSectionHeader('Peta & Pelacakan'),
            _buildSettingsCard([
              _buildDropdownTile(
                icon: Icons.map,
                title: 'Tipe Peta',
                value: _mapType,
                options: ['OpenStreetMap', 'Google Maps'],
                onChanged: (val) => setState(() => _mapType = val!),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.location_on,
                title: 'Pelacakan Lokasi',
                subtitle: 'Izinkan aplikasi melacak lokasi',
                value: _locationTracking,
                onChanged: (val) => setState(() => _locationTracking = val),
              ),
            ]),

            // App Section
            _buildSectionHeader('Aplikasi'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.system_update,
                title: 'Update Otomatis',
                subtitle: 'Perbarui aplikasi secara otomatis',
                value: _autoUpdate,
                onChanged: (val) => setState(() => _autoUpdate = val),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.delete_outline,
                title: 'Hapus Cache',
                subtitle: 'Bersihkan data cache aplikasi',
                onTap: () => _showClearCacheDialog(),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.restore,
                title: 'Reset Pengaturan',
                subtitle: 'Kembalikan ke pengaturan awal',
                onTap: () => _showResetDialog(),
                isDestructive: true,
              ),
            ]),

            // About Section
            _buildSectionHeader('Tentang'),
            _buildSettingsCard([
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'Versi Aplikasi',
                value: '1.0.0 (beta)',
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.description_outlined,
                title: 'Kebijakan Privasi',
                onTap: () {},
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.article_outlined,
                title: 'Syarat & Ketentuan',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 56, color: Colors.grey.shade200);
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFE53935), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFE53935),
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFE53935), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? Colors.red : const Color(0xFFE53935)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFFE53935),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
          : null,
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFE53935), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: TextStyle(color: Colors.grey.shade600)),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text('Apakah Anda yakin ingin menghapus semua cache aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache berhasil dihapus'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: const Text('Semua pengaturan akan dikembalikan ke nilai default. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _darkMode = false;
                _pushNotifications = true;
                _emailNotifications = false;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _language = 'Indonesia';
                _mapType = 'OpenStreetMap';
                _autoUpdate = true;
                _locationTracking = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pengaturan berhasil direset'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
