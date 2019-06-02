import './submission_bloc.dart';
import 'package:flutter/cupertino.dart';

class SubmissionProvider extends InheritedWidget {
  final bloc;

  SubmissionProvider({Key key, Widget child, this.bloc})
      : super(key: key, child: child);
  bool updateShouldNotify(_) => true;

  static SubmissionBloc of(BuildContext context) {
    //* What it does is through the "of" function, it looks through the context of a widget from the deepest in the widget tree
    //* and it keeps travelling up to each widget's parent's context until it finds a "Provider" widget
    //* and performs the type conversion to Provider through "as Provider" and then access the Provider's bloc instance variable
    return (context.inheritFromWidgetOfExactType(SubmissionProvider)
            as SubmissionProvider)
        .bloc;
  }
}
