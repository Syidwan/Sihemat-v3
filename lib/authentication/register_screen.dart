import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sihemat_v3/home/dashboard_screen.dart';
import 'package:sihemat_v3/models/account.dart';
import 'package:sihemat_v3/models/repositories/account_repository.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'register_selection_screen.dart';

class RegisterPage extends StatefulWidget {
  final String role;
  const RegisterPage({super.key, required this.role});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final platNomorController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    platNomorController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return "$fieldName harus diisi";
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email harus diisi";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Format email tidak valid";
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password harus diisi";
    if (value.length < 6) return "Minimal 6 karakter";
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);
    if (!hasLetter || !hasNumber) {
      return "Password harus berisi huruf dan angka";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Konfirmasi password harus diisi";
    }
    if (value != passwordController.text) return "Password tidak cocok";
    return null;
  }

  void _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi delay network
    await Future.delayed(Duration(milliseconds: 500));

    // Cek apakah email sudah terdaftar
    if (AccountRepository.isEmailRegistered(emailController.text.trim())) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email sudah terdaftar, silakan gunakan email lain"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Generate ID baru
    final accountId = widget.role == 'pengguna' 
        ? 'USR${DateTime.now().millisecondsSinceEpoch}'
        : 'CORP${DateTime.now().millisecondsSinceEpoch}';

    // Buat account baru
    final newAccount = Account(
      id: accountId,
      role: widget.role,
      email: emailController.text.trim(),
      password: passwordController.text,
      firstName: widget.role == 'pengguna' ? firstNameController.text.trim() : null,
      lastName: widget.role == 'pengguna' ? lastNameController.text.trim() : null,
      phone: widget.role == 'pengguna' ? phoneController.text.trim() : null,
      platNomor: widget.role == 'pengguna' ? platNomorController.text.trim() : null,
      companyName: widget.role == 'korporasi' ? companyNameController.text.trim() : null,
    );

    // Register ke repository
    final success = AccountRepository.register(newAccount);

    setState(() => _isLoading = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registrasi gagal, silakan coba lagi"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Registrasi berhasil - Langsung login
    SessionManager.login(newAccount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Registrasi berhasil! Selamat datang ${newAccount.fullName}"),
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
            child: ListView(
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  widget.role == "pengguna"
                      ? "Registrasi Pengguna"
                      : "Registrasi Korporasi",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                
                if (widget.role == "pengguna") ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            hintText: "Nama Depan",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => _validateNotEmpty(v, "Nama Depan"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: "Nama Belakang",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => _validateNotEmpty(v, "Nama Belakang"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Nomor Telepon",
                      prefixIcon: const Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => _validateNotEmpty(v, "Nomor Telepon"),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: platNomorController,
                    decoration: InputDecoration(
                      hintText: "Plat Nomor",
                      prefixIcon: const Icon(Icons.confirmation_num),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => _validateNotEmpty(v, "Plat Nomor"),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Konfirmasi Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ],
                
                if (widget.role == "korporasi") ...[
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(
                      hintText: "Nama Perusahaan",
                      prefixIcon: const Icon(Icons.business),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) => _validateNotEmpty(v, "Nama Perusahaan"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Konfirmasi Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ],
                
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onRegisterPressed,
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
                        : const Text(
                            "Register",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterSelection(),
                      ),
                    );
                  },
                  child: Text(
                    "Kembali ke Pilihan Registrasi",
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