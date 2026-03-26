// ignore_for_file: unnecessary_null_comparison, dead_code
import 'package:ai_masa/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:ai_masa/Services/product_services.dart';
import 'package:ai_masa/global/Global.dart';
import 'package:ai_masa/myScreen/CheckoutPage.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List addressData_list = [];
  Map<String, dynamic>? _selectedAddress;
  bool isRefreshing = true;
  bool showForm = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _get_customer_shipping_addresses();
  }

  Future<void> _get_customer_shipping_addresses() async {
    await ProductServices.get_customer_shipping_addresses()
        .then((response_data) {
          setState(() {
            if (response_data != null && response_data['status'] == true) {
              addressData_list = response_data['shipping_addresses'];
              isRefreshing = false;
              // Pehla address default select kar lete hain bina circle ke logic ke liye
              if (addressData_list.isNotEmpty) {
                _selectedAddress = addressData_list[0];
              }
            } else {
              addressData_list = [];
              isRefreshing = false;
            }
          });
        })
        .catchError((error) {
          setState(() => isRefreshing = false);
        });
  }

  // 1. UPDATED 4-STEP STEPPER
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
              _stepLine(true),
              _stepCircle(null, true, false, "2"),
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
                _stepLabel("Cart", false),
                _stepLabel("Address", true),
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
      width: 75,
      height: 2,
      color: isDone ? Colors.blue : Colors.grey.shade300,
    );
  }

  // 2. CLEAN ADDRESS HEADER (Bina Circle ke)
  Widget _buildDeliveryAddressHeader() {
    if (_selectedAddress == null) return Container();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                "Delivery Address",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Spacer(),
              SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: () => setState(() => showForm = !showForm),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: const Text(
                    "Change",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${_selectedAddress!['full_name']} • ${_selectedAddress!['mobile_number']}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "${_selectedAddress!['address_line_1']}, ${_selectedAddress!['city']}, ${_selectedAddress!['state']} - ${_selectedAddress!['zip_code']}",
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F8E9), // Light Mint Green Background
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E7D32), // Dark Green Icon
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'ADDRESS SELECTION',
          style: TextStyle(
            color: Color(0xFF2E7D32), // Dark Green Text
            fontSize: 16,
            fontWeight: FontWeight.w800, // Extra Bold for modern look
            letterSpacing: 1.2,
          ),
        ),

        // Bottom Line Design
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(
            75,
          ), // Stepper ke liye thodi zyada height
          child: Column(
            children: [
              _buildStepper(), // Aapka stepper widget
              const SizedBox(height: 10),
              Container(
                color: Colors.green.withOpacity(
                  0.1,
                ), // Halka divider line niche
                height: 1,
              ),
            ],
          ),
        ),
      ),
      body: isRefreshing
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              children: [
                // _buildStepper(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDeliveryAddressHeader(),

                        if (showForm) _buildAddressForm(),
                      ],
                    ),
                  ),
                ),

                // BOTTOM BAR - ALWAYS VISIBLE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 180,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_selectedAddress != null) {
                              GBL_selectedShippingAddress = _selectedAddress!
                                  .map((k, v) => MapEntry(k, v.toString()));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColors,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAddressForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              "Add New Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _address1Controller,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => showForm = false),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
