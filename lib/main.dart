import 'package:dev_stories/provider/auth_provider.dart';
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

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    authProvider = AuthProvider(authRepository);

  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Urbanist", "Urbanist");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light(),
      darkTheme: theme.dark(),
      home: MaterialApp.router(
        title: "Dev Stories",
        routerDelegate: ,
        routeInformationParser: ,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}
