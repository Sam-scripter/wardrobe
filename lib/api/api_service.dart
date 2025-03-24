import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.1.145:8000';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async{
    String? accessToken = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response, BuildContext context) async{
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 205) {
      return jsonDecode(response.body);
    }
    else if(response.statusCode == 206){
      return jsonDecode(response.body);
    }
    else if(response.statusCode == 401){
      await logout(context);
      throw Exception('Unauthorised');
    }
    else {
      throw Exception('Failed to perform operation: ${response.body}');
    }
  }

  // Register a new user
  Future<Map<String, dynamic>> registerUser(
      String username, String password, String email, String firstName, String lastName, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/register/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'email':email, 'first_name':firstName, 'last_name': lastName,}),
    );
    return await _handleResponse(response, context);
  }

  Future<Map<String, dynamic>> registerAdmin(
      String username, String password, String email, String firstName, String lastName, String? shop, String role, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/register/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'email':email, 'first_name':firstName, 'last_name': lastName, 'shop': shop, 'role': role}),
    );
    return await _handleResponse(response, context);
  }



  // Login a user
  Future<Map<String, dynamic>> loginUser(String username, String password, context) async {
    print("loginUser: Starting login request");
    final url = Uri.parse('$_baseUrl/api/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    print("loginUser: Response received");
    // print(response.body);

    Map<String, dynamic> data = await _handleResponse(response, context);
    print("loginUser: Response processed");

    if (data.containsKey("access")) {
      print("loginUser: access token found, calling saveTokens");
      await _saveTokens(data['access'], data['refresh']);
      print("loginUser: Token save complete, returning");
    } else {
      print('loginUser: NO DATA FOUND');
    }
    print("loginUser: method returning");
    print(data['username']);
    
    return data;
  }

  Future<void> _saveTokens(String access, String refresh) async {
    print("_saveTokens: Started saving tokens");
    try {
      await _storage.write(key: 'access_token', value: access);
      await _storage.write(key: 'refresh_token', value: refresh);
      print("_saveTokens: Successfully saved tokens");
    } catch (e) {
      print("_saveTokens: Error saving tokens: $e");
      // Handle exception - notify the user, logout etc
      throw Exception("Failed to save tokens");
    }
  }

  // Logout a user
  Future<void> logout(BuildContext context) async {
    print("logout: Start logout request");
    // Attempt to read the refresh token (it might not exist)
    String? refresh = await _storage.read(key: 'refresh_token');


    // If a refresh token exists, attempt to invalidate it on the backend
    if (refresh != null) {
      print("logout: refresh token found, attempting logout via API");
      final url = Uri.parse('$_baseUrl/api/logout/');
      try {
        final response = await http.post(
          url,
          headers: await _getHeaders(),
          body: jsonEncode({'refresh': refresh}),
        );
        if (response.statusCode == 205) {
          print("logout: Logout success via API");
        } else {
          print("logout: Logout failed via API: ${response.body}");
          // If logout fails, print to log but continue anyway.
        }
      } catch (e) {
        print("logout: Exception during logout API call: $e");
        //Log exception but continue anyway.
      }
    }
    // Always clear local tokens and navigate to the login page
    print("logout: Clearing local tokens and redirecting to login page.");
    await _clearTokens();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    print("logout: force logout completed");
  }

  // logout button
  // Logout a user
  Future<void> logoutButton(BuildContext context) async {
    print("logoutButton: Start force logout request");

    // Attempt to read the refresh token (it might not exist)
    String? refresh = await _storage.read(key: 'refresh_token');


    // If a refresh token exists, attempt to invalidate it on the backend
    if (refresh != null) {
      print("logoutButton: refresh token found, attempting logout via API");
      // print("logoutButton: Refresh token: $refresh");
      // print("logoutButton: Sending request data: ${jsonEncode({'refresh': refresh})}");
      final url = Uri.parse('$_baseUrl/api/logout/');
      try {
        final response = await http.post(
          url,
          headers: await _getHeaders(),
          body: jsonEncode({'refresh': refresh}),
        );
        if (response.statusCode == 205) {
          print("logoutButton: Logout success via API");
        } else {
          print("logoutButton: Logout failed via API: ${response.body}");
          // If logout fails, print to log but continue anyway.
        }
      } catch (e) {
        print("logoutButton: Exception during logout API call: $e");
        //Log exception but continue anyway.
      }
    }
    // Always clear local tokens and navigate to the login page
    print("logoutButton: Clearing local tokens and redirecting to login page.");
    await _clearTokens();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    print("logoutButton: force logout completed");
  }



  // Change user password
  Future<Map<String, dynamic>> changePassword(String oldPassword, String newPassword, context) async {
    final url = Uri.parse('$_baseUrl/api/change-password/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'old_password': oldPassword, 'new_password': newPassword}),
    );
    return await _handleResponse(response, context);
  }


  Future<Map<String, dynamic>> getUserDetails(BuildContext context, int userId) async {
    final url = Uri.parse('$_baseUrl/api/user-details/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponse(response, context);
  }

  Future<Map<String, dynamic>> getUserDetail(int userId, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/user-details/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponse(response, context);
  }

  Future<List<Map<String, dynamic>>> getUsersDetails(BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/users-details/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponseList(response, context);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  //Check if user is logged in using stored access token
  Future<bool> isLoggedIn() async {
    String? accessToken = await _storage.read(key: 'access_token');

    if (accessToken == null) {
      return false; // No access token found
    }

    try{
      return !JwtDecoder.isExpired(accessToken);
    }catch(e){
      return false;
    }
  }

  Future<Map<String, dynamic>> createShop(
      String name, String location, String? description, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/');
      List<Map<String, dynamic>> fetchedShops = await getShops(context);
      for (var shop in fetchedShops) {
        if (shop['name'] == name) {
          throw Exception('Shop with the same name already exists');
        }
      }
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({
          'name': name,
          'location': location,
          'description': description,
        }),
      );
      return await _handleResponse(response, context);
  }

  Future<List<Map<String, dynamic>>> getShops(BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponseList(response, context);
  }

  Future<Map<String, dynamic>> getShopDetails(int shopId, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/');
    final response = await http.get(url, headers: await _getHeaders());
    print("SHOP DETAIL: ${response.body}");
    return await _handleResponse(response, context);
  }

  Future<List<dynamic>> getShopCategories(int shopId, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/categories/shop/$shopId/');

    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      print('CATEGORIES RESPONSE: ${json.decode(response.body)}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories for shop');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoriesWithProducts({
    required int shopId,
  }) async {
    final url = Uri.parse('$_baseUrl/api/categories/shop/$shopId/');

    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Fetched Data and returning: $data");
      return data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load categories with products');
    }
  }





  Future<List<Map<String, dynamic>>> _handleResponseList(http.Response response, BuildContext context) async{
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 205) {
      print('RESPONSE: ${List<Map<String, dynamic>>.from(jsonDecode(response.body))}');
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    else if(response.statusCode == 206){
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
    else if(response.statusCode == 401){
      await logout(context);
      throw Exception('Unauthorised');
    }
    else {
      throw Exception('Failed to perform operation: ${response.body}');
    }
  }


  Future<void> deleteShop(int shopId) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/');
    final response = await http.delete(url, headers: await _getHeaders());
    if(response.statusCode != 200 && response.statusCode != 204){
      throw Exception("Failed to delete shop ${response.body}");
    }
  }

  Future<bool> isAdmin(BuildContext context, int id) async {
    Map<String, dynamic> userDetails = await getUserDetails(context, id);
    String? role = userDetails['profile']['role'];
    return role == 'Admin';
  }

  Future<Map<String, dynamic>> updateShopDetails(int shopId, Map<String, dynamic> data, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/');
    final response = await http.patch(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(data)
    );
    return await _handleResponse(response, context);
  }

  Future<List<Map<String, dynamic>>> getShopInventory(int shopId, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/inventory-list/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponseList(response, context);
  }

  Future<List<Map<String, dynamic>>> getShopOrders(int shopId, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/orders-list/');
    final response = await http.get(url, headers: await _getHeaders());
    return await _handleResponseList(response, context);
  }

  Future<Map<String, dynamic>> createShopItem(int shopId, String name, double price, int stock, String description, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/inventory/');
    final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({'name': name, 'price': price, 'stock': stock, 'description': description})
    );
    return await _handleResponse(response, context);
  }

  Future<Map<String, dynamic>> createShopOrder(
      int shopId,
      String customerName,
      String customerPhone,
      String customerLocation,
      List<Map<String, dynamic>> items,
      BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/create-order/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'customer_name': customerName,
        'customer_phone': customerPhone,
        'customer_location': customerLocation,
        'items': items, // Send names and quantities
      }),
    );
    return await _handleResponse(response, context);
  }




  Future<void> deleteShopItem(int shopId, int itemId) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/inventory/$itemId/');
    final response = await http.delete(url, headers: await _getHeaders());
    if(response.statusCode != 200 && response.statusCode != 204){
      throw Exception("Failed to delete item ${response.body}");
    }
  }

  Future<void> addItem(int shopId, int itemId) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/inventory/$itemId/add/');
    final response = await http.patch(url, headers: await _getHeaders());
    if(response.statusCode != 200 && response.statusCode != 204){
      throw Exception("Failed to add item ${response.body}");
    }
  }

  Future<void> subtractItem(int shopId, int itemId) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/inventory/$itemId/subtract/');
    final response = await http.patch(url, headers: await _getHeaders());
    if(response.statusCode != 200 && response.statusCode != 204){
      throw Exception("Failed to subtract item ${response.body}");
    }
  }

  Future<void> changeOrderStatus(int shopId, int orderId, String status) async {
    final url = Uri.parse('$_baseUrl/api/shops/$shopId/orders/$orderId/');
    final response = await http.patch(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update order status: ${response.body}");
    }
  }

  Future<void> checkoutSale(
      int shopId,
      List<Map<String, dynamic>> cartItems,
      double totalAmount,
      String modeOfPayment,
      bool isComplete,
      BuildContext context) async {
    final url = Uri.parse('$_baseUrl/api/shops/checkout/');

    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        "shop": shopId,
        "items": cartItems.map((item) {
          return {
            "item": item['id'],
            "quantity": item['quantity'],
            "price": item['price']
          };
        }).toList(),
        "total_amount": totalAmount,
        "mode_of_payment": modeOfPayment,
        "is_complete": isComplete,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to complete sale: ${response.body}');
    }
  }



  Future<List<dynamic>> fetchSales(int? shopId) async {
    final response = await http.get(Uri.parse("$_baseUrl/api/shops/fetch-sales/$shopId/"), headers: await _getHeaders(),);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch sales: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchSaleDetails(int saleId) async {
    final response = await http.get(Uri.parse("$_baseUrl/api/shops/$saleId/fetch-sale-detail/"), headers: await _getHeaders());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch sale details: ${response.body}");
    }
  }

  Future<List<dynamic>> fetchIncompleteSales(int? shopId) async {
    final url = Uri.parse('$_baseUrl/api/shops/fetch-incomplete-sales/');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch incomplete sales");
    }
  }

  Future<void> completeSale(int saleId, String modeOfPayment) async {
    final url = Uri.parse('$_baseUrl/api/shops/$saleId/complete-sale/');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({'mode_of_payment': modeOfPayment}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to complete sale");
    }
  }



  Future<List<Map<String, dynamic>>> fetchRefunds(int shopId) async {
    final response = await http.get(Uri.parse("$_baseUrl/api/shops/$shopId/refunds/"), headers: await _getHeaders());

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch refunds");
    }
  }

  Future<void> createRefund(Map<String, dynamic> refundData, int shopId) async {
    final response = await http.post(Uri.parse("$_baseUrl/api/shops/$shopId/refund/"),
        headers: await _getHeaders(),
        body: json.encode(refundData));

    if (response.statusCode != 201) {
      throw Exception("Failed to create refund");
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecentActivities(int shopId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/api/shops/$shopId/recent_activities/"),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Failed to load recent activities");
    }
  }


}

