// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, sort_child_properties_last, unused_field, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ai_masa/Auth/login.dart';
import 'package:ai_masa/Services/auth_services.dart';
import 'package:ai_masa/Services/product_services.dart';
import 'CartScreen.dart';
import 'MyOrderPage.dart';
import 'SearchPage.dart';
import 'WishlistPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> profileDetails = {};
  bool isRefreshing = true;
  final storage = const FlutterSecureStorage();

  // Define a nice deep green color for the theme
  static const Color appGreen = Color(0xFF2E7D32); // Adjust as needed
  static const Color accentGreen = Color(0xFFA5D6A7);
  static const Color lightMint = Color(
    0xFFE8F5E9,
  ); // Halka fresh green background
  static const Color deepForest = Color(
    0xFF2D6A4F,
  ); // Dark green text/icons ke liye
  static const Color softGreen = Color(0xFF81C784);

  @override
  void initState() {
    super.initState();
    _fetchProfileDetails();
  }

  Future<void> _fetchProfileDetails() async {
    await ProductServices.profile_details().then((response_data) {
      if (response_data['status'] == true) {
        setState(() {
          profileDetails = response_data['customer_data'];
          isRefreshing = false;
        });
      }
    });
  }

  // --- Click Functions for List Items ---
  void _navigateToWishlist() {
    // print('Wishlist item clicked');
    // Implement navigation logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WishlistPage()),
    );
  }

  void _navigateToMyOrders() {
    print('My Orders item clicked');
    // Implement navigation logic here
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrderPage()));
  }

  void _navigateToSharedProducts() {
    print('Shared Products item clicked');
    // Implement logic/navigation here
  }

  void _navigateToFollowedShops() {
    print('Followed Shops item clicked');
    // Implement logic/navigation here
  }

  void _navigateToBankDetails() {
    print('Bank & UPI Details clicked');
    // Implement logic/navigation here
  }

  void _navigateToPaymentRefund() {
    print('Payment & Refund clicked');
    // Implement logic/navigation here
  }

  void _navigateToLanguageChange() {
    print('Change Language clicked');
    // Implement logic/navigation here
  }

  void _navigateToSupplierRegistration() {
    print('Become a Supplier clicked');
    // Implement logic/navigation here
  }

  void _rateApp() {
    print('Rate App clicked');
    // Implement logic/navigation here
  }

  void _navigateToLegal() {
    print('Legal and Policies clicked');
    // Implement logic/navigation here
  }

  // --- Click Functions for Top Action Boxes ---
  void _navigateToHelpCentre() {
    print('Help Centre Box clicked');
    // Implement logic/navigation here
  }

  void _navigateToReferEarn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyOrderPage()),
    );
  }

  void _navigateToSettings() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SettingsPage()),
    // );
  }

  void _handleLogout() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Jitna content utni height
            children: [
              // Top handle bar or Close icon
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Message text
              const Text(
                'Are you sure you want to logout?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              // Buttons Row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.black26),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Logout Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await AuthServices.logout().then((response_data) {
                          if (response_data['status']) {
                            storage.delete(key: 'distributor_access_token');
                            Navigator.pop(context); // Close sheet
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          245,
                          39,
                          39,
                        ), // Purple color from image
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the name to display (fallback if API data isn't ready)
    String displayName = isRefreshing
        ? 'Loading...'
        : '${profileDetails['first_name'] ?? 'User'} ${profileDetails['last_name'] ?? ''}';

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading:
            false, // Account page usually main tab hota hai
        backgroundColor: const Color(0xFFF1F8E9), // Light Mint Green Background
        title: const Text(
          'ACCOUNT', // Uppercase for consistency
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2E7D32), // Deep Forest Green
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          // --- Custom Search Icon ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF2E7D32),
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
            ),
          ),

          // --- Cart Icon ---
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Color(0xFF2E7D32),
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],

        // Niche halki si divider line jo background se match kare
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Colors.green.withOpacity(
              0.1,
            ), // Black line ki jagah soft green divider
          ),
        ),
      ),
      body: isRefreshing
          ? Center(child: CircularProgressIndicator(color: appGreen))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Profile Info Header Section (API Data) ---
                  _buildProfileHeader(displayName),

                  // --- New Action Box Row (Help Centre / Refer & Earn) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildActionBox(
                            Icons.phone_forwarded_outlined,
                            'Help Centre',
                            _navigateToHelpCentre,
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildActionBox(
                            Icons.card_giftcard_outlined,
                            'My Order',
                            _navigateToReferEarn,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- List Sections ---
                  _buildSectionHeader('My Payments'),
                  _buildListTileCard(
                    Icons.payment_outlined,
                    'Bank & UPI Details',
                    _navigateToBankDetails,
                  ),
                  _buildListTileCard(
                    Icons.currency_rupee_outlined,
                    'Payment & Refund',
                    _navigateToPaymentRefund,
                  ),

                  _buildSectionHeader('My Activity'),
                  _buildListTileCard(
                    Icons.language_outlined,
                    'Change Language',
                    _navigateToLanguageChange,
                  ),
                  _buildListTileCard(
                    Icons.favorite_border,
                    'Wishlisted Products',
                    _navigateToWishlist,
                  ),
                  _buildListTileCard(
                    Icons.share_outlined,
                    'Shared Products',
                    _navigateToSharedProducts,
                  ),
                  _buildListTileCard(
                    Icons.storefront_outlined,
                    'Followed Shops',
                    _navigateToFollowedShops,
                    trailing: _buildNewBadge(),
                  ), // Trailing badge example

                  _buildSectionHeader('Others'),
                  _buildListTileCard(
                    Icons.account_balance_wallet_outlined,
                    'Al Masa Balance',
                    () {},
                    trailingText: '₹0',
                  ), // Trailing text example
                  _buildListTileCard(
                    Icons.business_center_outlined,
                    'Become a Supplier',
                    _navigateToSupplierRegistration,
                    trailing: _buildNewBadge(),
                  ),
                  _buildListTileCard(
                    Icons.settings_outlined,
                    'Settings',
                    _navigateToSettings,
                  ),
                  _buildListTileCard(
                    Icons.star_outline,
                    'Rate Al-Masa App',
                    _rateApp,
                  ),
                  _buildListTileCard(
                    Icons.policy_outlined,
                    'Legal and Policies',
                    _navigateToLegal,
                  ),

                  // --- Bottom Logout Section (Card style) ---
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListTile(
                        onTap: _handleLogout,
                        leading: Icon(Icons.logout, color: Colors.red[700]),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.black45,
                        ),
                      ), // Yahan ListTile khatam hota hai (No children: [])
                    ),
                  ),

                  // --- Bottom Flag Image & Version Text ---
                  _buildBottomFlagImage(),
                  _buildVersionText(),
                ],
              ),
            ),
    );
  }

  // --- UI Helper Widgets ---

  // --- Action Button ko stylish banane ka function ---
  Widget _buildCustomAction(IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: lightMint, // Halka green circle background
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: deepForest, size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProfileHeader(String displayName) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[200],
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/images.png', // Keep the same asset image
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName, // API Data here
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Placeholder below name as in img 1, just a dummy line
                  Container(width: 60, height: 1.5, color: Colors.grey[300]),
                ],
              ),
              Spacer(),
              Icon(Icons.chevron_right, color: Colors.black45),
            ],
          ),
          SizedBox(height: 15),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[100],
          ), // Divider below
        ],
      ),
    );
  }

  Widget _buildActionBox(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 75,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey[300]!, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey[600], size: 28),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ), // Bold Black
      ),
    );
  }

  Widget _buildListTileCard(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      child: Card(
        color: Colors.white,
        elevation: 0.5,
        margin: EdgeInsets.symmetric(vertical: 0.0), // No vertical margin
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ), // Squared for list feel
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: Colors.black54, size: 20),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 0.0,
          ), // Reduce vertical padding
          minVerticalPadding: 0,
          title: Transform.translate(
            offset: Offset(-20, 0), // Pull text closer to icon
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          trailing: trailing != null
              ? trailing
              : trailingText != null
              ? Text(
                  trailingText,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              : Icon(Icons.chevron_right, color: Colors.black45),
        ),
      ),
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'New',
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBottomFlagImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Column(
          children: [
            Text(
              'Made with love\nfor Bharat',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flag part (Dummy container with colors)
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                ),
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.grey[200]!),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                // Hands part (Placeholder using Icons)
                Icon(Icons.thumb_up_alt_outlined, size: 30, color: Colors.blue),
                SizedBox(width: 10),
                Icon(Icons.handshake_outlined, size: 30, color: Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'App Version: 1.0.0 (001)',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ),
    );
  }
}
