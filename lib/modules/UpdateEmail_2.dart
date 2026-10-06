import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/Base.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';
import 'package:pinput/pinput.dart';

class UpdateEmail_2 extends StatefulWidget {
  final String email;
  final String password;

  const UpdateEmail_2({super.key, required this.email, required this.password});

  @override
  State<UpdateEmail_2> createState() => _UpdateEmail_2State();
}

class _UpdateEmail_2State extends State<UpdateEmail_2> {
  late Manager _manager;
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<Manager, BlocState>(
          listener: (context, state) {
            if (state is Update_Email_SuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('email changed successfully'),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Base()),
                (route) => false,
              );
            }
            if (state is ErrorState &&
                (state is Resend_Request_Update_Email_ErrorState ||
                    state is Update_Email_ErrorState)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 5),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state is Resend_Request_Update_Email_SuccessState) {
              _startTimer();
            }
          },
          builder: (context, state) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  const Icon(Icons.mark_email_read_outlined, size: 90),

                  const SizedBox(height: 20),

                  const Text(
                    "Verify Your Email",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "if new email eligible to use, OTP will sent shortly",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  Pinput(
                    length: 4,
                    controller: _otpController,
                    validator: (value) {
                      if (value == null ||
                          !Constants.otpRegex.hasMatch(value)) {
                        return 'invalid pin';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  (state is Update_Email_LoadingState)
                      ? CircularProgressIndicator()
                      : Reusable.button('Verify New Email', () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _manager.updateEmail({
                              'email': widget.email,
                              'verifycode': _otpController.text,
                            });
                          }
                        }),

                  const SizedBox(height: 40),

                  const Text("Didn't receive code?"),

                  (state is Resend_Request_Update_Email_LoadingState)
                      ? const CircularProgressIndicator()
                      : TextButton(
                          onPressed: _canResend
                              ? () {
                                  _manager.reSendRequestUpdateEmail({
                                    'newemail': widget.email,
                                    'password': widget.password,
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
