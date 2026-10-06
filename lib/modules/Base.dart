import 'package:flutter/material.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/modules/Home.dart';
import 'package:novabank/modules/Profile.dart';
import 'package:novabank/modules/Settings.dart';

class Base extends StatefulWidget {
  const Base({super.key});

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  int _currentIndex = 0;

  List<Widget> screens = [Home(), Profile(), Settings()];

  @override
  void initState() {
    super.initState();
    var manager = Manager.get(context);
    manager.getProfile().then(
      (v) => manager.getAccountInfo().then((v) => manager.getTransactions(0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.person_outline, "Profile", 1),
              _navItem(Icons.settings_outlined, "Settings", 2),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
    );
  }

  Widget _navItem(IconData icon, String title, int index) {
    final selected = _currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        width: 65,
        decoration: selected
            ? BoxDecoration(
                color: const Color(0xff7C3FE0).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? const Color(0xff7C3FE0) : Colors.grey),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: selected ? const Color(0xff7C3FE0) : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
