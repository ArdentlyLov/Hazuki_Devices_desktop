// ================================
// 👥 好友页面
// ================================

import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  final Function(String) onItemTap;

  const FriendsPage({Key? key, required this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildFriendsList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '好友',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0), // 白色文字
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '在线好友: 5/12',
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 92, 92, 92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return Column(
      children: [
        _buildFriendCard(
          name: '小米16',
          address: '四川省·和平区',
          time: '23小时前',
          isOnline: true,
          onChat: () => onItemTap('开始与小米16聊天'),
          onTap: () => onItemTap('查看小米16资料'),
        ),
        _buildFriendCard(
          name: '张三',
          address: '北京市·海淀区',
          time: '2小时前',
          isOnline: true,
          onChat: () => onItemTap('开始与张三聊天'),
          onTap: () => onItemTap('查看张三资料'),
        ),
        _buildFriendCard(
          name: '李四',
          address: '上海市·浦东新区',
          time: '1天前',
          isOnline: false,
          onChat: () => onItemTap('开始与李四聊天'),
          onTap: () => onItemTap('查看李四资料'),
        ),
      ],
    );
  }

  Widget _buildFriendCard({
    required String name,
    required String address,
    required String time,
    required bool isOnline,
    required VoidCallback onChat,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 280,
      height: 86,
      child: Card(
        elevation: 0,
        color: Color.fromARGB(255, 232, 232, 232),
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 头像
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 222, 222, 222),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.person,
                    color: const Color.fromARGB(255, 147, 147, 147), size: 24),
              ),
              SizedBox(width: 16),
              // 内容区域
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // ✅ 控制垂直对齐
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          address,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // 聊天按钮
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 100, 100, 100),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  icon: Icon(Icons.chat, color: Colors.white, size: 14),
                  onPressed: onChat,
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
