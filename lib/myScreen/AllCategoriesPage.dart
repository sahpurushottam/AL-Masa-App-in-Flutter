import 'package:ai_masa/myScreen/CartScreen.dart';
import 'package:flutter/material.dart';
import '../Services/product_services.dart';
import 'ProductDetailsPage.dart';

class CategoryPage extends StatefulWidget {
  final dynamic selectedId; // Bahar se aane wali ID
  const CategoryPage({Key? key, this.selectedId}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int selectedIndex = 0;
  List<dynamic> categoryList = [];
  List<dynamic> productList = [];
  bool isLoadingCategories = true;
  bool isLoadingProducts = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await ProductServices.CategoriesData();
      if (response != null && response['status'] == true) {
        List<dynamic> tempList = [
          {'id': 'popular_01', 'category_name': 'Popular', 'cat_img': null},
        ];
        tempList.addAll(response['category_list']);

        // --- Logic: Agar selectedId aayi hai toh uska index dhoondo ---
        int initialIndex = 0;
        if (widget.selectedId != null) {
          int found = tempList.indexWhere(
            (cat) => cat['id'].toString() == widget.selectedId.toString(),
          );
          if (found != -1) initialIndex = found;
        }

        setState(() {
          categoryList = tempList;
          selectedIndex = initialIndex;
          isLoadingCategories = false;
        });

        // Wahi products load karo jo select huye hain
        _loadProducts(categoryList[selectedIndex]['id']);
      } else {
        setState(() => isLoadingCategories = false);
      }
    } catch (e) {
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> _loadProducts(dynamic catId) async {
    setState(() => isLoadingProducts = true);
    try {
      final response = await ProductServices.CategoriesChildData(
        catId.toString(),
      );
      setState(() {
        productList = (response != null && response['products'] is List)
            ? response['products']
            : [];
        isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        productList = [];
        isLoadingProducts = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leadingWidth: 40, // Space bachane ke liye
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A1A),
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        titleSpacing: 10,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Categories",
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5, // Modern tight look
              ),
            ),
            // Chota sa sub-text jo premium feel deta hai
            Text(
              "Explore best products",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          // Wishlist Icon with subtle glow/shadow
          _buildModernActionIcon(
            icon: Icons.favorite_rounded,
            iconColor: Colors.pinkAccent,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          // Shopping Bag with count badge
          _buildModernCartIcon(),
          const SizedBox(width: 16),
        ],
        // Bottom line ko thoda aur soft kiya hai gradient touch ke saath
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Colors.grey.withOpacity(0.2),
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
      ),
      body: isLoadingCategories
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : Row(
              children: [
                // --- Sidebar (Left) ---
                Container(
                  width: 85,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    border: Border(
                      right: BorderSide(color: Colors.grey.withOpacity(0.1)),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedIndex == index;
                      var category = categoryList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          _loadProducts(category['id']);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                          ),
                          child: Column(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.purple
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: isSelected
                                      ? Colors.purple.withOpacity(0.1)
                                      : Colors.grey[200],
                                  backgroundImage:
                                      (category['cat_img'] != null &&
                                          category['cat_img'] != "")
                                      ? NetworkImage(category['cat_img'])
                                      : null,
                                  child:
                                      (category['cat_img'] == null ||
                                          category['cat_img'] == "")
                                      ? Icon(
                                          category['category_name'] == 'Popular'
                                              ? Icons.star
                                              : Icons.category_outlined,
                                          color: isSelected
                                              ? Colors.purple
                                              : Colors.grey,
                                          size: 20,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                category['category_name'] ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.purple
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // --- Products Grid (Right) ---
                Expanded(
                  child: isLoadingProducts
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                            strokeWidth: 2,
                          ),
                        )
                      : productList.isEmpty
                      ? const Center(
                          child: Text(
                            "No items found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            var product = productList[index];
                            return _buildProductCard(product);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // Helper: Product Card
  Widget _buildProductCard(var product) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(id: product['id']),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product['primary_img'] ?? '',
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[100],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['prod_name'] ?? 'No Name',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "₹${product['sale_price'] ?? product['regular_price'] ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Modern Action Icon Helper
  Widget _buildModernActionIcon({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  // 2. Modern Cart Icon with Badge
  Widget _buildModernCartIcon() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(
                0xFF673AB7,
              ).withOpacity(0.08), // Light Purple tint
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.purple,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
