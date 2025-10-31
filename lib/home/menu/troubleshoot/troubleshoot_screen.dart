import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/menu/troubleshoot/pdf_viewer_screen.dart';
import 'package:sihemat_v3/home/menu/troubleshoot/troubleshoot_item.dart';

class TroubleshootScreen extends StatelessWidget {
  const TroubleshootScreen({super.key});

  // Data troubleshoot dengan PDF URL
  final List<TroubleshootItem> troubleshootItems = const [
    TroubleshootItem(
      id: 'motor_listrik',
      title: 'Troubleshoot Motor Listrik',
      icon: Icons.electric_bike,
      pdfAsset: 'assets/pdf/troubleshoot-motor-listrik.pdf',

      // pdfUrl: 'https://example.com/pdf/troubleshoot-motor-listrik.pdf',
      // Alternatif: gunakan asset lokal
    ),
    TroubleshootItem(
      id: 'motor_bensin',
      title: 'Troubleshoot Motor Bensin',
      icon: Icons.two_wheeler,
      pdfAsset: 'assets/pdf/troubleshoot-motor-bensin.pdf',
      // pdfUrl: 'https://example.com/pdf/troubleshoot-motor-bensin.pdf',
    ),
    TroubleshootItem(
      id: 'mobil_listrik',
      title: 'Troubleshoot Mobil Listrik',
      icon: Icons.electric_car,
      pdfAsset: 'assets/pdf/troubleshoot-mobil-listrik.pdf',

      // pdfUrl: 'https://example.com/pdf/troubleshoot-mobil-listrik.pdf',
    ),
    TroubleshootItem(
      id: 'mobil_bensin',
      title: 'Troubleshoot Mobil Bensin',
      icon: Icons.directions_car,
      pdfAsset: 'assets/pdf/troubleshoot-mobil-bensin.pdf',
      // pdfUrl:
      //     'https://microsite.mitsubishi-motors.co.id/owner-manual/media/file/originals/post/2023/01/16/owners-manual-xpander-23-model-year-rev-1310221.pdf',
    ),
    TroubleshootItem(
      id: 'mobil_hybrid',
      title: 'Troubleshoot Mobil Hybrid',
      icon: Icons.directions_car_filled,
      pdfAsset: 'assets/pdf/troubleshoot-mobil-hybrid.pdf',

      // pdfUrl: 'https://example.com/pdf/troubleshoot-mobil-hybrid.pdf',
    ),
  ];

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
          'Troubleshoot',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: troubleshootItems.length,
        itemBuilder: (context, index) {
          final item = troubleshootItems[index];
          return _buildTroubleshootCard(context, item);
        },
      ),
    );
  }

  Widget _buildTroubleshootCard(BuildContext context, TroubleshootItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFViewerScreen(
                title: item.title,
                pdfUrl: item.pdfUrl,
                pdfAsset: item.pdfAsset,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(item.icon, size: 28, color: Color(0xFFE53935)),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade600, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
