import 'package:dev_stories/provider/auth_provider.dart';
import 'package:dev_stories/router/router_delegate.dart';
import 'package:dev_stories/style/theme.dart';
import 'package:dev_stories/style/util.dart';
import 'package:flutter/material.dart';

import 'db/auth_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider authProvider;
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Urbanist", "Urbanist");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Dev Stories',
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: Router(
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
