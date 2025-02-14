import 'package:DairyDunk/pages/order_page.dart';
import 'package:DairyDunk/pages/profilepage.dart';
import 'package:DairyDunk/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:DairyDunk/components/components.dart';
import 'package:DairyDunk/services/auth/auth_service.dart';
import 'package:DairyDunk/utils/extension.dart';

import '../pages/pages.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(){
    final authService = AuthService();
    authService.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Icon(
              Icons.shopping_bag,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // home list title
          MyDrawerTile(
            text: "หน้าหลัก",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // setting list title
          MyDrawerTile(
            text: "ตั้งค่า",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
          ),
          MyDrawerTile(
            text: "โปรไฟล์ผู้ใช้งาน",
            icon: Icons.person_sharp,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  ProfileScreen(),
                ),
              );
            },
          ),
          MyDrawerTile(
            text: "รายการสั่งซื้อ",
            icon: Icons.edit_document,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  OrdersPage(),
                ),
              );
            },
          ),
          const Spacer(),

          // logout list title
          MyDrawerTile(
            text: "ออกจากระบบ",
            icon: Icons.logout,
            onTap: (){
              logout();
              Navigator.pop(context);
            },
          ),

          25.pv,
        ],
      ),
    );
  }
}
