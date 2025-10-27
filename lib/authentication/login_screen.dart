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

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    platNomorController.dispose();
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

  void _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi delay network
    await Future.delayed(Duration(milliseconds: 500));

    // Guest login (tanpa autentikasi)
    if (widget.role == "guest") {
      SessionManager.userRole = "guest";
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login berhasil sebagai Guest"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
      return;
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

                if (widget.role == "pengguna" || widget.role == "guest") ...[
                  TextFormField(
                    controller: platNomorController,
                    decoration: InputDecoration(
                      hintText: "Plat Nomor",
                      prefixIcon: Icon(Icons.confirmation_num),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePlatNomor,
                  ),
                  SizedBox(height: 16),
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
                            "Login",
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