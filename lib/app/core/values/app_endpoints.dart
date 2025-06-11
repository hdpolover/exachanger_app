abstract class AppEndpoints {
  static const String metadata = 'metadata'; // signin
  static const String signin = 'auth/sign-in';
  static const String signup = 'auth/sign-up';
  static const String logout = 'auth/logout';

  static const String refreshToken = 'auth/refresh-token';

  // promo
  static const String promo = 'promo';
  // blog
  static const String blog = 'blog';
  // transactions
  static const String transactions = '/transaction';
  static const String transactionHistory =
      '/transaction/get-by-user?page=1&limit=10&sort=created_at&order=ASC';

  // products
  static const String products = 'product';
}
