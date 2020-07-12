// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:my_notes/presentation/splash/splash_page.dart';
import 'package:my_notes/presentation/sing_in/sign_in_page.dart';
import 'package:my_notes/presentation/notes/note_form/notes_overview/notes_overview_page.dart';

class Routes {
  static const String splashPage = '/';
  static const String signInPage = '/sign-in-page';
  static const String notesOverviewPage = '/notes-overview-page';
  static const all = <String>{
    splashPage,
    signInPage,
    notesOverviewPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashPage, page: SplashPage),
    RouteDef(Routes.signInPage, page: SignInPage),
    RouteDef(Routes.notesOverviewPage, page: NotesOverviewPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashPage: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashPage(),
        settings: data,
      );
    },
    SignInPage: (RouteData data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SignInPage(),
        settings: data,
      );
    },
    NotesOverviewPage: (RouteData data) {
      var args = data.getArgs<NotesOverviewPageArguments>(
          orElse: () => NotesOverviewPageArguments());
      return MaterialPageRoute<dynamic>(
        builder: (context) => NotesOverviewPage(key: args.key),
        settings: data,
      );
    },
  };
}

// *************************************************************************
// Navigation helper methods extension
// **************************************************************************

extension RouterNavigationHelperMethods on ExtendedNavigatorState {
  Future<dynamic> pushSplashPage() => pushNamed<dynamic>(Routes.splashPage);

  Future<dynamic> pushSignInPage() => pushNamed<dynamic>(Routes.signInPage);

  Future<dynamic> pushNotesOverviewPage({
    Key key,
  }) =>
      pushNamed<dynamic>(
        Routes.notesOverviewPage,
        arguments: NotesOverviewPageArguments(key: key),
      );
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//NotesOverviewPage arguments holder class
class NotesOverviewPageArguments {
  final Key key;
  NotesOverviewPageArguments({this.key});
}
