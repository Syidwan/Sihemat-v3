import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BantuanScreen extends StatefulWidget {
  const BantuanScreen({super.key});

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {
  int _expandedIndex = -1;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara melacak kendaraan saya?',
      'answer': 'Untuk melacak kendaraan, buka menu "Lacak" dari dashboard atau pilih kendaraan dari daftar. Lokasi kendaraan akan ditampilkan pada peta secara real-time.',
    },
    {
      'question': 'Bagaimana cara menambah unit kendaraan baru?',
      'answer': 'Buka menu "Tambah Unit" dari dashboard, lalu isi formulir dengan data kendaraan dan nomor IMEI perangkat GPS. Setelah terverifikasi, kendaraan akan muncul di daftar.',
    },
    {
      'question': 'Apa itu fitur Playback?',
      'answer': 'Fitur Playback memungkinkan Anda melihat riwayat perjalanan kendaraan. Anda dapat memutar ulang rute yang telah dilalui lengkap dengan informasi waktu dan kecepatan.',
    },
    {
      'question': 'Bagaimana cara melihat info pajak kendaraan?',
      'answer': 'Buka menu "Cek Pajak" untuk melihat informasi pajak kendaraan termasuk tanggal jatuh tempo dan rincian biaya yang harus dibayar.',
    },
    {
      'question': 'Kenapa kendaraan saya menunjukkan status offline?',
      'answer': 'Status offline berarti perangkat GPS tidak mengirim data. Hal ini bisa terjadi karena: kendaraan di area tanpa sinyal, baterai perangkat habis, atau perangkat mengalami gangguan teknis.',
    },
    {
      'question': 'Bagaimana cara mengatur notifikasi?',
      'answer': 'Buka Akun > Notifikasi untuk mengatur jenis notifikasi yang ingin diterima seperti peringatan kecepatan, geofence, atau pengingat perawatan.',
    },
    {
      'question': 'Apa itu Mode Guest?',
      'answer': 'Mode Guest memungkinkan akses terbatas menggunakan plat nomor dan kode verifikasi. Fitur ini berguna untuk melihat lokasi kendaraan tanpa login penuh.',
    },
    {
      'question': 'Bagaimana cara mengexport laporan?',
      'answer': 'Buka menu Laporan, pilih periode yang diinginkan, lalu tekan tombol "Export". Laporan tersedia dalam format PDF dan Excel.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        title: const Text('Pusat Bantuan'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with search
            Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFFE53935),
              child: Column(
                children: [
                  const Icon(Icons.help_outline, size: 60, color: Colors.white),
                  const SizedBox(height: 16),
                  const Text(
                    'Ada yang bisa kami bantu?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari pertanyaan...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ],
              ),
            ),

            // Quick actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: _buildQuickAction(Icons.phone, 'Telepon', Colors.green, () => _launchPhone())),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickAction(Icons.email, 'Email', Colors.blue, () => _launchEmail())),
                  const SizedBox(width: 12),
                  Expanded(child: _buildQuickAction(Icons.chat, 'Chat', Colors.orange, () => _showChatDialog())),
                ],
              ),
            ),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Pertanyaan Umum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
            ),

            // FAQ List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _faqs.length,
              itemBuilder: (context, index) {
                final faq = _faqs[index];
                final isExpanded = _expandedIndex == index;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? -1 : index;
                          });
                        },
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.help_outline, color: Color(0xFFE53935), size: 20),
                        ),
                        title: Text(
                          faq['question']!,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        trailing: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                      if (isExpanded)
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            faq['answer']!,
                            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            // Guide Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Panduan Penggunaan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildGuideCard(Icons.play_circle_outline, 'Video Tutorial', 'Pelajari cara menggunakan aplikasi'),
                  _buildGuideCard(Icons.menu_book, 'User Manual', 'Baca panduan lengkap (PDF)'),
                  _buildGuideCard(Icons.tips_and_updates, 'Tips & Trik', 'Maksimalkan penggunaan aplikasi'),
                ],
              ),
            ),

            // Contact card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFE53935), const Color(0xFFEF5350)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent, size: 48, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Butuh bantuan lebih?', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Tim support kami siap membantu 24/7', style: TextStyle(color: Colors.white.withOpacity(0.9))),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _launchPhone(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFE53935),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Hubungi'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Membuka $title...')),
          );
        },
      ),
    );
  }

  void _launchPhone() async {
    final Uri url = Uri.parse('tel:08001234567');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi telepon')),
      );
    }
  }

  void _launchEmail() async {
    final Uri url = Uri.parse('mailto:support@sihemat.co.id?subject=Bantuan%20SiHemat');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka aplikasi email')),
      );
    }
  }

  void _showChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.chat, color: Colors.orange),
            SizedBox(width: 8),
            Text('Live Chat'),
          ],
        ),
        content: const Text('Fitur live chat akan segera tersedia. Untuk sementara, silakan hubungi kami via telepon atau email.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}