// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter_mvvm_1/domain/entity/user.dart';

import '../data_providers/user_data_provider.dart';

class UserState {
  late final User currentUser;
  UserState({
    required this.currentUser,
  });

  UserState copyWith({
    User? currentUser,
  }) {
    return UserState(
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  bool operator ==(covariant UserState other) {
    if (identical(this, other)) return true;

    return other.currentUser == currentUser;
  }

  @override
  int get hashCode => currentUser.hashCode;

  @override
  String toString() => 'UserState(currentUser: $currentUser)';
}

class UsersBloc {
  final _userDataProvider = UserDataProvider();
  var _state = UserState(currentUser: User(0));

  final _stateController = StreamController<UserState>();

  UserState get state => _state;
  Stream<UserState> get stream => _stateController.stream.asBroadcastStream();

  UsersBloc() {
    _initialize();
  }

  void updateState(UserState state) {
    if (_state == state) return;
    _state = state;
    _stateController.add(state);
  }

  Future<void> _initialize() async {
    final user = await _userDataProvider.loadValue();
    updateState(_state.copyWith(currentUser: user));
  }

  void incrementAge() {
    var user = _state.currentUser;
    user = user.copyWith(age: user.age + 1);
    updateState(_state.copyWith(currentUser: user));
    _userDataProvider.saveValue(user);
  }

  void decrementAge() {
    var user = _state.currentUser;
    user = user.copyWith(age: user.age - 1);
    updateState(_state.copyWith(currentUser: user));
    _userDataProvider.saveValue(user);
  }
}
