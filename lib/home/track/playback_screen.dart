import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sihemat_v3/models/route_history.dart';
import 'package:sihemat_v3/models/repositories/route_history_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/config/map_config.dart';

class PlaybackScreen extends StatefulWidget {
  final Vehicle vehicle;

  const PlaybackScreen({super.key, required this.vehicle});

  @override
  State<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  
  List<TripHistory> _trips = [];
  TripHistory? _selectedTrip;
  int _currentPointIndex = 0;
  bool _isPlaying = false;
  Timer? _animationTimer;
  double _playbackSpeed = 1.0;

  // Animation state
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  LatLng? _currentPosition;
  
  // Custom marker icons
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _endMarkerIcon;
  BitmapDescriptor? _vehicleMarkerIcon;
  
  // Animation controllers for smooth transitions
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcons();
    _loadTrips();
    _setupPulseAnimation();
  }

  void _setupPulseAnimation() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadMarkerIcons() async {
    // Create custom markers
    _startMarkerIcon = await _createCustomMarkerIcon(
      Colors.green,
      Icons.trip_origin,
    );
    _endMarkerIcon = await _createCustomMarkerIcon(
      Colors.red,
      Icons.location_on,
    );
    _vehicleMarkerIcon = await _createVehicleMarkerIcon();
    
    if (mounted) setState(() {});
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(Color color, IconData icon) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 120.0;
    
    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(const Offset(size / 2, size / 2 + 4), 28, shadowPaint);
    
    // Draw outer circle (white border)
    final outerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(size / 2, size / 2), 32, outerPaint);
    
    // Draw inner circle (colored)
    final innerPaint = Paint()..color = color;
    canvas.drawCircle(const Offset(size / 2, size / 2), 26, innerPaint);
    
    // Draw icon
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 32,
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

  Future<BitmapDescriptor> _createVehicleMarkerIcon() async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    const size = 140.0;
    
    // Draw outer glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFE53935).withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(const Offset(size / 2, size / 2), 45, glowPaint);
    
    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(const Offset(size / 2, size / 2 + 4), 32, shadowPaint);
    
    // Draw outer white ring
    final outerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(size / 2, size / 2), 38, outerPaint);
    
    // Draw main circle with gradient effect
    final mainPaint = Paint()..color = const Color(0xFFE53935);
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

  void _loadTrips() {
    setState(() {
      _trips = RouteHistoryRepository.getTripsByVehicleId(widget.vehicle.id);
      if (_trips.isNotEmpty) {
        _selectTrip(_trips.first);
      }
    });
  }

  void _selectTrip(TripHistory trip) {
    _stopPlayback();
    setState(() {
      _selectedTrip = trip;
      _currentPointIndex = 0;
      if (trip.routePoints.isNotEmpty) {
        _currentPosition = LatLng(
          trip.routePoints.first.latitude,
          trip.routePoints.first.longitude,
        );
      }
    });
    _updateMapElements();
    _centerMapOnTrip();
  }

  void _updateMapElements() {
    if (_selectedTrip == null) return;
    
    final fullPath = _selectedTrip!.routePoints
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
    
    final animatedPath = _selectedTrip!.routePoints
        .take(_currentPointIndex + 1)
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
    
    // Create polylines
    _polylines = {
      // Full route (faded gray)
      if (fullPath.length >= 2)
        Polyline(
          polylineId: const PolylineId('full_route'),
          points: fullPath,
          color: Colors.grey.shade400,
          width: 4,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ),
      // Animated path (highlighted red)
      if (animatedPath.length >= 2)
        Polyline(
          polylineId: const PolylineId('animated_route'),
          points: animatedPath,
          color: const Color(0xFFE53935),
          width: 6,
        ),
    };
    
    // Create markers
    _markers = {};
    
    // Start marker (green location pin)
    if (fullPath.isNotEmpty && _startMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('start'),
        position: fullPath.first,
        icon: _startMarkerIcon!,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Titik Awal'),
      ));
    }
    
    // End marker (red location pin)
    if (fullPath.length > 1 && _endMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('end'),
        position: fullPath.last,
        icon: _endMarkerIcon!,
        anchor: const Offset(0.5, 0.5),
        infoWindow: const InfoWindow(title: 'Titik Akhir'),
      ));
    }
    
    // Current vehicle position
    if (_currentPosition != null && _vehicleMarkerIcon != null) {
      _markers.add(Marker(
        markerId: const MarkerId('vehicle'),
        position: _currentPosition!,
        icon: _vehicleMarkerIcon!,
        anchor: const Offset(0.5, 0.5),
        zIndex: 10, // Above other markers
      ));
    }
    
    setState(() {});
  }

  void _centerMapOnTrip() {
    if (_selectedTrip == null || _selectedTrip!.routePoints.isEmpty) return;
    
    final points = _selectedTrip!.routePoints;
    
    // Calculate bounds
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;
    
    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }
    
    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 80),
      );
    });
  }

  void _startPlayback() {
    if (_selectedTrip == null) return;
    
    setState(() {
      _isPlaying = true;
    });

    // Enhanced smooth animation with interpolation
    final intervalMs = (200 / _playbackSpeed).round();
    
    _animationTimer = Timer.periodic(
      Duration(milliseconds: intervalMs),
      (timer) {
        if (_currentPointIndex < _selectedTrip!.routePoints.length - 1) {
          setState(() {
            _currentPointIndex++;
            final point = _selectedTrip!.routePoints[_currentPointIndex];
            _currentPosition = LatLng(point.latitude, point.longitude);
          });
          _updateMapElements();
          
          // Smoothly follow the vehicle
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_currentPosition!),
          );
        } else {
          _stopPlayback();
        }
      },
    );
  }

  void _stopPlayback() {
    _animationTimer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _resetPlayback() {
    _stopPlayback();
    setState(() {
      _currentPointIndex = 0;
      if (_selectedTrip != null && _selectedTrip!.routePoints.isNotEmpty) {
        _currentPosition = LatLng(
          _selectedTrip!.routePoints.first.latitude,
          _selectedTrip!.routePoints.first.longitude,
        );
      }
    });
    _updateMapElements();
    _centerMapOnTrip();
  }

  void _seekTo(double value) {
    if (_selectedTrip == null) return;
    _stopPlayback();
    
    final newIndex = (value * (_selectedTrip!.routePoints.length - 1)).round();
    setState(() {
      _currentPointIndex = newIndex;
      final point = _selectedTrip!.routePoints[newIndex];
      _currentPosition = LatLng(point.latitude, point.longitude);
    });
    _updateMapElements();
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    _mapController?.dispose();
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: Text('Playback - ${widget.vehicle.code}'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerMapOnTrip,
            tooltip: 'Center on route',
          ),
        ],
      ),
      body: _trips.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // Trip selector
                _buildTripSelector(),
                
                // Map
                Expanded(
                  child: _buildMap(),
                ),
                
                // Playback controls
                _buildPlaybackControls(),
                
                // Trip info
                if (_selectedTrip != null) _buildTripInfo(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.route_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada riwayat perjalanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kendaraan ${widget.vehicle.code} belum memiliki\ndata perjalanan yang tercatat',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripSelector() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _trips.length,
        itemBuilder: (context, index) {
          final trip = _trips[index];
          final isSelected = _selectedTrip?.id == trip.id;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Material(
              color: isSelected ? const Color(0xFFE53935) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              elevation: isSelected ? 2 : 0,
              child: InkWell(
                onTap: () => _selectTrip(trip),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFE53935) : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.route,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Trip ${index + 1} • ${_formatTime(trip.startTime)}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? LatLng(
          MapConfig.DEFAULT_CENTER_LAT,
          MapConfig.DEFAULT_CENTER_LNG,
        ),
        zoom: MapConfig.DEFAULT_ZOOM,
      ),
      onMapCreated: (controller) {
        _mapController = controller;
        controller.setMapStyle(MapConfig.GOOGLE_MAP_STYLE);
        _centerMapOnTrip();
      },
      polylines: _polylines,
      markers: _markers,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
      trafficEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: false,
    );
  }

  Widget _buildPlaybackControls() {
    final progress = _selectedTrip != null && _selectedTrip!.routePoints.isNotEmpty
        ? _currentPointIndex / (_selectedTrip!.routePoints.length - 1)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Progress bar with time indicators
          Row(
            children: [
              Text(
                _selectedTrip != null && _currentPointIndex < _selectedTrip!.routePoints.length
                    ? _formatTime(_selectedTrip!.routePoints[_currentPointIndex].timestamp)
                    : '--:--',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFFE53935),
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbColor: const Color(0xFFE53935),
                    overlayColor: const Color(0xFFE53935).withOpacity(0.2),
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: _seekTo,
                  ),
                ),
              ),
              Text(
                _selectedTrip != null && _selectedTrip!.routePoints.isNotEmpty
                    ? _formatTime(_selectedTrip!.routePoints.last.timestamp)
                    : '--:--',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset button
              _buildControlButton(
                icon: Icons.replay,
                onPressed: _resetPlayback,
                size: 44,
                color: Colors.grey.shade700,
              ),
              
              const SizedBox(width: 16),
              
              // Step backward
              _buildControlButton(
                icon: Icons.skip_previous,
                onPressed: () {
                  if (_currentPointIndex > 0) {
                    _stopPlayback();
                    _seekTo((_currentPointIndex - 1) / (_selectedTrip!.routePoints.length - 1));
                  }
                },
                size: 44,
                color: Colors.grey.shade700,
              ),
              
              const SizedBox(width: 12),
              
              // Play/Pause button (larger)
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE53935).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _isPlaying ? _stopPlayback : _startPlayback,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      key: ValueKey(_isPlaying),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  iconSize: 32,
                  padding: const EdgeInsets.all(12),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Step forward
              _buildControlButton(
                icon: Icons.skip_next,
                onPressed: () {
                  if (_selectedTrip != null && _currentPointIndex < _selectedTrip!.routePoints.length - 1) {
                    _stopPlayback();
                    _seekTo((_currentPointIndex + 1) / (_selectedTrip!.routePoints.length - 1));
                  }
                },
                size: 44,
                color: Colors.grey.shade700,
              ),
              
              const SizedBox(width: 16),
              
              // Speed control
              PopupMenuButton<double>(
                initialValue: _playbackSpeed,
                onSelected: (speed) {
                  setState(() {
                    _playbackSpeed = speed;
                  });
                  if (_isPlaying) {
                    _stopPlayback();
                    _startPlayback();
                  }
                },
                itemBuilder: (context) => [
                  _buildSpeedMenuItem(0.5),
                  _buildSpeedMenuItem(1.0),
                  _buildSpeedMenuItem(2.0),
                  _buildSpeedMenuItem(4.0),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.speed, size: 18, color: Color(0xFFE53935)),
                      const SizedBox(width: 4),
                      Text(
                        '${_playbackSpeed}x',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Current speed indicator
          if (_selectedTrip != null && _currentPointIndex < _selectedTrip!.routePoints.length)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.speed,
                      size: 18,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${_selectedTrip!.routePoints[_currentPointIndex].speed.toInt()} km/h',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
    required Color color,
  }) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 24),
        ),
      ),
    );
  }

  PopupMenuItem<double> _buildSpeedMenuItem(double speed) {
    final isSelected = _playbackSpeed == speed;
    return PopupMenuItem(
      value: speed,
      child: Row(
        children: [
          if (isSelected)
            const Icon(Icons.check, size: 18, color: Color(0xFFE53935))
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(
            '${speed}x',
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFFE53935) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              Icons.route,
              '${_selectedTrip!.totalDistance} km',
              'Jarak',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildInfoItem(
              Icons.timer,
              _selectedTrip!.durationString,
              'Durasi',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildInfoItem(
              Icons.speed,
              '${_selectedTrip!.avgSpeed.toInt()} km/h',
              'Rata-rata',
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _buildInfoItem(
              Icons.flash_on,
              '${_selectedTrip!.maxSpeed.toInt()} km/h',
              'Maks',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFFE53935)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
