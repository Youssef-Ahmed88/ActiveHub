import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({super.key});

  static const String defaultOwnerEmail    = 'owner@activehub.com';
  static const String defaultOwnerPassword = 'Owner@123';

  static Future<void> addOwner({required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> owners = prefs.getStringList('owners') ?? [];
    if (owners.any((o) => o.split('|')[0] == email)) return;
    owners.add('$email|$password');
    await prefs.setStringList('owners', owners);
  }

  static Future<bool> isValidOwner(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> owners = prefs.getStringList('owners') ?? [];
    if (email == defaultOwnerEmail && password == defaultOwnerPassword) return true;
    for (var owner in owners) {
      final parts = owner.split('|');
      if (parts[0] == email && parts[1] == password) return true;
    }
    return false;
  }

  // ✅ Check if email exists
  static Future<bool> ownerEmailExists(String email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == defaultOwnerEmail) return true;
    List<String> owners = prefs.getStringList('owners') ?? [];
    return owners.any((o) => o.split('|')[0] == email);
  }

  // ✅ Reset password
  static Future<bool> resetPassword(String email, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> owners = prefs.getStringList('owners') ?? [];
    for (int i = 0; i < owners.length; i++) {
      final parts = owners[i].split('|');
      if (parts[0] == email) {
        owners[i] = '$email|$newPassword';
        await prefs.setStringList('owners', owners);
        return true;
      }
    }
    return false;
  }

  @override
  State<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey            = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading       = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final isValid  = await OwnerLoginScreen.isValidOwner(email, password);

    if (isValid) {
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, Routes.ownerScreen, (route) => false);
    } else {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid owner credentials'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ✅ Forgot Password Dialog
  void _showForgotPasswordDialog() {
    final emailCtrl    = TextEditingController();
    final newPassCtrl  = TextEditingController();
    final confirmCtrl  = TextEditingController();
    final dialogFormKey = GlobalKey<FormState>();
    bool obscureNew     = true;
    bool obscureConfirm = true;
    bool isLoading      = false;
    int step            = 1; // 1 = enter email, 2 = enter new password

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: ColorsManager.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(step == 1 ? Icons.lock_reset : Icons.lock_outline,
                  color: Colors.orange, size: 22),
              const SizedBox(width: 8),
              Text(
                step == 1 ? 'Forgot Password' : 'New Password',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
          content: Form(
            key: dialogFormKey,
            child: SingleChildScrollView(
              child: step == 1
                  // ── Step 1: Enter Email ──────────────────
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter your owner email to reset your password.',
                          style: TextStyle(color: Color(0xFF8B949E), fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        const Text('EMAIL',
                            style: TextStyle(color: Color(0xFF8B949E), fontSize: 11,
                                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter your email';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: _inputDecoration('owner@activehub.com', Icons.email_outlined),
                        ),
                      ],
                    )
                  // ── Step 2: New Password ─────────────────
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text('Email verified: ${emailCtrl.text}',
                                    style: const TextStyle(color: Colors.green, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text('NEW PASSWORD',
                            style: TextStyle(color: Color(0xFF8B949E), fontSize: 11,
                                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: newPassCtrl,
                          obscureText: obscureNew,
                          validator: (v) {
                            if (v == null || v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: _inputDecoration('New password', Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility,
                                  color: const Color(0xFF8B949E), size: 18),
                              onPressed: () => setS(() => obscureNew = !obscureNew),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text('CONFIRM PASSWORD',
                            style: TextStyle(color: Color(0xFF8B949E), fontSize: 11,
                                fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: confirmCtrl,
                          obscureText: obscureConfirm,
                          validator: (v) {
                            if (v != newPassCtrl.text) return 'Passwords do not match';
                            return null;
                          },
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: _inputDecoration('Confirm password', Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                  color: const Color(0xFF8B949E), size: 18),
                              onPressed: () => setS(() => obscureConfirm = !obscureConfirm),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF8B949E))),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (!dialogFormKey.currentState!.validate()) return;
                setS(() => isLoading = true);

                if (step == 1) {
                  // ✅ Check if email exists
                  final exists = await OwnerLoginScreen.ownerEmailExists(emailCtrl.text.trim());
                  await Future.delayed(const Duration(milliseconds: 800));

                  if (exists) {
                    setS(() { step = 2; isLoading = false; });
                  } else {
                    setS(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No owner account found with this email'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  // ✅ Reset password
                  final email = emailCtrl.text.trim();
                  bool success = false;

                  // Default owner — can't reset via app
                  if (email == OwnerLoginScreen.defaultOwnerEmail) {
                    setS(() => isLoading = false);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Default owner password cannot be changed here'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  success = await OwnerLoginScreen.resetPassword(email, newPassCtrl.text.trim());
                  await Future.delayed(const Duration(milliseconds: 800));

                  if (mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(success
                            ? 'Password reset successfully! You can now login.'
                            : 'Failed to reset password. Try again.'),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                disabledBackgroundColor: Colors.orange.withOpacity(0.4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isLoading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(step == 1 ? 'Verify Email' : 'Reset Password',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF8B949E)),
      prefixIcon: Icon(icon, color: const Color(0xFF8B949E), size: 18),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF0F1115),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border:             OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF30363D))),
      enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF30363D))),
      focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.orange)),
      errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.red)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.store, color: Colors.orange, size: 44),
              ),
              const SizedBox(height: 16),
              const Text('Owner Panel',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorsManager.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Owner Login',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _emailController,
                      validator: (v) => v!.isEmpty ? 'Enter owner email' : null,
                      decoration: const InputDecoration(hintText: 'owner@activehub.com'),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (v) => v!.isEmpty ? 'Enter owner password' : null,
                      decoration: InputDecoration(
                        hintText: '••••••',
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),

                    // ✅ Forgot Password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text('Forgot Password?',
                            style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login as Owner'),
                    ),
                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.ownerSignUpScreen),
                      child: const Text('Create Owner Account'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}