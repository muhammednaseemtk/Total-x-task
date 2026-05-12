class AppConstants {
  AppConstants._();

  static const String appName = 'TOTAL-X';
  static const int pageSize = 20;
  static const int ageThreshold = 60;
}

class RouteNames {
  RouteNames._();

  static const String login = '/login';
  static const String usersList = '/users-list';
}

class FirestoreCollections {
  FirestoreCollections._();

  static const String users = 'users';
}

class StoragePaths {
  StoragePaths._();

  static const String userImages = 'user_images';
}