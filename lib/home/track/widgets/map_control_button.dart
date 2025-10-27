import 'package:flutter/material.dart';

class MapControlButtons extends StatelessWidget {
  final VoidCallback onRecenter;
  final VoidCallback onGpsLocation;
  final double top;

  const MapControlButtons({
    Key? key,
    required this.onRecenter,
    required this.onGpsLocation,
    required this.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      top: top,
      child: Column(
        children: [
          _buildCircleButton(
            icon: Icons.my_location,
            color: Colors.blue.shade700,
            onTap: onRecenter,
          ),
          SizedBox(height: 12),
          _buildCircleButton(
            icon: Icons.gps_fixed,
            color: Colors.grey.shade700,
            onTap: onGpsLocation,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: CircleBorder(),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
      ),
    );
  }
}

class MapNavigationButtons extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final double top;

  const MapNavigationButtons({
    Key? key,
    required this.onPrevious,
    required this.onNext,
    required this.top,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      top: top,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              icon: Icons.keyboard_arrow_up,
              onTap: onPrevious,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            Container(height: 1, width: 48, color: Colors.grey.shade300),
            _buildButton(
              icon: Icons.keyboard_arrow_down,
              onTap: onNext,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required BorderRadius borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
      ),
    );
  }
}