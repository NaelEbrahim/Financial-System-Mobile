import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/modules/Splash.dart';
import 'package:novabank/remote/DioHelper.dart';

void main() {
  DioHelper.init();
  runApp(BlocProvider(create: (context) => Manager(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Splash(),
    );
  }
}
