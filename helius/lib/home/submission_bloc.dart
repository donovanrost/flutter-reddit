import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

/*
  This is interesting. I need to be able to vote on a submission. 
  The voting functions are available on the submission object. 
  So I can vote. But if I do vote in the BLoC, then I don't think
  that the vote will be reflected higher up the widget tree. 
  I should consider optionally passing in 'SubredditBloc'. If no 
  SubredditBloc is passed in then cast the vote using this submission
  object. This may also be the case for

*/

class SubmissionBloc extends Object {
  SubmissionBloc({@required this.instance, @required this.submission});

  final instance;
  final submission;

  void dispose() {}
}
