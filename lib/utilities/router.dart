import 'package:flutter/material.dart';

import '../page/base.dart';
import '../page/login_page.dart';
import '../page/home_page.dart';
import '../page/recording_page.dart';
import '../page/settings_page.dart';

class Routes {
  static const String baseMainPage = '/baseMainPage';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String recordingPage = '/recording';
  static const String settingsPage = '/settings';

  static const String tempRecording = '/tempRecording';

  static const List<String> bottomNavigationRoutes = [
    homePage,
    recordingPage,
    loginPage,
    homePage,
    settingsPage,
  ];

  static Widget Function(BuildContext context)? get homeRoute =>
      Routes()._routes[homeRouteName];

  static String get homeRouteName => 1 == 1 ? baseMainPage : loginPage;
  // AccountManager.isLoggedIn() ? baseMainPage : login;
  static Map<String, WidgetBuilder> get routes => Routes()._routes;

  final Map<String, WidgetBuilder> _routes = {
    baseMainPage: (context) => const BaseMainPage(),
    homePage: (context) => const HomePage(),
    loginPage: (context) => const LoginPage(),
    recordingPage: (context) => const RecordingPage(),
    settingsPage: (context) => const SettingsPage(),
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
