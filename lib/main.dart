import 'package:flutter/material.dart';

import 'package:flutter_mvvm_1/ui/widgets/example_widget.dart';
import 'package:provider/provider.dart';

import 'domain/blocs/users_cubit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<UsersCubit>(
        create: (_) => UsersCubit(),
        child: ExampleWidget(),
        dispose: (context,  value) => value.close(),
      ),
      //routes: {
      //  'auth': (_) => AuthWidget.create(),
      //  'example': (_) => ExampleWidget.create(),
      //},
     /* onGenerateRoute: (RouteSettings settings) {
        if (settings.name == 'auth') {
          return PageRouteBuilder<dynamic>(
            pageBuilder: (context, animation1, animation2) => AuthWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == 'example') {
           return PageRouteBuilder<dynamic>(
            pageBuilder: (context, animation1, animation2) => ExampleWidget.create(),
            transitionDuration: Duration.zero,
          );
        }
      },*/
    );
  }
}
