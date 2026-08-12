// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ai_masa/global/Global.dart';
import 'package:ai_masa/utils/colors.dart';
import 'PaymentMethodPage.dart';
import 'ProductDetailsPage.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isRefreshing = false;
  Map<String, String> selectedShippingAddress = GBL_selectedShippingAddress;

  // --- DYNAMIC CALCULATIONS ---
  double _calculateSubTotal() {
    double total = 0.0;
    for (var item in GBL_cartItemList) {
      total +=
          double.parse(item['regular_price'].toString()) *
          double.parse(item['quantity'].toString());
    }
    return total;
  }

  double _calculateTotalDiscount() {
    double discount = 0.0;
    for (var item in GBL_cartItemList) {
      if (item['sale_price'] != null &&
          double.parse(item['sale_price'].toString()) > 0) {
        double reg = double.parse(item['regular_price'].toString());
        double sale = double.parse(item['sale_price'].toString());
        discount += (reg - sale) * double.parse(item['quantity'].toString());
      }
    }
    return discount;
  }

  void _onConfirmButtonClicked() {
    double billAmount = _calculateSubTotal();
    double discountAmt = _calculateTotalDiscount();
    double netAmt = billAmount - discountAmt;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => PaymentMethodPage(
          orderData: {
            'bill_amt': billAmount,
            'discount_amt': discountAmt,
            'net_amt': netAmt,
            'shipping_address': selectedShippingAddress['id'],
            'items': GBL_cartItemList,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double subTotal = _calculateSubTotal();
    double totalDiscount = _calculateTotalDiscount();
    double finalAmount = subTotal - totalDiscount;

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
          'REVIEW YOUR ORDER', // Page Name Changed
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Column(
            children: [
              _buildStepper(),
              const SizedBox(height: 10),
              Container(color: Colors.green.withOpacity(0.1), height: 1),
            ],
          ),
        ),
      ),
      body: isRefreshing
          ? Center(child: CircularProgressIndicator(color: primaryColors))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddressSection(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Text(
                            'Order Summary:',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                        _buildProductList(), // Updated with Individual Totals
                        _buildPriceDetails(
                          subTotal,
                          totalDiscount,
                          finalAmount,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(finalAmount),
              ],
            ),
    );
  }

  // --- STEPPER WIDGET ---
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
              _stepCircle(Icons.check, true, true),
              _stepLine(true),
              _stepCircle(null, true, false, "3"),
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

  // --- ADDRESS SECTION ---
  Widget _buildAddressSection() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Text(
                "Delivery Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${selectedShippingAddress['full_name']}\n${selectedShippingAddress['address_line_1']}, ${selectedShippingAddress['city']}",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Change",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- PRODUCT LIST WITH INDIVIDUAL TOTALS ---
  Widget _buildProductList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: GBL_cartItemList.length,
      itemBuilder: (context, index) {
        var item = GBL_cartItemList[index];
        double price = double.parse(
          (item['sale_price'] != null &&
                      double.parse(item['sale_price'].toString()) > 0
                  ? item['sale_price']
                  : item['regular_price'])
              .toString(),
        );
        double qty = double.parse(item['quantity'].toString());
        double itemTotal = price * qty;

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(id: (item['product_id']).toString()),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 2),
            child: Row(
              children: [
                Image.network(
                  item['primary_img'],
                  width: 70,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['prod_name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Price: ₹${price.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                      Text(
                        "Qty: ${item['quantity']}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      "₹${itemTotal.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- PRICE DETAILS ---
  Widget _buildPriceDetails(double sub, double disc, double total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Price Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _row("Product Price", "₹${sub.toStringAsFixed(2)}"),
          _row(
            "Total Discount",
            "- ₹${disc.toStringAsFixed(2)}",
            color: Colors.teal,
          ),
          const Divider(),
          _row("Order Total", "₹${total.toStringAsFixed(2)}", isBold: true),
        ],
      ),
    );
  }

  Widget _row(String t, String v, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t),
          Text(
            v,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomBar(double total) {
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
              const Text(
                "Payable Amount",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                "₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _onConfirmButtonClicked,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColors,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text(
              "Continue",
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
