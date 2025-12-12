import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

class DaftarPage extends StatefulWidget {
  final Function(int) onVehicleSelected;

  const DaftarPage({super.key, required this.onVehicleSelected});

  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
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

  void _handleDelete(int id) {
    final vehicle = VehicleRepository.getVehicleById(id);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Hapus Kendaraan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin menghapus kendaraan ini?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    vehicle?.type == 'motorcycle' ? Icons.two_wheeler : Icons.directions_car,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle?.code ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(vehicle?.plate ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final deleted = VehicleRepository.deleteVehicle(id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(deleted ? 'Kendaraan berhasil dihapus' : 'Gagal menghapus kendaraan'),
                  backgroundColor: deleted ? Colors.green : Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleInfo(int id) {
    final vehicle = VehicleRepository.getVehicleById(id);
    if (vehicle == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      vehicle.type == 'motorcycle' ? Icons.two_wheeler : Icons.directions_car,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(vehicle.code, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(vehicle.plate, style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(vehicle.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      vehicle.status[0].toUpperCase() + vehicle.status.substring(1),
                      style: TextStyle(color: _getStatusColor(vehicle.status), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              
              // Vehicle Info
              _buildInfoSection('Informasi Kendaraan', [
                _buildInfoRow('Merk', vehicle.brand ?? '-'),
                _buildInfoRow('Model', vehicle.model ?? '-'),
                _buildInfoRow('Warna', vehicle.color ?? '-'),
                _buildInfoRow('Tipe', vehicle.type == 'motorcycle' ? 'Motor' : 'Mobil'),
              ]),
              
              const SizedBox(height: 16),
              
              // Statistics
              _buildInfoSection('Statistik', [
                _buildInfoRow('Total Kilometer', '${vehicle.totalKm} km'),
                _buildInfoRow('Kilometer Hari Ini', '${vehicle.todayKm} km'),
              ]),
              
              const SizedBox(height: 16),
              
              // Tax Info
              _buildInfoSection('Informasi Pajak', [
                _buildInfoRow('Pajak Mulai', vehicle.taxStartDate ?? '-'),
                _buildInfoRow('Pajak Berakhir', vehicle.taxEndDate ?? '-'),
                _buildInfoRow('STNK Berakhir', vehicle.stnkEndDate ?? '-'),
              ]),
              
              const SizedBox(height: 16),
              
              // Location
              if (vehicle.address != null)
                _buildInfoSection('Lokasi Terakhir', [
                  _buildInfoRow('Alamat', vehicle.address!),
                  _buildInfoRow('Koordinat', '${vehicle.latitude}, ${vehicle.longitude}'),
                ]),
              
              const SizedBox(height: 24),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Tutup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        // Filter Tabs
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: ['semua', 'online', 'offline', 'expired'].map((filter) {
              final isActive = _activeFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
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
                  backgroundColor: const Color(0xFFF5F5F5),
                  selectedColor: Colors.white,
                  side: BorderSide(
                    color: isActive ? Colors.grey.shade300 : Colors.transparent,
                    width: isActive ? 2 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        // Vehicle Count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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

        const SizedBox(height: 8),

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
                      onTap: () => widget.onVehicleSelected(vehicle.id),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFFE0E0E0),
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
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.speed,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${vehicle.totalKm}km',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${vehicle.todayKm}km',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    vehicle.plate,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 12),
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
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'info') {
                                _handleInfo(vehicle.id);
                              } else if (value == 'delete') {
                                _handleDelete(vehicle.id);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'info',
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text('Info'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline,
                                        size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete',
                                        style: TextStyle(color: Colors.red)),
                                  ],
                                ),
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}