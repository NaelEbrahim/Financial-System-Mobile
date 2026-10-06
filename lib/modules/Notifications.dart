import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novabank/bloc/Manager.dart';
import 'package:novabank/bloc/States.dart';
import 'package:novabank/models/NotificationModel.dart';
import 'package:novabank/shared/Constants.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
    await _manager.getNotifications(_page);
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

    final oldLength = _manager.notifications.length;

    await _manager.getNotifications(_page + 1);

    final newLength = _manager.notifications.length;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _page = 0;
            _hasMore = true;
            await _manager.getNotifications(_page);
          },
          child: BlocConsumer<Manager, BlocState>(
            listener: (context, state) {
              if (state is Delete_Notification_SuccessState) {
                Navigator.pop(context);
              }

              if (state is Get_Notifications_ErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if ((state is Get_Notifications_LoadingState &&
                      _manager.notifications.isEmpty) ||
                  state is Mark_Notification_Read_LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              final notifications = _manager.notifications;

              if (notifications.isEmpty) {
                Center(
                  child: Text(
                    "No notifications found",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _header(),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: notifications.length + (_isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 15),
                      itemBuilder: (_, index) {
                        if (index == notifications.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final notification = notifications[index];

                        return _notificationCard(notification);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
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
          Icon(Icons.notifications_active, color: Colors.white, size: 34),
          SizedBox(height: 14),
          Text(
            "Notifications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Stay updated with your account activity.",
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _notificationCard(NotificationModel notification) {
    return InkWell(
      onTap: () {
        _manager.markNotificationRead(notification.id);
      },
      onLongPress: () {
        _showDeleteDialog(notification.id);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xffF7F2FF),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xff7C3FE0).withValues(alpha: .1),
              child: Icon(
                _icon(notification.type),
                color: const Color(0xff7C3FE0),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      if (!notification.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    notification.content,
                    style: const TextStyle(color: Colors.grey, height: 1.4),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    notification.createdAt,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int notificationId) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<Manager, BlocState>(
          builder: (context, state) => AlertDialog(
            title: const Text("Delete Notification"),
            content: const Text(
              "Are you sure you want to delete this notification?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              (state is Delete_Notification_LoadingState)
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        _manager.deleteNotification(notificationId);
                      },
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  IconData _icon(String type) {
    switch (type) {
      case "ACCOUNT_CREATED":
        return Icons.person_add_alt_1;

      case "DEPOSIT_COMPLETED":
        return Icons.south_west;

      case "WITHDRAWAL_COMPLETED":
        return Icons.north_east;

      case "PASSWORD_CHANGED":
        return Icons.lock_reset;

      case "PROFILE_UPDATED":
        return Icons.person;

      default:
        return Icons.notifications;
    }
  }
}
