import 'package:flutter/material.dart';

import 'map_screen.dart';
import 'events_screen.dart';
import 'bookings_history_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _index = 0;

  final _pages = const [
    MapScreen(),
    EventsScreen(),
    BookingsHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Mapa'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Eventos'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Reservas'),
        ],
      ),
    );
  }
}
