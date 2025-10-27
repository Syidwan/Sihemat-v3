import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sihemat_v3/home/track/widgets/map_control_button.dart';
import 'package:sihemat_v3/home/track/widgets/vehicle_bottom_sheet.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/config/map_config.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class PetaPageGoogle extends StatefulWidget {
  final int initialVehicleId;

  PetaPageGoogle({Key? key, required this.initialVehicleId}) : super(key: key);

  @override
  PetaPageGoogleState createState() => PetaPageGoogleState();
}

class PetaPageGoogleState extends State<PetaPageGoogle> {
  late int _currentVehicleIndex;
  double _bottomSheetHeight = MapConfig.DEFAULT_SHEET_HEIGHT;
  final double _minSheetHeight = MapConfig.MIN_SHEET_HEIGHT;
  final double _maxSheetHeight = MapConfig.MAX_SHEET_HEIGHT;
  bool _isExpanded = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final Map<int, GlobalKey> _markerKeys = {};

  @override
  void initState() {
    super.initState();
    _initializeVehicleIndex();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _updateMarkers();
    //   _centerMapToCurrentVehicle();
    // });
  }

  void _initializeVehicleIndex() {
    _currentVehicleIndex =
        _availableVehicles.indexWhere((v) => v.id == widget.initialVehicleId);
    if (_currentVehicleIndex == -1) {
      _currentVehicleIndex = 0;
    }
  }

  List<Vehicle> get _availableVehicles {
    final currentAccount = SessionManager.currentAccount;
    if (currentAccount == null) return [];
    
    if (currentAccount.role == 'korporasi') {
      return VehicleRepository.getVehiclesByOwnerId(currentAccount.id);
    } else if (currentAccount.role == 'pengguna') {
      if (currentAccount.assignedVehicleId != null) {
        final vehicle = VehicleRepository.getVehicleById(
          currentAccount.assignedVehicleId!,
        );
        return vehicle != null ? [vehicle] : [];
      }
      return [];
    }
    return [];
  }

  Vehicle get _currentVehicle {
    if (_availableVehicles.isEmpty) {
      return VehicleRepository.getAllVehicles().first;
    }
    return _availableVehicles[_currentVehicleIndex];
  }

  bool get _shouldShowNavigationButtons {
    final currentAccount = SessionManager.currentAccount;
    return currentAccount?.role == 'korporasi' && _availableVehicles.length > 1;
  }

  Color _getStatusColor(String status) {
    switch (status) {
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

  // Convert widget to BitmapDescriptor with optimized rendering
  Future<BitmapDescriptor> _createMarkerFromWidget(
    Vehicle vehicle,
    bool isSelected,
  ) async {
    final key = _markerKeys.putIfAbsent(vehicle.id, () => GlobalKey());
    
    final markerWidget = RepaintBoundary(
      key: key,
      child: _buildMarkerWidget(vehicle, isSelected),
    );

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        left: -1000,
        top: -1000,
        child: Material(
          color: Colors.transparent,
          child: markerWidget,
        ),
      ),
    );

    final overlayState = Overlay.of(context);
    overlayState.insert(overlay);

    await Future.delayed(Duration(milliseconds: 50)); // Reduced delay

    try {
      final renderObject = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (renderObject == null) {
        overlay.remove();
        throw Exception('Failed to get render object');
      }

      // Use configured pixel ratio for performance
      final image = await renderObject.toImage(pixelRatio: MapConfig.RENDER_PIXEL_RATIO);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final uint8List = byteData!.buffer.asUint8List();

      overlay.remove();
      return BitmapDescriptor.fromBytes(uint8List);
    } catch (e) {
      overlay.remove();
      rethrow;
    }
  }

  Widget _buildMarkerWidget(Vehicle vehicle, bool isSelected) {
    final size = isSelected ? MapConfig.SELECTED_MARKER_SIZE : MapConfig.NORMAL_MARKER_SIZE;
    final iconSize = isSelected ? MapConfig.SELECTED_ICON_SIZE : MapConfig.NORMAL_ICON_SIZE;
    
    return SizedBox(
      width: size,
      height: size + (isSelected ? 20 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: MapConfig.MARKER_ANIMATION_DURATION,
            width: size - (isSelected ? 28 : 20),
            height: size - (isSelected ? 28 : 20),
            decoration: BoxDecoration(
              color: _getStatusColor(vehicle.status),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? _getStatusColor(vehicle.status).withOpacity(0.6)
                      : Colors.black.withOpacity(0.3),
                  blurRadius: isSelected ? 12 : 6,
                  spreadRadius: isSelected ? 2 : 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              vehicle.type == 'motorcycle'
                  ? Icons.two_wheeler
                  : Icons.directions_car,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          if (isSelected) ...[
            SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                vehicle.code,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateMarkers() async {
    if (!_isMapReady || !mounted) return;
    final markers = <Marker>{};
    
    for (var vehicle in _availableVehicles) {
      final isSelected = vehicle.id == _currentVehicle.id;
      final icon = await _createMarkerFromWidget(vehicle, isSelected);
      
      markers.add(
        Marker(
          markerId: MarkerId(vehicle.id.toString()),
          position: LatLng(vehicle.latitude, vehicle.longitude),
          icon: icon,
          anchor: Offset(
            MapConfig.MARKER_ANCHOR_X, 
            isSelected ? 0.5 : MapConfig.MARKER_ANCHOR_Y
          ),
          flat: MapConfig.GOOGLE_MARKER_FLAT,
          draggable: MapConfig.GOOGLE_MARKER_DRAGGABLE,
          alpha: MapConfig.GOOGLE_MARKER_ALPHA,
          onTap: () => onMarkerTap(vehicle.id),
        ),
      );
    }
    
    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }
  }

  void _centerMapToCurrentVehicle() {
    if (_mapController == null) return;
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(_currentVehicle.latitude, _currentVehicle.longitude),
        MapConfig.DEFAULT_ZOOM,
      ),
    );
  }

  void onMarkerTap(int vehicleId) {
    final index = _availableVehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1 && index != _currentVehicleIndex) {
      setState(() => _currentVehicleIndex = index);
      _updateMarkers();
      _centerMapToCurrentVehicle();
    }
  }

  void _previousVehicle() {
    if (!_shouldShowNavigationButtons) return;
    setState(() {
      _currentVehicleIndex =
          (_currentVehicleIndex - 1 + _availableVehicles.length) %
              _availableVehicles.length;
    });
    _updateMarkers();
    _centerMapToCurrentVehicle();
  }

  void _nextVehicle() {
    if (!_shouldShowNavigationButtons) return;
    setState(() {
      _currentVehicleIndex = (_currentVehicleIndex + 1) % _availableVehicles.length;
    });
    _updateMarkers();
    _centerMapToCurrentVehicle();
  }

  bool _isMapReady = false;
  @override
  Widget build(BuildContext context) {
    if (_availableVehicles.isEmpty) {
      return _buildEmptyState();
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentVehicle.latitude, _currentVehicle.longitude),
            zoom: MapConfig.DEFAULT_ZOOM,
            tilt: MapConfig.GOOGLE_CAMERA_TILT,
            bearing: MapConfig.GOOGLE_CAMERA_BEARING,
          ),
          markers: _markers,
          
          onMapCreated: (controller) async {
            _mapController = controller;
            _mapController?.setMapStyle(MapConfig.GOOGLE_MAP_STYLE);

            _isMapReady = true;
            await Future.delayed(const Duration(milliseconds: 500));
            await _updateMarkers();
            _centerMapToCurrentVehicle();
          },
          // Optimized settings from MapConfig
          myLocationEnabled: MapConfig.GOOGLE_MY_LOCATION_ENABLED,
          myLocationButtonEnabled: MapConfig.GOOGLE_MY_LOCATION_BUTTON_ENABLED,
          zoomControlsEnabled: MapConfig.GOOGLE_ZOOM_CONTROLS_ENABLED,
          zoomGesturesEnabled: MapConfig.GOOGLE_ZOOM_GESTURES_ENABLED,
          scrollGesturesEnabled: MapConfig.GOOGLE_SCROLL_GESTURES_ENABLED,
          tiltGesturesEnabled: MapConfig.GOOGLE_TILT_GESTURES_ENABLED,
          rotateGesturesEnabled: MapConfig.GOOGLE_ROTATE_GESTURES_ENABLED,
          compassEnabled: MapConfig.GOOGLE_COMPASS_ENABLED,
          mapToolbarEnabled: MapConfig.GOOGLE_MAP_TOOLBAR_ENABLED,
          buildingsEnabled: MapConfig.GOOGLE_BUILDINGS_ENABLED,
          trafficEnabled: MapConfig.GOOGLE_TRAFFIC_ENABLED,
          indoorViewEnabled: MapConfig.GOOGLE_INDOOR_ENABLED,
          liteModeEnabled: MapConfig.GOOGLE_LITE_MODE,
          mapType: MapConfig.GOOGLE_MAP_TYPE,
          minMaxZoomPreference: MinMaxZoomPreference(
            MapConfig.MIN_ZOOM,
            MapConfig.MAX_ZOOM,
          ),
        ),
        if (_shouldShowNavigationButtons)
          MapNavigationButtons(
            onPrevious: _previousVehicle,
            onNext: _nextVehicle,
            top: screenHeight * 0.4 - 60,
          ),
        MapControlButtons(
          onRecenter: () {
            _centerMapToCurrentVehicle();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Centering to ${_currentVehicle.code}'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          onGpsLocation: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Getting current GPS location'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          top: screenHeight * 0.35 - 60,
        ),
        VehicleBottomSheet(
          vehicle: _currentVehicle,
          height: _bottomSheetHeight,
          minHeight: _minSheetHeight,
          maxHeight: _maxSheetHeight,
          isExpanded: _isExpanded,
          onVerticalDragUpdate: (delta) {
            setState(() {
              _bottomSheetHeight -= delta;
              _bottomSheetHeight = _bottomSheetHeight.clamp(_minSheetHeight, _maxSheetHeight);
              _isExpanded = _bottomSheetHeight > MapConfig.EXPAND_THRESHOLD;
            });
          },
          onVerticalDragEnd: (velocity) {
            setState(() {
              if (velocity > MapConfig.SNAP_VELOCITY_THRESHOLD) {
                _bottomSheetHeight = _minSheetHeight;
                _isExpanded = false;
              } else if (velocity < -MapConfig.SNAP_VELOCITY_THRESHOLD) {
                _bottomSheetHeight = _maxSheetHeight;
                _isExpanded = true;
              } else {
                if (_bottomSheetHeight < 200) {
                  _bottomSheetHeight = _minSheetHeight;
                  _isExpanded = false;
                } else if (_bottomSheetHeight < 350) {
                  _bottomSheetHeight = MapConfig.DEFAULT_SHEET_HEIGHT;
                  _isExpanded = false;
                } else {
                  _bottomSheetHeight = _maxSheetHeight;
                  _isExpanded = true;
                }
              }
            });
          },
          onToggleExpand: () {
            setState(() {
              if (_isExpanded) {
                _bottomSheetHeight = MapConfig.DEFAULT_SHEET_HEIGHT;
                _isExpanded = false;
              } else {
                _bottomSheetHeight = _maxSheetHeight;
                _isExpanded = true;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, size: 80, color: Colors.grey.shade300),
          SizedBox(height: 16),
          Text(
            'Tidak ada kendaraan tersedia',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}