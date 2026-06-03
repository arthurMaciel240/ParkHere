import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/booking_model.dart';
import '../../providers/app_provider.dart';
import 'bookings_history_screen.dart';

class PaymentScreen extends StatefulWidget {
  final BookingModel booking;

  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _processing = false;

  Future<void> _confirmPayment() async {
    setState(() => _processing = true);
    await Future.delayed(const Duration(seconds: 2));
    await context.read<AppProvider>().saveBooking(widget.booking);
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: AppTheme.secondaryColor, size: 60),
          title: const Text('Reserva confirmada!'),
          content: Text('Sua vaga ${widget.booking.spotName} foi reservada com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Resumo da reserva', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(b.lotName ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Vaga: ${b.spotName}'),
                    Text('Entrada: ${DateFormat('dd/MM/yy HH:mm').format(b.startTime)}'),
                    Text('Saída: ${DateFormat('dd/MM/yy HH:mm').format(b.endTime)}'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total a pagar:'),
                        Text('R\$ ${b.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.secondaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Dados do cartão (simulado)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Número do cartão', prefixIcon: Icon(Icons.credit_card)),
              keyboardType: TextInputType.number,
              controller: TextEditingController(text: '4111 1111 1111 1111'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Validade'),
                    keyboardType: TextInputType.datetime,
                    controller: TextEditingController(text: '12/28'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'CVV'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: '123'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Nome no cartão'),
              controller: TextEditingController(text: 'JOAO M SILVA'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _processing ? null : _confirmPayment,
              child: _processing
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Pagar e confirmar reserva', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
