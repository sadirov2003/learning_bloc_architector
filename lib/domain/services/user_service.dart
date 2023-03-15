import 'dart:math';
import '../data_providers/user_data_provider.dart';
import '../entity/user.dart';

class UserService {
  var _userDataProvider = UserDataProvider();
  var _user = User(0);
  User get user => _user;

  Future<void> initialize() async {
    _user = await _userDataProvider.loadValue();
  }

  void incrementAge() {
    _user = _user.copyWith(age: user.age + 1);
    _userDataProvider.saveValue(_user);
  }

  void decrementAge() {
    _user = _user.copyWith(age: max(user.age - 1, 0));
    _userDataProvider.saveValue(_user);
  }
}
