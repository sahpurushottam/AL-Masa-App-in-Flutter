// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ai_masa/myScreen/CartScreen.dart';
import 'package:ai_masa/myScreen/WishlistPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ai_masa/utils/colors.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final Map order;
  final Map shippingDetails;

  const OrderDetailPage({
    Key? key,
    required this.order,
    required this.shippingDetails,
  }) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late List orderItems;
  late Map shippingDetail; // Variable to store shippingDetails
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePageData();
  }

  void _initializePageData() {
    // Storing the shipping details in a variable
    shippingDetail = widget.shippingDetails;

    print(shippingDetail);

    // Storing the order items
    orderItems = widget.order['order_items'] as List;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F8E9), // Light Mint Green Background
        elevation: 0.8, // Halka shadow depth ke liye
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E7D32), // Deep Forest Green
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ORDER DETAILS', // Uppercase professional lagta hai
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 18,
            fontWeight: FontWeight.w800, // Modern Bold look
            letterSpacing: 1.2,
          ),
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
                ), // Apna class name check karein
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
                ), // Apna class name check karein
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        // Niche halki divider line separation ke liye
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0, color: Colors.green.withOpacity(0.1)),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Information Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: #${widget.order['id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // ignore: deprecated_member_use
                                const Icon(
                                  FontAwesomeIcons.calendarAlt,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Order Date: ${DateFormat('d-MMM-yyyy').format(DateTime.parse(widget.order['order_date']))}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.rupeeSign,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Total Amount: ₹${widget.order['pay_amt']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    widget.order['shipping_status'] ==
                                        'Delivered'
                                    ? primaryColors
                                    : widget.order['shipping_status'] ==
                                          'pending'
                                    ? Colors.orange[100]
                                    : Colors.red[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                // 'Status: ${(widget.order['shipping_status'] != null && widget.order['shipping_status'].toString().isNotEmpty) ? widget.order['shipping_status'] : 'Not Available'}',
                                "Not Available",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color:
                                      widget.order['shipping_status'] ==
                                          'Delivered'
                                      ? primaryColors
                                      : widget.order['shipping_status'] ==
                                            'pending'
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Details:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColors,
                          ),
                        ),
                        SizedBox(height: 10),
                        Card(
                          elevation: 5, // Shadow for the box
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Rounded corners
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${shippingDetail['first_name']} ${shippingDetail['last_name']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${shippingDetail['address_line_1']},  ${(shippingDetail['address_line_2'] == null) ? shippingDetail['address_line_2'] : ''}  \n${shippingDetail['city']}, ${shippingDetail['state']}, ${shippingDetail['zip_code']} ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Mobile No: ',
                                          style: TextStyle(
                                            color: primaryColors,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: shippingDetail['mobile_number'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),

                    SizedBox(height: 20),
                    // Order Items Header
                    Text(
                      'Order Items:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primaryColors,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Order Items List
                    ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['product_name'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Quantity: ${item['quantity']}'),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${item['total_price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true, // Avoid infinite height error
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable scrolling
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
