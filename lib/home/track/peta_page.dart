import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sihemat_v3/home/track/widgets/map_control_button.dart';
import 'package:sihemat_v3/home/track/widgets/vehicle_bottom_sheet.dart';
import 'package:sihemat_v3/home/track/widgets/vehicle_marker.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

class PetaPage extends StatefulWidget {
  final int initialVehicleId;

  PetaPage({Key? key, required this.initialVehicleId}) : super(key: key);

  @override
  PetaPageState createState() => PetaPageState();
}

class PetaPageState extends State<PetaPage> {
  late int _currentVehicleIndex;
  double _bottomSheetHeight = 250.0;
  final double _minSheetHeight = 150.0;
  final double _maxSheetHeight = 500.0;
  bool _isExpanded = false;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeVehicleIndex();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerMapToCurrentVehicle();
    });
  }

  void _initializeVehicleIndex() {
    _currentVehicleIndex =
        _availableVehicles.indexWhere((v) => v.id == widget.initialVehicleId);
    if (_currentVehicleIndex == -1) {
      _currentVehicleIndex = 0;
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // Get available vehicles based on role
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

  bool get _shouldShowNavigationButtons {
    final currentAccount = SessionManager.currentAccount;
    return currentAccount?.role == 'korporasi' && _availableVehicles.length > 1;
  }

  void updateSelectedVehicle(int vehicleId) {
    final newIndex = _availableVehicles.indexWhere((v) => v.id == vehicleId);
    if (newIndex != -1 && newIndex != _currentVehicleIndex) {
      setState(() => _currentVehicleIndex = newIndex);
      _centerMapToCurrentVehicle();
    }
  }

  Vehicle get _currentVehicle {
    if (_availableVehicles.isEmpty) {
      return VehicleRepository.getAllVehicles().first;
    }
    return _availableVehicles[_currentVehicleIndex];
  }

  void _centerMapToCurrentVehicle() {
    _mapController.move(
      LatLng(_currentVehicle.latitude, _currentVehicle.longitude),
      15.0,
    );
    if (mounted) setState(() {});
  }

  void _onMarkerTap(int vehicleId) {
    final index = _availableVehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1 && index != _currentVehicleIndex) {
      setState(() => _currentVehicleIndex = index);
      _centerMapToCurrentVehicle();
    }
  }

  void _nextVehicle() {
    if (!_shouldShowNavigationButtons) return;
    setState(() {
      _currentVehicleIndex = (_currentVehicleIndex + 1) % _availableVehicles.length;
    });
    _centerMapToCurrentVehicle();
  }

  void _previousVehicle() {
    if (!_shouldShowNavigationButtons) return;
    setState(() {
      _currentVehicleIndex =
          (_currentVehicleIndex - 1 + _availableVehicles.length) %
              _availableVehicles.length;
    });
    _centerMapToCurrentVehicle();
  }

  @override
  Widget build(BuildContext context) {
    if (_availableVehicles.isEmpty) {
      return _buildEmptyState();
    }

    return Stack(
      children: [
        _buildMap(),
        if (_shouldShowNavigationButtons) _buildNavigationButtons(context),
        _buildMapControls(context),
        _buildBottomSheet(),
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

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: LatLng(_currentVehicle.latitude, _currentVehicle.longitude),
        initialZoom: 15.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.sihemat',
        ),
        MarkerLayer(
          markers: _availableVehicles.map((vehicle) {
            return VehicleMarker(
              vehicle: vehicle,
              isSelected: vehicle.id == _currentVehicle.id,
              onTap: () => _onMarkerTap(vehicle.id),
            ).toMarker();
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return MapNavigationButtons(
      onPrevious: _previousVehicle,
      onNext: _nextVehicle,
      top: screenHeight * 0.4 - 60,
    );
  }

  Widget _buildMapControls(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return MapControlButtons(
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
    );
  }

  Widget _buildBottomSheet() {
    return VehicleBottomSheet(
      vehicle: _currentVehicle,
      height: _bottomSheetHeight,
      minHeight: _minSheetHeight,
      maxHeight: _maxSheetHeight,
      isExpanded: _isExpanded,
      onVerticalDragUpdate: (delta) {
        setState(() {
          _bottomSheetHeight -= delta;
          _bottomSheetHeight = _bottomSheetHeight.clamp(_minSheetHeight, _maxSheetHeight);
          _isExpanded = _bottomSheetHeight > 300;
        });
      },
      onVerticalDragEnd: (velocity) {
        setState(() {
          if (velocity > 300) {
            _bottomSheetHeight = _minSheetHeight;
            _isExpanded = false;
          } else if (velocity < -300) {
            _bottomSheetHeight = _maxSheetHeight;
            _isExpanded = true;
          } else {
            if (_bottomSheetHeight < 200) {
              _bottomSheetHeight = _minSheetHeight;
              _isExpanded = false;
            } else if (_bottomSheetHeight < 350) {
              _bottomSheetHeight = 250.0;
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
            _bottomSheetHeight = 250.0;
            _isExpanded = false;
          } else {
            _bottomSheetHeight = _maxSheetHeight;
            _isExpanded = true;
          }
        });
      },
    );
  }
}