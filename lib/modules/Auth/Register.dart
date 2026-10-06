import 'package:flutter/material.dart';
import 'package:novabank/modules/Auth/Login.dart';
import 'package:novabank/modules/Auth/Register_2.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Icon(Icons.person_add_alt_1, size: 80),

                const SizedBox(height: 16),

                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Enter your information to get started",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: _firstNameController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'first name',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'too short';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _lastNameController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'last name',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'too short';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: 'email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null ||
                        !Constants.emailRegex.hasMatch(value)) {
                      return 'invalid email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                Reusable.button('Continue', () {
                  if (_formKey.currentState?.validate() ?? false) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register_2(
                          firstname: _firstNameController.text,
                          lastname: _lastNameController.text,
                          email: _emailController.text,
                        ),
                      ),
                    );
                  }
                }),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
