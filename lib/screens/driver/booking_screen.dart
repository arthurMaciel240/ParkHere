import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../models/spot_model.dart';
import '../../models/booking_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final ParkingLotModel lot;

  const BookingScreen({super.key, required this.lot});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _start = DateTime.now().add(const Duration(hours: 1));
  DateTime _end = DateTime.now().add(const Duration(hours: 3));
  SpotModel? _selectedSpot;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadSpots(widget.lot.id);
    });
  }

  double get _totalHours => _end.difference(_start).inMinutes / 60.0;
  double get _totalPrice => _totalHours * widget.lot.pricePerHour;

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _start : _end,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(isStart ? _start : _end),
    );
    if (time == null) return;

    setState(() {
      final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStart) {
        _start = dt;
        if (_end.isBefore(_start.add(const Duration(minutes: 30)))) {
          _end = _start.add(const Duration(hours: 2));
        }
      } else {
        _end = dt;
      }
      _selectedSpot = null;
    });
  }

  List<SpotModel> _availableSpots(List<SpotModel> spots) {
    return spots.where((s) => s.isAvailable(_start, _end)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final available = _availableSpots(app.spots);

    return Scaffold(
      appBar: AppBar(title: const Text('Reservar vaga')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.lot.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _DateTimeCard(
              label: 'Entrada',
              value: DateFormat('dd/MM/yy HH:mm').format(_start),
              onTap: () => _pickDateTime(true),
            ),
            const SizedBox(height: 12),
            _DateTimeCard(
              label: 'Saída',
              value: DateFormat('dd/MM/yy HH:mm').format(_end),
              onTap: () => _pickDateTime(false),
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
                  Text('${_totalHours.toStringAsFixed(1)} h x R\$ ${widget.lot.pricePerHour.toStringAsFixed(2)}'),
                  Text('Total: R\$ ${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Vagas disponíveis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            if (app.loading) const Center(child: CircularProgressIndicator()),
            if (!app.loading && available.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Nenhuma vaga disponível neste horário.', textAlign: TextAlign.center),
                ),
              ),
            if (!app.loading)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: available.map((spot) {
                  final selected = _selectedSpot?.id == spot.id;
                  return ChoiceChip(
                    label: Text(spot.name),
                    avatar: Icon(spot.type == 'coberta' ? Icons.garage : Icons.local_parking, size: 18),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedSpot = spot),
                    selectedColor: AppTheme.secondaryColor,
                    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                  );
                }).toList(),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _selectedSpot == null
                  ? null
                  : () {
                      final booking = BookingModel(
                        id: const Uuid().v4(),
                        userId: context.read<AuthProvider>().user!.id,
                        lotId: widget.lot.id,
                        spotId: _selectedSpot!.id,
                        startTime: _start,
                        endTime: _end,
                        totalPrice: _totalPrice,
                        createdAt: DateTime.now(),
                        lotName: widget.lot.name,
                        spotName: _selectedSpot!.name,
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(booking: booking)));
                    },
              child: const Text('Continuar para pagamento', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeCard extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeCard({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
        title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.edit, size: 18),
        onTap: onTap,
      ),
    );
  }
}
