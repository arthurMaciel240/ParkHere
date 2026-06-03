import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class BookingsHistoryScreen extends StatefulWidget {
  const BookingsHistoryScreen({super.key});

  @override
  State<BookingsHistoryScreen> createState() => _BookingsHistoryScreenState();
}

class _BookingsHistoryScreenState extends State<BookingsHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<AppProvider>().loadBookings(userId: userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas reservas')),
      body: app.loading
          ? const Center(child: CircularProgressIndicator())
          : app.bookings.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Você ainda não tem reservas.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: app.bookings.length,
                  itemBuilder: (_, i) {
                    final b = app.bookings[i];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(b.lotName ?? 'Estacionamento',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: b.status == 'confirmed' ? Colors.green.shade100 : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    b.status == 'confirmed' ? 'Confirmada' : b.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: b.status == 'confirmed' ? Colors.green.shade800 : Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Vaga: ${b.spotName}'),
                            Text('Entrada: ${DateFormat('dd/MM/yy HH:mm').format(b.startTime)}'),
                            Text('Saída: ${DateFormat('dd/MM/yy HH:mm').format(b.endTime)}'),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total pago'),
                                Text('R\$ ${b.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
