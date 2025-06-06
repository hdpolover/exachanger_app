import 'package:exachanger_get_app/app/data/models/notification_model.dart';
import 'package:exachanger_get_app/app/data/remote/notification/notification_remote_data_source.dart';
import 'package:exachanger_get_app/app/data/repository/notification/notification_repository.dart';
import 'package:get/get.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteSource =
      Get.find(tag: (NotificationRemoteDataSource).toString());

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 10,
    String? sort,
    String? order,
    String? title,
    String? type,
  }) {
    return _remoteSource.getNotifications(
      page: page,
      limit: limit,
      sort: sort,
      order: order,
      title: title,
      type: type,
    );
  }
}
