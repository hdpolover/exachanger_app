import '../../models/promo_model.dart';

abstract class PromoRepository {
  Future<List<PromoModel>> getAllPromos();

  Future<PromoModel> getPromoDetail(String id);
}
