// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:ai_masa/myScreen/AllCategoriesPage.dart';
import 'package:ai_masa/myScreen/ProfilePage.dart';
import 'package:flutter/material.dart';
import '../Services/product_services.dart';
import '../utils/colors.dart';
import 'ProductDetailsPage.dart';
import 'SearchPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List data = [];
  List filteredData = [];
  List<int> itemCounts = [];
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int itemsToShow = 10;
  bool isLoading = false;
  bool isRefreshing = true;
  List category_list = [];
  int currentIndex = 0;
  int displayedItemCount = 8;
  final List<String> imageUrls = ['assets/img/1.jpg'];

  String currentPincode = "226021";
  String currentCity = "Kolkata";

  @override
  void initState() {
    super.initState();
    _onloadCategoriesData();
    _onloadProductData();
    _scrollController.addListener(_scrollListener);

    searchController.addListener(() {
      _filterProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 2));

      setState(() {
        if (itemsToShow + 10 <= data.length) {
          itemsToShow += 10;
        } else {
          itemsToShow = data.length;
        }

        if (itemCounts.length < itemsToShow) {
          itemCounts.addAll(
            List.generate(itemsToShow - itemCounts.length, (index) => 0),
          );
        }

        isLoading = false;
      });
    }
  }

  String getCityFromPincode(String pincode) {
    if (pincode == "226021") return "Lucknow";
    if (pincode == "700001") return "Kolkata";
    return "Unknown City";
  }

  Future<void> _onloadCategoriesData() async {
    try {
      final response_data = await ProductServices.CategoriesData();

      setState(() {
        if (response_data != null && response_data['status'] == true) {
          category_list = response_data['category_list'];
        } else {
          category_list = [];
        }
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> _onloadProductData() async {
    try {
      final response_data = await ProductServices.fetchproduct();

      setState(() {
        if (response_data != null && response_data['status'] == true) {
          data = response_data['products'];
          filteredData = data;
          itemCounts = List.generate(filteredData.length, (index) => 1);
        } else {
          data = [];
          filteredData = [];
        }
        isRefreshing = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $error");
    }
  }

  void _filterProducts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredData = data;
      } else {
        filteredData = data.where((product) {
          String prodName = product['prod_name']?.toLowerCase() ?? '';
          return prodName.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _refreshItems() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _onloadCategoriesData();
      _onloadProductData();
    });
  }

  Future<void> _addToCartButtonClicked(data, index) async {
    final api_data = {
      "product_id": data[index]['id'],
      "prod_variation_id": 0,
      "quantity":
          itemCounts[index] * num.parse(data[index]['pack_qty'].toString()),
      "price": data[index]['regular_price'],
    };
    await ProductServices.add_to_cart(api_data)
        .then((response_data) async {
          if (response_data != null) {
            final registerStatus = response_data['status'];
            if (registerStatus == true) {
            } else {}
          }
        })
        .catchError((errorMessage) {})
        .whenComplete(() {
          final snackBar = SnackBar(
            content: Text('Add To Cart'),
            backgroundColor: Colors.blue,
            duration: Duration(milliseconds: 400),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }

  Future<void> _addToWishlist(int index) async {
    final wishlist_data = {
      "product_id": filteredData[index]['id'],
      "prod_variation_id": null,
      "quantity": (itemCounts[index] == 0 ? 1 : itemCounts[index]),
    };

    await ProductServices.add_to_wishlist(wishlist_data)
        .then((response_data) {
          if (response_data['status'] == true) {
            setState(() {
              filteredData[index]['in_wishlist'] = true;
            });

            final snackBar = SnackBar(
              content: Text('Your item is added to Wishlist'),
              backgroundColor: primaryColors,
              duration: Duration(milliseconds: 400),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            final snackBar = SnackBar(
              content: Text('Your product is already in Wishlist'),
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 400),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        })
        .catchError((errorMessage) {
          final snackBar = SnackBar(
            content: Text('Error while adding to Wishlist $errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
  }

  void _showLocationPopup(BuildContext context) {
    TextEditingController pinController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "CHANGE DELIVERY LOCATION",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 20),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Type Delivery Pincode",
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    currentPincode = pinController.text;
                    currentCity = getCityFromPincode(currentPincode);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "SUBMIT",
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F8E9),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Container(
            color: const Color(0xFFF1F8E9),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Al-Masa",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.account_circle,
                            size: 38,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF81C784)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IgnorePointer(
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(
                                Icons.search,
                                color: Color(0xFF4CAF50),
                                size: 22,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  "Search by Keyword or Product ID",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 46, 45, 45),
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.mic_none, color: Colors.grey.shade500),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshItems,
          child: isRefreshing
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: primaryColors),
                      SizedBox(height: 25),
                      Text(
                        'Loading....',
                        style: TextStyle(color: primaryColors, fontSize: 18),
                      ),
                    ],
                  ),
                )
              : data == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: primaryColors),
                      SizedBox(height: 25),
                      Text('Loading....'),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _showLocationPopup(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          color: const Color(0xFF1B5E20),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Delivering to $currentCity - $currentPincode",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: SizedBox(
                          height: 190,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount:
                                category_list
                                    .where(
                                      (cat) =>
                                          cat['parent_category_id'] == null ||
                                          cat['parent_category_id'] == 0,
                                    )
                                    .length +
                                1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.1,
                                ),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) =>
                                            CategoryPage(selectedId: null),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFFC8E6C9,
                                                ).withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                            Container(
                                              width: 50,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF2E7D32,
                                                  ),
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.grid_view_rounded,
                                                color: Color(0xFF2E7D32),
                                                size: 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "All Categories",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1B5E20),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              var mainCategories = category_list
                                  .where(
                                    (cat) =>
                                        cat['parent_category_id'] == null ||
                                        cat['parent_category_id'] == 0,
                                  )
                                  .toList();

                              var category = mainCategories[index - 1];

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (c) => CategoryPage(
                                        selectedId: category['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          Container(
                                            width: 65,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8F5E9),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                      35,
                                                    ),
                                                    topRight: Radius.circular(
                                                      35,
                                                    ),
                                                    bottomLeft: Radius.circular(
                                                      8,
                                                    ),
                                                    bottomRight:
                                                        Radius.circular(8),
                                                  ),
                                              border: Border.all(
                                                color: const Color(0xFFC8E6C9),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Image.network(
                                              category['cat_img'] ?? '',
                                              height: 45,
                                              width: 45,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.category_rounded,
                                                    color: Color(0xFF2E7D32),
                                                    size: 25,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        category['category_name'] ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1B5E20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Column(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: filteredData.length < displayedItemCount
                                ? filteredData.length
                                : displayedItemCount,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 7,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 0.62,
                                ),
                            itemBuilder: (context, index) {
                              var product = filteredData[index];
                              double regularPrice =
                                  double.tryParse(
                                    product['regular_price'].toString(),
                                  ) ??
                                  0;
                              double? salePrice = double.tryParse(
                                product['sale_price']?.toString() ?? '',
                              );
                              bool hasDiscount =
                                  salePrice != null && salePrice < regularPrice;

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                      255,
                                      158,
                                      158,
                                      158,
                                    ).withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailsPage(id: product['id']),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              width: double.infinity,
                                              color: const Color(0xFFF7F7F7),
                                              child: Hero(
                                                tag: 'prod_${product['id']}',
                                                child: Image.network(
                                                  product['primary_img'] ??
                                                      'https://via.placeholder.com/150',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  _addToWishlist(index),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  product['in_wishlist'] == true
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  size: 18,
                                                  color:
                                                      product['in_wishlist'] ==
                                                          true
                                                      ? Colors.red
                                                      : Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['prod_name'] ??
                                                  'Product Name',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            Row(
                                              children: [
                                                Text(
                                                  "₹${hasDiscount ? salePrice : regularPrice}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                if (hasDiscount) ...[
                                                  Text(
                                                    "₹$regularPrice",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    "${((regularPrice - salePrice) / regularPrice * 100).toStringAsFixed(0)}% off",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),

                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Free Delivery",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 6,
                                                            vertical: 2,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.green[700],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            "4.1",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 2,
                                                          ),
                                                          const Icon(
                                                            Icons.star,
                                                            color: Colors.white,
                                                            size: 10,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                GestureDetector(
                                                  onTap: () =>
                                                      _addToCartButtonClicked(
                                                        filteredData,
                                                        index,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      Icons
                                                          .add_shopping_cart_rounded,
                                                      color: Colors.white,
                                                      size: 18,
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
                              );
                            },
                          ),

                          if (filteredData.length > displayedItemCount)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: primaryColors),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    displayedItemCount += 8;
                                  });
                                },
                                child: Text(
                                  "View More Items",
                                  style: TextStyle(
                                    color: primaryColors,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
