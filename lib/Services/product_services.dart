import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:ai_masa/global/Global.dart';

class ProductServices {
  // static Future<dynamic> fetchproduct() async {
  //   final url = '$API_BASE_URL/get_publish_products';
  //   final uri = Uri.parse(url);
  //   final response = await http.get(
  //     uri,
  //     headers: {"Authorization": "Bearer $app_auth_token"},
  //   );
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     final response_data = jsonDecode(response.body) as Map;
  //     return response_data;
  //   } else {
  //     return null;
  //   }
  // }

  static Future<dynamic> fetchproduct() async {
    final url = '$API_BASE_URL/get_publish_products';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $app_auth_token"},
      );
      if (response.statusCode == 200) {
        try {
          final response_data = jsonDecode(response.body) as Map;
          return response_data;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> CategoriesData() async {
    final url = '$API_BASE_URL/categories';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $app_auth_token"},
      );
      if (response.statusCode == 200) {
        try {
          final response_data = jsonDecode(response.body) as Map;
          return response_data;
        } catch (e) {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> CategoriesChildData(id) async {
    final url = '$API_BASE_URL/get_category_details/$id';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;

      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> get_product_details(id) async {
    final url = '$API_BASE_URL/get_product_details/$id';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;

      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> add_to_cart(api_data) async {
    final url = '$API_BASE_URL/add_to_cart';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
      body: jsonEncode(api_data),
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;

      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> get_customer_cart() async {
    final url = '$API_BASE_URL/get_customer_cart';
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> get_customer_shipping_addresses() async {
    final url = '$API_BASE_URL/get_customer_shipping_addresses';
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> add_customer_shipping_addresses(add_data) async {
    final url = '$API_BASE_URL/add_customer_shipping_addresses';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
      body: jsonEncode(add_data),
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;

      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> delete_cart_item(cart_id) async {
    final url = '$API_BASE_URL/delete_cart_item/$cart_id';
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> delete_customer_shipping_addresses(address_id) async {
    final url = '$API_BASE_URL/delete_customer_shipping_addresses/$address_id';
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> order_confirm(confirm_data) async {
    final url = '$API_BASE_URL/create_order';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
      body: jsonEncode(confirm_data),
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;

      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> order(orderId) async {
    final url = '$API_BASE_URL/order/$orderId';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> wishlist() async {
    final url = '$API_BASE_URL/get_customer_wishlist';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> profile_details() async {
    final url = '$API_BASE_URL/get_customer_details';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> get_my_orders() async {
    final url = '$API_BASE_URL/get_my_orders';
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $app_auth_token"},
    );

    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> add_to_wishlist(wishlistData) async {
    final url = '$API_BASE_URL/add_to_wishlist';
    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
      body: jsonEncode(wishlistData),
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }

  static Future<dynamic> delete_wishlist_item(id) async {
    final url = '$API_BASE_URL/delete_wishlist_item/$id';
    final uri = Uri.parse(url);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $app_auth_token",
      },
    );
    if (response.statusCode == 200) {
      final response_data = jsonDecode(response.body) as Map;
      return response_data;
    } else {
      return null;
    }
  }
}
