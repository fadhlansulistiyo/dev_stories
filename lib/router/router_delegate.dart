import 'package:dev_stories/screen/addstory/add_story_screen.dart';
import 'package:dev_stories/screen/detail/detail_screen.dart';
import 'package:dev_stories/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import '../db/auth_repository.dart';
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
            child: HomeScreen(
          key: const ValueKey("HomePage"),
          story: story,
          onTapped: (String quoteId) {
            selectedStory = quoteId;
            notifyListeners();
          },
          toFormScreen: () {
            isForm = true;
            notifyListeners();
          },
          onLogout: () {
            isLoggedIn = false;
            notifyListeners();
          },
        )),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey("DetailStoryPage-$selectedStory"),
            child: DetailScreen(
              quoteId: selectedQuote!,
            ),
          ),
        if (isAddStory)
          MaterialPage(
            key: const ValueKey("AddStoryPage"),
            child: AddStoryScreen(
              onSend: () {
                isForm = false;
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

        isRegister = false;
        selectedStory = null;
        isAddStory = false;
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
