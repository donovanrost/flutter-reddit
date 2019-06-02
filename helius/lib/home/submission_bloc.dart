import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:draw/draw.dart';

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

  final Reddit instance;
  final Submission submission;
  StreamSubscription _apiStream;
  final BehaviorSubject<List> comments = BehaviorSubject();

  void loadHotFor() async {
    CommentForest forest = await submission.refreshComments();
    print(forest.runtimeType.toString() +
        ' ---- ' +
        forest.comments.length.toString());
    comments.add(_depthFirstComments(forest.comments));
  }

  List _depthFirstComments(_comments) {
    final comments = [];
    final queue = Queue.from(_comments.reversed);

    while (queue.isNotEmpty) {
      final comment = queue.removeLast();
      comments.add(comment);

      if ((comment is! MoreComments) && (comment.replies != null)) {
        queue.addAll(comment.replies.comments.reversed);
      }
    }
    return comments;
  }

  // void _fillComments({@required Stream stream}) {
  //   _apiStream = stream.listen((s) {
  //     if (!comments.hasValue) {
  //       comments.add([s]);
  //     } else {
  //       List temp = comments.value;
  //       temp.add(s);
  //       comments.add(temp);
  //     }
  //   });
  // }

  pauseStream() => _apiStream.pause();
  resumeStream() => _apiStream.resume();

  void dispose() {
    // _apiStream.pause();

    comments?.drain();
    comments?.close();
  }
}
