import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'cek_pajak_detail_page.dart';

class CekPajakScreen extends StatefulWidget {
  @override
  _CekPajakScreenState createState() => _CekPajakScreenState();
}

class _CekPajakScreenState extends State<CekPajakScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Ambil kendaraan berdasarkan role
  List<Vehicle> get _vehicleList {
    final currentAccount = SessionManager.currentAccount;
    
    if (currentAccount == null) return [];
    
    if (currentAccount.role == 'korporasi') {
      // Korporasi: Tampilkan semua kendaraan yang dimiliki
      return VehicleRepository.getVehiclesByOwnerId(currentAccount.id);
    } else {
      // Pengguna: Tampilkan kendaraan yang ditugaskan (fallback)
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
      final matchesSearch = vehicle.code
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          vehicle.plate
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();
  }

  void _navigateToDetail(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CekPajakDetailPage(vehicle: vehicle),
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
          'Cek Pajak',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text(
              'Daftar Pajak Kendaraan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari',
                hintStyle: TextStyle(color: Colors.grey.shade400),
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

          SizedBox(height: 8),

          // Vehicle Count Info
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'Total: ${_filteredVehicles.length} kendaraan',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
                          Icons.receipt_long_outlined,
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return InkWell(
                        onTap: () => _navigateToDetail(vehicle),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                // Vehicle Icon
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xFFE0E0E0),
                                  child: Icon(
                                    vehicle.type == 'motorcycle'
                                        ? Icons.two_wheeler
                                        : Icons.directions_car,
                                    size: 28,
                                    color: Colors.black54,
                                  ),
                                ),

                                SizedBox(width: 16),

                                // Vehicle Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle.code,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'MS. Berlaku Pajak',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '${vehicle.taxStartDate ?? 'N/A'} - ${vehicle.taxEndDate ?? 'N/A'}',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tgl. Akhir STNK',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                vehicle.stnkEndDate ?? 'N/A',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Chevron icon
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                ),
                              ],
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