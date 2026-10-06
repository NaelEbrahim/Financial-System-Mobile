import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final _formKey = GlobalKey<FormState>();

  late Manager _manager;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool oldPasswordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Manager, BlocState>(
      listener: (context, state) {
        if (state is Update_Password_SuccessState) {
          oldPasswordController.clear();
          newPasswordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Password updated successfully"),
            ),
          );

          Navigator.pop(context);
        }

        if (state is Update_Password_ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _header(),

                  const SizedBox(height: 20),

                  _passwordField(
                    title: "Current Password",
                    icon: Icons.lock_outline,
                    controller: oldPasswordController,
                    obscure: !oldPasswordVisible,
                    onToggle: () {
                      setState(() {
                        oldPasswordVisible = !oldPasswordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  _passwordField(
                    title: "New Password",
                    icon: Icons.lock,
                    controller: newPasswordController,
                    obscure: !newPasswordVisible,
                    onToggle: () {
                      setState(() {
                        newPasswordVisible = !newPasswordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  _passwordField(
                    title: "Confirm Password",
                    icon: Icons.lock,
                    controller: confirmPasswordController,
                    obscure: !confirmPasswordVisible,
                    onToggle: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  state is Update_Password_LoadingState
                      ? const CircularProgressIndicator()
                      : Reusable.button("Update Password", () {
                          if (_formKey.currentState!.validate()) {
                            _manager.updatePassword({
                              "oldpassword": oldPasswordController.text.trim(),
                              "newpassword": newPasswordController.text.trim(),
                              "confirmpassword": confirmPasswordController.text.trim(),
                            });
                          }
                        }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [Constants.appSecondColor, Constants.appFirstColor],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_reset, color: Colors.white, size: 34),
          SizedBox(height: 14),
          Text(
            "Update Password",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Change your account password",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _passwordField({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xff7C3FE0)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: onToggle,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "$title is required";
              }

              if (title == "New Password") {
                if (!Constants.passwordRegex.hasMatch(value)) {
                  return "Must contain uppercase, lowercase, number and symbol";
                }

                if (value == oldPasswordController.text) {
                  return "New password must be different";
                }
              }

              if (title == "Confirm Password") {
                if (value != newPasswordController.text) {
                  return "Passwords do not match";
                }
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
