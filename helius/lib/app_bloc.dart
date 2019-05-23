import 'package:rxdart/rxdart.dart';
class Bloc extends Object {

  final _repository;

  BehaviorSubject get mySubscriptions => _repository.reddit.mySubscriptions;
  BehaviorSubject get myModerations => _repository.reddit.moderatorSubreddits;
  BehaviorSubject get reddit => _repository.reddit.instance;
  Function get loginWithNewAccount => _repository.reddit.loginWithNewAccount();

  Bloc(this._repository) {
    _repository.reddit.init();
  }



  

  void dispose() {

  }
}