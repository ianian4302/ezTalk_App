import 'package:flutter/material.dart';

import '../page/login_page.dart';
import '../page/home_page.dart';

class Routes {
  static const String baseMainPage = '/';
  static const String homePage = '/home';
  static const String loginPage = '/login';

  static const List<String> bottomNavigationRoutes = [
    // homePage,
    loginPage,
    // unsolvedPage,
    // selfProblemPage,
    // notificationPage,
    // sortProblemPage,
    // selfInformationPage,
  ];

  static Widget Function(BuildContext context)? get homeRoute =>
      Routes()._routes[homeRouteName];

  static String get homeRouteName =>
      1==1 ? homePage : loginPage;
      // AccountManager.isLoggedIn() ? baseMainPage : login;

  final Map<String, WidgetBuilder> _routes = {
    homePage: (context) => const HomePage(),
    loginPage: (context) => const LoginPage(),
  };
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
