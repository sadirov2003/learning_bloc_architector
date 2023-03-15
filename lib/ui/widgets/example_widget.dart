// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_1/domain/blocs/users_bloc.dart';
import 'package:flutter_mvvm_1/domain/services/auth_service.dart';
import 'package:flutter_mvvm_1/ui/widgets/navigation/main_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/services/user_service.dart';

/*
class _ViewModelState {
  final String ageTitle;
  _ViewModelState({
    required this.ageTitle,
  });
}

class ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  var _state = _ViewModelState(ageTitle: '');
  
  _ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initialize();
    _updateState();
  }

  ViewModel() {
    loadValue();
  }

  Future<void> onIncrementButtonPressed() async {
    _userService.incrementAge();
    _updateState();
  }

  Future<void> onDecrementButtonPressed() async {
    _userService.decrementAge();
    _updateState();
  }

  Future<void> onLogoutPressed(BuildContext context) async {
    await _authService.logout();
    MainNavigation.showLoader(context);
  }

  void _updateState() {
    final user = _userService.user;
    _state = _ViewModelState(
      ageTitle: user.age.toString(),
    );
    notifyListeners();
  }
}
*/
class ExampleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () => viewModel.onLogoutPressed(context),
            child: const Text('Выход'),
          ),
        ],
      ),*/
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _AgeTitle(),
              _AgeIncrementWidget(),
              _AgeDecrementWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return ElevatedButton(
      onPressed: () => bloc.dispatch(UsersDecrementEvent()),
      child: const Text('-'),
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return ElevatedButton(
      onPressed: () => bloc.dispatch(UserIncrementEvent()),
      child: const Text('+'),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();
    return StreamBuilder<UserState>(
        initialData: bloc.state,
        stream: bloc.stream,
        builder: (context, snapshot) {
          final age = snapshot.requireData.currentUser.age;
          return Text('$age');
   },
  );
  }
}
