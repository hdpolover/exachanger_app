import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/dio_provider.dart';
import '../../models/signin_model.dart';
import '../../models/user_model.dart';
import '/app/data/local/preference/preference_manager.dart';

class PreferenceManagerImpl implements PreferenceManager {
  final _preference = SharedPreferences.getInstance();

  Future<void> logout() async {
    await remove('access_token');
    await remove('refresh_token');
    await remove('user_data');
    await setBool('is_signed_in', false);
    // Clear auth token from Dio
    DioProvider.clearAuthToken();
  }

  // Save user data to shared preferences
  Future<bool> saveUserData(UserModel userData) async {
    final userJson = jsonEncode(userData.toJson());
    return await setString('user_data', userJson);
  }

  // Get user data from shared preferences
  Future<UserModel?> getUserData() async {
    final userJson = await getString('user_data');
    if (userJson.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    } catch (e) {
      print('Error parsing user data: $e');
      return null;
    }
  }

  // Handle saving user data from sign-in response
  Future<bool> saveUserDataFromSignin(SigninModel signinData) async {
    try {
      // Save tokens and sign-in status
      await setString("access_token", signinData.accessToken!);
      await setString("refresh_token", signinData.refreshToken!);
      await setBool("is_signed_in", true);

      // Save user data if present
      if (signinData.data != null) {
        // Create user model from signin data
        final Map<String, dynamic> userData = {
          'id': signinData.data!.id,
          'email': signinData.data!.email,
          'name': signinData.data!.name,
          'role': signinData.data!.role,
          'type': signinData.data!.type,
          'permissions': signinData.data!.permissions != null
              ? {
                  'mobile': signinData.data!.permissions!.mobile
                      ?.map((m) => {'key': m.key, 'access': m.access})
                      .toList(),
                  'app': signinData.data!.permissions!.app
                }
              : null,
          'date': signinData.data!.date,
          'expired': signinData.data!.expired,
        };

        // Save user data as JSON string
        return await setString('user_data', jsonEncode(userData));
      }
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }

  @override
  Future<String> getString(String key, {String defaultValue = ""}) {
    return _preference
        .then((preference) => preference.getString(key) ?? defaultValue);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _preference.then((preference) => preference.setString(key, value));
  }

  @override
  Future<int> getInt(String key, {int defaultValue = 0}) {
    return _preference
        .then((preference) => preference.getInt(key) ?? defaultValue);
  }

  @override
  Future<bool> setInt(String key, int value) {
    return _preference.then((preference) => preference.setInt(key, value));
  }

  @override
  Future<double> getDouble(String key, {double defaultValue = 0.0}) {
    return _preference
        .then((preference) => preference.getDouble(key) ?? defaultValue);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    return _preference.then((preference) => preference.setDouble(key, value));
  }

  @override
  Future<bool> getBool(String key, {bool defaultValue = false}) {
    return _preference
        .then((preference) => preference.getBool(key) ?? defaultValue);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    return _preference.then((preference) => preference.setBool(key, value));
  }

  @override
  Future<List<String>> getStringList(String key,
      {List<String> defaultValue = const []}) {
    return _preference
        .then((preference) => preference.getStringList(key) ?? defaultValue);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    return _preference
        .then((preference) => preference.setStringList(key, value));
  }

  @override
  Future<bool> remove(String key) {
    return _preference.then((preference) => preference.remove(key));
  }

  @override
  Future<bool> clear() {
    return _preference.then((preference) => preference.clear());
  }
}
