import 'package:flutter/material.dart';
import 'package:sihemat_v3/home/account/account_screen.dart';
import 'package:sihemat_v3/home/menu/bantuan_screen.dart';
import 'package:sihemat_v3/home/menu/cek_kendaraan/cek_kendaraan_navigator.dart';
import 'package:sihemat_v3/home/menu/cek_pajak/cek_pajak_screen.dart';
import 'package:sihemat_v3/home/menu/speedometer/speedometer_navigator.dart';
import 'package:sihemat_v3/home/menu/tambah_unit_screen.dart';
import 'package:sihemat_v3/home/menu/troubleshoot/troubleshoot_screen.dart';
import 'package:sihemat_v3/home/track/track_screen.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import '../models/menu_item.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

final List<String> newsImages = [
  'assets/images/news1.png',
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int? _selectedMenuIndex;

  final List<MenuItem> menuItems = [
    MenuItem(
      id: 'vehicle',
      assetPath: 'assets/images/tambah_unit.png',
      label: 'Tambah Unit',
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    MenuItem(
      id: 'maintenance',
      assetPath: 'assets/images/cek_kendaraan.png',
      label: 'Cek Kendaraan',
      color: Colors.white,
    ),
    MenuItem(
      id: 'speedometer',
      assetPath: 'assets/images/speedometer.png',
      label: 'Speedometer',
      color: Colors.white,
    ),
    MenuItem(
      id: 'reports',
      assetPath: 'assets/images/cek_pajak.png',
      label: 'Cek Pajak',
      color: Colors.white,
    ),
    MenuItem(
      id: 'troubleshoot',
      assetPath: 'assets/images/toubleshoot.png',
      label: 'Troubleshoot',
      color: Colors.white,
    ),
    MenuItem(
      id: 'bantuan',
      assetPath: 'assets/images/bantuan.png',
      label: 'Bantuan',
      color: Colors.white,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Get user name from session
  String _getUserName() {
    final account = SessionManager.currentAccount;
    if (account == null) return 'Pengguna';
    
    if (account.role == 'korporasi') {
      return account.companyName ?? 'Korporasi';
    } else {
      return account.firstName ?? 'Pengguna';
    }
  }

  // Get full greeting text
  String _getGreeting() {
    final account = SessionManager.currentAccount;
    if (account == null) return 'Pengguna';
    
    if (account.role == 'korporasi') {
      return account.companyName ?? 'Korporasi';
    } else {
      return '${account.firstName} ${account.lastName}';
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // Brand Banner
        Padding(
          padding: const EdgeInsets.all(10),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 170,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 6),
              enlargeCenterPage: true,
              viewportFraction: 0.9,
            ),
            items: List.generate(4, (index) {
              if (index < newsImages.length) {
                // Slide berita
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      newsImages[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                );
              } else {
                // Slide placeholder
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Tidak ada berita terkini",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ),

        // Profile + Menu
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // User Profile
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: SessionManager.currentAccount?.role == 'korporasi' 
                            ? Colors.orange 
                            : Colors.blue,
                        child: Icon(
                          SessionManager.currentAccount?.role == 'korporasi'
                              ? Icons.business
                              : Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo,',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.fullscreen),
                        onPressed: () {},
                        color: Colors.grey.shade400,
                        iconSize: 32,
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: Colors.grey.shade300),

                // Menu Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return GestureDetector(
                          onTapDown: (_) {
                            setState(() {
                              _selectedMenuIndex = index;
                            });
                          },
                          onTapUp: (_) {
                            setState(() {
                              _selectedMenuIndex = null;
                            });

                            // Handle navigation based on menu ID
                            switch (item.id) {
                              case 'vehicle':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TambahUnitScreen(),
                                  ),
                                );
                                break;
                              
                              case 'maintenance':
                                // Menggunakan CekKendaraanNavigator
                                // Otomatis akan ke list (korporasi) atau detail (pengguna)
                                CekKendaraanNavigator.navigate(context);
                                break;
                              
                              case 'speedometer':
                                SpeedometerNavigator.navigate(context);
                                break;
                              
                              case 'reports':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CekPajakScreen(),
                                  ),
                                );
                                break;
                              
                              case 'troubleshoot':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TroubleshootScreen(),
                                  ),
                                );
                                break;
                              
                              case 'bantuan':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BantuanScreen(),
                                  ),
                                );
                                break;
                              
                              default:
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Scaffold(
                                      body: Center(
                                        child: Text("Halaman belum tersedia"),
                                      ),
                                    ),
                                  ),
                                );
                            }
                          },
                          onTapCancel: () {
                            setState(() {
                              _selectedMenuIndex = null;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: _selectedMenuIndex == index
                                      ? Colors.grey.shade200
                                      : item.color,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: _selectedMenuIndex == index
                                        ? Colors.grey.shade200
                                        : Colors.grey.shade400,
                                    width: _selectedMenuIndex == index ? 3 : 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: item.assetPath != null
                                      ? Image.asset(
                                          item.assetPath!,
                                          fit: BoxFit.contain,
                                        )
                                      : Icon(
                                          item.icon,
                                          size: 32,
                                          color: item.color,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Material(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.2),
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/sihemat_logo.png',
                    height: 40,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                        color: Colors.grey.shade600,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () {},
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Content dengan IndexedStack
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeContent(),
                const TrackScreen(),
                const AccountScreen(),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Track',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.grey.shade400,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}