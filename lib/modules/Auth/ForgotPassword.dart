import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/Auth/ResetForgotPassword.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late Manager _manager;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<Manager, BlocState>(
          listener: (context, state) {
            if (state is Forgot_Password_SuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ResetPassword(email: _emailController.text.trim()),
                ),
              );
            }
            if (state is Forgot_Password_ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.lock_reset, size: 90),

                  const SizedBox(height: 20),

                  const Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Enter your email address to reset your password.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !Constants.emailRegex.hasMatch(value)) {
                        return "invalid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  (state is Forgot_Password_LoadingState)
                      ? CircularProgressIndicator()
                      : Reusable.button('Continue', () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _manager.forgotPassword({
                              'email': _emailController.text,
                            });
                          }
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
