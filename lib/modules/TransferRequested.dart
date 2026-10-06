import 'package:flutter/material.dart';
import 'package:novabank/modules/Base.dart';
import 'package:novabank/shared/Reusable.dart';

class TransferRequested extends StatelessWidget {
  const TransferRequested({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: const Column(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: Color(0xff7C3FE0),
                    size: 70,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Transfer Under Processing",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Your transfer request is currently under processing.\n\nWe'll notify you as soon as it has been completed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Reusable.button("Back to Home", () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Base()),
                (route) => false,
              );
            }),
          ],
        ),
      ),
    );
  }
}
