import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:novabank/shared/Constants.dart';

class ReceiveMoney extends StatefulWidget {
  const ReceiveMoney({super.key});

  @override
  State<ReceiveMoney> createState() => _ReceiveMoneyState();
}

class _ReceiveMoneyState extends State<ReceiveMoney> {
  late Manager _manager;
  var accountNumber = '';

  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
    if (_manager.isAccountInfoLoaded) {
      accountNumber = _manager.accountInfoModel.account_number;
    }
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: accountNumber));

    setState(() => _copied = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _copied = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<Manager, BlocState>(
        listener: (context, state) {},
        builder: (context, state) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
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
                    Icon(Icons.qr_code_rounded, color: Colors.white, size: 34),
                    SizedBox(height: 14),
                    Text(
                      "Receive Money",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Scan your QR code or share account number to receive funds.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              (_manager.isAccountInfoLoaded)
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: accountNumber,
                            version: QrVersions.auto,
                            size: 230,
                            embeddedImage: const AssetImage('assets/logo.png'),
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(40, 40),
                            ),
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Constants.appSecondColor,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Constants.appFirstColor,
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "Or Copy Account Number",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Constants.appSecondColor,
                                      Constants.appFirstColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _copyToClipboard,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          transitionBuilder:
                                              (child, animation) {
                                                return ScaleTransition(
                                                  scale: animation,
                                                  child: child,
                                                );
                                              },
                                          child: Icon(
                                            _copied
                                                ? Icons.check_circle
                                                : Icons.copy_rounded,
                                            key: ValueKey(_copied),
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          transitionBuilder:
                                              (child, animation) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                          child: Text(
                                            _copied
                                                ? "Copied!"
                                                : "Click to Copy",
                                            key: ValueKey(_copied),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
