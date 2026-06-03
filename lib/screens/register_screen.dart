import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _role = 'driver';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Como você quer usar o app?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'driver', label: Text('Motorista'), icon: Icon(Icons.directions_car)),
                  ButtonSegment(value: 'owner', label: Text('Proprietário'), icon: Icon(Icons.business)),
                ],
                selected: {_role},
                onSelectionChanged: (val) => setState(() => _role = val.first),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome completo', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
              ),
              if (auth.error != null) ...[
                const SizedBox(height: 12),
                Text(auth.error!, style: const TextStyle(color: AppTheme.errorColor)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: auth.loading ? null : _register,
                child: auth.loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Cadastrar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    context.read<AuthProvider>().clearError();
    final ok = await context.read<AuthProvider>().register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _phoneCtrl.text.trim(),
          _passwordCtrl.text.trim(),
          _role,
        );
    if (ok && mounted) {
      Navigator.pop(context);
    }
  }
}
