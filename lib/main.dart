import 'package:flutter/material.dart';

void main() {
  runApp(const OOTDApp());
}

class OOTDApp extends StatelessWidget {
  const OOTDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OOTD AI',
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OOTD AI"),
      ),
        body: GridView.count(
    padding: const EdgeInsets.all(16),
    crossAxisCount: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    children: [
      Card(
        child: InkWell(
          onTap: () {},
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.checkroom, size: 50),
              SizedBox(height: 10),
              Text("My Closet"),
            ],
          ),
        ),
      ),
      Card(
        child: InkWell(
          onTap: () {},
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_laundry_service, size: 50),
              SizedBox(height: 10),
              Text("Laundry"),
            ],
          ),
        ),
      ),
      Card(
        child: InkWell(
          onTap: () {},
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 50),
              SizedBox(height: 10),
              Text("Today's Outfit"),
            ],
          ),
        ),
      ),
      Card(
        child: InkWell(
          onTap: () {},
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 50),
              SizedBox(height: 10),
              Text("History"),
            ],
          ),
        ),
      ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
    );
  }
}