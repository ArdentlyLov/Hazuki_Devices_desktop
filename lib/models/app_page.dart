// ================================
// 📄 页面枚举定义
// ================================
import 'package:flutter/material.dart';

enum AppPage { device, friends, profile }

extension AppPageExtension on AppPage {
  String get title {
    switch (this) {
      case AppPage.device:
        return '设备管理';
      case AppPage.friends:
        return '好友列表';
      case AppPage.profile:
        return '个人中心0';
    }
  }
  
  IconData get icon {
    switch (this) {
      case AppPage.device:
        return Icons.device_hub;
      case AppPage.friends:
        return Icons.person;
      case AppPage.profile:
        return Icons.my_library_add;
    }
  }
}