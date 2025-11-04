import 'package:flutter/material.dart';
import 'package:sihemat_v3/components/menu_grid_widget.dart';
import 'package:sihemat_v3/components/news_carousel_widget.dart';
import 'package:sihemat_v3/components/user_profile_widget.dart';
import 'package:sihemat_v3/home/account/account_screen.dart';
import 'package:sihemat_v3/home/menu/bantuan_screen.dart';
import 'package:sihemat_v3/home/menu/cek_kendaraan/cek_kendaraan_navigator.dart';
import 'package:sihemat_v3/home/menu/cek_pajak/cek_pajak_screen.dart';
import 'package:sihemat_v3/home/menu/speedometer/speedometer_navigator.dart';
import 'package:sihemat_v3/home/menu/tambah_unit_screen.dart';
import 'package:sihemat_v3/home/menu/troubleshoot/troubleshoot_screen.dart';
import 'package:sihemat_v3/home/notification_screen.dart';
import 'package:sihemat_v3/home/track/track_screen.dart';
import 'package:sihemat_v3/home/track/peta_page_google.dart';
import 'package:sihemat_v3/utils/news_data.dart';
import 'package:sihemat_v3/utils/session_manager.dart';
import 'package:sihemat_v3/models/repositories/vehicle_repository.dart';
import 'package:sihemat_v3/models/menu_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isMapPreloaded = false;

  // Menu items yang akan difilter berdasarkan role dan guest mode
  List<MenuItem> get menuItems {
    final currentAccount = SessionManager.currentAccount;
    final isGuest = SessionManager.isGuestMode;

    final allMenus = [
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

    // Filter menu berdasarkan role dan guest mode
    if (isGuest || currentAccount?.role == 'pengguna') {
      return allMenus.where((menu) => menu.id != 'vehicle').toList();
    }

    return allMenus;
  }

  @override
  void initState() {
    super.initState();
    _preloadMap();
  }

  Future<void> _preloadMap() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isMapPreloaded = true;
      });
    }
  }

  int _getInitialVehicleId() {
    final currentAccount = SessionManager.currentAccount;

    if (currentAccount != null) {
      if (currentAccount.role == 'korporasi') {
        final vehicles = VehicleRepository.getVehiclesByOwnerId(
          currentAccount.id,
        );
        if (vehicles.isNotEmpty) {
          return vehicles.first.id;
        }
      } else if (currentAccount.role == 'pengguna' &&
          currentAccount.assignedVehicleId != null) {
        return currentAccount.assignedVehicleId!;
      }
    }

    final allVehicles = VehicleRepository.getAllVehicles();
    return allVehicles.isNotEmpty ? allVehicles.first.id : 1;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getGreeting() {
    final account = SessionManager.currentAccount;
    final isGuest = SessionManager.isGuestMode;

    if (account == null) return 'Pengguna';

    if (isGuest) {
      return 'Mode Guest';
    }

    if (account.role == 'korporasi') {
      return account.companyName ?? 'Korporasi';
    } else {
      return '${account.firstName} ${account.lastName}';
    }
  }

  void _handleMenuTap(String menuId) {
    switch (menuId) {
      case 'vehicle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TambahUnitScreen()),
        );
        break;

      case 'maintenance':
        CekKendaraanNavigator.navigate(context);
        break;

      case 'speedometer':
        SpeedometerNavigator.navigate(context);
        break;

      case 'reports':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CekPajakScreen()),
        );
        break;

      case 'troubleshoot':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TroubleshootScreen()),
        );
        break;

      case 'bantuan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BantuanScreen()),
        );
        break;

      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text("Halaman belum tersedia")),
            ),
          ),
        );
    }
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // News Carousel
        NewsCarouselWidget(newsItems: NewsData.getNewsItems()),

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
                UserProfileWidget(
                  isGuestMode: SessionManager.isGuestMode,
                  userRole: SessionManager.currentAccount?.role,
                  greetingText: _getGreeting(),
                  onFullscreenTapped: () {
                    // Implementasi fullscreen jika diperlukan
                  },
                ),

                Divider(height: 1, color: Colors.grey.shade300),

                // Menu Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: MenuGridWidget(
                      menuItems: menuItems,
                      onMenuTapped: _handleMenuTap,
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
      body: Stack(
        children: [
          // Main Content
          Column(
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
                      Image.asset('assets/images/sihemat_logo.png', height: 40),
                      Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_outlined,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationScreen(),
                                      ),
                                    );
                                  },
                                  color: Colors.grey.shade600,
                                ),
                                // Badge - tampilkan hanya jika ada notifikasi belum dibaca
                                // Uncomment untuk menampilkan badge
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: const Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.settings_outlined),
                          //   onPressed: () {},
                          //   color: Colors.grey.shade600,
                          // ),
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

          // Preload Map di background (hidden)
          if (_isMapPreloaded)
            Positioned(
              left: -10000,
              top: -10000,
              child: SizedBox(
                width: 1,
                height: 1,
                child: Offstage(
                  offstage: true,
                  child: PetaPageGoogle(
                    initialVehicleId: _getInitialVehicleId(),
                  ),
                ),
              ),
            ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Track',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
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
