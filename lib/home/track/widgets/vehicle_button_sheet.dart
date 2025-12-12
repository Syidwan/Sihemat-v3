import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/track/widgets/action_button_widget.dart';
import 'package:sihemat_v3/home/track/playback_screen.dart';
import 'package:sihemat_v3/home/track/live_tracking_screen.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/home/menu/speedometer/speedometer_screen.dart';

/// Model untuk action button configuration
class VehicleAction {
  final String id;
  final String label;
  final IconData? icon;
  final String? assetPath;
  final Color color;

  const VehicleAction({
    required this.id,
    required this.label,
    this.icon,
    this.assetPath,
    required this.color,
  }) : assert(icon != null || assetPath != null);
}

class VehicleBottomSheet extends StatelessWidget {
  final Vehicle vehicle;
  final double height;
  final double minHeight;
  final double maxHeight;
  final bool isExpanded;
  final Function(double) onVerticalDragUpdate;
  final Function(double) onVerticalDragEnd;
  final VoidCallback onToggleExpand;

  const VehicleBottomSheet({
    Key? key,
    required this.vehicle,
    required this.height,
    required this.minHeight,
    required this.maxHeight,
    required this.isExpanded,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.onToggleExpand,
  }) : super(key: key);

  /// Konfigurasi action buttons
  static const List<VehicleAction> _actions = [
    VehicleAction(
      id: 'track',
      label: 'Lacak',
      icon: Icons.person_pin_circle,
      assetPath: 'assets/images/icons/lacak.png',
      color: Colors.white,
    ),
    VehicleAction(
      id: 'playback',
      label: 'Playback',
      icon: Icons.play_circle,
      assetPath: 'assets/images/icons/playback.png',
      color: Colors.white,
    ),
    VehicleAction(
      id: 'speedometer',
      label: 'Speedometer',
      icon: Icons.speed,
      assetPath: 'assets/images/icons/speedometer.png',
      color: Colors.white,
    ),
    VehicleAction(
      id: 'info',
      label: 'Informasi',
      icon: Icons.info,
      assetPath: 'assets/images/icons/informasi.png',
      color: Colors.white,
    ),
  ];

  Color _getStatusColor() {
    switch (vehicle.status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.grey;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Handler untuk action button tap
  void _handleActionTap(BuildContext context, String actionId) {
    switch (actionId) {
      case 'track':
        _handleTrack(context);
        break;
      case 'playback':
        _handlePlayback(context);
        break;
      case 'speedometer':
        _handleSpeedometer(context);
        break;
      case 'info':
        _handleInfo(context);
        break;
    }
  }

  void _handleTrack(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveTrackingScreen(vehicle: vehicle),
      ),
    );
  }

  void _handlePlayback(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaybackScreen(vehicle: vehicle),
      ),
    );
  }

  void _handleSpeedometer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeedometerScreen(vehicle: vehicle),
      ),
    );
  }

  void _handleInfo(BuildContext context) {
    _showVehicleInfo(context);
  }

  void _showVehicleInfo(BuildContext context) {
    final owner = AccountRepository.getVehicleOwner(vehicle.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // PERBAIKAN: Untuk menghindari overflow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              _buildInfoHeader(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow('Kode', vehicle.code, Icons.qr_code),
              _buildInfoRow('Plat Nomor', vehicle.plate, Icons.credit_card),
              _buildInfoRow(
                'Tipe',
                vehicle.type == 'motorcycle' ? 'Motor' : 'Mobil',
                vehicle.type == 'motorcycle'
                    ? Icons.two_wheeler
                    : Icons.directions_car,
              ),
              _buildInfoRow(
                'Status',
                vehicle.status[0].toUpperCase() + vehicle.status.substring(1),
                Icons.circle,
                statusColor: _getStatusColor(),
              ),
              _buildInfoRow('Total KM', '${vehicle.totalKm} km', Icons.speed),
              _buildInfoRow(
                'KM Hari Ini',
                '${vehicle.todayKm} km',
                Icons.today,
              ),
              if (vehicle.address != null)
                _buildInfoRow('Lokasi', vehicle.address!, Icons.location_on),
              if (owner != null) ...[
                const Divider(),
                const SizedBox(height: 8),
                _buildInfoRow('Pemilik', owner.fullName, Icons.business),
              ],
              const SizedBox(height: 16),
              _buildCloseButton(context),
              const SizedBox(height: 8), // Extra padding untuk bottom safe area
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoHeader() {
    return Row(
      children: [
        const Icon(Icons.info_outline, color: Colors.orange, size: 24),
        const SizedBox(width: 8),
        const Text(
          'Informasi Kendaraan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // PERBAIKAN: Untuk teks panjang
        children: [
          Icon(icon, size: 18, color: statusColor ?? Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: statusColor ?? Colors.black87,
                  ),
                  maxLines: 3, // PERBAIKAN: Batasi maksimal 3 baris
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Tutup',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentAccount = SessionManager.currentAccount;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) =>
            onVerticalDragUpdate(details.delta.dy),
        onVerticalDragEnd: (details) =>
            onVerticalDragEnd(details.primaryVelocity ?? 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 4),
                      _buildPlate(),
                      if (currentAccount?.role == 'pengguna')
                        _buildOwnerBadge(),
                      const SizedBox(height: 12),
                      if (vehicle.address != null) _buildAddress(),
                      const SizedBox(height: 16),
                      _buildActionButtons(context),
                      const SizedBox(height: 16),
                      _buildStats(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      onTap: onToggleExpand,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            vehicle.code,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, // PERBAIKAN: Hindari overflow
          ),
        ),
        const SizedBox(width: 8), // PERBAIKAN: Spacing antara title dan badge
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        vehicle.status[0].toUpperCase() + vehicle.status.substring(1),
        style: TextStyle(
          color: _getStatusColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPlate() {
    return Text(
      vehicle.plate,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      overflow: TextOverflow.ellipsis, // PERBAIKAN: Hindari overflow
    );
  }

  Widget _buildOwnerBadge() {
    final owner = AccountRepository.getVehicleOwner(vehicle.id);
    if (owner == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business, size: 14, color: Colors.orange.shade700),
            const SizedBox(width: 6),
            Flexible(
              // PERBAIKAN: Gunakan Flexible untuk teks panjang
              child: Text(
                'Pemilik: ${owner.fullName}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            vehicle.address!,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            maxLines: 2, // PERBAIKAN: Batasi maksimal 2 baris
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build action buttons dengan style seperti MenuGrid
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _actions.map((action) {
        return ActionButtonCompact(
          icon: action.icon,
          assetPath: action.assetPath,
          label: action.label,
          color: action.color,
          onTap: () => _handleActionTap(context, action.id),
        );
      }).toList(),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('Kilometer total', '${vehicle.totalKm}km'),
          const SizedBox(height: 12),
          _buildStatRow('Kilometer hari ini', '${vehicle.todayKm}km'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          // PERBAIKAN: Wrap dengan Expanded
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
