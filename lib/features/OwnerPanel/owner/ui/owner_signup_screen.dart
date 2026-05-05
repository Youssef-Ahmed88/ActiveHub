import 'package:flutter/material.dart';
import 'owner_screen.dart';
import 'owner_login_screen.dart'; // 👈 مهم جدًا

class OwnerSignupScreen extends StatefulWidget {
  const OwnerSignupScreen({super.key});

  @override
  State<OwnerSignupScreen> createState() => _OwnerSignupScreenState();
}

class _OwnerSignupScreenState extends State<OwnerSignupScreen> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl  = TextEditingController();
  final _formKey      = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    String email = _emailCtrl.text.trim();
    String password = _passwordCtrl.text.trim();

    // ✅ حفظ الأكاونت
    await OwnerLoginScreen.addOwner(
      email: email,
      password: password,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _loading = false);

    // ✅ بعد التسجيل يدخل على طول
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const OwnerScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1115),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                autovalidateMode:
                    AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('Create account',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white)),
                    const SizedBox(height: 6),
                    const Text(
                        'Register as a sports venue owner',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 14)),
                    const SizedBox(height: 36),

                    const Text('FULL NAME',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _nameCtrl,
                      hint: 'Samer Ibrahim',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty)
                              ? 'Required'
                              : null,
                    ),

                    const SizedBox(height: 20),

                    const Text('EMAIL',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _emailCtrl,
                      hint: 'you@email.com',
                      icon: Icons.email_outlined,
                      validator: (v) =>
                          (v == null || !v.contains('@'))
                              ? 'Enter valid email'
                              : null,
                    ),

                    const SizedBox(height: 20),

                    const Text('PASSWORD',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _passwordCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                            _obscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF8B949E)),
                        onPressed: () => setState(
                            () => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                    ),

                    const SizedBox(height: 20),

                    const Text('CONFIRM PASSWORD',
                        style: TextStyle(
                            color: Color(0xFF8B949E),
                            fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildField(
                      controller: _confirmCtrl,
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      obscure: true,
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Required';
                        if (v != _passwordCtrl.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed:
                            _loading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF3D5AFE),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12)),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Create Account'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Text(
                            'Already have an account? ',
                            style: TextStyle(
                                color: Color(0xFF8B949E))),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pop(context),
                          child: const Text('Sign in',
                              style: TextStyle(
                                  color: Color(0xFF3D5AFE))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon:
            Icon(icon, color: const Color(0xFF8B949E)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF161B22),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}