import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/shared/Constants.dart';

class DailyTotals extends StatefulWidget {
  const DailyTotals({super.key});

  @override
  State<DailyTotals> createState() => _DailyTotalsState();
}

class _DailyTotalsState extends State<DailyTotals> {
  late Manager _manager;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
    _manager.getTodayTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Today's Activity")),
      body: BlocConsumer<Manager, BlocState>(
        listener: (context, state) {},
        builder: (context, state) {
          final totals = _manager.dailyTotals;
          final income = totals?.totalIncome ?? 0;
          final outcome = totals?.totalOutcome ?? 0;
          final net = income - outcome;

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await _manager.getTodayTotals();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.insights_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            "Today's Net Balance",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          state is Get_Today_Totals_LoadingState
                              ? CircularProgressIndicator()
                              : FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${net >= 0 ? '+' : '-'}\$${net.abs().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 6),
                          Text(
                            totals?.todayDate ?? '-',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    _card(
                      title: 'Total Income',
                      subtitle: 'Money received today',
                      amount: income,
                      icon: Icons.arrow_downward_rounded,
                      color: const Color(0xff2E9E5B),
                      sign: '+',
                    ),

                    const SizedBox(height: 15),

                    _card(
                      title: 'Total Outcome',
                      subtitle: 'Money sent today',
                      amount: outcome,
                      icon: Icons.arrow_upward_rounded,
                      color: const Color(0xffD64545),
                      sign: '-',
                    ),

                    if (state is Get_Today_Totals_ErrorState) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Couldn't load today's totals.\nPull down to retry.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _card({
    required String title,
    required String subtitle,
    required double amount,
    required IconData icon,
    required Color color,
    required String sign,
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$sign\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
