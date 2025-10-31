import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sihemat_v3/home/dashboard_screen.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'auth_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final platNomorController = TextEditingController();
  final verificationCodeController = TextEditingController();

  bool _isLoading = false;
  bool _showVerificationField = false; // Flag untuk tampilkan field verification code

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    platNomorController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email harus diisi";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Format email tidak valid";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Kata sandi harus diisi";
    if (value.length < 6) return "Minimal 6 karakter";
    return null;
  }

  String? _validatePlatNomor(String? value) {
    if (value == null || value.isEmpty) return "Plat nomor harus diisi";
    return null;
  }

  String? _validateVerificationCode(String? value) {
    if (value == null || value.isEmpty) return "Kode verifikasi harus diisi";
    return null;
  }

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi delay network
    await Future.delayed(Duration(milliseconds: 500));

    // Guest login (2 step)
    if (widget.role == "guest") {
      if (!_showVerificationField) {
        // Step 1: Validasi plat nomor
        final platNomor = platNomorController.text.trim();
        final account = AccountRepository.getAccountByPlatNomor(platNomor);

        setState(() => _isLoading = false);

        if (account == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Plat nomor tidak terdaftar"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Plat nomor valid, tampilkan field verification code
        setState(() {
          _showVerificationField = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Plat nomor ditemukan! Masukkan kode verifikasi"),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      } else {
        // Step 2: Validasi verification code
        final platNomor = platNomorController.text.trim();
        final verificationCode = verificationCodeController.text.trim();
        
        final account = AccountRepository.guestLogin(platNomor, verificationCode);

        setState(() => _isLoading = false);

        if (account == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Kode verifikasi salah"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        // Login berhasil sebagai guest
        SessionManager.loginAsGuest(account);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login berhasil sebagai Guest - Plat ${account.platNomor}"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        return;
      }
    }

    // Login untuk pengguna & korporasi
    final account = AccountRepository.login(
      emailController.text.trim(),
      passwordController.text,
    );

    setState(() => _isLoading = false);

    if (account == null) {
      // Login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email atau password salah"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Cek apakah role sesuai
    if (account.role != widget.role) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Akun ini terdaftar sebagai ${account.role}, "
            "silakan login melalui halaman login ${account.role}"
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // Login berhasil - Simpan ke session
    SessionManager.login(account);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login berhasil! Selamat datang ${account.fullName}"),
        backgroundColor: Colors.green,
      ),
    );

    // Navigasi ke dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.05),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/images/sihemat_logo.png',
                    width: screenHeight * 0.28,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Title
                Text(
                  widget.role == "pengguna"
                      ? "Login Pengguna"
                      : widget.role == "korporasi"
                          ? "Login Korporasi"
                          : "Login Guest",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Field sesuai role
                if (widget.role == "pengguna" || widget.role == "korporasi") ...[
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Anda",
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Kata Sandi",
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  SizedBox(height: 16),
                ],

                // Guest Login Flow
                if (widget.role == "guest") ...[
                  // Step 1: Plat Nomor
                  TextFormField(
                    controller: platNomorController,
                    enabled: !_showVerificationField, // Disable setelah valid
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "Plat Nomor (contoh: D 1234 AB)",
                      prefixIcon: Icon(Icons.directions_car),
                      filled: true,
                      fillColor: _showVerificationField 
                          ? Colors.grey.shade200 
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: _showVerificationField
                          ? Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                    validator: _validatePlatNomor,
                  ),
                  SizedBox(height: 16),

                  // Step 2: Verification Code (muncul setelah plat valid)
                  if (_showVerificationField) ...[
                    TextFormField(
                      controller: verificationCodeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: "Kode Verifikasi",
                        prefixIcon: Icon(Icons.vpn_key),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: _validateVerificationCode,
                    ),
                    SizedBox(height: 16),
                  ],
                ],

                // Helper text untuk demo
                if (widget.role != "guest") ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akun Demo ${widget.role == 'pengguna' ? 'Pengguna' : 'Korporasi'}:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        if (widget.role == "pengguna") ...[
                          Text(
                            "• budi.santoso@gmail.com / budi123\n"
                            "• siti.nurhaliza@gmail.com / siti456",
                            style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                          ),
                        ] else ...[
                          Text(
                            "• admin@pertamina.co.id / pertamina123\n"
                            "• contact@shellindo.com / shell456",
                            style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                // Helper text untuk guest
                if (widget.role == "guest" && !_showVerificationField) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Akun Demo Guest:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Plat: D 1234 AB | Kode: BUDI2025\n"
                          "Plat: D 5678 CD | Kode: SITI2025",
                          style: TextStyle(fontSize: 11, color: Colors.orange.shade800),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                // Tombol untuk kembali jika sudah tampil verification field
                if (widget.role == "guest" && _showVerificationField) ...[
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showVerificationField = false;
                        verificationCodeController.clear();
                      });
                    },
                    icon: Icon(Icons.arrow_back, size: 16),
                    label: Text("Ubah Plat Nomor"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 8),
                ],

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.role == "guest" && !_showVerificationField
                                ? "Lanjutkan"
                                : "Login",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

                Spacer(),

                // Pilihan Login
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthSelectionScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Pilihan Login",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenHeight * 0.018,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}