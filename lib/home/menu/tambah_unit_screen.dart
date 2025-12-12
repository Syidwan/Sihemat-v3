import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sihemat_v3/models/vehicle_model.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
// import 'package:image_picker/image_picker.dart';

class TambahUnitScreen extends StatefulWidget {
  @override
  _TambahUnitScreenState createState() => _TambahUnitScreenState();
}

class _TambahUnitScreenState extends State<TambahUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _namaUnitController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _nomorImeiController = TextEditingController();
  final _nomorRegistrasiController = TextEditingController();
  final _merkController = TextEditingController();
  final _jenisController = TextEditingController();
  final _tipeController = TextEditingController();
  final _tahunRegistrasiController = TextEditingController();
  final _tanggalBayarPajakController = TextEditingController();
  final _nomorRangkaController = TextEditingController();
  final _nomorMesinController = TextEditingController();
  final _nomorBPKBController = TextEditingController();
  
  File? _selectedImage;
  // final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaUnitController.dispose();
    _namaPemilikController.dispose();
    _alamatController.dispose();
    _nomorImeiController.dispose();
    _nomorRegistrasiController.dispose();
    _merkController.dispose();
    _jenisController.dispose();
    _tipeController.dispose();
    _tahunRegistrasiController.dispose();
    _tanggalBayarPajakController.dispose();
    _nomorRangkaController.dispose();
    _nomorMesinController.dispose();
    _nomorBPKBController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    // Uncomment setelah tambahkan image_picker package
    /*
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
    */
    
    // Sementara untuk demo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fitur upload gambar memerlukan image_picker package')),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final currentAccount = SessionManager.currentAccount;
      
      // Create new vehicle with form data
      final newVehicle = Vehicle(
        id: VehicleRepository.getNextId(),
        code: _nomorImeiController.text.toUpperCase(),
        plate: _nomorRegistrasiController.text.toUpperCase(),
        totalKm: 0,
        todayKm: 0,
        status: 'online',
        type: _jenisController.text.toLowerCase().contains('motor') ? 'motorcycle' : 'car',
        latitude: -6.9175,
        longitude: 107.6191,
        address: _alamatController.text,
        ownerId: currentAccount?.id ?? 'CORP001',
        taxStartDate: _tanggalBayarPajakController.text,
        taxEndDate: _calculateNextYear(_tanggalBayarPajakController.text),
        stnkEndDate: _calculateFiveYears(_tanggalBayarPajakController.text),
        color: 'BLACK',
        brand: _merkController.text.toUpperCase(),
        model: _tipeController.text.toUpperCase(),
        pajakKendaraan: 100000,
        swdkllj: 35000,
        pnbpStnk: 66100,
        pnbpTnkb: 0,
        adminStnk: 35000,
        adminTnkb: 0,
        penerbitan: 0,
      );

      final success = VehicleRepository.addVehicle(newVehicle);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unit kendaraan berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Plat nomor sudah terdaftar!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _calculateNextYear(String date) {
    // Simple date calculation for demo
    if (date.isEmpty) return '01/01/2026';
    final parts = date.split('/');
    if (parts.length == 3) {
      final year = int.tryParse(parts[2]) ?? 2025;
      return '${parts[0]}/${parts[1]}/${year + 1}';
    }
    return '01/01/2026';
  }

  String _calculateFiveYears(String date) {
    if (date.isEmpty) return '01/01/2030';
    final parts = date.split('/');
    if (parts.length == 3) {
      final year = int.tryParse(parts[2]) ?? 2025;
      return '${parts[0]}/${parts[1]}/${year + 5}';
    }
    return '01/01/2030';
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
          'Tambah Unit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nama Unit
              _buildTextField(
                controller: _namaUnitController,
                label: 'Nama Unit',
                hint: 'Masukkan nama unit',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama unit tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nama Pemilik
              _buildTextField(
                controller: _namaPemilikController,
                label: 'Nama Pemilik',
                hint: 'Masukkan nama pemilik',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama pemilik tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Alamat
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat',
                hint: 'Masukkan alamat',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nomor Imei
              _buildTextField(
                controller: _nomorImeiController,
                label: 'Nomor Imei',
                hint: 'Masukkan nomor IMEI',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor IMEI tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nomor Registrasi/Plat
              _buildTextField(
                controller: _nomorRegistrasiController,
                label: 'Nomor Registrasi/Plat',
                hint: 'Contoh: D 1234 ABC',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor registrasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Merk
              _buildTextField(
                controller: _merkController,
                label: 'Merk',
                hint: 'Masukkan merk kendaraan',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Merk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Jenis & Tipe (Row)
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _jenisController,
                      label: 'Jenis',
                      hint: 'Motor/Mobil',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Jenis tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _tipeController,
                      label: 'Tipe',
                      hint: 'Tipe kendaraan',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tipe tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Tahun Registrasi
              _buildTextField(
                controller: _tahunRegistrasiController,
                label: 'Tahun Registrasi',
                hint: 'Contoh: 2023',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tahun registrasi tidak boleh kosong';
                  }
                  if (value.length != 4) {
                    return 'Format tahun tidak valid';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Tanggal Bayar Pajak
              _buildTextField(
                controller: _tanggalBayarPajakController,
                label: 'Tanggal Bayar Pajak',
                hint: 'DD/MM/YYYY',
                keyboardType: TextInputType.datetime,
                suffixIcon: Icons.calendar_today,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _tanggalBayarPajakController.text =
                          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal bayar pajak tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nomor Rangka
              _buildTextField(
                controller: _nomorRangkaController,
                label: 'Nomor Rangka',
                hint: 'Masukkan nomor rangka',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor rangka tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nomor Mesin
              _buildTextField(
                controller: _nomorMesinController,
                label: 'Nomor Mesin',
                hint: 'Masukkan nomor mesin',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor mesin tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Nomor BPKB
              _buildTextField(
                controller: _nomorBPKBController,
                label: 'Nomor BPKB',
                hint: 'Masukkan nomor BPKB',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor BPKB tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24),
              
              // Foto Kendaraan
              Text(
                'Foto Kendaraan',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              
              Row(
                children: [
                  // Preview Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                  ),
                  
                  SizedBox(width: 16),
                  
                  // Button Tambahkan Gambar
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.upload, size: 20),
                      label: Text('Tambahkan Gambar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 32),
              
              // Button Simpan
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE53935),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          readOnly: onTap != null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFE53935), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey.shade600)
                : null,
          ),
        ),
      ],
    );
  }
}