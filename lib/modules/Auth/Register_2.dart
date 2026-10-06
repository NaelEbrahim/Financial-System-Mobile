import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/Auth/VerifyEmail.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class Register_2 extends StatefulWidget {
  final String firstname;
  final String lastname;
  final String email;

  const Register_2({
    super.key,
    required this.firstname,
    required this.lastname,
    required this.email,
  });

  @override
  State<Register_2> createState() => _Register_2State();
}

class _Register_2State extends State<Register_2> {
  late Manager _manager;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _pinController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscurePin = true;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: BlocConsumer<Manager, BlocState>(
          listener: (context, state) {
            if (state is Register_SuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => VerifyEmail(email: widget.email),
                ),
              );
            }
            if (state is Register_ErrorState) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person_add_alt_1, size: 80),

                  const SizedBox(height: 16),

                  const Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Complete your information to get started",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'password',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !Constants.passwordRegex.hasMatch(value)) {
                        return 'must contain uppercase, lowercase\nnumber and symbol';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    maxLength: 50,
                    decoration: InputDecoration(
                      labelText: 'confirm password',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'password confirmation not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _pinController,
                    obscureText: _obscurePin,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: '6-Digit PIN',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePin ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePin = !_obscurePin;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !Constants.pinRegex.hasMatch(value)) {
                        return 'must be 6 digits (cannot be repeated or sequential)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  (state is Register_LoadingState)
                      ? CircularProgressIndicator()
                      : Reusable.button('Submit & Continue', () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _manager.register({
                              'firstname': widget.firstname,
                              'lastname': widget.lastname,
                              'email': widget.email,
                              'password': _passwordController.text,
                              'pin': _pinController.text,
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
