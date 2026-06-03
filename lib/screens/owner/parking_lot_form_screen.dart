import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme.dart';
import '../../models/parking_lot_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class ParkingLotFormScreen extends StatefulWidget {
  final ParkingLotModel? lot;

  const ParkingLotFormScreen({super.key, this.lot});

  @override
  State<ParkingLotFormScreen> createState() => _ParkingLotFormScreenState();
}

class _ParkingLotFormScreenState extends State<ParkingLotFormScreen> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _photoCtrl = TextEditingController();
  bool _loadingGeo = false;

  @override
  void initState() {
    super.initState();
    if (widget.lot != null) {
      _nameCtrl.text = widget.lot!.name;
      _addressCtrl.text = widget.lot!.address;
      _priceCtrl.text = widget.lot!.pricePerHour.toStringAsFixed(2);
      _photoCtrl.text = widget.lot!.photos.isNotEmpty ? widget.lot!.photos.first : '';
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _priceCtrl.dispose();
    _photoCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loadingGeo = true);

    double lat = widget.lot?.lat ?? 0;
    double lng = widget.lot?.lng ?? 0;

    try {
      final locations = await locationFromAddress(_addressCtrl.text.trim());
      if (locations.isNotEmpty) {
        lat = locations.first.latitude;
        lng = locations.first.longitude;
      }
    } catch (_) {
      // ignore geocoding errors for demo
    }

    final lot = ParkingLotModel(
      id: widget.lot?.id ?? const Uuid().v4(),
      ownerId: context.read<AuthProvider>().user!.id,
      name: _nameCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      lat: lat,
      lng: lng,
      pricePerHour: double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? 0,
      photos: _photoCtrl.text.trim().isNotEmpty ? [_photoCtrl.text.trim()] : [],
      eventId: widget.lot?.eventId,
    );

    await context.read<AppProvider>().saveParkingLot(lot);

    if (mounted) {
      setState(() => _loadingGeo = false);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.lot != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar estacionamento' : 'Novo estacionamento')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome do estacionamento', prefixIcon: Icon(Icons.business)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressCtrl,
              decoration: const InputDecoration(labelText: 'Endereço completo', prefixIcon: Icon(Icons.location_on)),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Preço por hora (R\$)', prefixIcon: Icon(Icons.attach_money)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _photoCtrl,
              decoration: const InputDecoration(
                labelText: 'URL da foto (opcional)',
                prefixIcon: Icon(Icons.image),
                hintText: 'https://...',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadingGeo ? null : _save,
              child: _loadingGeo
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isEdit ? 'Salvar alterações' : 'Cadastrar', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
