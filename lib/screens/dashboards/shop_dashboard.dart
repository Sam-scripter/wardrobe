import 'package:flutter/material.dart';

class ShopDashboard extends StatefulWidget {
  final int shopId;
  final String shopName;
  const ShopDashboard({super.key, required this.shopId, required this.shopName});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Shop Dashboard'),
      ),
    );
  }
}
