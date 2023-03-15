import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/services/auth_service.dart';

class _ViewModel {
  final _authService = AuthService();
  BuildContext context;

  _ViewModel(this.context) {
    init();
  }

  void init() async {
    final isAuth = await _authService.checkAuth();
    if (isAuth) {
      _goToAppScreen();
    } else {
      _goToAuthScreen();
    }
  }

  void _goToAuthScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil('auth', (route) => false);
  }

  void _goToAppScreen() {
     Navigator.of(context).pushNamedAndRemoveUntil('example', (route) => false);
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  static Widget create() {
    return Provider(
      create: (context) => _ViewModel(context),
      lazy: false,
      child: const LoaderWidget(),
    );
  }
}
