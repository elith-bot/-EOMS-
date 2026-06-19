import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
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
  final List<String> _userTypes = ['student', 'teacher'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول إلى ELM')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Consumer<AuthProvider>(builder: (context, authProvider, _) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value?.trim() ?? '',
                      validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'كلمة المرور'),
                      obscureText: true,
                      onSaved: (value) => _password = value ?? '',
                      validator: (value) => value == null || value.isEmpty ? 'هذا الحقل مطلوب' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _userType,
                      decoration: const InputDecoration(labelText: 'نوع المستخدم'),
                      items: _userTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type == 'student' ? 'طالب' : 'معلم')))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _userType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                            onPressed: () => _submit(authProvider),
                            child: const Text('تسجيل الدخول'),
                          ),
                    if (authProvider.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(AuthProvider authProvider) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();
    final success = await authProvider.login(_email, _password, _userType);

    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      final message = authProvider.errorMessage ?? 'فشل تسجيل الدخول';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
