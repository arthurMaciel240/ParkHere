import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../services/routing_service.dart';
import '../../services/location_service.dart';
import 'booking_screen.dart';

class ParkingDetailScreen extends StatefulWidget {
  final ParkingLotModel lot;

  const ParkingDetailScreen({super.key, required this.lot});

  @override
  State<ParkingDetailScreen> createState() => _ParkingDetailScreenState();
}

class _ParkingDetailScreenState extends State<ParkingDetailScreen> {
  bool _routing = false;
  String? _routeInfo;

  Future<void> _traceRoute() async {
    setState(() => _routing = true);

    // Pega localizacao real do aparelho
    final loc = await LocationService.getCurrentLocation();
    LatLng from;
    String originText;

    if (loc != null) {
      from = loc;
      originText = 'Sua localizacao';
    } else {
      // Fallback para centro de BH se nao conseguir localizacao
      from = const LatLng(-19.9167, -43.9345);
      originText = 'Centro de BH (localizacao nao disponivel)';
    }

    final to = LatLng(widget.lot.lat, widget.lot.lng);
    final route = await RoutingService.getRoute(from, to);

    setState(() {
      _routing = false;
      if (route != null) {
        final km = route.distanceMeters / 1000;
        final min = route.durationSeconds / 60;
        _routeInfo = 'De: $originText\nDistancia: ${km.toStringAsFixed(1)} km • Tempo: ${min.toStringAsFixed(0)} min';
      } else {
        _routeInfo = 'Nao foi possivel calcular a rota.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lot.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 220,
            child: widget.lot.photos.isNotEmpty
                ? Image.network(widget.lot.photos.first, fit: BoxFit.cover, width: double.infinity)
                : Container(color: Colors.grey.shade300, child: const Center(child: Icon(Icons.local_parking, size: 60))),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.lot.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                      const SizedBox(width: 4),
                      Expanded(child: Text(widget.lot.address, style: const TextStyle(fontSize: 15, color: Colors.grey))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Preço por hora:', style: TextStyle(fontSize: 16)),
                        Text('R\$ ${widget.lot.pricePerHour.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                      ],
                    ),
                  ),
                  if (_routeInfo != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.primaryColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.directions, color: AppTheme.primaryColor),
                          const SizedBox(width: 10),
                          Expanded(child: Text(_routeInfo!, style: const TextStyle(fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const Text('Sobre este estacionamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Estacionamento com segurança 24h, câmeras de monitoramento e fácil acesso. Reserve agora e garanta sua vaga!'),
                  const SizedBox(height: 24),
                  const Text('Comodidades', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('Segurança 24h'), avatar: Icon(Icons.security, size: 18)),
                      Chip(label: Text('Coberto'), avatar: Icon(Icons.garage, size: 18)),
                      Chip(label: Text('Câmeras'), avatar: Icon(Icons.videocam, size: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: _routing ? null : _traceRoute,
                  icon: _routing
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.directions),
                  label: Text(_routing ? 'Calculando rota...' : 'Como chegar', style: const TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen(lot: widget.lot))),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
                  child: const Text('Reservar vaga', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
