import 'package:exachanger_get_app/app/data/models/api_response_model.dart';
import 'package:exachanger_get_app/app/data/models/notification_model.dart';
import 'package:exachanger_get_app/app/data/remote/notification/notification_remote_data_source.dart';
import 'package:exachanger_get_app/app/network/dio_provider.dart';

import '../../../core/base/base_remote_source.dart';

class NotificationRemoteDataSourceImpl extends BaseRemoteSource
    implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int limit = 10,
    String? sort,
    String? order,
    String? title,
    String? type,
  }) async {
    var endpoint = "${DioProvider.baseUrl}/profile/notification";
    
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };
    
    if (sort != null) queryParams['sort'] = sort;
    if (order != null) queryParams['order'] = order;
    if (title != null) queryParams['title'] = title;
    if (type != null) queryParams['type'] = type;

    var dioCall = dioClient.get(
      endpoint,
      queryParameters: queryParams,
    );

    try {
      return callApiWithErrorParser(dioCall).then((response) {
        final apiResponseModel = ApiResponseModel.fromJson(response.data);
        final notificationResponse = NotificationResponseModel.fromJson(
          apiResponseModel.data,
        );
        return notificationResponse.notifications;
      });
    } catch (e) {
      rethrow;
    }
  }
}
