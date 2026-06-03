import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import 'parking_lot_form_screen.dart';
import 'spots_management_screen.dart';

class ParkingLotsScreen extends StatefulWidget {
  const ParkingLotsScreen({super.key});

  @override
  State<ParkingLotsScreen> createState() => _ParkingLotsScreenState();
}

class _ParkingLotsScreenState extends State<ParkingLotsScreen> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Meus estacionamentos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParkingLotFormScreen())),
        child: const Icon(Icons.add),
      ),
      body: app.loading
          ? const Center(child: CircularProgressIndicator())
          : app.parkingLots.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.business, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Nenhum estacionamento cadastrado.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: app.parkingLots.length,
                  itemBuilder: (_, i) {
                    final lot = app.parkingLots[i];
                    return Card(
                      child: ListTile(
                        leading: lot.photos.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(lot.photos.first, width: 56, height: 56, fit: BoxFit.cover),
                              )
                            : const CircleAvatar(child: Icon(Icons.local_parking)),
                        title: Text(lot.name),
                        subtitle: Text('R\$ ${lot.pricePerHour.toStringAsFixed(2)}/h • ${lot.address}'),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'edit') {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ParkingLotFormScreen(lot: lot)));
                            } else if (value == 'spots') {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => SpotsManagementScreen(lot: lot)));
                            } else if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Excluir?'),
                                  content: Text('Deseja excluir "${lot.name}"?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
                                  ],
                                ),
                              );
                              if (confirm == true && mounted) {
                                final ownerId = context.read<AuthProvider>().user!.id;
                                await context.read<AppProvider>().deleteParkingLot(lot.id, ownerId);
                              }
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'edit', child: Text('Editar')),
                            PopupMenuItem(value: 'spots', child: Text('Gerenciar vagas')),
                            PopupMenuItem(value: 'delete', child: Text('Excluir')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
