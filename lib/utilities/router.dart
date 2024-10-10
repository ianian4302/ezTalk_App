import 'package:flutter/material.dart';

import 'package:eztalk/page/base.dart';
import 'package:eztalk/page/login_page.dart';
import 'package:eztalk/page/home_page.dart';
import 'package:eztalk/page/translate_page.dart';
import 'package:eztalk/page/settings_page.dart';
import 'package:eztalk/page/dataCollect/data_collection_page.dart';
import 'package:eztalk/page/translate/series_connecting_page.dart';
import 'package:eztalk/page/translate/lecture_playing_page.dart';

class Routes {
  static const String baseMainPage = '/baseMainPage';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String translatePage = '/translate_page';
  static const String settingsPage = '/settings';
  static const String dataCollectionPage = '/dataCollectionPage';

  static const String tempRecording = '/tempRecording';

  //translate about page
  static const String seriesConnectingPage = '/seriesConnectingPage';
  static const String lecturePlayingPage = '/lecturePlayingPage';


  static const List<String> bottomNavigationRoutes = [
    homePage,
    translatePage,
    loginPage,
    dataCollectionPage,
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
    translatePage: (context) => const TranslatePage(),
    settingsPage: (context) => const SettingsPage(),
    dataCollectionPage: (context) => const DataCollectionPage(),

    //translate about page
    seriesConnectingPage: (context) => const SeriesConnectingPage(),
    lecturePlayingPage: (context) => const LecturePlayingPage(),
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
