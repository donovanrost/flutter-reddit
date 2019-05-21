import 'package:helius/app_repository.dart';

import './app_bloc.dart';
import 'package:flutter/material.dart';

class AppProvider extends InheritedWidget {


  final bloc = Bloc(AppRepository());

  AppProvider({Key key, Widget child}) : super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static Bloc of(BuildContext context) {
    //* What it does is through the "of" function, it looks through the context of a widget from the deepest in the widget tree
    //* and it keeps travelling up to each widget's parent's context until it finds a "Provider" widget
    //* and performs the type conversion to Provider through "as Provider" and then access the Provider's bloc instance variable
    return (context.inheritFromWidgetOfExactType(AppProvider) as AppProvider).bloc;
  }
}
