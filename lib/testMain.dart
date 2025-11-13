import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  // 初始化窗口管理器
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  // 设置窗口大小
  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 600), // 你想要的窗口大小
    center: true, // 居中显示
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

// ================================
// 📱 应用配置脚本（类似Vue的main.js）
// ================================
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '交互式Hello World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),
      home: const MyHomePage(), // 设置首页
    );
  }
}

// 页面枚举
enum AppPage { device, friends, profile }

// ================================
// 🔧 页面框架脚本（类似Vue的组件声明）
// ================================
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

// ================================
// 🎮 业务逻辑脚本（类似Vue的<script>部分）
// ================================
class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AppPage _currentPage = AppPage.device;
  double _cardPosition = 0.5; // 0.3=最小, 0.5=默认, 0.9=最大
  late AnimationController _animationController;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardAnimation = Tween<double>(begin: 0.5, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = AppPage.values[index];
    });
    log('切换到第 $index 个页面: ${AppPage.values[index]}');
  }

  void _animateToPosition(double targetPosition) {
    setState(() {
      _cardPosition = targetPosition;
    });
    _animationController.forward(from: 0.0);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      // 根据拖拽距离计算新位置
      final dragAmount = -details.primaryDelta! / MediaQuery.of(context).size.height;
      _cardPosition = (_cardPosition + dragAmount).clamp(0.3, 0.9);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    // 拖拽结束后吸附到最近的位置
    final snapPositions = [0.3, 0.5, 0.9];
    double nearestPosition = snapPositions[0];
    double minDistance = double.infinity;
    
    for (final position in snapPositions) {
      final distance = (_cardPosition - position).abs();
      if (distance < minDistance) {
        minDistance = distance;
        nearestPosition = position;
      }
    }
    
    _animateToPosition(nearestPosition);
  }

  // 📱 不同页面的内容构建方法
  Widget _buildDevicePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.device_hub, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                '设备管理',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '当前设备数量: 3',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showSnackBar('开始扫描设备');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          child: const Text('扫描设备'),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.laptop_mac, color: Colors.blue),
            ),
            title: const Text('笔记本电脑'),
            subtitle: const Text('已连接'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            onTap: () {
              _showSnackBar('查看笔记本电脑详情');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.phone_iphone, color: Colors.green),
            ),
            title: const Text('iPhone 13'),
            subtitle: const Text('已连接'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            onTap: () {
              _showSnackBar('查看iPhone 13详情');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tablet_mac, color: Colors.orange),
            ),
            title: const Text('iPad Pro'),
            subtitle: const Text('未连接'),
            trailing: const Icon(Icons.cancel, color: Colors.red),
            onTap: () {
              _showSnackBar('查看iPad Pro详情');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsPage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.group, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              Text(
                '好友列表',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '在线好友: 5/12',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            title: const Text('张三'),
            subtitle: const Text('在线'),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                _showSnackBar('开始与张三聊天');
              },
            ),
            onTap: () {
              _showSnackBar('查看张三资料');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            title: const Text('李四'),
            subtitle: const Text('离线'),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                _showSnackBar('开始与李四聊天');
              },
            ),
            onTap: () {
              _showSnackBar('查看李四资料');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Colors.green),
            ),
            title: const Text('王五'),
            subtitle: const Text('在线'),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                _showSnackBar('开始与王五聊天');
              },
            ),
            onTap: () {
              _showSnackBar('查看王五资料');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            title: const Text('赵六'),
            subtitle: const Text('在线'),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                _showSnackBar('开始与赵六聊天');
              },
            ),
            onTap: () {
              _showSnackBar('查看赵六资料');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            title: const Text('孙七'),
            subtitle: const Text('离线'),
            trailing: IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                _showSnackBar('开始与孙七聊天');
              },
            ),
            onTap: () {
              _showSnackBar('查看孙七资料');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePage() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.purple.shade100,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.person, size: 50, color: Colors.purple),
              ),
              const SizedBox(height: 16),
              Text(
                '用户个人中心',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '账号: user@example.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            title: const Text('编辑资料'),
            onTap: () {
              _showSnackBar('编辑资料');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.settings, color: Colors.green),
            ),
            title: const Text('设置'),
            onTap: () {
              _showSnackBar('打开设置');
            },
          ),
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.help, color: Colors.orange),
            ),
            title: const Text('帮助与反馈'),
            onTap: () {
              _showSnackBar('帮助与反馈');
            },
          ),
        ),
        const SizedBox(height: 30),
        OutlinedButton(
          onPressed: () {
            _showSnackBar('退出登录');
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          child: const Text('退出登录'),
        ),
      ],
    );
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

  // 📱 根据当前索引获取对应页面内容
  Widget _getCurrentPageContent() {
    switch (_currentPage) {
      case AppPage.device:
        return _buildDevicePage();
      case AppPage.friends:
        return _buildFriendsPage();
      case AppPage.profile:
        return _buildProfilePage();
    }
  }

  // 🎴 构建可滑动卡片
  Widget _buildSlidingCard() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: 0,
      right: 0,
      bottom: 0,
      top: MediaQuery.of(context).size.height * (1 - _cardPosition),
      child: GestureDetector(
        onVerticalDragUpdate: _handleDragUpdate,
        onVerticalDragEnd: _handleDragEnd,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // 卡片顶部拖拽区域
              GestureDetector(
                onTap: () {
                  // 点击切换位置
                  if (_cardPosition == 0.5) {
                    _animateToPosition(0.9);
                  } else if (_cardPosition == 0.9) {
                    _animateToPosition(0.3);
                  } else {
                    _animateToPosition(0.5);
                  }
                },
                child: Container(
                  height: 40,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              // 卡片内容区域
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: _getCurrentPageContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🖼️ 构建背景图
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

  // ================================
  // 🎨 UI构建部分（类似Vue的<template>部分）
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
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
                  onPressed: () {
                    _showSnackBar('搜索功能');
                  },
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
                  onPressed: () {
                    _showSnackBar('通知功能');
                  },
                  tooltip: '通知',
                ),
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          _buildBackground(),
          _buildSlidingCard(),
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
          onDestinationSelected: (int index) {
            _onItemTapped(index);
          },
        ),
      ),

      floatingActionButton: _currentPage == AppPage.device 
          ? FloatingActionButton(
              onPressed: () {
                _showSnackBar('添加设备');
              },
              child: const Icon(Icons.add),
              tooltip: '添加设备',
            )
          : _currentPage == AppPage.friends
            ? FloatingActionButton(
                onPressed: () {
                  _showSnackBar('添加好友');
                },
                child: const Icon(Icons.person_add),
                tooltip: '添加好友',
              )
            : null,
    );
  }
}