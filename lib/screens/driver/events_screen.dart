import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/event_model.dart';
import '../../providers/app_provider.dart';
import 'map_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos')),
      body: app.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: app.events.length,
              itemBuilder: (_, i) {
                final evt = app.events[i];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _showEventOptions(evt),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 140,
                          width: double.infinity,
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          child: const Center(child: Icon(Icons.event, size: 60, color: AppTheme.primaryColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(evt.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(DateFormat('dd/MM/yyyy - HH:mm').format(evt.date), style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(evt.address, style: const TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(evt.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEventOptions(EventModel evt) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(evt.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Filter map by event-related lots
                  context.read<AppProvider>().loadParkingLots(eventId: evt.id);
                  // In a real app we would navigate to map and move camera. Here we just show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mapa filtrado para vagas próximas a ${evt.title}')),
                  );
                },
                icon: const Icon(Icons.local_parking),
                label: const Text('Ver estacionamentos próximos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
