import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/profile_cubit.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theming/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().loadUserProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBg,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: ColorsManager.cardBg,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUnauthorized) {

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session expired. Please login again.'),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginScreen,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: ColorsManager.primaryBlue,
              ),
            );
          } else if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: ColorsManager.primaryBlue,
                    backgroundImage: user.photo != null
                        ? NetworkImage(user.photo!)
                        : null,
                    child: user.photo == null
                        ? Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      color: ColorsManager.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: const TextStyle(
                      color: ColorsManager.mutedText,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildButton(
                    icon: Icons.edit,
                    label: "Edit Profile",
                    color: ColorsManager.primaryBlue,
                    onPressed: () => _showEditDialog(context, user),
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    icon: Icons.payment,
                    label: "Payment Methods",
                    color: ColorsManager.primaryBlue,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.paymentMethodsScreen,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    icon: Icons.notifications_outlined,
                    label: "Notifications",
                    color: ColorsManager.primaryBlue,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.notificationsScreen,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildButton(
                    icon: Icons.history,
                    label: "Booking History",
                    color: ColorsManager.primaryBlue,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      Routes.bookingHistoryScreen,
                    ),
                  ),
                  const SizedBox(height: 30),

                  _buildButton(
                    icon: Icons.logout,
                    label: "Logout",
                    color: Colors.red,
                    onPressed: () {
                      context.read<ProfileCubit>().logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Routes.loginScreen,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(
            child: Text(
              "No profile loaded",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showEditDialog(BuildContext context, user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final cubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorsManager.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorsManager.borderColor, width: 0.5),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: ColorsManager.mutedText),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: ColorsManager.mutedText),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: ColorsManager.mutedText),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: ColorsManager.mutedText),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await cubit.updateUserProfile(
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
              );
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.primaryBlue,
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
