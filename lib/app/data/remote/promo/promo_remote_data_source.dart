import '../../model/promo_model.dart';
import '../../model/blog_model.dart';

abstract class PromoRemoteDataSource {
  Future<List<PromoModel>> getAll();

  Future<PromoModel> getById(String id);
}
