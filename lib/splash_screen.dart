import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
// import 'dashboard_screen.dart';
import 'authentication/auth_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String selectedProduct; // gambar produk yang dipilih random

  final List<String> productImages = [
    'assets/images/product1.png',
    'assets/images/product2.png',
    'assets/images/product3.png',
  ];

  @override
  void initState() {
    super.initState();

    // pilih gambar produk random
    final random = Random();
    selectedProduct = productImages[random.nextInt(productImages.length)];

    // Timer untuk pindah halaman
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) => AuthSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // dari kanan
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Logo aplikasi (statis)
            Padding(
              padding: const EdgeInsets.only(top: 135),
              child: Center(
                  child: Image.asset(
                  'assets/images/sihemat_logo.png',
                  width: 350,
                  fit: BoxFit.contain,
                ),
              ),
              
            ),

            // 2. Produk (random dari 3 gambar)
            Image.asset(
              selectedProduct,
                width: (selectedProduct.contains("product1") || 
                        selectedProduct.contains("product2"))
                    ? 650
                    : 500,
                fit: BoxFit.contain,
            ),

            // 3. Sponsor (statis)
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/images/sponsor.png',
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
