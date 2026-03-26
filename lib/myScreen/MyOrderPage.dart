import 'package:ai_masa/myScreen/CartScreen.dart';
import 'package:ai_masa/myScreen/WishlistPage.dart';
import 'package:flutter/material.dart';
import 'package:ai_masa/Services/product_services.dart';
import 'package:ai_masa/myScreen/OrderDetailPage.dart';
import 'package:ai_masa/utils/colors.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  List ordersData = [];
  bool isRefreshing = true;

  @override
  void initState() {
    super.initState();
    _onFetchOrders();
  }

  Future<void> _onFetchOrders() async {
    await ProductServices.get_my_orders().then((response_data) {
      if (response_data['status'] == true) {
        setState(() {
          ordersData = response_data['orders'];
          isRefreshing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ORDERS', // Uppercase for consistency
          style: TextStyle(
            color: Color(0xFF2E7D32), // Deep Forest Green
            fontSize: 18,
            fontWeight: FontWeight.w800, // Modern Bold look
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFF1F8E9), // Light Mint Green Background
        elevation: 0.8, // Halka shadow depth ke liye
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E7D32),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // 1. Wishlist Icon
          IconButton(
            icon: const Icon(
              Icons.favorite_border_rounded,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishlistPage(),
                ), // Check your class name
              );
            },
          ),
          // 2. Cart Icon
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ), // Check your class name
              );
            },
          ),
          const SizedBox(width: 8), // Right side spacing
        ],
        // Bottom Divider for clean separation
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0, color: Colors.green.withOpacity(0.1)),
        ),
      ),
      body: isRefreshing
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: ordersData.length,
              itemBuilder: (context, index) {
                final order = ordersData[index];

                // Format the order date to d-MMM-yyyy
                final DateFormat formatter = DateFormat('d-MMM-yyyy');
                final DateTime orderDate = DateTime.parse(order['order_date']);
                final String formattedDate = formatter.format(orderDate);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Order ID: #${order['id']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${order['shipping_status']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              order['shipping_status'] ==
                                                  'Delivered'
                                              ? Colors.green[600]
                                              : order['shipping_status'] ==
                                                    'pending'
                                              ? Colors.orange
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Order Date: $formattedDate', // Formatted date
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Total Amount: ₹${order['net_amt']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Button positioned below the order details
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to OrderDetailPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailPage(
                                  order: order,
                                  shippingDetails:
                                      ordersData[index]['customer'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColors, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // Fit button width to content
                            children: [
                              const Text(
                                'View Details',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                width: 5,
                              ), // Space between text and icon
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ), // Right arrow icon
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
