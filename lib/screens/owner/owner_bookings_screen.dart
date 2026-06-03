import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class OwnerBookingsScreen extends StatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  State<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends State<OwnerBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ownerId = context.read<AuthProvider>().user?.id;
      if (ownerId != null) {
        context.read<AppProvider>().loadParkingLots(ownerId: ownerId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final lots = app.parkingLots;

    return Scaffold(
      appBar: AppBar(title: const Text('Reservas recebidas')),
      body: lots.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Cadastre um estacionamento para ver reservas.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: lots.length,
              itemBuilder: (_, i) {
                final lot = lots[i];
                return FutureBuilder(
                  future: context.read<AppProvider>().fetchBookings(lotId: lot.id),
                  builder: (context, snap) {
                    final bookings = snap.data ?? [];
                    if (bookings.isEmpty) return const SizedBox.shrink();
                    return Card(
                      child: ExpansionTile(
                        title: Text(lot.name),
                        subtitle: Text('${bookings.length} reserva(s)'),
                        children: bookings.map((b) {
                          return ListTile(
                            dense: true,
                            title: Text('Vaga ${b.spotName}'),
                            subtitle: Text('${DateFormat('dd/MM/yy HH:mm').format(b.startTime)} - ${DateFormat('dd/MM/yy HH:mm').format(b.endTime)}'),
                            trailing: Text('R\$ ${b.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
