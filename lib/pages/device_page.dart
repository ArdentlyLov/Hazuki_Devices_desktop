// ================================
// 📱 设备页面
// ================================

import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  final Function(String) onItemTap;

  const DevicePage({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        _buildDeviceList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 图标和标题在一行
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('设备',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0))
                        ),
              ],
            ),
            const SizedBox(height: 8),
            // 设备数量
            Text('当前设备数量: 0',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
    );
  }

  Widget _buildDeviceList() {
    return Column(
      children: [
        _buildDeviceCard(
          icon: Icons.laptop_mac,
          title: 'TUFGame F15',
          subtitle: '已连接',
          color: Colors.blue,
          isConnected: true,
          onTap: () => onItemTap('查看笔记本电脑详情'),
        ),
        _buildDeviceCard(
          icon: Icons.phone_iphone,
          title: 'Xiaomi 14 Pro',
          subtitle: '已连接',
          color: Colors.green,
          isConnected: true,
          onTap: () => onItemTap('查看iPhone 13详情'),
        ),
        _buildDeviceCard(
          icon: Icons.tablet_mac,
          title: 'iPad Pro 11',
          subtitle: '未连接',
          color: Colors.orange,
          isConnected: false,
          onTap: () => onItemTap('查看iPad Pro详情'),
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isConnected,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 230, 245, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(
          isConnected ? Icons.check_circle : Icons.cancel,
          color: isConnected ? Colors.green : Colors.red,
        ),
        onTap: onTap,
      ),
    );
  }
}
