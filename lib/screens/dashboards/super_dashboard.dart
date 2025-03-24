import 'package:flutter/material.dart';

class SuperDashboard extends StatefulWidget {
  const SuperDashboard({super.key});

  @override
  State<SuperDashboard> createState() => _SuperDashboardState();
}

class _SuperDashboardState extends State<SuperDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('Super Dashboard'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the SuperUser Dashboard'),
      ),
    );
  }
}
