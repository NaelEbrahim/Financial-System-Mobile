import 'dart:ui';

class Constants {
  static final version = "1.0.0";

  static final appFirstColor = Color(0xff7C3FE0);

  static final appSecondColor = Color(0xff0F3BB0);

  static final serverURL = 'REAL-SERVER-URL';

  static final emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static final usernameRegex = RegExp(r'^[A-Z0-9]{8}$');

  static final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[$#@])[A-Za-z\d$#@]{6,}$',
  );

  static final pinRegex = RegExp(r'^(?!(\d)\1{5}$|123456$|654321$)\d{6}$');

  static final otpRegex = RegExp(r'^\d{4}$');
}
