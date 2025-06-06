import 'package:exachanger_get_app/app/data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 10,
    String? sort,
    String? order,
    String? title,
    String? type,
  });
}
