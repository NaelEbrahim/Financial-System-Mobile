import 'package:flutter/material.dart';
import 'package:novabank/modules/Auth/Login.dart';
import 'package:novabank/modules/Base.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/SecureStorage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final minDelay = Future.delayed(const Duration(seconds: 5));
    final token = await TokenStorage.readAccessToken();

    await minDelay;
    if (!mounted) return;

    final loggedIn = token != null && token.isNotEmpty;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn ? const Base() : const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/logo.png",height: 250,width: 250),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Constants.appFirstColor),
          ],
        ),
      ),
    );
  }
}