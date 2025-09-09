import 'package:bogoballers/core/constants/size.dart';
import 'package:bogoballers/core/helpers/message_helpers.dart';
import 'package:bogoballers/core/models/notification_model.dart';
import 'package:bogoballers/core/services/entity_service.dart';
import 'package:bogoballers/core/services/notification_action.dart';
import 'package:bogoballers/core/utils/custom_exceptions.dart' as ErrorHandler;
import 'package:bogoballers/core/widget/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:bogoballers/core/services/socket_io_service.dart';
import 'package:bogoballers/core/services/socket_notification.dart';
import 'package:bogoballers/core/theme/theme_extensions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    try {
      SocketService.instance.off('notifications');
      SocketService.instance.off('new_notification');
      SocketService.instance.off('joined_notification_room');
    } catch (_) {}
    super.dispose();
  }

  Future<void> _init() async {
    final socketService = SocketService.instance;

    if (!socketService.isConnected) {
      await socketService.connect();
    }

    final entity = await getEntityCredentialsFromStorage();
    _currentUserId = entity.userId;

    if (_currentUserId == null) {
      setState(() => _isLoading = false);
      return;
    }

    socketService.joinNotificationRoom(_currentUserId!);

    socketService.onJoinedNotificationRoom((data) {
      debugPrint("✅ Notification room joined: $data");
    });

    socketService.onNotifications((list) {
      setState(() {
        _notifications
          ..clear()
          ..addAll(list.map((n) => NotificationModel.fromJson(n)));
        _isLoading = false;
      });
    });

    socketService.onNewNotification((notif) {
      setState(() {
        _notifications.insert(0, NotificationModel.fromJson(notif));
      });
    });

    // fetch initial notifications
    await _refreshNotifications();
  }

  Future<void> _refreshNotifications() async {
    if (_currentUserId != null) {
      setState(() => _isLoading = true);
      SocketService.instance.getNotifications(_currentUserId!);
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppThemeColors>()!;

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(child: Text("No notifications yet"))
          : RefreshIndicator(
              onRefresh: _refreshNotifications,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return NotificationItem(notification: notif, colors: colors);
                },
              ),
            ),
    );
  }
}

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final AppThemeColors colors;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.colors,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radiusMd),
        border: Border.all(
          color: widget.colors.gray6,
          width: Sizes.borderWidthSm,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.notification.title ?? "Notification",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.notification.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              Text(
                formatConversationTimestamp(widget.notification.createdAt),
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (_hasActions())
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _getActionButtons(),
            ),
        ],
      ),
    );
  }

  bool _hasActions() {
    return widget.notification.actionType != "message_only";
  }

  List<Widget> _getActionButtons() {
    switch (widget.notification.actionType) {
      case "team_invitation":
        return [
          _actionButton("Join", _handleAcceptInvite),
          _actionButton("Reject", _handleRejectInvite),
        ];
      case "view_only":
        return [
          _actionButton("View", () {
            debugPrint('View tapped for ${widget.notification.notificationId}');
          }),
        ];
      case "message_only":
      default:
        return [];
    }
  }

  Future<void> _handleAcceptInvite() async {
    try {
      await NotificationAction.acceptTeamInvitation(
        widget.notification.actionPayload?['player_team_id'] as String,
      );

      if (mounted) {
        showAppSnackbar(
          context,
          message: "Accepted successfully.",
          title: "Succcess",
          variant: SnackbarVariant.success,
        );
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  Future<void> _handleRejectInvite() async {
    try {
      await NotificationAction.rejectTeamInvitation(
        widget.notification.actionPayload?['player_team_id'] as String,
      );

      if (mounted) {
        showAppSnackbar(
          context,
          message: "Reject successfully.",
          title: "Succcess",
          variant: SnackbarVariant.info,
        );
      }
    } catch (e) {
      if (mounted) {
        showAppSnackbar(
          context,
          message: ErrorHandler.getErrorMessage(e),
          title: "Error",
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(50, 24),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
