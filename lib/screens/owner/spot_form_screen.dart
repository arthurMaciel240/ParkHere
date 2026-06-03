import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/spot_model.dart';
import '../../providers/app_provider.dart';
import '../../providers/auth_provider.dart';

class SpotFormScreen extends StatefulWidget {
  final String lotId;
  final SpotModel? spot;

  const SpotFormScreen({super.key, required this.lotId, this.spot});

  @override
  State<SpotFormScreen> createState() => _SpotFormScreenState();
}

class _SpotFormScreenState extends State<SpotFormScreen> {
  final _nameCtrl = TextEditingController();
  String _type = 'descoberta';

  @override
  void initState() {
    super.initState();
    if (widget.spot != null) {
      _nameCtrl.text = widget.spot!.name;
      _type = widget.spot!.type;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final spot = SpotModel(
      id: widget.spot?.id ?? const Uuid().v4(),
      lotId: widget.lotId,
      name: _nameCtrl.text.trim(),
      type: _type,
      bookedSlots: widget.spot?.bookedSlots ?? [],
    );
    final ownerId = context.read<AuthProvider>().user!.id;
    await context.read<AppProvider>().saveSpot(spot, ownerId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.spot != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar vaga' : 'Nova vaga')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Nome/Identificação da vaga'),
            ),
            const SizedBox(height: 16),
            const Text('Tipo de vaga', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'descoberta', label: Text('Descoberta')),
                ButtonSegment(value: 'coberta', label: Text('Coberta')),
              ],
              selected: {_type},
              onSelectionChanged: (val) => setState(() => _type = val.first),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              child: Text(isEdit ? 'Salvar' : 'Cadastrar vaga', style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
