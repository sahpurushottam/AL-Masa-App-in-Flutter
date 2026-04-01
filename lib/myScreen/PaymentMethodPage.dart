import 'package:ai_masa/myScreen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:ai_masa/Services/product_services.dart';
import 'package:ai_masa/global/Global.dart';

import '../utils/colors.dart';

class PaymentMethodPage extends StatefulWidget {
  final Map orderData;
  PaymentMethodPage({required this.orderData});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String selectedMethod = 'Online';
  bool isRefreshing = false;

  double get _subTotal => widget.orderData['bill_amt'];

  double get _onlineDiscount => widget.orderData['discount_amt'] + 51.0;
  double get _codDiscount => widget.orderData['discount_amt'];

  double get _currentDiscount =>
      (selectedMethod == 'Online') ? _onlineDiscount : _codDiscount;
  double get _finalTotal => _subTotal - _currentDiscount;

  Future<void> _placeOrder() async {
    setState(() => isRefreshing = true);

    var finalApiData = {
      'bill_amt': _subTotal,
      'discount_amt': _currentDiscount,
      'tax_total': 0,
      'net_amt': _finalTotal,
      'shipping_total': 0,
      'pay_amt': _finalTotal.round(),
      'payment_method': selectedMethod,
      'shipping_address': widget.orderData['shipping_address'],
      'order_items': (widget.orderData['items'] as List).map((item) {
        var price =
            (item['sale_price'] != null &&
                double.parse(item['sale_price'].toString()) > 0)
            ? item['sale_price']
            : item['regular_price'];
        return {
          'product_id': item['product_id'],
          'product_name': item['prod_name'],
          'quantity': item['quantity'],
          'price': price,
          'total_price':
              (double.parse(item['quantity'].toString()) *
                      double.parse(price.toString()))
                  .toStringAsFixed(2),
        };
      }).toList(),
    };

    try {
      var response = await ProductServices.order_confirm(finalApiData);
      if (response['status'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Order Failed: $e")));
    } finally {
      setState(() => isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F8E9),
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF2E7D32),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PAYMENT METHOD',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Column(
            children: [
              _buildStepper(),
              const SizedBox(height: 8),
              Container(color: Colors.green.withOpacity(0.1), height: 1),
            ],
          ),
        ),
      ),
      body: isRefreshing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Select payment method",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _buildPaymentOption(
                    id: 'COD',
                    title: 'Cash on Delivery',
                    price: "₹${(_subTotal - _codDiscount).toStringAsFixed(0)}",
                    icon: Icons.money,
                  ),
                  const SizedBox(height: 10),
                  _buildPaymentOption(
                    id: 'Online',
                    title: 'Pay Online',
                    price:
                        "₹${(_subTotal - _onlineDiscount).toStringAsFixed(0)}",
                    isOnline: true,
                    saveAmount: "Save ₹51",
                  ),
                  if (selectedMethod == 'Online') _buildOnlineSubMethods(),

                  _buildPriceDetails(),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
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
              _stepLine(true),
              _stepCircle(Icons.check, true, true, "2"),
              _stepLine(true),
              _stepCircle(Icons.check, true, true, "3"),
              _stepLine(false),
              _stepCircle(null, true, false, "4"),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stepLabel("Cart", false),
                _stepLabel("Address", false),
                _stepLabel("Review", true),
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

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String price,
    bool isOnline = false,
    String? saveAmount,
    IconData? icon,
  }) {
    bool isSelected = selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (saveAmount != null)
                  Text(
                    saveAmount,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineSubMethods() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _subMethodItem("PhonePe", Icons.account_balance_wallet),
          const Divider(),
          _subMethodItem("Pay by any UPI App", Icons.qr_code, hasOffers: true),
          const Divider(),
          _subMethodItem("Wallet", Icons.wallet_giftcard, hasOffers: true),
        ],
      ),
    );
  }

  Widget _subMethodItem(String name, IconData icon, {bool hasOffers = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green.shade700),
      title: Text(name, style: const TextStyle(fontSize: 13)),
      subtitle: hasOffers
          ? const Text(
              "Offers Available",
              style: TextStyle(color: Colors.teal, fontSize: 11),
            )
          : null,
      trailing: const Icon(Icons.keyboard_arrow_down, size: 18),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildPriceDetails() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price Details (${GBL_cartItemList.length} Items)",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _priceRow("Product Price", "+ ₹${_subTotal.toStringAsFixed(0)}"),
          _priceRow(
            "Total Discounts",
            "- ₹${_currentDiscount.toStringAsFixed(0)}",
            color: Colors.teal,
          ),
          const Divider(),
          _priceRow(
            "Order Total",
            "₹${_finalTotal.toStringAsFixed(0)}",
            isBold: true,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.teal.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.teal, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Yay! Your total discount is ₹${_currentDiscount.toStringAsFixed(0)}",
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: isBold ? Colors.black : Colors.grey[600]),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹${_finalTotal.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "VIEW PRICE DETAILS",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColors,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Place Order",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
