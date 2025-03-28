import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wardrobe_app/screens/auth/login.dart';
import 'package:wardrobe_app/screens/dashboards/admin_dashboard.dart';
import '../../api/api_service.dart';
import '../../components/overview_card.dart';
import '../profile/profile.dart';
import '../shops/shops.dart';

class SuperUserDashboard extends StatefulWidget {
  final data;

  const SuperUserDashboard({super.key, required this.data});

  @override
  State<SuperUserDashboard> createState() => _SuperUserDashboardState();
}

class _SuperUserDashboardState extends State<SuperUserDashboard> {
  int currentPageIndex = 0;
  final _apiService = ApiService();
  late List<String> _appBarTitles = [];
  late List<Widget> bottomNav = [];

  Future<void> _getAppBarTitles() async {
    if (widget.data["role"] == "SuperUser") {
      setState(() {
        _appBarTitles = [
          'Wardrobe SuperUser',
          'Shops',
          'Users',
          'My Profile',
        ];
        bottomNav = [
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
            icon: Icon(Icons.people_alt_rounded),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      });
    } else if (widget.data["role"] == "Admin") {
      setState(() {
        _appBarTitles = [
          'Wardrobe Admin',
          'Shops',
          'Sales',
          'My Profile',
        ];
        bottomNav = [
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
            icon: Icon(Icons.people_alt_rounded),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      });
    } else if (widget.data["role"] == "Attendant") {
      setState(() {
        _appBarTitles = [
          'Wardrobe Attendant',
          'Shops',
          'Sales',
          'My Profile',
        ];
        bottomNav = [
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
            icon: Icon(Icons.people_alt_rounded),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ];
      });
    }
  }

  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
    print("DATA HERE: ${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black26,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFF1A2B3C),
        selectedIndex: currentPageIndex,
        destinations: bottomNav,
      ),
      appBar: AppBar(
        backgroundColor: Colors.black26,
        // Dynamically change the title based on the current page index
        title: Text(
          _appBarTitles[currentPageIndex],
          style: GoogleFonts.acme(
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
        ShopsPage(
          //TODO: Pass user and role to ShopsPage
          user: widget.data['username'],
          role: widget.data['role'],
        ),
        widget.data["role"] == "SuperUser" ? UsersPage() : SalesPage(),

        ProfilePage(
          profile: widget.data,
        ),
        // Profile Page
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
  final data;
  const DashboardHome({Key? key, this.data}) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with SingleTickerProviderStateMixin {
  bool _visible = false;
  late List<Widget> overviewItems = [];
  late List<Widget> actionCards = [];

  Future<void> _getOverviewItems() async {
    if (widget.data["role"] == "SuperUser") {
      setState(() {
        overviewItems = [
          OverviewItem(value: "12", label: "Shops"),
          OverviewItem(value: "420", label: "Total Sales"),
          OverviewItem(value: "4", label: "Pending Approvals"),
          OverviewItem(value: "67", label: "Users"),
        ];
        actionCards = [
          buildActionCard(Icons.store_mall_directory, "Manage Shops",
              Colors.white70, () {}),
          buildActionCard(
              Icons.people_alt, "Manage Users", Colors.white70, () {}),
          buildActionCard(Icons.approval, "Approvals", Colors.white70, () {}),
          buildActionCard(Icons.admin_panel_settings, "Assign Roles",
              Colors.white70, () {}),
        ];
      });
    } else if (widget.data["role"] == "Admin") {
      setState(() {
        overviewItems = [
          OverviewItem(value: "Ksh 200,000", label: "Revenue Today"),
          OverviewItem(value: "30", label: "Sales Today"),
          OverviewItem(value: "7", label: "Orders Today"),
          OverviewItem(value: "5", label: "Low Inventory"),
          OverviewItem(value: "3", label: "Active Shops"),
          OverviewItem(value: "7", label: "Attendants"),
        ];
        actionCards = [
          buildActionCard(Icons.receipt_long, "Orders", Colors.white70, () {}),
          buildActionCard(
              Icons.monetization_on, "Sales", Colors.white70, () {}),
          buildActionCard(Icons.store, "Shops", Colors.white70, () {}),
          buildActionCard(
              Icons.inventory_2, "Inventory", Colors.white70, () {}),
          buildActionCard(Icons.people, "Attendants", Colors.white70, () {}),
        ];
      });
    } else if (widget.data["role"] == "Attendant") {
      setState(() {
        overviewItems = [];
        actionCards = [
          buildActionCard(Icons.receipt_long, "Orders", Colors.white70, () {}),
          buildActionCard(
              Icons.monetization_on, "Sales", Colors.white70, () {}),
          buildActionCard(Icons.store, "Shops", Colors.white70, () {}),
          buildActionCard(
              Icons.inventory_2, "Inventory", Colors.white70, () {}),
          buildActionCard(Icons.people, "Attendants", Colors.white70, () {}),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _visible = true;
      });
    });
    _getOverviewItems();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data["role"] == "Attendant" ||
                    widget.data["role"] == "Customer"
                ? Container()
                : AnimatedSlide(
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
                            colors: [Color(0xFF0F2027), Color(0xFF1A2B3C)],
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
                            const Text("Platform Overview",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: overviewItems,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            const SizedBox(height: 30),
            // Quick Action Cards (you can also animate them similarly)
            widget.data["role"] == "Attendant" || widget.data["role"] == "Admin"
                ? Text("Quick Actions",
                    style: Theme.of(context).textTheme.titleLarge)
                : Text("Admin Tools",
                    style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> users = [];
  String searchQuery = "";

  Map<String, bool> expanded = {
    'SuperUser': false,
    'Admin': false,
    'Attendant': false,
    'Customer': false,
  };

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final fetchedUsers = await _apiService.getUsersDetails(context);
    setState(() {
      users = fetchedUsers;
    });
  }

  List<Map<String, dynamic>> filterUsersByRole(String role) {
    final filtered = users.where((user) {
      final matchesRole = user['profile']['role'] == role;
      final name = "${user['first_name']} ${user['last_name']}".toLowerCase();
      final username = user['username'].toLowerCase();
      final contact = user['profile']['contact']?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();

      final matchesSearch = name.contains(query) ||
          username.contains(query) ||
          contact.contains(query);

      return matchesRole && (searchQuery.isEmpty || matchesSearch);
    }).toList();

    return filtered;
  }

  Widget buildUserCard(Map<String, dynamic> user) {
    final name = "${user['first_name']} ${user['last_name']}".trim().isEmpty
        ? user['username']
        : "${user['first_name']} ${user['last_name']}";
    final role = user['profile']['role'];
    final contact = user['profile']['contact'] ?? 'No contact';
    final image = user['profile']['image'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1A2B3C),
          radius: 25,
          backgroundImage: image != null ? NetworkImage(image) : null,
          child: image == null
              ? Text(name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 20))
              : null,
        ),
        title: Text(name,
            style: const TextStyle(fontSize: 15, color: Colors.white)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2B3C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(role,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ),
        onTap: () {
          // TODO: Navigate to user detail or edit page
        },
      ),
    );
  }

  Widget buildUserSection(String title, List<Map<String, dynamic>> items) {
    final isExpanded = expanded[title]!;
    final shownItems = isExpanded ? items : items.take(10).toList();

    return FadeInUp(
      duration: const Duration(milliseconds: 500),
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
            Text(title, style: GoogleFonts.aBeeZee(fontSize: 16)),
            const SizedBox(height: 12),
            if (items.isEmpty)
              const Text('No users found',
                  style: TextStyle(color: Colors.white38)),
            ...shownItems.map(buildUserCard).toList(),
            if (items.length > 10)
              TextButton(
                onPressed: () {
                  setState(() {
                    expanded[title] = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'View Less' : 'View All (${items.length})',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            if (items.length <= 10)
              Text(
                'Total: ${items.length}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final superUsers = filterUsersByRole('SuperUser');
    final admins = filterUsersByRole('Admin');
    final attendants = filterUsersByRole('Attendant');
    final customers = filterUsersByRole('Customer');

    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchUsers,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.white38),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),

                buildUserSection('SuperUser', superUsers),
                buildUserSection('Admin', admins),
                buildUserSection('Attendant', attendants),
                buildUserSection('Customer', customers),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
