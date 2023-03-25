// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mvvm_1/domain/entity/user.dart';

import '../data_providers/user_data_provider.dart';

class UserState{
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

abstract class UsersEvents {}

class UserIncrementEvent implements UsersEvents {}

class UsersDecrementEvent implements UsersEvents {}

class UsersInitializeEvent implements UsersEvents {}

class UsersBloc extends Bloc<UsersEvents, UserState>{
  final _userDataProvider = UserDataProvider();
  var _state = UserState(currentUser: User(0));

  final _stateController = StreamController<UsersEvents>.broadcast();
  late final Stream<UserState> _stateStream;

  //UserState get state => _state;
  //Stream<UserState> get stream => _stateStream;

  UsersBloc() : super(UserState(currentUser: User(0))){
    //dispatch(UsersInitializeEvent());
    _stateStream = _stateController.stream
        .asyncExpand<UserState>((_mapEventToState))
        .asyncExpand(_updateState)
        .asBroadcastStream();
    _stateStream.listen((event) {});
    dispatch(UsersInitializeEvent());
  }

  void dispatch(UsersEvents event) {
    _stateController.add(event);
  }

  Stream<UserState> _updateState(UserState state) async* {
    if (_state == state) return;
    _state = state;
    yield state;
  }

  Stream<UserState> _mapEventToState(UsersEvents event) async* {
    if (event is UsersInitializeEvent) {
      final user = await _userDataProvider.loadValue();
      yield UserState(currentUser: user);
    } else if (event is UserIncrementEvent) {
      var user = _state.currentUser;
      user = user.copyWith(age: user.age + 1);
      await _userDataProvider.saveValue(user);
      yield UserState(currentUser: user);
    } else if (event is UsersDecrementEvent) {
      var user = _state.currentUser;
      user = user.copyWith(age: user.age - 1);
      await _userDataProvider.saveValue(user);
      yield UserState(currentUser: user);
    }
  }

  /* void updateState(UserState state) {
    if (_state == state) return;
    _state = state;
    _stateContoller.add(state);
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
  }*/
}
