import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/UpdateEmail.dart';
import 'package:novabank/modules/UpdatePassword.dart';

import 'package:novabank/shared/Constants.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Manager, BlocState>(
      listener: (context, state) {},
      builder: (context, state) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _header(),

            const SizedBox(height: 25),

            _item(
              icon: Icons.lock_outline,
              title: "Update Password",
              subtitle: "Change your account password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePassword()),
                );
              },
            ),

            const SizedBox(height: 15),

            _item(
              icon: Icons.email_outlined,
              title: "Update Email",
              subtitle: "Change your registered email",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateEmail()),
                );
              },
            ),

            const SizedBox(height: 15),

            _infoItem(
              icon: Icons.info_outline,
              title: "App Version",
              value: Constants.version,
            ),

            const SizedBox(height: 15),

            (state is Logout_LoadingState)
                ? CircularProgressIndicator()
                : _item(
                    icon: Icons.logout,
                    title: "Logout",
                    subtitle: "Sign out from your account",
                    color: Colors.red,
                    onTap: () {
                      Manager.get(context).logout();
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
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
          Icon(Icons.settings, color: Colors.white, size: 34),
          SizedBox(height: 14),
          Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Manage your application settings",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color color = const Color(0xff7C3FE0),
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
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
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xff7C3FE0)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
