import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/menu/cek_kendaraan/cek_kendaraan_screen.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

class CekKendaraanListPage extends StatefulWidget {
  @override
  _CekKendaraanListPageState createState() => _CekKendaraanListPageState();
}

class _CekKendaraanListPageState extends State<CekKendaraanListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'semua';
  String _searchQuery = '';

  // Ambil kendaraan berdasarkan role
  List<Vehicle> get _vehicleList {
    final currentAccount = SessionManager.currentAccount;
    
    if (currentAccount == null) return [];
    
    if (currentAccount.role == 'korporasi') {
      // Korporasi: Tampilkan semua kendaraan yang dimiliki
      return VehicleRepository.getVehiclesByOwnerId(currentAccount.id);
    } else {
      // Pengguna: Tampilkan kendaraan yang ditugaskan (fallback, seharusnya tidak sampai sini)
      if (currentAccount.assignedVehicleId != null) {
        final vehicle = VehicleRepository.getVehicleById(
          currentAccount.assignedVehicleId!,
        );
        return vehicle != null ? [vehicle] : [];
      }
      return [];
    }
  }

  List<Vehicle> get _filteredVehicles {
    return _vehicleList.where((vehicle) {
      final matchesSearch =
          vehicle.code.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              vehicle.plate.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _activeFilter == 'semua' || vehicle.status == _activeFilter;
      return matchesSearch && matchesFilter;
    }).toList();
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

  void _navigateToDetail(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CekKendaraan(vehicle: vehicle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE53935),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cek Kendaraan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filter Tabs
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['semua', 'online', 'offline', 'expired'].map((filter) {
                final isActive = _activeFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      filter[0].toUpperCase() + filter.substring(1),
                      style: TextStyle(
                        color: isActive ? Colors.black87 : Colors.grey,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    selected: isActive,
                    onSelected: (selected) {
                      setState(() => _activeFilter = filter);
                    },
                    backgroundColor: Color(0xFFF5F5F5),
                    selectedColor: Colors.white,
                    side: BorderSide(
                      color:
                          isActive ? Colors.grey.shade300 : Colors.transparent,
                      width: isActive ? 2 : 0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 8),

          // Vehicle Count Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total: ${_filteredVehicles.length} kendaraan',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Vehicle List
          Expanded(
            child: _filteredVehicles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Tidak ada kendaraan ditemukan',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return InkWell(
                        onTap: () => _navigateToDetail(vehicle),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Color(0xFFE0E0E0),
                              child: Icon(
                                vehicle.type == 'motorcycle'
                                    ? Icons.two_wheeler
                                    : Icons.directions_car,
                                size: 28,
                                color: Colors.black54,
                              ),
                            ),
                            title: Text(
                              vehicle.code,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.speed,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      '${vehicle.totalKm}km',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(
                                      '${vehicle.todayKm}km',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      vehicle.plate,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      vehicle.status[0].toUpperCase() +
                                          vehicle.status.substring(1),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(vehicle.status),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}