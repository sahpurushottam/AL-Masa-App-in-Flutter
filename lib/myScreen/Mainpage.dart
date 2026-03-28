// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ai_masa/myScreen/CartScreen.dart';
import 'package:ai_masa/myScreen/ProfilePage.dart';
import 'package:ai_masa/myScreen/WishlistPage.dart';
import 'package:ai_masa/myScreen/homeScreen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    CartScreen(),
    WishlistPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: _selectedIndex, children: _pages),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.green.shade800,
                unselectedItemColor: Colors.grey.shade400,
                selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                onTap: _onItemTapped,
                items: [
                  _buildNavItem(
                    Icons.home_rounded,
                    Icons.home_outlined,
                    'Home',
                    0,
                  ),
                  _buildNavItem(
                    Icons.shopping_cart,
                    Icons.shopping_cart_outlined,
                    'Cart',
                    1,
                  ),
                  _buildNavItem(
                    Icons.favorite_rounded,
                    Icons.favorite_outline_rounded,
                    'Favorites',
                    2,
                  ),
                  _buildNavItem(
                    Icons.person_rounded,
                    Icons.person_outline_rounded,
                    'Account',
                    3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    int index,
  ) {
    bool isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(isSelected ? activeIcon : inactiveIcon, size: 26),
      ),
      label: label,
    );
  }
}
