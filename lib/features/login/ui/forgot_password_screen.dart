import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/routing/routes.dart';
import 'package:flutter_complete_project/core/theming/colors.dart';
import 'package:flutter_complete_project/features/login/ui/logic/forgot_password_cubit.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
    final rootContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ForgotPasswordCubit>(),
        child: StatefulBuilder(
          builder: (context, setDialogState) =>
              BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) async {
                  if (state is ForgotPasswordCodeSent) {
                    setDialogState(() => codeSent = true);
                  } else if (state is ForgotPasswordSuccess) {
                    // ✅ أغلق الـ dialog الأول
                    Navigator.of(rootContext, rootNavigator: true).pop();

                    await Future.delayed(const Duration(milliseconds: 300));

                    if (rootContext.mounted) {
                      // ✅ اعرض الـ success dialog
                      await showDialog(
                        context: rootContext,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '✅ Password reset successfully!\nPlease login with your new password.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(rootContext),
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      // ✅ بعد ما يضغط OK روح للـ login
                      if (rootContext.mounted) {
                        Navigator.of(
                          rootContext,
                          rootNavigator: true,
                        ).pushNamedAndRemoveUntil(
                          Routes.loginScreen,
                          (route) => false,
                        );
                      }
                    }
                  } else if (state is ForgotPasswordError) {
                    ScaffoldMessenger.of(rootContext).showSnackBar(
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
                                    obscuringCharacter: '*',
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
                          Navigator.pop(rootContext);
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
                                      .read<ForgotPasswordCubit>()
                                      .sendResetEmail(
                                        emailController.text.trim(),
                                      );
                                } else {
                                  final code = otpControllers
                                      .map((c) => c.text)
                                      .join();
                                  context
                                      .read<ForgotPasswordCubit>()
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
