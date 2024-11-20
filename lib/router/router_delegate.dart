import 'package:dev_stories/screen/addstory/add_story_screen.dart';
import 'package:dev_stories/screen/detail/detail_screen.dart';
import 'package:dev_stories/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../db/auth_repository.dart';
import '../screen/detail/maps_screen.dart';
import '../screen/login/login_screen.dart';
import '../screen/register/register_screen.dart';
import '../screen/splash/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  AuthRepository authRepository;

  MyRouterDelegate(this.authRepository)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authRepository.isLoggedIn();
    notifyListeners();
  }

  List<Page> historyStack = [];
  String? selectedStory;
  double? locationLat;
  double? locationLon;
  bool? isLoggedIn;
  bool? isUnknown;
  bool isRegister = false;
  bool isAddStory = false;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
            key: const ValueKey("HomePage"),
            child: HomeScreen(
              onLogout: () {
                isLoggedIn = false;
                notifyListeners();
              },
              onDetail: (String id) {
                selectedStory = id;
                notifyListeners();
              },
              toAddStoryScreen: () {
                isAddStory = true;
                notifyListeners();
              },
            )),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey("DetailStoryPage-$selectedStory"),
            child: DetailScreen(
              id: selectedStory!,
              toStoryLocation: (double lat, double lon) {
                locationLat = lat;
                locationLon = lon;
                notifyListeners();
              },
            ),
          ),
        if (locationLat != null && locationLon != null)
          MaterialPage(
            key: ValueKey("MapsScreen-$locationLat-$locationLon"),
            child: MapsScreen(
              lat: locationLat!,
              lon: locationLon!,
            ),
          ),
        if (isAddStory)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: AddStoryScreen(
              onPost: () {
                isAddStory = false;
                notifyListeners();
              },
            ),
          ),
      ];

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        if (route.settings is MaterialPage) {
          final pageKey = (route.settings as MaterialPage).key;
          if (pageKey == ValueKey("MapsScreen-$locationLat-$locationLon")) {
            locationLat = null;
            locationLon = null;
          } else if (pageKey == ValueKey("DetailStoryPage-$selectedStory")) {
            selectedStory = null;
          } else if (pageKey == const ValueKey("AddStoryPage")) {
            isAddStory = false;
          } else if (pageKey == const ValueKey("RegisterPage")) {
            isRegister = false;
          }
        }

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /*Do nothing*/
  }
}
