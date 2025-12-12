import 'package:flutter/material.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Minggu Ini';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Laporan'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Perjalanan'),
            Tab(text: 'Konsumsi BBM'),
            Tab(text: 'Perawatan'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today),
            onSelected: (val) => setState(() => _selectedPeriod = val),
            itemBuilder: (context) => [
              'Hari Ini',
              'Minggu Ini',
              'Bulan Ini',
              '3 Bulan Terakhir',
            ].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Period indicator
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.date_range, size: 18, color: Color(0xFFE53935)),
                const SizedBox(width: 8),
                Text(
                  'Periode: $_selectedPeriod',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTripReport(),
                _buildFuelReport(),
                _buildMaintenanceReport(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showExportDialog(),
        backgroundColor: const Color(0xFFE53935),
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text('Export', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildTripReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Total Jarak', '245.5 km', Icons.route, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Total Trip', '23', Icons.flag, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Durasi', '12j 35m', Icons.timer, Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Rata-rata', '35 km/h', Icons.speed, Colors.purple)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Chart placeholder
          _buildChartCard('Jarak Perjalanan Harian', _buildBarChart()),
          
          const SizedBox(height: 16),
          
          // Trip list
          _buildSectionTitle('Riwayat Perjalanan'),
          ...List.generate(5, (i) => _buildTripItem(i)),
        ],
      ),
    );
  }

  Widget _buildFuelReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Total BBM', '85.5 L', Icons.local_gas_station, Colors.amber)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Biaya', 'Rp 855.000', Icons.payments, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Konsumsi', '12.5 km/L', Icons.eco, Colors.teal)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Pengisian', '8x', Icons.ev_station, Colors.blue)),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildChartCard('Konsumsi BBM Mingguan', _buildLineChart()),
          
          const SizedBox(height: 16),
          _buildSectionTitle('Riwayat Pengisian'),
          ...List.generate(4, (i) => _buildFuelItem(i)),
        ],
      ),
    );
  }

  Widget _buildMaintenanceReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryCard('Total Biaya', 'Rp 1.2 Jt', Icons.account_balance_wallet, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildSummaryCard('Service', '3x', Icons.build, Colors.indigo)),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Upcoming maintenance
          _buildSectionTitle('Perawatan Mendatang'),
          _buildMaintenanceCard('Ganti Oli', '15 Des 2025', Colors.orange, true),
          _buildMaintenanceCard('Service Berkala', '20 Jan 2026', Colors.blue, false),
          
          const SizedBox(height: 16),
          
          _buildSectionTitle('Riwayat Perawatan'),
          ...List.generate(3, (i) => _buildMaintenanceHistoryItem(i)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          chart,
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'].asMap().entries.map((e) {
          final heights = [0.4, 0.6, 0.8, 0.5, 0.9, 0.3, 0.7];
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                height: 100 * heights[e.key],
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.7 + e.key * 0.03),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Text(e.value, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLineChart() {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        size: const Size(double.infinity, 130),
        painter: _LineChartPainter(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTripItem(int index) {
    final dates = ['12 Des', '11 Des', '10 Des', '9 Des', '8 Des'];
    final distances = ['45.2 km', '32.1 km', '28.5 km', '55.0 km', '40.3 km'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.route, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dates[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('3 perjalanan', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(distances[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFuelItem(int index) {
    final locations = ['SPBU Sukajadi', 'SPBU Dago', 'SPBU Pasteur', 'SPBU Setiabudi'];
    final amounts = ['15 L', '20 L', '25 L', '18 L'];
    final costs = ['Rp 150.000', 'Rp 200.000', 'Rp 250.000', 'Rp 180.000'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.local_gas_station, color: Colors.amber, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locations[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(amounts[index], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(costs[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard(String title, String date, Color color, bool urgent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: urgent ? Border.all(color: Colors.orange, width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.build, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          if (urgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
              child: const Text('Segera', style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceHistoryItem(int index) {
    final items = ['Ganti Oli', 'Service Berkala', 'Ganti Ban'];
    final dates = ['1 Nov 2025', '15 Sep 2025', '20 Aug 2025'];
    final costs = ['Rp 250.000', 'Rp 500.000', 'Rp 450.000'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(items[index], style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(dates[index], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Text(costs[index], style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export PDF'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Laporan PDF berhasil diunduh')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export Excel'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Laporan Excel berhasil diunduh')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.5];
    
    for (int i = 0; i < points.length; i++) {
      final x = i * (size.width / (points.length - 1));
      final y = size.height - (points[i] * size.height);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw dots
    final dotPaint = Paint()..color = const Color(0xFFE53935);
    for (int i = 0; i < points.length; i++) {
      final x = i * (size.width / (points.length - 1));
      final y = size.height - (points[i] * size.height);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
