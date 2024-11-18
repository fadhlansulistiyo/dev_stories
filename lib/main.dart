import 'package:dev_stories/data/api/api_service.dart';
import 'package:dev_stories/db/stories_repository.dart';
import 'package:dev_stories/provider/add_story_provider.dart';
import 'package:dev_stories/provider/auth_provider.dart';
import 'package:dev_stories/provider/stories_provider.dart';
import 'package:dev_stories/router/page_manager.dart';
import 'package:dev_stories/router/router_delegate.dart';
import 'package:dev_stories/style/theme.dart';
import 'package:dev_stories/style/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'db/auth_repository.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  runApp(const MyApp());
}

void initializeTimeZones() {
  tz.initializeTimeZones();
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
    final apiService = ApiService();
    final authRepository = AuthRepository(apiService: apiService);
    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Urbanist", "Urbanist");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PageManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => authProvider,
        ),
        Provider(
          create: (context) => ApiService(),
        ),
        Provider(
          create: (context) =>
              StoriesRepository(apiService: context.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoriesProvider(
            storiesRepository: context.read<StoriesRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AddStoryProvider(apiService: context.read<ApiService>()),
        )
      ],
      child: MaterialApp(
        title: 'Dev Stories',
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
