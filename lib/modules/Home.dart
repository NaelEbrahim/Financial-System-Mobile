import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/modules/DailyTotals.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/modules/Notifications.dart';
import 'package:novabank/modules/ReceiveMoney.dart';
import 'package:novabank/modules/SendMoney.dart';
import 'package:novabank/modules/TransactionsHistory.dart';
import 'package:novabank/shared/Constants.dart';
import 'package:novabank/shared/Reusable.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Manager _manager;
  bool _showBalance = false;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Manager, BlocState>(
      listener: (context, state) {},
      builder: (context, state) => RefreshIndicator(
        onRefresh: () async {
          _manager.isAccountInfoLoaded = false;
          await _manager.getAccountInfo().then(
            (v) => _manager.getTransactions(0),
          );
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 25, child: Icon(Icons.person)),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Welcome", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 2),
                        if (_manager.isProfileLoaded)
                          Text(
                            '${_manager.profileModel.firstname} ${_manager.profileModel.lastname}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notifications(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications_none, size: 30),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              AsyncView(
                isLoading: state is Get_Account_Info_LoadingState,
                error: state is Get_Account_Info_ErrorState
                    ? state.error
                    : null,
                onRetry: () {
                  _manager.isAccountInfoLoaded = false;
                  _manager.getAccountInfo();
                },
                child: _manager.isAccountInfoLoaded
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              Constants.appSecondColor,
                              Constants.appFirstColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xff7C3FE0,
                              ).withValues(alpha: .35),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: -45,
                              right: -30,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: .08),
                                ),
                              ),
                            ),

                            Positioned(
                              bottom: -55,
                              left: -40,
                              child: Container(
                                width: 170,
                                height: 170,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: .05),
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "NovaBank",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    Container(
                                      width: 48,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xffD4AF37),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.sim_card,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 30),

                                const Text(
                                  "Account Number",
                                  style: TextStyle(color: Colors.white70),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "**** **** **** ${_manager.accountInfoModel.account_number.substring(_manager.accountInfoModel.account_number.length - 4)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3,
                                  ),
                                ),

                                const SizedBox(height: 30),

                                Row(
                                  children: [
                                    const Text(
                                      "Available Balance",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showBalance = !_showBalance;
                                        });
                                      },
                                      icon: Icon(
                                        _showBalance
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    _showBalance
                                        ? "\$${_manager.accountInfoModel.account_balance}"
                                        : "********",
                                    key: ValueKey(_showBalance),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _action(Icons.north_east_rounded, "Send", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SendMoney()),
                    );
                  }),
                  _action(Icons.south_west_rounded, "Receive", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReceiveMoney()),
                    );
                  }),
                  _action(Icons.today_rounded, "Today", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DailyTotals()),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 35),

              Row(
                children: [
                  const Text(
                    "Recent Transactions",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionsHistory(),
                        ),
                      );
                    },
                    child: const Text("See All"),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 15),
                ],
              ),

              const SizedBox(height: 10),

              AsyncView(
                isLoading: state is Get_Transactions_LoadingState,
                error: state is Get_Transactions_ErrorState
                    ? state.error
                    : null,
                onRetry: () {
                  _manager.getTransactions(0);
                },
                child: (_manager.transactions.isNotEmpty)
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _manager.transactions.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = _manager.transactions[index];

                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: item.income
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  child: Icon(
                                    item.income
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: item.income
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),

                                const SizedBox(width: 15),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.referenceNumber,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        item.recordedAt,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  (item.income ? '+' : '-') +
                                      item.amount.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: item.income
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Text('no transactions yet !'),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _action(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff7C3FE0).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff7C3FE0).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xff7C3FE0), size: 26),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
