import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              const Icon(Icons.local_parking, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo ao ParkHere',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Encontre e reserve vagas de estacionamento com facilidade',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email)),
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
                onPressed: auth.loading ? null : _login,
                child: auth.loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Entrar', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Contas de demonstração:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _DemoAccountTile(
                label: 'Motorista',
                email: AppConstants.demoDriverEmail,
                onTap: () {
                  _emailCtrl.text = AppConstants.demoDriverEmail;
                  _passwordCtrl.text = AppConstants.demoPassword;
                },
              ),
              _DemoAccountTile(
                label: 'Proprietário',
                email: AppConstants.demoOwnerEmail,
                onTap: () {
                  _emailCtrl.text = AppConstants.demoOwnerEmail;
                  _passwordCtrl.text = AppConstants.demoPassword;
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text('Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    context.read<AuthProvider>().clearError();
    final ok = await context.read<AuthProvider>().login(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    if (!ok && mounted) {
      // error already set in provider
    }
  }
}

class _DemoAccountTile extends StatelessWidget {
  final String label;
  final String email;
  final VoidCallback onTap;

  const _DemoAccountTile({required this.label, required this.email, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.badge, color: AppTheme.primaryColor),
        title: Text(label),
        subtitle: Text(email),
        trailing: const Icon(Icons.copy, size: 18),
        onTap: onTap,
      ),
    );
  }
}
