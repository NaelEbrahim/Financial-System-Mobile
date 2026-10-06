import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/Auth/Login.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';
import 'package:pinput/pinput.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  const ResetPassword({super.key, required this.email});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late Manager _manager;
  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;

  Timer? _timer;
  int _remainingSeconds = 60;

  bool get _canResend => _remainingSeconds == 0;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<Manager, BlocState>(
          listener: (context, state) {
            if (state is Reset_Forgot_Password_SuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('password reset successfully'),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false,
              );
            }
            if (state is Reset_Forgot_Password_ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state is Forgot_Password_SuccessState) {
              _startTimer();
            }
          },
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.mark_email_read_outlined, size: 90),

                  const SizedBox(height: 20),

                  const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "If an account exists for the provided email address,\n"
                    "a verification code will be sent shortly.",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  Pinput(
                    controller: _otpController,
                    length: 4,
                    validator: (value) {
                      if (value == null ||
                          !Constants.otpRegex.hasMatch(value)) {
                        return 'invalid pin';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !Constants.passwordRegex.hasMatch(value)) {
                        return 'must contain uppercase, lowercase, number and symbol';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _confirmController,
                    obscureText: _hideConfirm,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideConfirm = !_hideConfirm;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  (state is Reset_Forgot_Password_LoadingState)
                      ? CircularProgressIndicator()
                      : Reusable.button('Reset Password', () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _manager.resetForgotPassword({
                              'email': widget.email,
                              'verifycode': _otpController.text,
                              'password': _passwordController.text,
                            });
                          }
                        }),
                  const SizedBox(height: 35),

                  const Text("Didn't receive the code?"),

                  (state is Forgot_Password_LoadingState)
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: _canResend
                              ? () {
                                  _manager.forgotPassword({
                                    'email': widget.email,
                                  });
                                }
                              : null,
                          child: Text(
                            _canResend
                                ? "Resend"
                                : "Resend in $_remainingSeconds s",
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _remainingSeconds = 60;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }
}
