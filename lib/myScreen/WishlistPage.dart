import 'package:ai_masa/myScreen/CartScreen.dart';
import 'package:ai_masa/myScreen/SearchPage.dart';
import 'package:flutter/material.dart';
import '../Services/product_services.dart';
import '../utils/colors.dart';
import 'ProductDetailsPage.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List wishlist_data = [];
  bool isRefreshing = true;

  @override
  void initState() {
    super.initState();
    _fetchWishlistData();
  }

  Future<void> _fetchWishlistData() async {
    setState(() => isRefreshing = true);
    try {
      final response_data = await ProductServices.wishlist();
      if (response_data != null && response_data['status'] == true) {
        setState(() {
          wishlist_data = response_data['wishlist'];
          isRefreshing = false;
        });
      } else {
        setState(() => isRefreshing = false);
      }
    } catch (e) {
      setState(() => isRefreshing = false);
    }
  }

  Future<void> _addToCard(productData, index, item) async {
    final api_data = {
      "product_id": productData['id'],
      "prod_variation_id": 0,
      "quantity":
          (int.tryParse(item['quantity'].toString()) ?? 1) *
          (int.tryParse(productData['pack_qty'].toString()) ?? 1),
      "price": productData['sale_price'] ?? productData['regular_price'],
    };

    await ProductServices.add_to_cart(api_data).then((response_data) {
      if (response_data != null && response_data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Added to Cart Successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  Future<void> _delete_wishlist_item(index, id) async {
    await ProductServices.delete_wishlist_item(id).then((response_data) {
      if (response_data['status'] == true) {
        setState(() {
          wishlist_data.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from Wishlist'),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "MY WISHLIST",
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFF1F8E9),
        elevation: 0.8,

        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchWishlistData,
        color: primaryColors,
        child: isRefreshing
            ? Center(child: CircularProgressIndicator(color: primaryColors))
            : wishlist_data.isEmpty
            ? LayoutBuilder(
                builder: (context, constraints) => ListView(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: _buildEmptyWishlist(),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: wishlist_data.length,
                itemBuilder: (context, index) {
                  var item = wishlist_data[index];
                  var product = item['product'];
                  return _buildWishlistCard(product, item, index);
                },
              ),
      ),
    );
  }

  Widget _buildWishlistCard(var product, var item, int index) {
    double regularPrice = double.parse(product['regular_price'].toString());
    double? salePrice = product['sale_price'] != null
        ? double.parse(product['sale_price'].toString())
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(id: product['id']),
          ),
        ),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product['primary_img'],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product['prod_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _delete_wishlist_item(index, item['id']),
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '₹${salePrice ?? regularPrice}',
                          style: TextStyle(
                            color: primaryColors,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (salePrice != null && salePrice < regularPrice) ...[
                          const SizedBox(width: 8),
                          Text(
                            '₹$regularPrice',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              _qtyIconButton(Icons.remove, () {
                                if (int.parse(item['quantity'].toString()) >
                                    1) {
                                  setState(
                                    () => item['quantity'] =
                                        int.parse(item['quantity'].toString()) -
                                        1,
                                  );
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  item['quantity'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _qtyIconButton(Icons.add, () {
                                setState(
                                  () => item['quantity'] =
                                      int.parse(item['quantity'].toString()) +
                                      1,
                                );
                              }),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _addToCard(product, index, item),
                          icon: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 14,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Add",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColors,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qtyIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, size: 16, color: Colors.black54),
      ),
    );
  }

  Widget _buildEmptyWishlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          const Text(
            "Your wishlist is empty",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
