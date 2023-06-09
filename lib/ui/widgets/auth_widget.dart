// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_1/ui/widgets/navigation/main_navigation.dart';
import 'package:provider/provider.dart';

import 'package:flutter_mvvm_1/domain/data_providers/auth_api_provider.dart';
import 'package:flutter_mvvm_1/domain/services/auth_service.dart';

enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {
  final String authErrorTitle;
  final String login;
  final String password;
  final bool isAuthInprocess;

  _ViewModelAuthButtonState get authButtonState {
    if (isAuthInprocess) {
      return _ViewModelAuthButtonState.authProcess;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return _ViewModelAuthButtonState.canSubmit;
    } else {
      return _ViewModelAuthButtonState.disable;
    }
  }

  _ViewModelState({
    this.authErrorTitle = '',
    this.login = '',
    this.password = '',
    this.isAuthInprocess = false,
  });

  _ViewModelState copyWith({
    String? authErrorTitle,
    String? login,
    String? password,
    bool? isAuthInprocess,
  }) {
    return _ViewModelState(
      authErrorTitle: authErrorTitle ?? this.authErrorTitle,
      login: login ?? this.login,
      password: password ?? this.password,
      isAuthInprocess: isAuthInprocess ?? this.isAuthInprocess,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  var _state = _ViewModelState();
  _ViewModelState get state => _state;
  

  void changeLogin(String value) {
    if (_state.login == value) return;
    _state = _state.copyWith(login: value);
    notifyListeners();
  }

  void changePassword(String value) {
    if (_state.password == value) return;
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;
    if (login.isEmpty || password.isEmpty) return;

    _state = _state.copyWith(authErrorTitle: '', isAuthInprocess: true);
    notifyListeners();

    try {
      await _authService.login(login, password);
      _state = _state.copyWith(isAuthInprocess: false);
      notifyListeners();
      MainNavigation.showLoader(context);
    } on AuthApiProviderIncorrectDataError {
      _state = _state.copyWith(
          authErrorTitle: 'Неправильный логин или пароль',
          isAuthInprocess: false);
      notifyListeners();
    } catch (exception) {
      _state = _state.copyWith(
          authErrorTitle: 'Случилось неприятность, попробуйте повторить подже',
          isAuthInprocess: false);
      notifyListeners();
    }
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: const [
            _ErrorTitleWidget(),
            SizedBox(height: 10),
            _LoginWidget(),
            SizedBox(height: 10),
            _PasswordWidget(),
            SizedBox(height: 10),
            _AuthButtonWidget(),
          ]),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Логин',
        border: OutlineInputBorder(),
      ),
      onChanged: model.changeLogin,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Пароль',
        border: OutlineInputBorder(),
      ),
      onChanged: model.changePassword,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authErrorTitle = context.select((_ViewModel value) {
      return value.state.authErrorTitle;
    });
    return Text(authErrorTitle);
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    final authButtonState =
        context.select((_ViewModel value) => value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAuthButtonState.canSubmit
        ? model.onAuthButtonPressed
        : null;
    final child = authButtonState == _ViewModelAuthButtonState.authProcess
        ? CircularProgressIndicator()
        : const Text('Авторизоватся');

    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}
