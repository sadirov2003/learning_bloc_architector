// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_1/domain/blocs/users_cubit.dart';

import 'package:provider/provider.dart';



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
    final cubit = context.read<UsersCubit>();
    return ElevatedButton(
      onPressed: () => cubit.decrementAge(),
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
    final cubit = context.read<UsersCubit>();
    return ElevatedButton(
      onPressed: () => cubit.incrementAge(),
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
    final cubit = context.read<UsersCubit>();
    return StreamBuilder<UserState>(
        initialData: cubit.state,
        stream: cubit.stream,
        builder: (context, snapshot) {
          final age = snapshot.requireData.currentUser.age;
          return Text('$age');
   },
  );
  }
}
