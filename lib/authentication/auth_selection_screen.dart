import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'register_selection_screen.dart';

import 'login_screen.dart';

class AuthSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ambil tinggi layar
            final screenHeight = constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05), // lebih responsif

                  // Logo Section
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.05),
                      child: Image.asset(
                        'assets/images/sihemat_logo.png',
                        width: screenHeight * 0.28,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Cara Login',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Card 1
                  _buildLoginCard(
                    context: context,
                    title: 'Login Sebagai\nPengguna (Individu)',
                    backgroundColor: Colors.blue[500]!,
                    icon: Icons.person,
                    characterImage: 'assets/images/individual.png',
                    backgroundImage: 'assets/images/laptop_desk.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(role: "pengguna"),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Card 2
                  _buildLoginCard(
                    context: context,
                    title: 'Login Sebagai\nKorporasi (Pemilik/\nPerusahaan)',
                    backgroundColor: Colors.red[400]!,
                    icon: Icons.group,
                    characterImage: 'assets/images/corporate_group.png',
                    backgroundImage: 'assets/images/office_background.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(role: "korporasi"),
                        ),
                      );
                    },
                  ),

                  Spacer(),

                  // Bottom Section
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterSelection(),
                        ),
                      );
                    },
                    child: Text(
                      'Belum Punya Akun ?',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: screenHeight * 0.018,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(role: "guest"),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.account_circle_outlined,
                            color: Colors.grey[600],
                            size: screenHeight * 0.025),
                        SizedBox(width: screenHeight * 0.01),
                        Text(
                          'Mode Guest',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: screenHeight * 0.018,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginCard({
    required BuildContext context,
    required String title,
    required Color backgroundColor,
    required IconData icon,
    required String characterImage,
    required String backgroundImage,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: _BackgroundPatternPainter(backgroundColor),
                ),
              ),
            ),

            // Background image
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // Content (text + arrow + character)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Text and Arrow
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white.withOpacity(0.9),
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Character image
            Positioned(
              bottom: 0,
              right: 17,
              child: Image.asset(
                characterImage,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[600]),
              const SizedBox(width: 8),
              const Text('Coming Soon'),
            ],
          ),
          content: Text('Fitur $feature akan segera hadir!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue[600]),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom Painter for background pattern
class _BackgroundPatternPainter extends CustomPainter {
  final Color color;

  _BackgroundPatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Draw circles pattern
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      30,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.7),
      20,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.8),
      15,
      paint,
    );

    // Draw diagonal lines
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * 0.6 + i * 10, 0),
        Offset(size.width * 0.8 + i * 10, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}