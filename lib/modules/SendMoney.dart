import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/TransferRequested.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final _account = TextEditingController();
  final _amount = TextEditingController();
  final _pin = TextEditingController();

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
    returnImage: false,
  );

  var _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _account.dispose();
    _amount.dispose();
    _pin.dispose();
    _scannerController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<Manager, BlocState>(
        listener: (context, state) {
          if (state is Transfer_Money_SuccessState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TransferRequested()),
            );
          }
          if (state is Transfer_Money_ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.error)),
            );
          }
        },
        builder: (context, state) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          Constants.appSecondColor,
                          Constants.appFirstColor,
                        ],
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.send_rounded, color: Colors.white, size: 34),
                        SizedBox(height: 14),
                        Text(
                          "Send Money",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Transfer funds securely to another NovaBank account.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 25),
          
                  _card(
                    title: "Receiver Account",
                    icon: Icons.person_outline,
                    child: TextFormField(
                      controller: _account,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Account number",
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner_rounded),
                          onPressed: _scannerFunction,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Account number is required";
                        }
          
                        if (value.trim().length < 6) {
                          return "Invalid account number";
                        }
          
                        return null;
                      },
                    ),
                  ),
          
                  const SizedBox(height: 15),
          
                  _card(
                    title: "Amount",
                    icon: Icons.attach_money,
                    child: TextFormField(
                      controller: _amount,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(hintText: "0.00"),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Amount is required";
                        }
          
                        final amount = double.tryParse(value);
          
                        if (amount == null || amount <= 0) {
                          return "Enter a valid amount";
                        }
          
                        return null;
                      },
                    ),
                  ),
          
                  const SizedBox(height: 15),
          
                  _card(
                    title: "Security PIN",
                    icon: Icons.lock_outline,
                    child: TextFormField(
                      controller: _pin,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: '6-digit PIN',
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
                            !Constants.pinRegex.hasMatch(value)) {
                          return "invalid PIN";
                        }
          
                        return null;
                      },
                    ),
                  ),
          
                  const SizedBox(height: 30),
          
                  (state is Transfer_Money_LoadingState)
                      ? CircularProgressIndicator()
                      : Reusable.button('Confirm & Send', () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Manager.get(context).transferMoney({
                              'receiver_account': _account.text,
                              'amount': _amount.text,
                              'pin': _pin.text,
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

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
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
          child,
        ],
      ),
    );
  }

  void _scannerFunction() {
    bool isScanning = false;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: SizedBox(
          height: 400,
          child: MobileScanner(
            controller: _scannerController,
            onDetect: (capture) async {
              if (isScanning || !mounted) return;

              final barcode = capture.barcodes.firstOrNull;
              final value = barcode?.rawValue;

              if (value == null || value.isEmpty) return;

              isScanning = true;

              try {
                await _scannerController.stop();
                await _player.play(AssetSource('sounds/qr_beep.mp3'));

                setState(() {
                  _account.text = value;
                });

                if (mounted) {
                  Navigator.pop(context);
                }
              } finally {
                isScanning = false;
              }
            },
          ),
        ),
      ),
    );
  }
}
