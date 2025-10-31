import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'daftar_page.dart';
import 'peta_page_google.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedVehicleId = 1;
  final GlobalKey<PetaPageGoogleState> _petaPageGoogleKey =
      GlobalKey<PetaPageGoogleState>();

  @override
  void initState() {
    super.initState();

    // Setup initial vehicle berdasarkan role
    final currentAccount = SessionManager.currentAccount;
    if (currentAccount != null) {
      if (currentAccount.role == 'pengguna' &&
          currentAccount.assignedVehicleId != null) {
        // Pengguna: gunakan kendaraan yang ditugaskan
        _selectedVehicleId = currentAccount.assignedVehicleId!;
      } else if (currentAccount.role == 'korporasi') {
        // Korporasi: gunakan kendaraan pertama yang dimiliki
        final vehicles = VehicleRepository.getVehiclesByOwnerId(
          currentAccount.id,
        );
        if (vehicles.isNotEmpty) {
          _selectedVehicleId = vehicles.first.id;
        }
      }
    }

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onVehicleSelected(int vehicleId) {
    print('==========================================');
    print('TrackScreen._onVehicleSelected CALLED!');
    print('Vehicle ID selected: $vehicleId');
    print('Previous selectedVehicleId: $_selectedVehicleId');

    setState(() {
      _selectedVehicleId = vehicleId;
    });
    print('State updated! New selectedVehicleId: $_selectedVehicleId');

    // Pindah ke tab Peta
    print('Switching to Peta tab (index 1)...');
    _tabController.animateTo(1);

    // Update PetaPage
    Future.delayed(Duration(milliseconds: 100), () {
      print('Calling PetaPage.updateSelectedVehicle($vehicleId)...');

      if (_petaPageGoogleKey.currentState == null) {
        print('❌ ERROR: _petaPageKey.currentState is NULL!');
      } else {
        print('✅ PetaPage state found, calling updateSelectedVehicle...');
        _petaPageGoogleKey.currentState?.onMarkerTap(vehicleId);
      }
    });

    print('==========================================');
  }

  // Check if user should see tabs (only korporasi)
  bool get _shouldShowTabs {
    final currentAccount = SessionManager.currentAccount;
    return currentAccount?.role == 'korporasi';
  }

  @override
  Widget build(BuildContext context) {
    // Jika bukan korporasi, langsung tampilkan peta tanpa tabs
    if (!_shouldShowTabs) {
      if (!_shouldShowTabs) {
        return PetaPageGoogle(
          key: _petaPageGoogleKey,
          initialVehicleId: _selectedVehicleId,
        );
      }
    }

    // Korporasi: tampilkan dengan TabBar
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
              bottom: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFE53935),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFE53935),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            tabs: const [
              Tab(text: 'Daftar'),
              Tab(text: 'Peta'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), // ✅ DISABLE SWIPE
        children: [
          DaftarPage(onVehicleSelected: _onVehicleSelected),
          PetaPageGoogle(
            key: _petaPageGoogleKey,
            initialVehicleId: _selectedVehicleId,
          ),
        ],
      ),
    );
  }
}
