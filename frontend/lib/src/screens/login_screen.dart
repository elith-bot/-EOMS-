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
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _role = 'student';

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 820;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 36, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: compact ? _formPanel() : Row(children: [_brandPanel(), const SizedBox(width: 28), Expanded(child: _formPanel())]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _brandPanel() {
    return Expanded(
      child: Container(
        height: 620,
        padding: const EdgeInsets.all(42),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Color(0xFF3157D5), Color(0xFF172B70)]),
          boxShadow: const [BoxShadow(color: Color(0x223157D5), blurRadius: 30, offset: Offset(0, 16))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 58, height: 58, decoration: BoxDecoration(color: Colors.white.withOpacity(.16), borderRadius: BorderRadius.circular(18)), child: const Icon(Icons.school_rounded, color: Colors.white, size: 32)),
          const Spacer(),
          const Text('مرحباً بك في ELM', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 16),
          Text('منصة تعليمية ذكية تجمع الطالب والمعلم في مكان واحد.', style: TextStyle(color: Colors.white.withOpacity(.82), fontSize: 17, height: 1.7)),
          const SizedBox(height: 28),
          Row(children: [
            _feature(Icons.auto_graph_rounded, 'تعلم بذكاء'),
            const SizedBox(width: 18),
            _feature(Icons.verified_user_rounded, 'بيانات آمنة'),
          ]),
          const Spacer(),
          Text('نحو تجربة تعليمية أفضل', style: TextStyle(color: Colors.white.withOpacity(.64), fontSize: 14)),
        ]),
      ),
    );
  }

  Widget _feature(IconData icon, String text) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFFBFD0FF), size: 24), const SizedBox(height: 8), Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]);

  Widget _formPanel() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Consumer<AuthProvider>(builder: (context, auth, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_isSignUp ? 'أنشئ حسابك' : 'تسجيل الدخول', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF17233F))),
            const SizedBox(height: 8),
            Text(_isSignUp ? 'ابدأ رحلتك التعليمية الآن' : 'أهلاً بعودتك، سجّل دخولك للمتابعة', style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 15)),
            const SizedBox(height: 26),
            _modeSwitch(),
            const SizedBox(height: 24),
            if (_isSignUp) ...[_field(_nameController, 'الاسم الكامل', Icons.person_outline_rounded, validator: (v) => (v == null || v.trim().length < 2) ? 'اكتب اسمك الكامل' : null), const SizedBox(height: 14)],
            _field(_identifierController, 'رقم الهاتف أو البريد الإلكتروني', Icons.alternate_email_rounded, keyboard: TextInputType.emailAddress, validator: (v) => (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null),
            const SizedBox(height: 14),
            _passwordField(_passwordController, 'كلمة المرور', _obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
            if (_isSignUp) ...[const SizedBox(height: 14), _passwordField(_confirmController, 'تأكيد كلمة المرور', _obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm), confirm: true), const SizedBox(height: 20), _rolePicker()],
            if (!_isSignUp) Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () {}, child: const Text('هل نسيت كلمة المرور؟'))),
            if (auth.errorMessage != null) ...[const SizedBox(height: 10), _error(auth.errorMessage!)],
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 54, child: FilledButton(onPressed: auth.isLoading ? null : () => _submit(auth), style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: auth.isLoading ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Text(_isSignUp ? 'إنشاء الحساب' : 'دخول إلى حسابي', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 20),
            Center(child: TextButton(onPressed: () { setState(() { _isSignUp = !_isSignUp; }); context.read<AuthProvider>().clearError(); }, child: Text(_isSignUp ? 'لديك حساب؟ سجّل الدخول' : 'ليس لديك حساب؟ أنشئ حساباً جديداً'))),
          ])),
        ),
      ),
    );
  }

  Widget _modeSwitch() => Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFF0F3FA), borderRadius: BorderRadius.circular(14)), child: Row(children: [Expanded(child: _modeButton('تسجيل الدخول', !_isSignUp)), Expanded(child: _modeButton('حساب جديد', _isSignUp))]));
  Widget _modeButton(String label, bool selected) => GestureDetector(onTap: () => setState(() => _isSignUp = label == 'حساب جديد'), child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(11), boxShadow: selected ? const [BoxShadow(color: Color(0x12000000), blurRadius: 8)] : null), child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? const Color(0xFF3157D5) : Colors.blueGrey, fontWeight: FontWeight.w700))));

  Widget _field(TextEditingController controller, String label, IconData icon, {TextInputType? keyboard, String? Function(String?)? validator}) => TextFormField(controller: controller, keyboardType: keyboard, textDirection: TextDirection.rtl, validator: validator, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: const Color(0xFF3157D5))));
  Widget _passwordField(TextEditingController controller, String label, bool obscure, VoidCallback toggle, {bool confirm = false}) => TextFormField(controller: controller, obscureText: obscure, validator: (v) { if (v == null || v.length < 6) return 'كلمة المرور 6 أحرف على الأقل'; if (confirm && v != _passwordController.text) return 'كلمتا المرور غير متطابقتين'; return null; }, decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF3157D5)), suffixIcon: IconButton(onPressed: toggle, icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined))));
  Widget _rolePicker() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('نوع الحساب', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF344054))), const SizedBox(height: 10), Row(children: [_roleOption('student', 'طالب', Icons.school_outlined), const SizedBox(width: 10), _roleOption('teacher', 'معلم', Icons.co_present_outlined)])]);
  Widget _roleOption(String value, String label, IconData icon) { final selected = _role == value; return Expanded(child: GestureDetector(onTap: () => setState(() => _role = value), child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.symmetric(vertical: 13), decoration: BoxDecoration(color: selected ? const Color(0xFFEAF0FF) : const Color(0xFFF7F8FC), border: Border.all(color: selected ? const Color(0xFF3157D5) : Colors.transparent), borderRadius: BorderRadius.circular(14)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 20, color: selected ? const Color(0xFF3157D5) : Colors.blueGrey), const SizedBox(width: 7), Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: selected ? const Color(0xFF3157D5) : Colors.blueGrey))])))); }
  Widget _error(String text) => Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFFF0F0), borderRadius: BorderRadius.circular(12)), child: Text(text, style: const TextStyle(color: Color(0xFFC62828), fontSize: 13)));

  Future<void> _submit(AuthProvider auth) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final ok = _isSignUp ? await auth.register(fullName: _nameController.text.trim(), identifier: _identifierController.text.trim(), password: _passwordController.text, role: _role) : await auth.login(_identifierController.text.trim(), _passwordController.text);
    if (!mounted) return;
    if (ok && _isSignUp) {
      setState(() { _isSignUp = false; _passwordController.clear(); _confirmController.clear(); });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب، يمكنك تسجيل الدخول الآن.')));
    } else if (ok) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
    }
  }
}
