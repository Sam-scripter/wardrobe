import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wardrobe_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:wardrobe_app/screens/auth/login.dart';
import 'package:wardrobe_app/screens/dashboards/admin_dashboard.dart';
import 'package:wardrobe_app/screens/dashboards/homepage.dart';
import 'package:wardrobe_app/screens/dashboards/splash_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const System(),
    ),
  );
}

class System extends StatelessWidget {
  const System({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          color: const Color(0xFF0A0D22),
          systemOverlayStyle:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        ),
        scaffoldBackgroundColor: const Color(0xFF0A0D22),
      ),
      home: SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}