import 'package:flutter/material.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/utils/session_manager.dart';

class CekPajakDetailPage extends StatelessWidget {
  final Vehicle vehicle;

  CekPajakDetailPage({required this.vehicle});

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    // Get owner info
    final owner = AccountRepository.getVehicleOwner(vehicle.id);
    final currentUser = SessionManager.currentAccount;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Code
              Text(
                vehicle.code,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              // Owner Info (jika pengguna)
              if (currentUser?.role == 'pengguna' && owner != null) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.business, size: 16, color: Colors.orange.shade700),
                      SizedBox(width: 8),
                      Text(
                        'Pemilik: ${owner.fullName}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24),

              // Informasi Kendaraan
              _buildSection(
                title: 'Informasi Kendaraan',
                children: [
                  _buildInfoRow(
                    leftLabel: 'Nomor Polisi',
                    leftValue: vehicle.plate,
                    rightLabel: 'Warna KB',
                    rightValue: vehicle.color ?? 'N/A',
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow(
                    leftLabel: 'Merk',
                    leftValue: vehicle.brand ?? 'N/A',
                    rightLabel: 'Model',
                    rightValue: vehicle.model ?? 'N/A',
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Informasi Pajak dan PNBP
              _buildSection(
                title: 'Informasi Pajak dan PNBP',
                children: [
                  _buildInfoRow(
                    leftLabel: 'MS. Berlaku Pajak',
                    leftValue:
                        '${vehicle.taxStartDate ?? 'N/A'} - ${vehicle.taxEndDate ?? 'N/A'}',
                    rightLabel: 'Tgl. Akhir STNK',
                    rightValue: vehicle.stnkEndDate ?? 'N/A',
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Informasi Biaya
              _buildSection(
                title: 'Informasi Biaya',
                children: [
                  _buildBiayaRow('Pajak Kendaraan', 'Rp',
                      _formatCurrency(vehicle.pajakKendaraan ?? 0)),
                  _buildBiayaRow(
                      'SWDKLLJ', 'Rp', _formatCurrency(vehicle.swdkllj ?? 0)),
                  _buildBiayaRow('PNBP STNK', 'Rp',
                      _formatCurrency(vehicle.pnbpStnk ?? 0)),
                  _buildBiayaRow('PNBP TNKB', 'Rp',
                      _formatCurrency(vehicle.pnbpTnkb ?? 0)),
                  _buildBiayaRow('Admin STNK', 'Rp',
                      _formatCurrency(vehicle.adminStnk ?? 0)),
                  _buildBiayaRow('Admin TNKB', 'Rp',
                      _formatCurrency(vehicle.adminTnkb ?? 0)),
                  _buildBiayaRow('Penerbitan', 'Rp',
                      _formatCurrency(vehicle.penerbitan ?? 0)),
                  Divider(thickness: 2, color: Colors.grey.shade300),
                  SizedBox(height: 8),
                  _buildBiayaRow(
                      'TOTAL', 'Rp', _formatCurrency(vehicle.totalPajak),
                      isTotal: true),
                ],
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black87, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String leftLabel,
    required String leftValue,
    String? rightLabel,
    String? rightValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leftLabel,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                leftValue,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        if (rightLabel != null && rightValue != null) ...[
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rightLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  rightValue,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBiayaRow(String label, String currency, String amount,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTotal ? 0 : 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            ': $currency',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          SizedBox(width: 16),
          SizedBox(
            width: 90,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}