import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/config/map_config.dart';

/// Screen untuk melacak kendaraan secara real-time (simulasi frontend)
class LiveTrackingScreen extends StatefulWidget {
  final Vehicle vehicle;

  const LiveTrackingScreen({super.key, required this.vehicle});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  GoogleMapController? _mapController;
  Timer? _trackingTimer;
  
  // Current tracking state
  late LatLng _currentPosition;
  double _currentSpeed = 0;
  double _currentHeading = 0;
  String _currentAddress = '';
  DateTime _lastUpdate = DateTime.now();
  bool _isTracking = true;
  bool _cameraFollowEnabled = true;
  
  // Bottom sheet state
  double _sheetHeight = 220;
  final double _minSheetHeight = 120;
  final double _maxSheetHeight = 400;
  bool _isExpanded = false;
  
  // Custom marker icon
  BitmapDescriptor? _vehicleMarkerIcon;
  
  // Simulated movement
  final Random _random = Random();
  int _simulationStep = 0;
  
  // Predefined route for simulation (around Bandung)
  final List<LatLng> _simulatedRoute = [
    const LatLng(-6.9175, 107.6191),
    const LatLng(-6.9165, 107.6200),
    const LatLng(-6.9155, 107.6215),
    const LatLng(-6.9145, 107.6225),
    const LatLng(-6.9135, 107.6240),
    const LatLng(-6.9125, 107.6255),
    const LatLng(-6.9115, 107.6270),
    const LatLng(-6.9105, 107.6280),
    const LatLng(-6.9095, 107.6290),
    const LatLng(-6.9085, 107.6300),
    const LatLng(-6.9080, 107.6310),
    const LatLng(-6.9075, 107.6320),
    const LatLng(-6.9070, 107.6330),
    const LatLng(-6.9068, 107.6340),
    const LatLng(-6.9065, 107.6350),
  ];

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.vehicle.latitude, widget.vehicle.longitude);
    _currentAddress = widget.vehicle.address ?? 'Memuat lokasi...';
    _loadVehicleMarkerIcon();
    _startTracking();
  }

  Color _getStatusColor() {
    switch (widget.vehicle.status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.grey;
      case 'expired':
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  Future<void> _loadVehicleMarkerIcon() async {
    _vehicleMarkerIcon = await _createVehicleMarkerIcon();
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _createVehicleMarkerIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 120.0;
    
    final statusColor = _getStatusColor();
    
    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(size / 2, size / 2 + 3), 36, shadowPaint);
    
    // Draw outer glow (status color)
    final glowPaint = Paint()
      ..color = statusColor.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(const Offset(size / 2, size / 2), 42, glowPaint);
    
    // Draw white border
    final borderPaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(size / 2, size / 2), 38, borderPaint);
    
    // Draw main circle (status color)
    final mainPaint = Paint()..color = statusColor;
    canvas.drawCircle(const Offset(size / 2, size / 2), 32, mainPaint);
    
    // Draw vehicle icon
    final icon = widget.vehicle.type == 'motorcycle' 
        ? Icons.two_wheeler 
        : Icons.directions_car;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 36,
        fontFamily: icon.fontFamily,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size - textPainter.width) / 2,
        (size - textPainter.height) / 2,
      ),
    );
    
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  void _startTracking() {
    // Simulate GPS updates every 2 seconds
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_isTracking) return;
      _updatePosition();
    });
  }

  void _updatePosition() {
    setState(() {
      _lastUpdate = DateTime.now();
      
      // Simulate movement along predefined route
      if (_simulationStep < _simulatedRoute.length - 1) {
        _simulationStep++;
      } else {
        _simulationStep = 0; // Loop back
      }
      
      final targetPosition = _simulatedRoute[_simulationStep];
      
      // Calculate heading
      _currentHeading = _calculateHeading(_currentPosition, targetPosition);
      
      // Simulate speed (20-60 km/h with some variation)
      _currentSpeed = 25 + _random.nextDouble() * 35;
      
      // Update position
      _currentPosition = targetPosition;
      
      // Simulate address update
      _currentAddress = _getSimulatedAddress(_simulationStep);
    });
    
    // Move camera to follow vehicle
    if (_cameraFollowEnabled && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_currentPosition),
      );
    }
  }

  double _calculateHeading(LatLng from, LatLng to) {
    final deltaLng = to.longitude - from.longitude;
    final y = sin(deltaLng * pi / 180);
    final x = cos(from.latitude * pi / 180) * sin(to.latitude * pi / 180) -
        sin(from.latitude * pi / 180) * cos(to.latitude * pi / 180) * cos(deltaLng * pi / 180);
    return atan2(y, x) * 180 / pi;
  }

  String _getSimulatedAddress(int step) {
    final addresses = [
      'Jl. Asia Afrika, Bandung',
      'Jl. Braga, Bandung',
      'Jl. Merdeka, Bandung',
      'Jl. Ir. H. Juanda (Dago), Bandung',
      'Jl. Dipatiukur, Bandung',
      'Jl. Ganesha, Bandung',
      'Jl. Tamansari, Bandung',
      'Jl. Cihampelas, Bandung',
      'Jl. Setiabudhi, Bandung',
      'Jl. Sukajadi, Bandung',
      'Jl. Pasteur, Bandung',
      'Jl. Surya Sumantri, Bandung',
      'Jl. Soekarno Hatta, Bandung',
      'Jl. Buah Batu, Bandung',
      'Jl. Gatot Subroto, Bandung',
    ];
    return addresses[step % addresses.length];
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
      if (_isTracking) {
        _currentSpeed = 25 + _random.nextDouble() * 35;
      } else {
        _currentSpeed = 0;
      }
    });
  }

  void _toggleCameraFollow() {
    setState(() {
      _cameraFollowEnabled = !_cameraFollowEnabled;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_cameraFollowEnabled 
            ? 'Kamera mengikuti kendaraan' 
            : 'Kamera bebas'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _centerOnVehicle() {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition,
          zoom: 16,
        ),
      ),
    );
  }

  void _onVerticalDragUpdate(double delta) {
    setState(() {
      _sheetHeight -= delta;
      _sheetHeight = _sheetHeight.clamp(_minSheetHeight, _maxSheetHeight);
      _isExpanded = _sheetHeight > 280;
    });
  }

  void _onVerticalDragEnd(double velocity) {
    setState(() {
      if (velocity > 300) {
        // Swipe down - minimize
        _sheetHeight = _minSheetHeight;
        _isExpanded = false;
      } else if (velocity < -300) {
        // Swipe up - expand
        _sheetHeight = _maxSheetHeight;
        _isExpanded = true;
      } else {
        // Snap to nearest position
        if (_sheetHeight < 170) {
          _sheetHeight = _minSheetHeight;
          _isExpanded = false;
        } else if (_sheetHeight < 300) {
          _sheetHeight = 220;
          _isExpanded = false;
        } else {
          _sheetHeight = _maxSheetHeight;
          _isExpanded = true;
        }
      }
    });
  }

  void _toggleExpand() {
    setState(() {
      if (_isExpanded) {
        _sheetHeight = _minSheetHeight;
        _isExpanded = false;
      } else {
        _sheetHeight = _maxSheetHeight;
        _isExpanded = true;
      }
    });
  }

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          _buildMap(),
          
          // Top bar with back button and title
          _buildTopBar(),
          
          // Live indicator
          _buildLiveIndicator(),
          
          // Map controls
          _buildMapControls(),
          
          // Bottom info panel (draggable)
          _buildInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 16,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        controller.setMapStyle(MapConfig.GOOGLE_MAP_STYLE);
      },
      markers: {
        Marker(
          markerId: const MarkerId('vehicle'),
          position: _currentPosition,
          icon: _vehicleMarkerIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          rotation: _currentHeading,
          anchor: const Offset(0.5, 0.5),
          infoWindow: InfoWindow(
            title: widget.vehicle.code,
            snippet: '${_currentSpeed.toInt()} km/h',
          ),
        ),
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      trafficEnabled: false,
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 8,
          right: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Melacak ${widget.vehicle.code}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.vehicle.plate,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isTracking ? Colors.red : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (_isTracking ? Colors.red : Colors.grey).withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: _isTracking ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 4,
                  ),
                ] : null,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _isTracking ? 'LIVE' : 'PAUSED',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      right: 16,
      bottom: _sheetHeight + 16,
      child: Column(
        children: [
          // Camera follow toggle
          _buildControlButton(
            icon: _cameraFollowEnabled ? Icons.gps_fixed : Icons.gps_not_fixed,
            onPressed: _toggleCameraFollow,
            isActive: _cameraFollowEnabled,
          ),
          const SizedBox(height: 8),
          // Center on vehicle
          _buildControlButton(
            icon: Icons.my_location,
            onPressed: _centerOnVehicle,
          ),
          const SizedBox(height: 8),
          // Pause/Resume tracking
          _buildControlButton(
            icon: _isTracking ? Icons.pause : Icons.play_arrow,
            onPressed: _toggleTracking,
            color: _isTracking ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
    Color? color,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: color ?? (isActive ? const Color(0xFFE53935) : Colors.grey.shade700),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (details) => _onVerticalDragUpdate(details.delta.dy),
        onVerticalDragEnd: (details) => _onVerticalDragEnd(details.primaryVelocity ?? 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _sheetHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              GestureDetector(
                onTap: _toggleExpand,
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
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Speed display (compact when minimized)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _currentSpeed.toInt().toString(),
                            style: TextStyle(
                              fontSize: _isExpanded ? 56 : 40,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE53935),
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4, left: 4),
                            child: Text(
                              'km/h',
                              style: TextStyle(
                                fontSize: _isExpanded ? 18 : 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          if (!_isExpanded) ...[
                            const Spacer(),
                            // Mini location when collapsed
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _currentAddress,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      
                      if (_isExpanded) ...[
                        const SizedBox(height: 16),
                        
                        // Location info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                Icons.location_on,
                                'Lokasi',
                                _currentAddress,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.explore,
                                'Koordinat',
                                '${_currentPosition.latitude.toStringAsFixed(6)}, ${_currentPosition.longitude.toStringAsFixed(6)}',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                Icons.access_time,
                                'Update Terakhir',
                                _formatTime(_lastUpdate),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Stop tracking button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.stop),
                            label: const Text('Berhenti Melacak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE53935),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
