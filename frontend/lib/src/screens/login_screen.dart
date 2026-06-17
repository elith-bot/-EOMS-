import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userType = 'student';
  bool _loading = false;
  final List<String> _userTypes = ['student', 'teacher'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ELM Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value?.trim() ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => _password = value ?? '',
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _userType,
                decoration: const InputDecoration(labelText: 'User Type'),
                items: _userTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(_capitalize(type))))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _userType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String _capitalize(String input) => input.isEmpty ? input : '${input[0].toUpperCase()}${input.substring(1)}';

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();
    setState(() {
      _loading = true;
    });

    final response = await ApiService.login(_email, _password, _userType);
    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      final message = response.body.isNotEmpty ? response.body : 'Login failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
