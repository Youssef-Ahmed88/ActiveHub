import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/features/login/ui/logic/forgot_password_cubit.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool codeSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ForgetPasswordCubit>(),
        child: StatefulBuilder(
          builder: (context, setDialogState) =>
              BlocConsumer<ForgetPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state is ForgotPasswordCodeSent) {
                    setDialogState(() => codeSent = true);
                  } else if (state is ForgotPasswordSuccess) {
                    Navigator.pop(context);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.loginScreen,
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Password reset successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ ${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final loading = state is ForgotPasswordLoading;
                  return AlertDialog(
                    backgroundColor: ColorsManager.cardBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!codeSent) ...[
                            const Text(
                              'Enter your email to reset your password',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white38),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          ] else ...[
                            const Text(
                              'Enter the 6-digit code sent to your email',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  width: 38,
                                  child: TextField(
                                    controller: otpControllers[index],
                                    onChanged: (val) {
                                      if (val.length == 1 && index < 5) {
                                        FocusScope.of(context).nextFocus();
                                      } else if (val.isEmpty && index > 0) {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    obscureText: true,
                                    obscuringCharacter: '*', // ✅
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: const Color(0xFF1C2333),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: ColorsManager.primaryBlue,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: ColorsManager.primaryBlue,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'New Password',
                                hintStyle: TextStyle(color: Colors.white38),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: confirmController,
                              obscureText: true,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(color: Colors.white38),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.white38,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: loading
                            ? null
                            : () {
                                if (!codeSent) {
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .sendResetEmail(
                                        emailController.text.trim(),
                                      );
                                } else {
                                  final code = otpControllers
                                      .map((c) => c.text)
                                      .join();
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .resetPassword(
                                        code: code,
                                        password: passwordController.text,
                                        passwordConfirmation:
                                            confirmController.text,
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primaryBlue,
                        ),
                        child: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                codeSent ? 'Reset Password' : 'Send Reset Code',
                                style: const TextStyle(color: Colors.white),
                              ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    ).then((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.transparent);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
