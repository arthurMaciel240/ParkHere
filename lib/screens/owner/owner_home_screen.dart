import 'package:flutter/material.dart';

import 'parking_lots_screen.dart';
import 'owner_bookings_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  int _index = 0;

  final _pages = const [
    ParkingLotsScreen(),
    OwnerBookingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.business), label: 'Estacionamentos'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Reservas'),
        ],
      ),
    );
  }
}
