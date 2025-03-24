import 'package:flutter/material.dart';

class CustomerDashboard extends StatefulWidget {
  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start animations
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wardrobe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Navigate to search page
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to notifications page
            },
          ),
        ],
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner with Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildHeroBanner(),
              ),
            ),
            SizedBox(height: 20),

            // Categories Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _buildCategories(),
            SizedBox(height: 20),

            // Trending Items Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Trending Now', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _buildTrendingItems(),
            SizedBox(height: 20),

            // New Arrivals Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('New Arrivals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _buildNewArrivals(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/banner1.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          'New Collection 2023',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
            Shadow(
            blurRadius: 10,
            color: Colors.black,
            offset: Offset(2, 2),
            )],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Shoes', 'icon': Icons.shopping_bag, 'color': Colors.blue},
      {'name': 'Jackets', 'icon': Icons.checkroom, 'color': Colors.red},
      {'name': 'Shirts', 'icon': Icons.face_retouching_natural, 'color': Colors.green},
      {'name': 'Sweaters', 'icon': Icons.thermostat, 'color': Colors.orange},
      {'name': 'T-Shirts', 'icon': Icons.tag_faces, 'color': Colors.purple},
      {'name': 'Innerwear', 'icon': Icons.inventory, 'color': Colors.teal},

    ];

    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: category['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(category['icon'], size: 40, color: category['color']),
                ),
                SizedBox(height: 8),
                Text(category['name'], style: TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingItems() {
    final List<String> trendingItems = [
      'assets/item1.jpg',
      'assets/item2.jpg',
      'assets/item3.jpg',
      'assets/item4.jpg',
    ];

    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(trendingItems[index], width: 150, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewArrivals() {
    final List<String> newArrivals = [
      'assets/item5.jpg',
      'assets/item6.jpg',
      'assets/item7.jpg',
      'assets/item8.jpg',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: newArrivals.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(newArrivals[index], fit: BoxFit.cover),
        );
      },
    );
  }
}