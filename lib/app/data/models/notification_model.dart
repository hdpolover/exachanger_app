import 'package:exachanger_get_app/app/data/models/user_model.dart';

class NotificationModel {
  final String? id;
  final String? userId;
  final String? reffId;
  final String? reffType;
  final String? title;
  final String? icon;
  final String? notification;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final UserModel? user;

  NotificationModel({
    this.id,
    this.userId,
    this.reffId,
    this.reffType,
    this.title,
    this.icon,
    this.notification,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      reffId: json['reff_id'],
      reffType: json['reff_type'],
      title: json['title'],
      icon: json['icon'],
      notification: json['notification'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'reff_id': reffId,
      'reff_type': reffType,
      'title': title,
      'icon': icon,
      'notification': notification,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'user': user?.toJson(),
    };
  }
}

class NotificationResponseModel {
  final List<NotificationModel> notifications;
  final NotificationMetaModel meta;

  NotificationResponseModel({required this.notifications, required this.meta});

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      notifications: (json['notifications'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList(),
      meta: NotificationMetaModel.fromJson(json['meta']),
    );
  }
}

class NotificationMetaModel {
  final int currentPage;
  final int lastPage;
  final int from;
  final int to;
  final int page;
  final int offset;
  final int limit;
  final int total;

  NotificationMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.page,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory NotificationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetaModel(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      from: json['from'],
      to: json['to'],
      page: json['page'],
      offset: json['offset'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}
