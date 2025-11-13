// ================================
// 👤 个人中心页面
// ================================

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Function(String) onItemTap;

  const ProfilePage({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        _buildMenuItems(),
        const SizedBox(height: 30),
        _buildLogoutButton(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('我',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
              ),
            ],
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
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person,
          title: '编辑资料',
          color: Colors.blue,
          onTap: () => onItemTap('编辑资料'),
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: '设置',
          color: Colors.green,
          onTap: () => onItemTap('打开设置'),
        ),
        _buildMenuItem(
          icon: Icons.help,
          title: '帮助与反馈',
          color: Colors.orange,
          onTap: () => onItemTap('帮助与反馈'),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return OutlinedButton(
      onPressed: () {
        onItemTap('退出登录');
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      ),
      child: const Text('退出登录'),
    );
  }
}
