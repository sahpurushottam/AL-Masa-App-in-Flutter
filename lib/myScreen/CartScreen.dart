import 'package:flutter/material.dart';
import '../Services/product_services.dart';
import '../global/Global.dart';
import '../utils/colors.dart';
import 'AddressPage.dart';
import 'SearchPage.dart';
import 'WishlistPage.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with RouteAware {
  bool isRefreshing = true;

  @override
  void initState() {
    super.initState();
    _get_customer_cart();
    _refreshCart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _get_customer_cart();
  }

  Future<void> _refreshCart() async {
    await _get_customer_cart();
  }

  Future<void> _get_customer_cart() async {
    setState(() {
      isRefreshing = true;
    });
    try {
      await ProductServices.get_customer_cart().then((response_data) {
        setState(() {
          if (response_data != null && response_data['status'] == true) {
            GBL_cartItemList = response_data['cart_items'];
          } else {
            GBL_cartItemList = [];
          }
          isRefreshing = false;
        });
      });
    } catch (error) {
      setState(() {
        isRefreshing = false;
      });
      print("Error fetching data: $error");
    }
  }

  double _calculateTotalPrice() {
    double total = 0.0;
    for (var item in GBL_cartItemList) {
      var price = item['regular_price'];
      if (item['sale_price'] != null &&
          double.parse(item['sale_price'].toString()) > 0) {
        price = item['sale_price'];
      }
      total +=
          double.parse(item['quantity'].toString()) *
          double.parse(price.toString());
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'MY CART',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_outline_rounded,
                  color: Color(0xFF2E7D32),
                  size: 26,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshCart,
          child: isRefreshing
              ? Center(child: CircularProgressIndicator(color: primaryColors))
              : Column(
                  children: [
                    _buildStepper(),

                    Expanded(
                      child: GBL_cartItemList.isEmpty
                          ? ListView(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 250),
                                  child: Center(
                                    child: Text(
                                      'Your cart is empty',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: GBL_cartItemList.length,
                              itemBuilder: (context, index) {
                                return _buildCartItem(
                                  GBL_cartItemList[index],
                                  index,
                                );
                              },
                            ),
                    ),

                    if (GBL_cartItemList.isNotEmpty) _buildBottomBar(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepCircle(Icons.check, true, true),
              _stepLine(false),
              _stepCircle(null, false, false, "2"),
              _stepLine(false),
              _stepCircle(null, false, false, "3"),
              _stepLine(false),
              _stepCircle(null, false, false, "4"),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stepLabel("Cart", true),
                _stepLabel("Address", false),
                _stepLabel("Review", false),
                _stepLabel("Payment", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepLabel(String text, bool isActive) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        color: isActive ? Colors.black : Colors.grey,
      ),
    );
  }

  Widget _stepCircle(
    IconData? icon,
    bool isActive,
    bool isDone, [
    String? text,
  ]) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? Colors.blue : Colors.white,
        border: Border.all(
          color: isActive || isDone ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : Text(
                text ?? "",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.blue : Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _stepLine(bool isDone) {
    return Container(
      width: 78,
      height: 2,
      color: isDone ? Colors.blue : Colors.grey.shade300,
    );
  }

  Widget _buildCartItem(Map item, int index) {
    var productPrice =
        (item['sale_price'] != null &&
            double.parse(item['sale_price'].toString()) > 0)
        ? item['sale_price']
        : item['regular_price'];

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['primary_img'],
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['prod_name'].toString().toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "₹$productPrice",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Qty: ${(double.parse(item['quantity'].toString())).toStringAsFixed(0)}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColors,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  double currentQty = double.parse(
                                    item['quantity'].toString(),
                                  );
                                  double packQty = double.parse(
                                    item['pack_qty'].toString(),
                                  );
                                  setState(() {
                                    if (currentQty > packQty) {
                                      item['quantity'] = (currentQty - packQty)
                                          .toString();
                                    } else {
                                      _delete_cart_item(index, item['id']);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 35),
                              ),
                              Text(
                                (double.parse(item['quantity'].toString()) /
                                        double.parse(
                                          item['pack_qty'].toString(),
                                        ))
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  double currentQty = double.parse(
                                    item['quantity'].toString(),
                                  );
                                  double packQty = double.parse(
                                    item['pack_qty'].toString(),
                                  );
                                  setState(() {
                                    item['quantity'] = (currentQty + packQty)
                                        .toString();
                                  });
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 35),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 30, thickness: 0.5),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    /* Wishlist logic */
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Text("Wishlist", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: Colors.grey[300]),
              Expanded(
                child: InkWell(
                  onTap: () => _delete_cart_item(index, item['id']),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.black54,
                      ),
                      SizedBox(width: 8),
                      Text("Remove", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹${_calculateTotalPrice().toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  "View Price Details",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColors,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete_cart_item(index, cart_id) async {
    await ProductServices.delete_cart_item(cart_id)
        .then((response_data) {
          if (response_data['status'] == true) {
            setState(() {
              GBL_cartItemList.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item removed from cart'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        })
        .catchError((error) {
          print('Delete Error: $error');
        });
  }
}
