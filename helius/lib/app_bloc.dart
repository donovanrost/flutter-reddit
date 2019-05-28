import 'package:rxdart/rxdart.dart';
class Bloc extends Object {

  final _repository;

  BehaviorSubject get mySubscriptions => _repository.reddit.mySubscriptions;
  BehaviorSubject get myModerations => _repository.reddit.moderatorSubreddits;
  // BehaviorSubject get subredditContent => _repository.reddit.subredditContent;
  BehaviorSubject get reddit => _repository.reddit.instance;
  test(String subreddit) => _repository.reddit.test(subreddit);

  // Function get rising =>  _repository.reddit.subredditRising();
  Function get loginWithNewAccount => _repository.reddit.loginWithNewAccount();

  Bloc(this._repository) {
    _repository.reddit.init();
  }



  

  void dispose() {

  }
}