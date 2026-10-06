import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';

class TransactionsHistory extends StatefulWidget {
  const TransactionsHistory({super.key});

  @override
  State<TransactionsHistory> createState() => _TransactionsHistoryState();
}

class _TransactionsHistoryState extends State<TransactionsHistory> {
  late Manager _manager;

  final ScrollController _scrollController = ScrollController();

  int _page = 0;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _manager = Manager.get(context);
    _scrollController.addListener(_scrollListener);
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    _page = 0;
    _hasMore = true;
    await _manager.getTransactions(_page);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    final oldLength = _manager.transactions.length;

    await _manager.getTransactions(_page + 1);

    final newLength = _manager.transactions.length;

    if (newLength == oldLength) {
      _hasMore = false;
    } else {
      _page++;
    }

    if (mounted) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions History")),
      body: SafeArea(
        child: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              _page = 0;
              _hasMore = true;
              _manager.getTransactions(_page);
            },
            child: BlocConsumer<Manager, BlocState>(
              listener: (context, state) {
                if (state is Get_Transactions_ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.error),
                    ),
                  );
                }
              },

              builder: (context, state) {
                if (state is Get_Transactions_LoadingState &&
                    _manager.transactions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final transactions = _manager.transactions;

                return (transactions.isNotEmpty)
                    ? ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),

                        itemCount:
                            transactions.length + (_isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == transactions.length) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final item = transactions[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
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

                                        const SizedBox(height: 4),

                                        Text(
                                          item.recordedAt,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Text(
                                    '${item.income ? '+' : '-'}${item.amount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: item.income
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Text('no transactions yet !');
              },
            ),
          ),
        ),
      ),
    );
  }
}
