import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/features/login/logic/cubit/login_cubit.dart';
import 'package:flutter_complete_project/features/login/logic/cubit/login_state.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.whenOrNull(
            loading: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(
                    color: ColorsManager.primaryBlue),
              ),
            ),
            success: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.homeScreen, (route) => false);
            },
            adminSuccess: (_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.adminScreen, (route) => false);
            },
            error: (error) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error)));
            },
          );
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: cubit.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Book your court. Play your game.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  TextFormField(
                    controller: cubit.emailController,
                    validator: (v) => v!.isEmpty ? "Enter email" : null,
                    decoration: const InputDecoration(labelText: "EMAIL"),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: cubit.passwordController,
                    validator: (v) => v!.isEmpty ? "Enter password" : null,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "PASSWORD"),
                  ),
                  const SizedBox(height: 8),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                          context, Routes.forgetPasswordScreen),
                      child: const Text("Forgot password?",
                          style: TextStyle(color: ColorsManager.primaryBlue)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sign in button
                  ElevatedButton(
                    onPressed: cubit.emitLoginStates,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.primaryBlue,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: const [
                      Expanded(
                          child: Divider(color: ColorsManager.borderColor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Or continue with",
                            style: TextStyle(
                                color: ColorsManager.mutedText, fontSize: 12)),
                      ),
                      Expanded(
                          child: Divider(color: ColorsManager.borderColor)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Social Login Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _socialButton(
                          onTap: () {},
                          color: const Color(0xFF4285F4),
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _socialButton(
                          onTap: () {},
                          color: const Color(0xFF1DA1F2),
                          icon: Icons.alternate_email,
                          label: 'Twitter',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _socialButton(
                          onTap: () {},
                          color: const Color(0xFF1877F2),
                          icon: Icons.facebook,
                          label: 'Facebook',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?",
                          style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, Routes.signUpScreen),
                        child: const Text("Sign up",
                            style: TextStyle(
                                color: ColorsManager.primaryBlue)),
                      ),
                    ],
                  ),

                  // Admin Access
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.adminLoginScreen),
                    child: const Text(
                      "Admin Access",
                      style: TextStyle(
                        color: ColorsManager.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  // Owner Access (NEW)
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.ownerLoginScreen),
                    child: const Text(
                      "Owner Access",
                      style: TextStyle(
                        color: ColorsManager.mutedText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton({
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: ColorsManager.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorsManager.borderColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
