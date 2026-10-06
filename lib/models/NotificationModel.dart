class NotificationModel {
  final int id;
  final String title;
  final String content;
  final String type;
  bool isRead;
  final String createdAt;

  NotificationModel(
    this.id,
    this.title,
    this.content,
    this.type,
    this.isRead,
    this.createdAt,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      json['id'],
      json['title'],
      json['content'],
      json['type'],
      json['isRead'],
      json['createdAt'],
    );
  }

  static List<NotificationModel> parseList(Map<String, dynamic> json) {
    final List<dynamic> list = json['message'];

    return List<NotificationModel>.from(
      list.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)),
    );
  }
}
