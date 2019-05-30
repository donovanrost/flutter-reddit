import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SubredditBloc extends Object {
  SubredditBloc({@required this.instance});
  final instance;
  BehaviorSubject subredditContent = BehaviorSubject();
  StreamSubscription _apiStream;

  void loadHotFor({@required subreddit}) {
    if (instance != null) {
      Stream stream = instance.subreddit(subreddit).hot();
      _fillSubredditContent(stream: stream);
    }
  }

  void _fillSubredditContent({@required Stream stream}) {
    _apiStream = stream.listen((s) {
      if (!subredditContent.hasValue) {
        subredditContent.add([s]);
      } else {
        List temp = subredditContent.value;
        temp.add(s);
        subredditContent.add(temp);
      }
    });
  }

  pauseStream() => _apiStream.pause();
  resumeStream() => _apiStream.resume();

  Future upvote({@required submission}) async {
    await _isVoted(submission.vote, 'upvoted')
        ? submission.clearVote(waitForResponse: false)
        : submission.upvote(waitForResponse: false);
    subredditContent.add(subredditContent.value);
  }

  void downvote({@required submission}) {
    _isVoted(submission.vote, 'downvoted')
        ? submission.clearVote(waitForResponse: false)
        : submission.downvote(waitForResponse: false);
    subredditContent.add(subredditContent.value);
  }

  _isVoted(vote, whichVote) {
    vote = vote.toString().split('.').last;
    return (vote == whichVote) ? true : false;
  }

  void dispose() {
    _apiStream.pause();
    subredditContent.drain();
    subredditContent.close();
  }
}
