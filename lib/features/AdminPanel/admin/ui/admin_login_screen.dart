import 'package:flutter/material.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_complete_project/core/di/dependency_injection.dart';
import 'package:flutter_complete_project/core/networking/dio_factory.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  // Default admin
  static const String defaultAdminEmail = 'admin@activehub.com';
  static const String defaultAdminPassword = 'Admin@123';

  // Add new admin (save locally)
  static Future<void> addAdmin({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> admins = prefs.getStringList('admins') ?? [];

    // منع التكرار
    if (admins.any((a) => a.split('|')[0] == email)) return;

    admins.add('$email|$password');
    await prefs.setStringList('admins', admins);
  }

  // Check login
  static Future<bool> isValidAdmin(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> admins = prefs.getStringList('admins') ?? [];

    // default admin
    if (email == defaultAdminEmail && password == defaultAdminPassword) {
      return true;
    }

    for (var admin in admins) {
      final parts = admin.split('|');
      if (parts[0] == email && parts[1] == password) {
        return true;
      }
    }
    return false;
  }

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      final dio = getIt<Dio>();
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final user = response.data['data']['user'];
      final token = response.data['data']['token'];

      // تأكد إن الـ role admin
      if (user['role'] != 'admin') {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid admin credentials'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ✅ حفظ التوكن باستخدام الـ DioFactory المعدل
      await DioFactory.saveToken(token);

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.adminScreen, (route) => false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid admin credentials'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorsManager.borderColor, width: 0.5),
        ),
        title: const Text('Reset Password', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your admin email to reset your password',
              style: TextStyle(color: ColorsManager.mutedText, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Admin Email',
                labelStyle: TextStyle(color: ColorsManager.mutedText),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: ColorsManager.mutedText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reset link sent to your email ✅'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text('Send Reset Link', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple.withOpacity(0.5)),
                ),
                child: const Icon(Icons.admin_panel_settings,
                    color: Colors.purple, size: 44),
              ),

              const SizedBox(height: 16),
              const Text(
                'Admin Panel',
                style: TextStyle(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: ColorsManager.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Admin Login',
                        style: TextStyle(color: Colors.white, fontSize: 18)),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _emailController,
                      validator: (v) => v!.isEmpty ? 'Enter admin email' : null,
                      decoration: const InputDecoration(
                        hintText: 'admin@activehub.com',
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (v) => v!.isEmpty ? 'Enter admin password' : null,
                      decoration: InputDecoration(
                        hintText: '••••••',
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _showForgotPasswordDialog,
                        child: const Text("Forgot password?",
                            style: TextStyle(color: Colors.purple)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Login as Admin',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Flexible(
                          child: Text("Don't have an account?",
                              style: TextStyle(color: Colors.grey)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.adminSignUpScreen),
                          child: const Text("Create Account",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
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