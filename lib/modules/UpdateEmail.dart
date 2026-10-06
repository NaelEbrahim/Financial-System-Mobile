import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/UpdateEmail_2.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final _formKey = GlobalKey<FormState>();

  late Manager _manager;

  final newEmailController = TextEditingController();
  final passwordController = TextEditingController();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  void dispose() {
    newEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Manager, BlocState>(
      listener: (context, state) {
        if (state is Request_Update_Email_SuccessState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateEmail_2(
                email: newEmailController.text,
                password: passwordController.text,
              ),
            ),
          );
        }

        if (state is Request_Update_Email_ErrorState) {
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

                  _field(
                    title: "New Email",
                    icon: Icons.email_outlined,
                    controller: newEmailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }

                      if (!Constants.emailRegex.hasMatch(value.trim())) {
                        return "Enter a valid email";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  _passwordField(),

                  const SizedBox(height: 25),

                  state is Request_Update_Email_LoadingState
                      ? const CircularProgressIndicator()
                      : Reusable.button("Update Email", () {
                          if (_formKey.currentState!.validate()) {
                            _manager.requestUpdateEmail({
                              "newemail": newEmailController.text.trim(),
                              "password": passwordController.text,
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
          Icon(Icons.email, color: Colors.white, size: 34),
          SizedBox(height: 14),
          Text(
            "Update Email",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Secure your account with email change",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
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
            decoration: const InputDecoration(border: InputBorder.none),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
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
            children: const [
              Icon(Icons.lock_outline, color: Color(0xff7C3FE0)),
              SizedBox(width: 8),
              Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: passwordController,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Password is required";
              }

              if (!Constants.passwordRegex.hasMatch(value.trim())) {
                return "Must contain uppercase, lowercase, number and symbol";
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}
