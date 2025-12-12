import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Notification preferences
  bool _allNotifications = true;
  bool _vehicleAlerts = true;
  bool _taxReminders = true;
  bool _speedAlerts = true;
  bool _geofenceAlerts = true;
  bool _maintenanceReminders = true;
  bool _tripSummary = false;
  bool _promotions = false;

  // Quiet hours
  bool _quietHoursEnabled = false;
  TimeOfDay _quietStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietEnd = const TimeOfDay(hour: 7, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Pengaturan Notifikasi'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Master toggle
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _allNotifications ? const Color(0xFFE53935) : Colors.grey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Semua Notifikasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _allNotifications ? 'Aktif' : 'Nonaktif',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _allNotifications,
                    onChanged: (val) => setState(() => _allNotifications = val),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.5),
                  ),
                ],
              ),
            ),

            // Alert types
            _buildSectionHeader('Jenis Notifikasi'),
            _buildSettingsCard([
              _buildNotificationTile(
                icon: Icons.warning_amber,
                title: 'Peringatan Kendaraan',
                subtitle: 'Status online/offline, baterai rendah',
                value: _vehicleAlerts,
                onChanged: (val) => setState(() => _vehicleAlerts = val),
                iconColor: Colors.orange,
              ),
              _buildDivider(),
              _buildNotificationTile(
                icon: Icons.receipt_long,
                title: 'Pengingat Pajak',
                subtitle: 'Notifikasi sebelum jatuh tempo pajak',
                value: _taxReminders,
                onChanged: (val) => setState(() => _taxReminders = val),
                iconColor: Colors.blue,
              ),
              _buildDivider(),
              _buildNotificationTile(
                icon: Icons.speed,
                title: 'Peringatan Kecepatan',
                subtitle: 'Notifikasi saat melebihi batas kecepatan',
                value: _speedAlerts,
                onChanged: (val) => setState(() => _speedAlerts = val),
                iconColor: Colors.red,
              ),
              _buildDivider(),
              _buildNotificationTile(
                icon: Icons.location_on,
                title: 'Peringatan Geofence',
                subtitle: 'Notifikasi keluar/masuk area',
                value: _geofenceAlerts,
                onChanged: (val) => setState(() => _geofenceAlerts = val),
                iconColor: Colors.purple,
              ),
              _buildDivider(),
              _buildNotificationTile(
                icon: Icons.build,
                title: 'Pengingat Perawatan',
                subtitle: 'Service berkala, ganti oli, dll',
                value: _maintenanceReminders,
                onChanged: (val) => setState(() => _maintenanceReminders = val),
                iconColor: Colors.teal,
              ),
            ]),

            // Summary & Other
            _buildSectionHeader('Lainnya'),
            _buildSettingsCard([
              _buildNotificationTile(
                icon: Icons.summarize,
                title: 'Ringkasan Perjalanan',
                subtitle: 'Ringkasan harian/mingguan',
                value: _tripSummary,
                onChanged: (val) => setState(() => _tripSummary = val),
                iconColor: Colors.green,
              ),
              _buildDivider(),
              _buildNotificationTile(
                icon: Icons.local_offer,
                title: 'Promosi & Penawaran',
                subtitle: 'Info promo dan penawaran menarik',
                value: _promotions,
                onChanged: (val) => setState(() => _promotions = val),
                iconColor: Colors.pink,
              ),
            ]),

            // Quiet hours
            _buildSectionHeader('Jam Tenang'),
            _buildSettingsCard([
              _buildNotificationTile(
                icon: Icons.do_not_disturb_on,
                title: 'Aktifkan Jam Tenang',
                subtitle: 'Nonaktifkan notifikasi pada waktu tertentu',
                value: _quietHoursEnabled,
                onChanged: (val) => setState(() => _quietHoursEnabled = val),
                iconColor: Colors.indigo,
              ),
              if (_quietHoursEnabled) ...[
                _buildDivider(),
                ListTile(
                  leading: const SizedBox(width: 40),
                  title: Row(
                    children: [
                      Expanded(
                        child: _buildTimeButton('Mulai', _quietStart, (time) {
                          setState(() => _quietStart = time);
                        }),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('—'),
                      ),
                      Expanded(
                        child: _buildTimeButton('Selesai', _quietEnd, (time) {
                          setState(() => _quietEnd = time);
                        }),
                      ),
                    ],
                  ),
                ),
              ],
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
    return Divider(height: 1, indent: 72, color: Colors.grey.shade200);
  }

  Widget _buildNotificationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return ListTile(
      enabled: _allNotifications,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: _allNotifications ? null : Colors.grey,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: _allNotifications ? Colors.grey.shade600 : Colors.grey.shade400,
        ),
      ),
      trailing: Switch(
        value: value && _allNotifications,
        onChanged: _allNotifications ? onChanged : null,
        activeColor: const Color(0xFFE53935),
      ),
    );
  }

  Widget _buildTimeButton(String label, TimeOfDay time, ValueChanged<TimeOfDay> onChanged) {
    return OutlinedButton(
      onPressed: () async {
        final picked = await showTimePicker(context: context, initialTime: time);
        if (picked != null) onChanged(picked);
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
