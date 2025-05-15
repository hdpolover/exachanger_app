import '../../models/promo_model.dart';
import '../../models/blog_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getAll();

  Future<PromoModel> getById(String id);
}
