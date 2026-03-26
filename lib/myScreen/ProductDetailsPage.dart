// ignore_for_file: unnecessary_null_comparison, dead_code
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ai_masa/Services/product_services.dart';
import 'package:ai_masa/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'CartScreen.dart';

class ProductDetailsPage extends StatefulWidget {
  final dynamic id;
  ProductDetailsPage({required this.id, Key? key}) : super(key: key);

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _currentSlide = 0;
  Map<String, dynamic> data = {};
  bool isRefreshing = true;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    get_product_details(widget.id);
  }

  // API Call to get product details
  Future<void> get_product_details(id) async {
    setState(() => isRefreshing = true);
    try {
      final response_data = await ProductServices.get_product_details(id);
      if (response_data != null) {
        setState(() {
          data = response_data['product_details'];
          isRefreshing = false;
        });
      }
    } catch (e) {
      print("Error fetching details: $e");
      setState(() => isRefreshing = false);
    }
  }

  // Wishlist Toggle Logic
  void toggleWishlist() {
    setState(() {
      isWishlisted = !isWishlisted;
    });
    if (isWishlisted) {
      addToWishlist(data);
    }
  }

  void shareProduct() {
    final String productUrl =
        "https://yourapp.com/product/${widget.id}"; // Aapka product link
    Share.share("Check out this product: $productUrl");
  }

  // Add To Cart Logic
  Future<void> addToCart(
    Map<String, dynamic> productData,
    int selectedQty,
  ) async {
    if (selectedQty > 0) {
      final apiData = {
        "product_id": productData['id'],
        "prod_variation_id": 0,
        "quantity":
            selectedQty *
            (int.tryParse(productData['pack_qty'].toString()) ?? 1),
        "price": productData['regular_price'],
      };

      await ProductServices.add_to_cart(apiData).then((response) {
        if (response != null && response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Added To Cart Successfully!'),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    }
  }

  // Add To Wishlist Logic
  Future<void> addToWishlist(Map<String, dynamic> productData) async {
    final wishlistData = {
      "product_id": productData['id'],
      "prod_variation_id": null,
      "quantity": 1,
    };

    await ProductServices.add_to_wishlist(wishlistData).then((response) {
      if (response != null && response['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Added to Wishlist'),
            backgroundColor: primaryColors,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String deliveryDate = DateFormat(
      'EEEE, d MMM',
    ).format(DateTime.now().add(const Duration(days: 4)));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F8E9), // Light Mint Green Background
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: const Color(0xFFF1F8E9),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E7D32), // Deep Green Icon
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PRODUCT DETAILS",
          style: TextStyle(
            color: Color(0xFF2E7D32), // Deep Green Text
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        actions: [
          // Share Icon
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF2E7D32)),
            onPressed: shareProduct,
          ),

          // Simple Cart Icon (Bina dot ke)
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
                ), // Check class name
              );
            },
          ),
          const SizedBox(width: 8), // Right side spacing
        ],

        // Halka divider line separation ke liye
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(height: 1.0, color: Colors.green.withOpacity(0.1)),
        ),
      ),
      body: isRefreshing
          ? Center(child: CircularProgressIndicator(color: primaryColors))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Carousel Section
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 380,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) =>
                              setState(() => _currentSlide = index),
                        ),
                        items: [data['primary_img'], data['secondary_img']].map(
                          (imagePath) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image.network(
                                  imagePath ?? '',
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width,
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [0, 1].map((index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: _currentSlide == index ? 20 : 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _currentSlide == index
                                    ? primaryColors
                                    : Colors.grey[300],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  // 2. Product Info Section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['prod_name'] ?? 'Product Name',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "₹${data['sale_price']}",
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "₹${data['regular_price']}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "15% off",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        // Rating Badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    "3.8",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "1,245 Ratings",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 40),

                        // Delivery Info
                        Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: TextSpan(
                                text: "Free Delivery by ",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text: deliveryDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 40),

                        // Product Description
                        const Text(
                          "Product Details",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['prod_desc'] ?? "Description here...",
                          style: TextStyle(
                            color: Colors.grey[700],
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Reviews Section
                        const Text(
                          "Customer Reviews",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildReviewItem(
                          "Rahul Kumar",
                          "5",
                          "Bhai bahut mast product hai, quality ek dum top hai!",
                        ),
                        _buildReviewItem(
                          "Priya Singh",
                          "4",
                          "Delivery thoda late tha but product achha hai.",
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

      // 3. Bottom Bar Buttons
      bottomNavigationBar: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColors),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => addToCart(data, 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColors,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: primaryColors,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColors,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                onPressed: () {},
                child: const Text(
                  "Buy Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String rating, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey[200],
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.green, size: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const Divider(color: Colors.black12, height: 25),
        ],
      ),
    );
  }
}
