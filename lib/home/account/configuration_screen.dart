import 'package:flutter/material.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  // Speed alert settings
  bool _speedAlertEnabled = true;
  double _speedLimit = 80;
  
  // Geofence settings
  bool _geofenceEnabled = true;
  final List<Map<String, dynamic>> _geofences = [
    {'name': 'Kantor', 'radius': 500, 'lat': -6.9175, 'lng': 107.6191},
    {'name': 'Rumah', 'radius': 200, 'lat': -6.9080, 'lng': 107.6010},
  ];
  
  // Maintenance reminder settings
  bool _maintenanceReminderEnabled = true;
  int _oilChangeKm = 5000;
  int _serviceIntervalKm = 10000;
  
  // Idle alert settings
  bool _idleAlertEnabled = false;
  int _idleMinutes = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Konfigurasi'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speed Alert Section
            _buildSectionHeader('Peringatan Kecepatan'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.speed,
                title: 'Aktifkan Peringatan',
                subtitle: 'Notifikasi saat melebihi batas kecepatan',
                value: _speedAlertEnabled,
                onChanged: (val) => setState(() => _speedAlertEnabled = val),
              ),
              if (_speedAlertEnabled) ...[
                _buildDivider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Batas Kecepatan', style: TextStyle(fontWeight: FontWeight.w500)),
                          Text('${_speedLimit.toInt()} km/h', 
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
                        ],
                      ),
                      Slider(
                        value: _speedLimit,
                        min: 40,
                        max: 120,
                        divisions: 16,
                        activeColor: const Color(0xFFE53935),
                        onChanged: (val) => setState(() => _speedLimit = val),
                      ),
                    ],
                  ),
                ),
              ],
            ]),

            // Geofence Section
            _buildSectionHeader('Geofence (Area Monitoring)'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.share_location,
                title: 'Aktifkan Geofence',
                subtitle: 'Notifikasi saat keluar/masuk area',
                value: _geofenceEnabled,
                onChanged: (val) => setState(() => _geofenceEnabled = val),
              ),
              if (_geofenceEnabled) ...[
                _buildDivider(),
                ..._geofences.asMap().entries.map((e) => _buildGeofenceItem(e.key, e.value)),
                ListTile(
                  onTap: () => _showAddGeofenceDialog(),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.green),
                  ),
                  title: const Text('Tambah Area Baru', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                ),
              ],
            ]),

            // Maintenance Reminder Section
            _buildSectionHeader('Pengingat Perawatan'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.build,
                title: 'Aktifkan Pengingat',
                subtitle: 'Notifikasi untuk perawatan berkala',
                value: _maintenanceReminderEnabled,
                onChanged: (val) => setState(() => _maintenanceReminderEnabled = val),
              ),
              if (_maintenanceReminderEnabled) ...[
                _buildDivider(),
                _buildSliderTile(
                  title: 'Interval Ganti Oli',
                  value: _oilChangeKm,
                  min: 2000,
                  max: 10000,
                  unit: 'km',
                  onChanged: (val) => setState(() => _oilChangeKm = val.toInt()),
                ),
                _buildDivider(),
                _buildSliderTile(
                  title: 'Interval Service',
                  value: _serviceIntervalKm,
                  min: 5000,
                  max: 20000,
                  unit: 'km',
                  onChanged: (val) => setState(() => _serviceIntervalKm = val.toInt()),
                ),
              ],
            ]),

            // Idle Alert Section
            _buildSectionHeader('Peringatan Idle'),
            _buildSettingsCard([
              _buildSwitchTile(
                icon: Icons.timer_off,
                title: 'Aktifkan Peringatan Idle',
                subtitle: 'Notifikasi saat kendaraan diam terlalu lama',
                value: _idleAlertEnabled,
                onChanged: (val) => setState(() => _idleAlertEnabled = val),
              ),
              if (_idleAlertEnabled) ...[
                _buildDivider(),
                _buildSliderTile(
                  title: 'Durasi Idle',
                  value: _idleMinutes,
                  min: 1,
                  max: 30,
                  unit: 'menit',
                  onChanged: (val) => setState(() => _idleMinutes = val.toInt()),
                ),
              ],
            ]),

            const SizedBox(height: 24),

            // Save button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Konfigurasi berhasil disimpan'), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Simpan Konfigurasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
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
        decoration: BoxDecoration(color: const Color(0xFFE53935).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: const Color(0xFFE53935), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)) : null,
      trailing: Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFFE53935)),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required int value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('$value $unit', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE53935))),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            activeColor: const Color(0xFFE53935),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceItem(int index, Map<String, dynamic> geofence) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: const Icon(Icons.location_on, color: Colors.blue, size: 22),
      ),
      title: Text(geofence['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('Radius: ${geofence['radius']}m', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () {
          setState(() => _geofences.removeAt(index));
        },
      ),
    );
  }

  void _showAddGeofenceDialog() {
    final nameController = TextEditingController();
    final radiusController = TextEditingController(text: '500');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Area Geofence'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Area',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: radiusController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Radius (meter)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 18),
                  SizedBox(width: 8),
                  Expanded(child: Text('Lokasi akan diambil dari posisi GPS saat ini', style: TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _geofences.add({
                    'name': nameController.text,
                    'radius': int.tryParse(radiusController.text) ?? 500,
                    'lat': -6.9175,
                    'lng': 107.6191,
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935)),
            child: const Text('Tambah', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
