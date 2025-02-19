import 'package:exachanger_get_app/app/data/model/promo_model.dart';
import 'package:exachanger_get_app/app/data/repository/promo/promo_repository.dart';
import 'package:get/get.dart';

import '../../remote/promo/promo_remote_data_source.dart';

class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteSource =
      Get.find(tag: (PromoRemoteDataSource).toString());

  @override
  Future<List<PromoModel>> getAllPromos() {
    return _remoteSource.getAll();
  }

  @override
  Future<PromoModel> getPromoDetail(String id) {
    return _remoteSource.getById(id);
  }
}
