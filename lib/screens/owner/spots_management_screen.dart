import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../models/spot_model.dart';
import '../../providers/app_provider.dart';
import 'spot_form_screen.dart';

class SpotsManagementScreen extends StatefulWidget {
  final ParkingLotModel lot;

  const SpotsManagementScreen({super.key, required this.lot});

  @override
  State<SpotsManagementScreen> createState() => _SpotsManagementScreenState();
}

class _SpotsManagementScreenState extends State<SpotsManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadSpots(widget.lot.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Vagas - ${widget.lot.name}')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SpotFormScreen(lotId: widget.lot.id)),
        ),
        child: const Icon(Icons.add),
      ),
      body: app.loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
              ),
              itemCount: app.spots.length,
              itemBuilder: (_, i) {
                final spot = app.spots[i];
                return Card(
                  color: spot.bookedSlots.isEmpty ? Colors.green.shade50 : Colors.orange.shade50,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SpotFormScreen(lotId: widget.lot.id, spot: spot)),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            spot.type == 'coberta' ? Icons.garage : Icons.local_parking,
                            size: 32,
                            color: spot.bookedSlots.isEmpty ? AppTheme.secondaryColor : Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(spot.type, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          if (spot.bookedSlots.isNotEmpty)
                            Text('${spot.bookedSlots.length} reserva(s)', style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
