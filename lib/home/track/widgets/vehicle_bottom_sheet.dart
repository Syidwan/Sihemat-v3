import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

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
          duration: Duration(milliseconds: 200),
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 4),
                      _buildPlate(),
                      if (currentAccount?.role == 'pengguna')
                        _buildOwnerBadge(),
                      SizedBox(height: 12),
                      if (vehicle.address != null) _buildAddress(),
                      SizedBox(height: 16),
                      _buildActionButtons(),
                      SizedBox(height: 16),
                      _buildStats(),
                      SizedBox(height: 20),
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
        padding: EdgeInsets.symmetric(vertical: 12),
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        ),
      ],
    );
  }

  Widget _buildPlate() {
    return Text(
      vehicle.plate,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
    );
  }

  Widget _buildOwnerBadge() {
    final owner = AccountRepository.getVehicleOwner(vehicle.id);
    if (owner == null) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business, size: 14, color: Colors.orange.shade700),
            SizedBox(width: 6),
            Text(
              'Pemilik: ${owner.fullName}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.orange.shade900,
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
        SizedBox(width: 8),
        Expanded(
          child: Text(
            vehicle.address!,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(child: _buildActionButton(
          icon: Icons.person_pin_circle,
          label: 'Lacak',
          color: Colors.blue,
        )),
        SizedBox(width: 8),
        Expanded(child: _buildActionButton(
          icon: Icons.play_circle,
          label: 'Playback',
          color: Colors.green,
        )),
        SizedBox(width: 8),
        Expanded(child: _buildActionButton(
          icon: Icons.speed,
          label: 'Speedometer',
          color: Colors.red,
        )),
        SizedBox(width: 8),
        Expanded(child: _buildActionButton(
          icon: Icons.info,
          label: 'Informasi',
          color: Colors.orange,
        )),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildStatRow('Kilometer total', '${vehicle.totalKm}km'),
          SizedBox(height: 12),
          _buildStatRow('Kilometer hari ini', '${vehicle.todayKm}km'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
