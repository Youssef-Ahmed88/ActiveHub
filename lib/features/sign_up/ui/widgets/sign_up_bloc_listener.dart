import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/core/helpers/extensions.dart';
import 'package:flutter_complete_project/features/sign_up/logic/sign_up_cubit.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';
import '../../logic/sign_up_state.dart';

class SignupBlocListener extends StatelessWidget {
  const SignupBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is SignupLoading ||
          current is SignupSuccess ||
          current is SignupError,
      listener: (context, state) {
        state.whenOrNull(
          signupLoading: () {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryBlue,
                ),
              ),
            );
          },
          signupSuccess: (signupResponse) {
            context.pop();
            showSuccessDialog(context);
          },
          signupError: (error) {
            setupErrorState(context, error);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorsManager.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(
              color: ColorsManager.borderColor,
              width: 0.5,
            ),
          ),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 48,
          ),
          title: Text(
            'Welcome to ActiveHub!',
            style: TextStyles.font20WhiteMedium,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Your account has been created successfully. Start booking your courts now!',
            style: TextStyles.font13MutedRegular,
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorsManager.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  context.pushNamed(Routes.loginScreen);
                },
                child: const Text('Let\'s Go!'),
              ),
            ),
          ],
        );
      },
    );
  }

  void setupErrorState(BuildContext context, String error) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: ColorsManager.borderColor,
            width: 0.5,
          ),
        ),
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 32,
        ),
        content: Text(
          error,
          style: TextStyles.font13MutedRegular,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              'Got it',
              style: TextStyles.font13BlueMedium,
            ),
          ),
        ],
      ),
    );
  }
}