class NotificationModel {
  final String notificationId;
  final String actionType;
  final Map<String, dynamic>? actionPayload;
  final String? title;
  final String message;
  final String toId;
  final String status;
  final String createdAt;

  NotificationModel({
    required this.notificationId,
    required this.actionType,
    this.actionPayload,
    this.title,
    required this.message,
    required this.toId,
    required this.status,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json["notification_id"],
      actionType: json["action_type"],
      actionPayload: json["action_payload"],
      title: json["title"],
      message: json["message"],
      toId: json["to_id"],
      status: json["status"],
      createdAt: json["created_at"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "notification_id": notificationId,
      "action_type": actionType,
      "action_payload": actionPayload,
      "title": title,
      "message": message,
      "to_id": toId,
      "status": status,
      "created_at": createdAt,
    };
  }
}
