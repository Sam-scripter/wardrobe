import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:wardrobe_app/screens/auth/login.dart';
import 'package:wardrobe_app/screens/shops/shop_detail.dart';
import '../../api/api_service.dart';
import '../../components/overview_card.dart';
import '../shops/add_shop.dart';

class AdminDashboard extends StatefulWidget {
  final data;

  const AdminDashboard(
      {super.key, required this.data});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int currentPageIndex = 0;
  final _apiService = ApiService();

  // List of titles corresponding to each page
  final List<String> _appBarTitles = [
    'Wardrobe Admin',
    'My Shops',
    'Sales',
    'My Profile',
  ];
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Color(0xFF111328),
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blueAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shop),
            label: 'Shops',
          ),
          NavigationDestination(
            icon: Icon(Icons.monetization_on),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      appBar: AppBar(
        // Dynamically change the title based on the current page index
        title: Text(
          _appBarTitles[currentPageIndex],
          style: GoogleFonts.poppins(
            fontSize: 20,
          ),
        ),
        actions: [
          NotificationIconButton(
            unreadCount: 5,
          ),
          IconButton(
            onPressed: () async {
              await _apiService.logout(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: <Widget>[
        // Home Page (Dashboard)
        DashboardHome(),
        // Shops Page
        ShopsPage(admin: widget.data['username'],),
        // Sales Page
        SalesPage(),
        // Profile Page
        ProfilePage(profile: widget.data,),
      ][currentPageIndex],
    );
  }
}

class NotificationIconButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback? onPressed;

  const NotificationIconButton({
    super.key,
    required this.unreadCount,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: const Icon(Icons.notifications),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({Key? key}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSlide(
              offset: _visible ? Offset.zero : const Offset(0, 0.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: _visible ? 1.0 : 0.0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Overview",
                          style:
                              TextStyle(color: Colors.white70, fontSize: 16)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          OverviewItem(
                              value: "Ksh 200,000", label: "Revenue Today"),
                          OverviewItem(value: "30", label: "Sales Today"),
                          OverviewItem(value: "7", label: "Orders Today"),
                          OverviewItem(value: "5", label: "Low Inventory"),
                          OverviewItem(value: "3", label: "Active Shops"),
                          OverviewItem(value: "7", label: "Attendants"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            // Quick Action Cards (you can also animate them similarly)
            Text("Quick Actions",
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: [
                buildActionCard(
                    Icons.receipt_long, "Orders", Colors.teal, () {}),
                buildActionCard(
                    Icons.monetization_on, "Sales", Colors.green, () {}),
                buildActionCard(Icons.store, "Shops", Colors.blue, () {}),
                buildActionCard(
                    Icons.inventory_2, "Inventory", Colors.orange, () {}),
                buildActionCard(
                    Icons.people, "Attendants", Colors.purple, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ShopsPage extends StatefulWidget {
  final String admin;

  const ShopsPage({super.key, required this.admin});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final _apiService = ApiService();
  List<Map<String, dynamic>> shops = [];

  @override
  void initState() {
    super.initState();
    _fetchShops();
  }

  Future<void> _fetchShops() async {
    try{

      List<Map<String, dynamic>> fetchedShops = await _apiService.getShops(context);

      for (var shop in fetchedShops) {
        if (shop['admin']['username'] != widget.admin) {
          fetchedShops.remove(shop);
        }
      }
      setState(() {
        shops = fetchedShops;
      });

    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(shop['name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(shop['location']),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to shop details or management page
                Navigator.push(context, MaterialPageRoute(builder: (context) => ShopDetailPage(shopId: shop['id'])));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          // Navigate to add new shop page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddShopPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final List<Map<String, dynamic>> sales = [
    {'id': 1, 'date': '2025-03-22', 'amount': 200.0, 'customer': 'John Doe'},
    {'id': 2, 'date': '2025-03-21', 'amount': 150.0, 'customer': 'Jane Smith'},
    {
      'id': 3,
      'date': '2025-03-20',
      'amount': 300.0,
      'customer': 'Alice Johnson'
    },
    {'id': 4, 'date': '2025-03-24', 'amount': 90.0, 'customer': 'Michael Kim'},
    {'id': 5, 'date': '2025-03-23', 'amount': 220.0, 'customer': 'Grace Paul'},
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));

    final todaySales = sales.where((s) => s['date'] == today).toList();
    final yesterdaySales = sales.where((s) => s['date'] == yesterday).toList();
    final allSales = sales;

    double sum(List<Map<String, dynamic>> list) {
      return list.fold(0.0, (prev, e) => prev + (e['amount'] as double));
    }

    Widget buildSaleTile(Map<String, dynamic> sale) {
      return SlideInUp(
        duration: const Duration(milliseconds: 300),
        child: Card(
          color: const Color(0xFF1D1E33),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text('\$${sale['amount'].toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            subtitle: Text('${sale['date']} - ${sale['customer']}',
                style: const TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios,
                color: Colors.white70, size: 16),
            onTap: () {
              // Navigate to detail page
            },
          ),
        ),
      );
    }

    Widget buildSalesCard(String title, List<Map<String, dynamic>> items) {
      return FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 12),
              if (items.isEmpty)
                const Text('No sales found',
                    style: TextStyle(color: Colors.white38)),
              ...items.map(buildSaleTile).toList(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSalesCard('Today', todaySales),
              buildSalesCard('Yesterday', yesterdaySales),
              buildSalesCard('All Sales', allSales),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> profile;
  const ProfilePage({super.key, required this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Dummy profile data (replace with backend data)


  File? _profileImage;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _viewImage() {
    if (_profileImage == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: InteractiveViewer(
          child: Image.file(_profileImage!, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GestureDetector(
                  onTap: _viewImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/default_profile.jpg')
                            as ImageProvider,
                  ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 20, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.profile['username'],
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              widget.profile['role'],
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),

            // Profile Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoTile('Name', '${widget.profile['first_name']} ${widget.profile['last_name']}'),
                  _infoTile('Email', widget.profile['email']),
                  _infoTile('Phone', '0712345678'),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Navigate to UpdateProfilePage
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          Expanded(
              child: Text(value, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}








// Card(
// elevation: 4,
// color: Color(0xFF111328),
// margin: EdgeInsets.only(bottom: 16),
// child: ListTile(
// title: Text(shop['name'],
// style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// subtitle: Text(shop['location']),
// trailing: Icon(Icons.arrow_forward_ios),
// onTap: () {
// // Navigate to shop details or management page
// Navigator.push(context, MaterialPageRoute(builder: (context) => ShopDetailPage(shopId: shop['id'])));
// },
// ),
// );