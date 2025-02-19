import 'package:exachanger_get_app/app/data/model/signin_model.dart';

abstract class AuthRepository {
  Future<SigninModel> getAuthData(Map<String, dynamic> data);
}
