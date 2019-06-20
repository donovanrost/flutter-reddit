import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:helius/classes/content_type.dart';
import 'package:helius/classes/image_model.dart';
import 'package:helius/classes/video_model.dart';
import 'package:helius/home/repository.dart';
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
  Repository _repository = Repository();

  final Reddit instance;
  final Submission submission;
  StreamSubscription _apiStream;
  final BehaviorSubject<List> comments = BehaviorSubject();
  final BehaviorSubject content = BehaviorSubject();
  SubmissionBloc({@required this.instance, @required this.submission}) {
    Type type = ContentType.getContentTypeFromURL(submission.url.toString());
    print("$type");

    if (ContentType.displayImage(type)) {
      _repository
          .fetchImage(submission.url.toString())
          .then((ImageModel image) => content.add(image));
    }
    if (ContentType.displayVideo(type)) {
      _repository
          .fetchVideo(submission.url.toString())
          .then((VideoModel video) => content.add(video));
    }
  }

  void loadHotFor() async {
    CommentForest forest = await submission.refreshComments();

    comments.add(_depthFirstComments(forest.comments));
    // var x = Submissin submission.
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

  pauseStream() => _apiStream.pause();
  resumeStream() => _apiStream.resume();

  void dispose() {
    // _apiStream.pause();

    comments?.drain();
    comments?.close();
  }
}
