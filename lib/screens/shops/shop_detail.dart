import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../api/api_service.dart';

class ShopDetailPage extends StatefulWidget {
  final int shopId;

  const ShopDetailPage({super.key, required this.shopId});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  final _apiService = ApiService();
  Map<String, dynamic>? shopData;
  List<dynamic> categoryData = [];
  List<dynamic> categoryAndProductData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShopDetails();
  }

  Future<void> _loadShopDetails() async {
    try {
      final data = await _apiService.getShopDetails(widget.shopId, context);
      final fetchedCategories =
          await _apiService.getShopCategories(widget.shopId, context);
      final fetchedCategoriesAndProducts = await _apiService.fetchCategoriesWithProducts(shopId: widget.shopId);
      print("SHOP DATA: ${data}");
      print("CATEGORY DATA: ${fetchedCategories}");
      print("CATEGORIES AND PRODUCTS: ${fetchedCategoriesAndProducts}");
      setState(() {
        shopData = data;
        categoryData = fetchedCategories;
        categoryAndProductData = fetchedCategoriesAndProducts;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading shop details: $e");
    }
  }

  List<Map<String, dynamic>> getParentCategories() {
    return categoryAndProductData
        .where((cat) => cat['parent'] == null)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  List<Map<String, dynamic>> getSubcategories(int parentId) {
    return categoryAndProductData
        .where((cat) => cat['parent'] == parentId)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  void _onAddCategory() {
    // Handle category add
  }

  void _onEditShop() {
    // Handle shop edit
  }

  void _onDeleteShop() {
    // Handle shop delete
  }

  Widget buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: getParentCategories().map<Widget>((parentCategory) {
        final parentProducts = parentCategory['products'] ?? [];
        final subcategories = getSubcategories(parentCategory['id']);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: ExpansionTile(
            title: Text(parentCategory['name'],
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(parentCategory['description'] ?? ""),
            childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              if (parentProducts.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: parentProducts.map<Widget>((product) {
                    return GestureDetector(
                      onTap: () {}, // Product detail
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: product['image'] != null
                                  ? Image.network(product['image'],
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.cover)
                                  : Container(
                                      height: 80,
                                      color: Colors.grey.shade200,
                                      child: Icon(Icons.shopping_bag)),
                            ),
                            SizedBox(height: 8),
                            Text(product['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                                "Ksh ${product['price']} - Qty: ${product['quantity']}",
                                style: TextStyle(fontSize: 12))
                          ],
                        ),
                      ),
                    ).animate().fade(duration: 500.ms).slideX(begin: 0.1);
                  }).toList(),
                ),
              ...subcategories.map<Widget>((subCat) {
                final subProducts = subCat['products'] ?? [];
                return ExpansionTile(
                        title: Text(subCat['name']),
                        subtitle: Text(subCat['description'] ?? ""),
                        children: subProducts.isEmpty
                            ? [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No products."),
                                )
                              ]
                            : [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: subProducts.map<Widget>((product) {
                                    return Container(
                                      width: 140,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: product['image'] != null
                                                ? Image.network(
                                                    product['image'],
                                                    height: 80,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover)
                                                : Container(
                                                    height: 80,
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                        Icons.shopping_bag)),
                                          ),
                                          SizedBox(height: 8),
                                          Text(product['name'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Ksh ${product['price']} - Qty: ${product['quantity']}",
                                              style: TextStyle(fontSize: 12))
                                        ],
                                      ),
                                    )
                                        .animate()
                                        .fade(duration: 500.ms)
                                        .slideX(begin: 0.1);
                                  }).toList(),
                                )
                              ])
                    .animate()
                    .fade(duration: 500.ms)
                    .slideY(begin: 0.1);
              }).toList(),
            ],
          ),
        ).animate().fade(duration: 600.ms).slideY(begin: 0.1);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop Details'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: _onEditShop),
          IconButton(icon: Icon(Icons.delete), onPressed: _onDeleteShop),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAddCategory,
        icon: Icon(Icons.add),
        label: Text("Add Category"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : shopData == null
              ? Center(child: Text("No data available"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(shopData!['name'],
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text("Location: ${shopData!['location']}"),
                              if (shopData!['description'] != null)
                                Text(
                                    "Description: ${shopData!['description']}"),
                              SizedBox(height: 10),
                              Text("Attendants:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              ...(shopData!['attendants'] as List<dynamic>)
                                  .map<Widget>(
                                      (a) => Text("• ${a['username']}")),
                            ],
                          ),
                        ),
                      ).animate().fade(duration: 500.ms).slideY(begin: 0.2),
                      SizedBox(height: 20),
                      Text("Categories",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      buildCategorySection(),
                    ],
                  ),
                ),
    );
  }
}
