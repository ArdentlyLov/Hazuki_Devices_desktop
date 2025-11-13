// ================================
// 🏠 主页框架
// ================================
import 'package:flutter/material.dart';
import '../models/app_page.dart'; // ✅ 正确导入
import '../widgets/sliding_card.dart'; // ✅ 正确导入
import 'device_page.dart'; // ✅ 正确导入
import 'friends_page.dart'; // ✅ 正确导入
import 'profile_page.dart'; // ✅ 正确导入

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  AppPage _currentPage = AppPage.device;
  double _cardPosition = 0.5;
  
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = AppPage.values[index];
    });
  }
  
  void _onCardPositionChanged(double position) {
    setState(() {
      _cardPosition = position;
    });
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  Widget _buildCurrentPage() {
    switch (_currentPage) {
      case AppPage.device:
        return DevicePage(onItemTap: _showSnackBar);
      case AppPage.friends:
        return FriendsPage(onItemTap: _showSnackBar);
      case AppPage.profile:
        return ProfilePage(onItemTap: _showSnackBar);
    }
  }
  
  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade100,
            Colors.purple.shade50,
          ],
        ),
      ),
    );
  }
  
  PreferredSizeWidget _buildCustomAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        margin: const EdgeInsets.all(16),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () => _showSnackBar('搜索功能'),
                tooltip: '搜索',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => _showSnackBar('通知功能'),
                tooltip: '通知',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildCustomAppBar(),
      body: Stack(
        children: [
          _buildBackground(),
          SlidingCard(
            initialPosition: _cardPosition,
            onPositionChanged: _onCardPositionChanged,
            child: _buildCurrentPage(),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: NavigationBar(
          height: 70,
          indicatorColor: Colors.blue.shade100,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.device_hub),
              selectedIcon: Icon(Icons.device_hub, color: Colors.blue),
              label: '设备',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(Icons.person, color: Colors.blue),
              label: '好友',
            ),
            NavigationDestination(
              icon: Icon(Icons.my_library_add),
              selectedIcon: Icon(Icons.my_library_add, color: Colors.blue),
              label: '我的',
            )
          ],
          selectedIndex: AppPage.values.indexOf(_currentPage),
          onDestinationSelected: _onPageChanged,
        ),
      )
    );
  }
}
