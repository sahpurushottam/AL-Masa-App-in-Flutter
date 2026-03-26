import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _recentSearches = [
    'Chocolate Chip Cookies',
    'Butter Crunch Biscuit',
    'Red Velvet Mini Cake',
    'Coconut Crunchies',
    'Bourbon Biscuit',
  ];

  final List<String> _popularSearches = [
    'Chocolate Cookies',
    'Butter Biscuit',
    'Red Velvet Cake',
    'Oatmeal Cookies',
    'Vanilla Cake',
    'Cashew Biscuit',
    'Pineapple Cake',
    'Coconut Cookies',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Container(
          height: 45,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by Keyword or Product ID',
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic_none, color: Colors.grey),
                  SizedBox(width: 10),
                  Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  SizedBox(width: 10),
                ],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1, height: 1),

            // --- Recent Searches Section ---
            _buildSectionTitle("Your Recent Searches"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.black54,
                    size: 20,
                  ),
                  title: Text(
                    _recentSearches[index],
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  onTap: () {},
                );
              },
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 8, color: Color(0xFFF5F5F7)),

            // --- Popular Searches Section ---
            _buildSectionTitle("Popular Searches"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _popularSearches
                    .map((tag) => _buildSearchChip(tag))
                    .toList(),
              ),
            ),

            const SizedBox(height: 30),

            // --- Bottom Banner Section ---
            _buildBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSearchChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.black54),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade100, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Crunchy Cookie ka Swad\nya Cake ki Mithas",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Shop what you ❤️",
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          // Image placeholder for the lady in the banner
          Container(
            height: 120,
            width: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://your-image-url-here.png",
                ), // Add your asset here
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
