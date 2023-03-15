import 'package:shared_preferences/shared_preferences.dart';

import '../entity/user.dart';

class UserDataProvider {
  final sharedPreferences = SharedPreferences.getInstance();
  var imitationCounter = 0;

  Future<User> loadValue() async {
    final age = (await sharedPreferences).getInt('age') ?? 0;
    return User(age);
  }

  Future<void> saveValue(User user) async {
   
    (await sharedPreferences).setInt('age', user.age);
  }
}
